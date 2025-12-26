import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biocu/features/auth/providers/auth_provider.dart';
import '../../homepage/homepage_view.dart';
import '../presentation/login.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late Future<bool> _checkAuth;

  @override
  void initState() {
    super.initState();
    _checkAuth = _initAuth();
  }

  Future<bool> _initAuth() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isLoggedIn = await authProvider.isAuthenticated();

      if (isLoggedIn) {
        await authProvider.loadUser();
        // Verifica que tanto el token como el perfil estén cargados
        return authProvider.currentUser != null && authProvider.profile != null;
      }
      return false;
    } catch (e) {
      debugPrint('Error en _initAuth: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkAuth,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const LoginPage(); // En caso de error, va al login
        }

        return snapshot.data == true ? const HomePage() : const LoginPage();
      },
    );
  }
}