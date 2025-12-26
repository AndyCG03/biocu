import 'dart:convert';
import 'package:biocu/core/constants/api_constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String baseUrl = ApiConstants.baseUrl; // Cambia esto por tu URL
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<http.Response> get(String endpoint) async {
    final token = await _getToken();
    final uri = Uri.parse('$baseUrl/$endpoint');
    return http.get(
      uri,
      headers: _buildHeaders(token),
    );
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final token = await _getToken();
    final uri = Uri.parse('$baseUrl/$endpoint');
    return http.post(
      uri,
      headers: _buildHeaders(token),
      body: jsonEncode(data),
    );
  }

  Map<String, String> _buildHeaders(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}
