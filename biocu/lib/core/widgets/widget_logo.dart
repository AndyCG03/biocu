import 'package:flutter/material.dart';

import '../constants/assets_constants.dart';

class AppLogo extends StatelessWidget {
  final double height;

  const AppLogo({super.key, this.height = 100});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AssetConstants.logo,
      height: height,
      fit: BoxFit.contain,
    );
  }
}