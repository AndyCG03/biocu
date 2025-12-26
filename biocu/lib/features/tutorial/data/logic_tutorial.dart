import 'dart:ui';

import '../../../core/styles/styles_colors.dart';

class OnboardContent {
  final String lottieAnimation;
  final String title;
  final String description;
  final Color backgroundColor;

  OnboardContent({
    required this.lottieAnimation,
    required this.title,
    required this.description,
    this.backgroundColor = AppColors.background,
  });
}

List<OnboardContent> contents = [
  OnboardContent(
    lottieAnimation: "assets/lottie/avatar.json",
    title: "¡Bienvenido a Biocu!",
    description: "Tu app para mejorar la comunidad cubana\n\nReporta problemas y contribuye al cambio",
  ),
  OnboardContent(
    lottieAnimation: "assets/lottie/photo.json",
    title: "Reporta problemas",
    description: "1. Fotografía el problema (baches, basura, fugas)\n"
        "2. Describe la situación\n"
        "3. Ubícalo en el mapa\n\n"
        "¡Entre todos podemos mejorar nuestro entorno!",
  ),
  OnboardContent(
    lottieAnimation: "assets/lottie/document.json",
    title: "Verificación colectiva",
    description: "Los reportes son revisados por la comunidad\n"
        "y autoridades competentes\n\n"
        "Tus contribuciones serán reconocidas",
  ),
  OnboardContent(
    lottieAnimation: "assets/lottie/start.json",
    title: "¡Listo para comenzar!",
    description: "Empieza a reportar problemas en tu comunidad\n\n"
        "Tu participación hace la diferencia",
  ),
];