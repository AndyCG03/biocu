import { reportes as PrismaReporte } from '@prisma/client';

export type ReporteEntity = PrismaReporte;

export type CreateReportEntity = Omit<ReporteEntity, 'id' | 'fecha_creacion'>;
export type ModifyReportEntityStatus = Omit<
  ReporteEntity,
  | 'titulo'
  | 'direccion'
  | 'descripcion'
  | 'latitud'
  | 'longitud'
  | 'usuario_id'
  | 'fecha_creacion'
  | 'fecha_actualizacion'
  | 'imagenes'
>;
