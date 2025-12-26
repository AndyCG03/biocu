import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/login_response.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';


class AuthProvider with ChangeNotifier {
  final AuthService authService;
  bool _isLoading = false;
  String _errorMessage = '';
  LoginResponse? _currentUser;
  UserModel? _profile;

  static const String _tokenKey = 'auth_token';
  static const String _emailKey = 'auth_email';
  static const String _profileKey = 'user_profile';

  AuthProvider({required this.authService});

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  LoginResponse? get currentUser => _currentUser;
  UserModel? get profile => _profile;

  Future<void> loadUser() async {
    debugPrint('Cargando usuario desde SharedPreferences...');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final email = prefs.getString(_emailKey);

    if (token != null && email != null) {
      _currentUser = LoginResponse(token: token);
      debugPrint('Usuario cargado: $email');

      try {
        // Intenta cargar el perfil desde SharedPreferences primero
        final profileData = prefs.getString(_profileKey);
        if (profileData != null) {
          _profile = UserModel.fromJson(json.decode(profileData));
          debugPrint('Perfil cargado desde caché');
        }

        // Luego intenta actualizar desde el servidor
        await _loadUserProfile(token);
      } catch (e) {
        debugPrint('Error cargando perfil: $e');
        // Si falla, al menos mantenemos el token y email
      }

      notifyListeners();
    }
  }

  Future<void> _loadUserProfile(String token) async {
    try {
      debugPrint('Cargando perfil con token: $token');
      final response = await authService.getProfile(token);

      if (response != null && response.isNotEmpty) {
        // Verifica que los campos requeridos existan
        if (response['id'] == null ||
            response['nombre'] == null ||
            response['email'] == null ||
            response['role'] == null) {
          throw Exception('El perfil no contiene todos los campos requeridos');
        }

        _profile = UserModel(
          id: response['id'].toString(),
          nombre: response['nombre'].toString(),
          email: response['email'].toString(),
          role: response['role'].toString(),
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_profileKey, json.encode(_profile!.toJson()));
        debugPrint('Perfil cargado exitosamente');
      } else {
        throw Exception('La respuesta del perfil está vacía');
      }
    } catch (e) {
      debugPrint('Error cargando perfil: $e');
      // Limpia el perfil si hay error
      _profile = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_profileKey);
      throw Exception('No se pudo cargar el perfil del usuario');
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    debugPrint('Iniciando sesión para: $email');

    try {
      final response = await authService.login(email: email, password: password);
      debugPrint('Respuesta del login: ${response.token}');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, response.token);
      await prefs.setString(_emailKey, email); // Guarda el email también

      _currentUser = LoginResponse(token: response.token);

      try {
        await _loadUserProfile(response.token);
      } catch (e) {
        debugPrint('Error cargando perfil: $e');
        // Continúa aunque falle la carga del perfil
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _parseLoginError(e);
      debugPrint('Error en login: $_errorMessage');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  String _parseLoginError(dynamic error) {
    if (error.toString().contains('Credenciales incorrectas')) {
      return 'Correo o contraseña incorrectos';
    } else if (error.toString().contains('Error de conexión')) {
      return 'Problema de conexión. Verifica tu internet';
    } else {
      return 'Error al iniciar sesión. Intenta nuevamente';
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_profileKey);

    _currentUser = null;
    _profile = null;
    notifyListeners();
  }
  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final isAuth = prefs.containsKey(_tokenKey);
    debugPrint('¿Usuario autenticado? $isAuth');
    return isAuth;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    debugPrint('Token obtenido: $token');
    return token;
  }

  /// Registro de nuevo usuario
  Future<bool> register({
    required String email,
    required String password,
    required String username,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    debugPrint('Registrando nuevo usuario: $email');

    try {
      // 1. Registrar al usuario
      await authService.register(
        username: username,
        passwordHash: password,
        email: email,
      );

      // 2. Iniciar sesión automáticamente
      final loginResponse = await authService.login(
        email: email,
        password: password,
      );
      debugPrint('Autologin después de registro: ${loginResponse.token}');

      // 3. Guardar datos de autenticación
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, loginResponse.token);
      await prefs.setString(_emailKey, email);
      _currentUser = LoginResponse(token: loginResponse.token);

      // 4. Cargar y guardar perfil
      try {
        await _loadUserProfile(loginResponse.token);
      } catch (e) {
        debugPrint('Error cargando perfil después de registro: $e');
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } on ConflictException catch (e) {
      _errorMessage = 'El email ya está registrado';
      debugPrint('Error de conflicto: ${e.message}');
    } on AuthException catch (e) {
      _errorMessage = 'Error al iniciar sesión automática después del registro';
      debugPrint('Error de autenticación: ${e.message}');
    } on ApiException catch (e) {
      _errorMessage = 'Error en el servidor (${e.statusCode})';
      debugPrint('Error de API: ${e.message}');
    } catch (e) {
      _errorMessage = 'Error inesperado al registrar';
      debugPrint('Error desconocido: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Método para acceder a la información guardada del perfil
  Future<UserModel?> getProfile() async {
    if (_profile != null) {
      return _profile; // Si ya se ha cargado el perfil, devolverlo
    }

    // Si el perfil no está en memoria, intentar cargarlo de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final profileData = prefs.getString(_profileKey);

    if (profileData != null) {
      final profile = UserModel.fromJson(json.decode(profileData));
      _profile = profile;
      return profile;
    }

    // Si no se encuentra el perfil guardado, retornar null
    return null;
  }

  // Método para obtener el email del usuario desde SharedPreferences
  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  // Método para obtener el nombre del usuario desde el perfil
  Future<String?> getUserName() async {
    final user = await getProfile();
    return user?.nombre; // Obtener nombre desde el perfil si está disponible
  }

  // Método para obtener el rol del usuario desde el perfil
  Future<String?> getUserRole() async {
    final user = await getProfile();
    return user?.role; // Obtener rol desde el perfil si está disponible
  }
}
