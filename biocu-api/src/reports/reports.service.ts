import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import {
  ModifyReportEntityStatus,
  ReporteEntity,
} from './entities/report.entity';
import { CreateReportDto } from './dto/create-report.dto';
import { UpdateReportDto } from './dto/update-report.dto';
import { FileService } from 'src/file/file.service';
import { UserActiveInterface } from 'src/common/interfaces/active-user.interface';

@Injectable()
export class ReportsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly fileService: FileService,
  ) {}

  async create(
    createReportDto: CreateReportDto,
    user: UserActiveInterface,
  ): Promise<ReporteEntity> {
    let images: string[] = [];

    if (createReportDto.imagenes && createReportDto.imagenes.length > 0) {
      images = await this.fileService.saveUserImages(
        user.sub,
        createReportDto.imagenes,
      );
    }
    return this.prisma.reportes.create({
      data: {
        titulo: createReportDto.titulo,
        direccion: createReportDto.direccion,
        descripcion: createReportDto.descripcion,
        latitud: parseFloat(createReportDto.latitud),
        longitud: parseFloat(createReportDto.longitud),
        imagenes: images,
        usuario_id: user.sub,
        estado: 'sin_revisar', // Estado por defecto
      },
    });
  }

  findAllOfUser(user: UserActiveInterface): Promise<ReporteEntity[]> {
    return this.prisma.reportes.findMany({
      where: { usuario_id: user.sub },
      orderBy: {
        fecha_creacion: 'desc',
      },
    });
  }

  findAll(): Promise<ReporteEntity[]> {
    return this.prisma.reportes.findMany({
      include: {
        usuarios: {
          select: {
            nombre: true,
          },
        },
      },
      orderBy: {
        fecha_creacion: 'desc',
      },
    });
  }

  async findOne(
    id: string,
    user: UserActiveInterface,
  ): Promise<ReporteEntity | null> {
    const reporte = await this.prisma.reportes.findUnique({
      where: { id, usuario_id: user.sub },
    });

    if (!reporte) {
      throw new NotFoundException(`Reporte con ID ${id} no encontrado`);
    }

    return reporte;
  }

  async findOneWithoutUser(id: string): Promise<ReporteEntity | null> {
    const reporte = await this.prisma.reportes.findUnique({
      where: { id },
    });

    if (!reporte) {
      throw new NotFoundException(`Reporte con ID ${id} no encontrado`);
    }

    return reporte;
  }

  async update(
    id: string,
    updateReportDto: UpdateReportDto,
    user: UserActiveInterface,
  ): Promise<ReporteEntity> {
    await this.findOne(id, user); // Verifica que el reporte exista

    return this.prisma.reportes.update({
      where: { id, usuario_id: user.sub },
      data: {
        titulo: updateReportDto.titulo,
        direccion: updateReportDto.direccion,
        descripcion: updateReportDto.descripcion,
        latitud: updateReportDto.latitud
          ? parseFloat(updateReportDto.latitud)
          : undefined,
        longitud: updateReportDto.longitud
          ? parseFloat(updateReportDto.longitud)
          : undefined,
        imagenes: updateReportDto.imagenes,
      },
    });
  }

  async remove(id: string, user: UserActiveInterface): Promise<ReporteEntity> {
    await this.findOne(id, user); // Verifica que el reporte exista

    return this.prisma.reportes.delete({
      where: { id, usuario_id: user.sub },
    });
  }

  findByUser(userId: string): Promise<ReporteEntity[]> {
    return this.prisma.reportes.findMany({
      where: { usuario_id: userId },
      orderBy: {
        fecha_creacion: 'desc',
      },
    });
  }

  async changeReportStatus(id: string): Promise<ModifyReportEntityStatus> {
    const reporte = await this.findOneWithoutUser(id); // Verifica que el reporte exista

    const nuevoEstado =
      reporte?.estado === 'sin_revisar' ? 'revisado' : 'sin_revisar';

    return this.prisma.reportes.update({
      where: { id },
      data: { estado: nuevoEstado },
      select: {
        id: true,
        estado: true,
      },
    });
  }
}
