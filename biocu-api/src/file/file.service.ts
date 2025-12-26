/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-call */
import { Injectable } from '@nestjs/common';
import * as fs from 'fs-extra';
import { join } from 'path';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class FileService {
  private readonly uploadPath = join(__dirname, '..', '..', 'uploads');

  async saveUserImages(
    userId: string,
    base64Images: string[],
  ): Promise<string[]> {
    const userUploadPath = join(this.uploadPath, userId);
    await fs.ensureDir(userUploadPath); // Crea la carpeta si no existe

    const savedImages: string[] = [];

    for (const base64Image of base64Images) {
      const imageName = `${uuidv4()}.jpg`;
      const imagePath = join(userUploadPath, imageName);

      // Eliminar el encabezado si existe (ej: "data:image/jpeg;base64,")
      const base64Data = base64Image.replace(/^data:image\/\w+;base64,/, '');
      const imageBuffer = Buffer.from(base64Data, 'base64');

      await fs.writeFile(imagePath, imageBuffer);
      savedImages.push(join('uploads', userId, imageName)); // Ruta relativa
    }

    return savedImages;
  }

  async deleteUserImage(imagePath: string): Promise<void> {
    const fullPath = join(__dirname, '..', '..', imagePath);
    await fs.remove(fullPath);
  }
}
