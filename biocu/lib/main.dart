import 'package:biocu/core/constants/api_constants.dart';
import 'package:biocu/features/auth/presentation/forgot_password.dart';
import 'package:biocu/features/reports/presentation/report_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/widgets/doubleTap_to_exit.dart';
import 'features/auth/presentation/login.dart';
import 'features/auth/presentation/register_page.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/services/auth_gate.dart';
import 'features/auth/services/auth_service.dart';
import 'features/homepage/homepage_view.dart';
import 'features/reports/providers/report_provider.dart';
import 'features/reports/services/report_service.dart';
import 'features/tutorial/onborad_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            authService: AuthService(baseUrl: ApiConstants.baseUrl),
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ReportProvider>(
          create: (context) => ReportProvider(
            reportService: ReportService(),
            authProvider: Provider.of<AuthProvider>(context, listen: false),
          ),
          update: (context, authProvider, previous) => ReportProvider(
            reportService: ReportService(),
            authProvider: authProvider,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biocu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      builder: (context, child) {
        return DoubleBackExitWrapper(
          child: child!,
        );
      },
      home: const AuthGate(),
      // Ahora comienza en el Login
      routes: {
        '/register': (context) => const RegisterPage(),
        '/forgot_password': (context) => const ForgotPasswordPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/reports': (context) => const ReportScreen(),
        '/tutorial': (context) => const OnboardingPage(),
      },
    );
  }
}
