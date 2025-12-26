import 'package:biocu/core/styles/styles_colors.dart';
import 'package:flutter/material.dart';

class DoubleBackExitWrapper extends StatefulWidget {
  final Widget child;
  final String message;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const DoubleBackExitWrapper({
    super.key,
    required this.child,
    this.message = 'Presiona de nuevo para salir',
    this.scaffoldKey,
  });

  @override
  State<DoubleBackExitWrapper> createState() => _DoubleBackExitWrapperState();
}

class _DoubleBackExitWrapperState extends State<DoubleBackExitWrapper> {
  DateTime? lastBackPressedTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Si el drawer está abierto, ciérralo primero
        if (widget.scaffoldKey?.currentState?.isDrawerOpen ?? false) {
          Navigator.of(context).pop();
          return false;
        }

        final now = DateTime.now();
        final shouldExit = lastBackPressedTime != null &&
            now.difference(lastBackPressedTime!) < const Duration(seconds: 2);

        if (shouldExit) return true;

        lastBackPressedTime = now;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text(
                widget.message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            backgroundColor: AppColors.primary.withOpacity(0.95), // Transparencia
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.all(20),
            duration: const Duration(seconds: 2),
            elevation: 4,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        );
        return false;
      },
      child: widget.child,
    );
  }
}