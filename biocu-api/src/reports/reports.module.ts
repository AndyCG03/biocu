// src/reports/reports.module.ts
import { Module } from '@nestjs/common';
import { ReportsService } from './reports.service';
import { ReportsController } from './reports.controller';
import { PrismaModule } from '../prisma/prisma.module'; // Importa el PrismaModule
import { FileService } from 'src/file/file.service';

@Module({
  imports: [PrismaModule], // Añade esta línea
  controllers: [ReportsController],
  providers: [ReportsService, FileService],
  exports: [ReportsService, FileService],
})
export class ReportsModule {}
