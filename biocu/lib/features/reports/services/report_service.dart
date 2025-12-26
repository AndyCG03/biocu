import 'dart:convert';
import 'dart:io';
import 'package:biocu/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

import '../models/report_model_admin.dart';

class ReportService {
  final String baseUrl = ApiConstants.baseUrl; // Cambia esta URL a la de tu API

  // Crear el reporte y enviar los datos al servidor
  Future<bool> createReport({
    required String titulo,
    required String direccion,
    required String descripcion,
    required double latitud,
    required double longitud,
    required List<String> imagenesBase64, // Las imágenes ya están en Base64

    required String token,  // El token para la autenticación
  }) async {
    try {
      final url = Uri.parse('$baseUrl/reports'); // Cambia la URL según tu endpoint

      final headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token', // Enviar el token en el header
      };

      final body = jsonEncode({
        'titulo': titulo,
        'direccion': direccion,
        'descripcion': descripcion,
        'latitud': latitud.toString(),
        'longitud': longitud.toString(),
        'imagenes': imagenesBase64,

      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Error al crear el reporte: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error al enviar el reporte: $e');
    }
  }

  //ESTO ES DE ADMIN
  Future<List<Report>> getAllReports(String token) async {
    try {
      final url = Uri.parse('$baseUrl/reports');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((report) => Report.fromJson(report)).toList();
      } else {
        throw Exception('Failed to load reports: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching reports: $e');
    }
  }

  // Cambiar el estado de un reporte (PATCH)
  Future<bool> changeReportStatus({
    required String reportId,
    required String token,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/reports/$reportId/status');
      final headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      };

      final response = await http.patch(url, headers: headers);

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Error al cambiar el estado: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error al actualizar el estado: $e');
    }
  }

  // Eliminar un reporte (DELETE)
  Future<bool> deleteReport({
    required String reportId,
    required String token,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/reports/$reportId/delete');
      final headers = {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      };

      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Error al eliminar el reporte: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error al eliminar el reporte: $e');
    }
  }


  // Método para construir URLs completas de imágenes (si es necesario)
  String getFullImageUrl(String relativePath) {
    return '$baseUrl/$relativePath'.replaceAll(r'\', '/');
  }
}
