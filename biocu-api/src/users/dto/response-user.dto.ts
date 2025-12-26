import { ApiProperty } from '@nestjs/swagger';

export class UserResponseDto {
  @ApiProperty({
    description: 'ID único del usuario',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  id: string;

  @ApiProperty({
    description: 'Nombre completo del usuario',
    example: 'Juan Pérez',
  })
  nombre: string;

  @ApiProperty({
    description: 'Correo electrónico del usuario',
    example: 'juan.perez@example.com',
  })
  email: string;

  @ApiProperty({
    description: 'Indica si el usuario tiene privilegios de administrador',
    example: false,
  })
  es_admin: boolean;

  @ApiProperty({
    description: 'Fecha de creación del usuario',
    example: '2023-05-15T12:00:00.000Z',
  })
  fecha_creacion: Date;

  @ApiProperty({
    description: 'Fecha de última actualización del usuario',
    example: '2023-05-15T12:00:00.000Z',
  })
  fecha_actualizacion: Date;
}
