import { ApiProperty } from '@nestjs/swagger';

export class ReportResponseDto {
  @ApiProperty({
    description: 'ID único del reporte',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  id: string;

  @ApiProperty({
    description: 'Título del reporte',
    example: 'Bache en calle principal',
  })
  titulo: string;

  @ApiProperty({
    description: 'Dirección exacta del problema',
    example: 'Calle Principal 123, Colonia Centro',
  })
  direccion: string;

  @ApiProperty({
    description: 'Descripción detallada del problema',
    example: 'Bache de aproximadamente 1m de diámetro y 30cm de profundidad',
  })
  descripcion: string;

  @ApiProperty({
    description: 'Latitud geográfica',
    example: '19.4326018',
  })
  latitud: string;

  @ApiProperty({
    description: 'Longitud geográfica',
    example: '-99.1332049',
  })
  longitud: string;

  @ApiProperty({
    description: 'Imágenes en formato base64',
    example: ['data:image/jpeg;base64,/9j/4AAQSkZJRgABAQ...'],
    type: [String],
    required: false,
  })
  imagenes?: string[];

  @ApiProperty({
    description: 'Estado del reporte',
    example: 'sin_revisar',
    enum: ['revisado', 'sin_revisar'],
  })
  estado: string;

  @ApiProperty({
    description: 'Fecha de creación del reporte',
    example: '2023-05-15T12:00:00.000Z',
  })
  fecha_creacion: Date;

  @ApiProperty({
    description: 'Fecha de última actualización del reporte',
    example: '2023-05-15T12:00:00.000Z',
  })
  fecha_actualizacion: Date;
}
