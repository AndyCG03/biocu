import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:biocu/features/auth/providers/auth_provider.dart';
import 'package:biocu/features/reports/models/report_model.dart';
import 'package:biocu/features/reports/services/report_service.dart';

import '../models/report_model_admin.dart';

class ReportProvider with ChangeNotifier {
  final ReportService reportService;
  final AuthProvider authProvider;

  ReportProvider({
    required this.reportService,
    required this.authProvider,
  });

  // Estado
  List<Report> _reports = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  List<Report> get reports => _reports;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Convertir imagen a base64
  Future<String> _convertImageToBase64(File image) async {
    try {
      final imageBytes = await image.readAsBytes();
      return base64Encode(imageBytes);
    } catch (e) {
      throw Exception('Error al procesar imágenes: $e');
    }
  }

  // Crear reporte
  Future<bool> createReport({
    required String titulo,
    required String direccion,
    required String descripcion,
    required double latitud,
    required double longitud,
    required List<File> imagenesFiles,

  }) async {
    if (titulo.isEmpty || direccion.isEmpty || descripcion.isEmpty) {
      _errorMessage = 'Todos los campos son requeridos';
      notifyListeners();
      return false;
    }

    if (imagenesFiles.isEmpty) {
      _errorMessage = 'Debe agregar al menos una imagen';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final imagenesBase64 = await Future.wait(
        imagenesFiles.map((image) => _convertImageToBase64(image)),
      );

      final token = await authProvider.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('No se encontró el token de autenticación');
      }

      final success = await reportService.createReport(
        titulo: titulo,
        direccion: direccion,
        descripcion: descripcion,
        latitud: latitud,
        longitud: longitud,
        imagenesBase64: imagenesBase64,

        token: token,
      );

      if (!success) {
        throw Exception('El servidor no pudo procesar el reporte');
      }

      return true;
    } catch (e) {
      _errorMessage = _parseErrorMessage(e);
      debugPrint('Error en ReportProvider: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cargar reportes
  Future<void> loadReports() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final token = await authProvider.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('No authentication token available');
      }

      _reports = await reportService.getAllReports(token);
    } catch (e) {
      _errorMessage = _parseErrorMessage(e);
      _reports = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Buscar reportes por texto
  List<Report> searchReports(String query) {
    if (query.isEmpty) return _reports;
    return _reports.where((report) =>
    report.titulo.toLowerCase().contains(query.toLowerCase()) ||
        report.descripcion.toLowerCase().contains(query.toLowerCase()) ||
        report.direccion.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }



  String getFullImageUrl(String imagePath) {
    return reportService.getFullImageUrl(imagePath);
  }

  // Filtrar por estado
  List<Report> getReportsByStatus(String status) {
    return _reports.where((report) => report.estado == status).toList();
  }

  // Resetear estado de error/carga
  void resetState() {
    _isLoading = false;
    _errorMessage = '';
    notifyListeners();
  }

  void clearReports() {
    _reports = [];
    notifyListeners();
  }



  Future<bool> changeReportStatus({
    required String reportId,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final token = await authProvider.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('No authentication token available');
      }

      final success = await reportService.changeReportStatus(
        reportId: reportId,
        token: token,
      );

      if (success) {
        // Actualizar el estado localmente a "Revisado" directamente
        final index = _reports.indexWhere((r) => r.id == reportId);
        if (index != -1) {
          _reports[index] = _reports[index].copyWith(estado: "Revisado");
          notifyListeners();
        }
      }

      return success;
    } catch (e) {
      _errorMessage = _parseErrorMessage(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Eliminar reporte
  Future<bool> deleteReport(String reportId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final token = await authProvider.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('No authentication token available');
      }

      final success = await reportService.deleteReport(
        reportId: reportId,
        token: token,
      );

      if (success) {
        _reports.removeWhere((r) => r.id == reportId);
        notifyListeners();
      }

      return success;
    } catch (e) {
      _errorMessage = _parseErrorMessage(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  // Formatear errores comunes
  String _parseErrorMessage(dynamic error) {
    if (error is SocketException) return 'Error de conexión a internet';
    if (error is HttpException) return 'Error en el servidor (${error.message})';
    if (error is FormatException) return 'Error en el formato de los datos';
    if (error.toString().contains('token')) return 'Problema de autenticación';
    return 'Error: ${error.toString()}';
  }
}
