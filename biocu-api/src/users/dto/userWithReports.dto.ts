import { ApiProperty } from '@nestjs/swagger';
import { ReportResponseDto } from 'src/reports/dto/response-report.dto';
import { UserResponseDto } from './response-user.dto';

export class UserWithReportsResponseDto extends UserResponseDto {
  @ApiProperty({
    description: 'Array de reportes creados por el usuario',
    type: [ReportResponseDto],
    required: false,
  })
  reportes?: ReportResponseDto[];
}
