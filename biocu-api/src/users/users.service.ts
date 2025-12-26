/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-call */
import {
  BadRequestException,
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { PrismaService } from 'src/prisma/prisma.service';
import {
  LoginUsuarioEntity,
  SafeUsuarioEntity,
  UsuarioEntity,
} from './entities/user.entity';
import * as bcrypt from 'bcrypt';
import { Prisma } from '@prisma/client';

@Injectable()
export class UsersService {
  constructor(private prisma: PrismaService) {}
  private readonly SALT_ROUNDS = 10;

  async create(createUserDto: CreateUserDto): Promise<UsuarioEntity> {
    try {
      return await this.prisma.usuarios.create({
        data: {
          nombre: createUserDto.nombre,
          email: createUserDto.email,
          password_hash: createUserDto.password_hash,
          role: createUserDto.role,
        },
      });
    } catch (error) {
      if (error instanceof Prisma.PrismaClientKnownRequestError) {
        throw new BadRequestException('Error al crear el usuario');
      }
      throw error;
    }
  }

  findAll(): Promise<SafeUsuarioEntity[]> {
    return this.prisma.usuarios.findMany({
      select: {
        id: true,
        nombre: true,
        email: true,
        role: true,
        _count: {
          select: { reportes: true },
        },
      },
      orderBy: {
        fecha_creacion: 'desc',
      },
    });
  }

  async findOne(id: string): Promise<SafeUsuarioEntity> {
    const user = await this.prisma.usuarios.findUnique({
      where: { id },
      select: {
        id: true,
        nombre: true,
        email: true,
        role: true,
        reportes: {
          select: {
            titulo: true,
            direccion: true,
            descripcion: true,
            estado: true,
          },
        },
      },
    });
    if (!user) {
      throw new NotFoundException(`Usuario con ID ${id} no encontrado`);
    }
    return user;
  }

  findByEmail(email: string): Promise<SafeUsuarioEntity | null> {
    return this.prisma.usuarios.findUnique({
      where: { email },
      select: {
        id: true,
        nombre: true,
        email: true,
        role: true,
      },
    });
  }

  findOneByEmailWithPassword(
    email: string,
  ): Promise<LoginUsuarioEntity | null> {
    return this.prisma.usuarios.findUnique({
      where: { email },
      select: {
        id: true,
        nombre: true,
        email: true,
        password_hash: true,
        role: true,
      },
    });
  }

  async update(
    id: string,
    updateUserDto: UpdateUserDto,
  ): Promise<UsuarioEntity> {
    await this.findOne(id); // Verificar que el usuario existe

    if (updateUserDto.email) {
      const existingUser = await this.prisma.usuarios.findFirst({
        where: {
          email: updateUserDto.email,
          NOT: { id },
        },
      });

      if (existingUser) {
        throw new ConflictException('El email ya está en uso por otro usuario');
      }
    }

    const data: any = { ...updateUserDto };

    if (updateUserDto.password_hash) {
      data.password_hash = await bcrypt.hash(
        updateUserDto.password_hash,
        this.SALT_ROUNDS,
      );
    }

    return this.prisma.usuarios.update({
      where: { id },
      data,
    });
  }

  async remove(id: string): Promise<UsuarioEntity> {
    await this.findOne(id); // Verificar que el usuario existe

    return this.prisma.usuarios.delete({
      where: { id },
    });
  }

  async getUserReports(userId: string) {
    await this.findOne(userId); // Verificar que el usuario existe

    return this.prisma.reportes.findMany({
      where: { usuario_id: userId },
      orderBy: {
        fecha_creacion: 'desc',
      },
    });
  }
}
