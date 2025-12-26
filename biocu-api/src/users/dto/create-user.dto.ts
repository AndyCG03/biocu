import { ApiProperty } from '@nestjs/swagger';
import {
  IsEmail,
  IsNotEmpty,
  IsString,
  MaxLength,
  MinLength,
  IsOptional,
} from 'class-validator';

export class CreateUserDto {
  @ApiProperty({
    description: 'Nombre completo del usuario',
    example: 'Juan Pérez',
    maxLength: 100,
  })
  @IsString()
  @IsNotEmpty()
  @MaxLength(100)
  nombre: string;

  @ApiProperty({
    description: 'Correo electrónico del usuario (debe ser único)',
    example: 'juan.perez@example.com',
    maxLength: 100,
  })
  @IsString()
  @IsNotEmpty()
  @IsEmail()
  @MaxLength(100)
  email: string;

  @ApiProperty({
    description: 'Contraseña hasheada del usuario (mínimo 8 caracteres)',
    example: '$2a$10$EjemploDeHash12345678901234567890',
    minLength: 8,
  })
  @IsString()
  @IsNotEmpty()
  @MinLength(8)
  password_hash: string;

  @ApiProperty({
    description: 'Indica si el usuario tiene privilegios de administrador',
    example: false,
    default: false,
  })
  @IsString()
  @IsNotEmpty()
  @IsOptional()
  role: string;
}
