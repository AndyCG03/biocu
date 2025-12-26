import 'dart:convert';
import 'dart:io';

class ImageConverter {
  // Convertir una imagen (File) a Base64
  static Future<String> fileToBase64(File file) async {
    List<int> imageBytes = await file.readAsBytes();
    return base64Encode(imageBytes);
  }

  // Convertir una cadena Base64 a un archivo (File)
  static Future<File> base64ToFile(String base64String, String filePath) async {
    List<int> bytes = base64Decode(base64String);
    File file = File(filePath);
    return file.writeAsBytes(bytes);
  }
}
