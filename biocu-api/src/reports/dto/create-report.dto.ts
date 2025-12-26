import { ApiProperty } from '@nestjs/swagger';
import {
  IsNotEmpty,
  IsString,
  IsLatitude,
  IsLongitude,
  MaxLength,
  IsOptional,
  IsArray,
  IsBase64,
} from 'class-validator';
import { Transform } from 'class-transformer';

export class CreateReportDto {
  @ApiProperty({
    description: 'Título del reporte',
    example: 'Bache en calle principal',
    maxLength: 100,
  })
  @IsString()
  @IsNotEmpty()
  @MaxLength(100)
  titulo: string;

  @ApiProperty({
    description: 'Dirección exacta del problema',
    example: 'Calle Principal 123, Colonia Centro',
    maxLength: 255,
  })
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  direccion: string;

  @ApiProperty({
    description: 'Descripción detallada del problema',
    example: 'Bache de aproximadamente 1m de diámetro y 30cm de profundidad',
  })
  @IsString()
  @IsNotEmpty()
  descripcion: string;

  @ApiProperty({
    description: 'Latitud geográfica',
    example: '19.4326018',
    type: String,
  })
  @IsLatitude()
  @Transform(({ value }) => parseFloat(value).toFixed(8))
  latitud: string;

  @ApiProperty({
    description: 'Longitud geográfica',
    example: '-99.1332049',
    type: String,
  })
  @IsLongitude()
  @Transform(({ value }) => parseFloat(value).toFixed(8))
  longitud: string;

  @ApiProperty({
    description: 'Imágenes en formato base64',
    example: ['data:image/jpeg;base64,/9j/4AAQSkZJRgABAQ...'],
    type: [String],
    required: false,
  })
  @IsOptional()
  @IsArray()
  @IsBase64({}, { each: true })
  imagenes?: string[];

  @IsString()
  @IsNotEmpty()
  usuario_id: string;
}
