import { usuarios as PrismaUsuarios } from '@prisma/client';

export type UsuarioEntity = PrismaUsuarios;

export type CreateUserEntity = Omit<UsuarioEntity, 'id' | 'fecha_creacion'>;
export type SafeUsuarioEntity = Omit<
  UsuarioEntity,
  'password_hash' | 'fecha_actualizacion' | 'fecha_creacion'
>;
export type LoginUsuarioEntity = Omit<
  UsuarioEntity,
  'fecha_creacion' | 'fecha_actualizacion'
>;
