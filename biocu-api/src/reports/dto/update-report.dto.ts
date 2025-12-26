import { ApiProperty } from '@nestjs/swagger';
import {
  IsOptional,
  IsString,
  IsLatitude,
  IsLongitude,
  MaxLength,
  IsIn,
  IsBase64,
  IsArray,
} from 'class-validator';
import { Transform } from 'class-transformer';

export class UpdateReportDto {
  @ApiProperty({
    description: 'Título del reporte',
    example: 'Bache en calle principal reparado',
    required: false,
    maxLength: 100,
  })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  titulo?: string;

  @ApiProperty({
    description: 'Dirección exacta del problema',
    example: 'Calle Principal 123, Colonia Centro',
    required: false,
    maxLength: 255,
  })
  @IsOptional()
  @IsString()
  @MaxLength(255)
  direccion?: string;

  @ApiProperty({
    description: 'Descripción detallada del problema',
    example: 'Bache reparado pero el material no es de buena calidad',
    required: false,
  })
  @IsOptional()
  @IsString()
  descripcion?: string;

  @ApiProperty({
    description: 'Latitud geográfica',
    example: '19.4326018',
    required: false,
    type: String,
  })
  @IsOptional()
  @IsLatitude()
  @Transform(({ value }) => parseFloat(value).toFixed(8))
  latitud?: string;

  @ApiProperty({
    description: 'Longitud geográfica',
    example: '-99.1332049',
    required: false,
    type: String,
  })
  @IsOptional()
  @IsLongitude()
  @Transform(({ value }) => parseFloat(value).toFixed(8))
  longitud?: string;

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

  @ApiProperty({
    description: 'Estado del reporte',
    example: 'revisado',
    enum: ['revisado', 'sin_revisar'],
    required: false,
  })
  @IsOptional()
  @IsString()
  @IsIn(['revisado', 'sin_revisar'])
  estado?: string;
}
