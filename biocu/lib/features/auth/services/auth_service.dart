import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_response.dart';

class AuthService {
  final String baseUrl;

  AuthService({required this.baseUrl});

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return LoginResponse.fromJson(responseBody);
      } else if (response.statusCode == 401) {
        throw AuthException(
          message: responseBody['message'] ?? 'Credenciales inválidas',
          statusCode: response.statusCode,
        );
      } else {
        throw ApiException(
          message: responseBody['message'] ?? 'Error al iniciar sesión',
          statusCode: response.statusCode,
        );
      }
    } on http.ClientException catch (e) {
      throw NetworkException(message: 'Error de conexión: ${e.message}');
    } on FormatException {
      throw DataException(message: 'Error en el formato de los datos');
    }
  }

  Future<Map<String, dynamic>> getProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return responseBody as Map<String, dynamic>;
      } else if (response.statusCode == 401) {
        throw AuthException(
          message: 'No autorizado - Token inválido o expirado',
          statusCode: response.statusCode,
        );
      } else {
        throw ApiException(
          message: responseBody['message'] ?? 'Error obteniendo perfil',
          statusCode: response.statusCode,
        );
      }
    } on http.ClientException catch (e) {
      throw NetworkException(message: 'Error de conexión: ${e.message}');
    } on FormatException {
      throw DataException(message: 'Error en el formato de los datos');
    }
  }

  Future<bool> register({
    required String email,
    required String passwordHash,
    required String username,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': username,
          'email': email,
          'password_hash': passwordHash,
          'role': "user",
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 409) {
        throw ConflictException(
          message: responseBody['message'] ?? 'El usuario ya existe',
          statusCode: response.statusCode,
        );
      } else {
        throw ApiException(
          message: responseBody['message'] ?? 'Error en el registro',
          statusCode: response.statusCode,
        );
      }
    } on http.ClientException catch (e) {
      throw NetworkException(message: 'Error de conexión: ${e.message}');
    } on FormatException {
      throw DataException(message: 'Error en el formato de los datos');
    }
  }
}

// Excepciones personalizadas
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException({required this.message, required this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class AuthException extends ApiException {
  AuthException({required String message, required int statusCode})
      : super(message: message, statusCode: statusCode);
}

class ConflictException extends ApiException {
  ConflictException({required String message, required int statusCode})
      : super(message: message, statusCode: statusCode);
}

class NetworkException implements Exception {
  final String message;

  NetworkException({required this.message});

  @override
  String toString() => 'NetworkException: $message';
}

class DataException implements Exception {
  final String message;

  DataException({required this.message});

  @override
  String toString() => 'DataException: $message';
}