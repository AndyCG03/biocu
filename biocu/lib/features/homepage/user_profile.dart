import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biocu/core/styles/styles_colors.dart';
import 'package:biocu/core/styles/styles_texts.dart';
import 'package:biocu/features/auth/providers/auth_provider.dart';

class SimpleProfileScreen extends StatelessWidget {
  const SimpleProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.profile;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textDark),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Foto de perfil
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.card,
              ),
              child: Icon(
                Icons.person,
                size: 50,
                color: AppColors.textDark.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 20),

            // Nombre y rol
            Text(
              user?.nombre ?? 'Nombre no disponible',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              (user?.role?.toUpperCase() == 'USER' || user?.role?.isEmpty == true)
                  ? 'USUARIO'
                  : user?.role?.toUpperCase() ?? 'USUARIO',
              style: AppTextStyles.bodyText.copyWith(
                color: AppColors.Lightsecondary,
              ),
            ),
            const SizedBox(height: 30),

            // Información del usuario
            Card(
              elevation: 2,
              color: AppColors.card,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.email, 'Correo electrónico', user?.email),
                    const Divider(height: 24, color: Colors.grey),
                    _buildInfoRow(Icons.person, 'Nombre completo', user?.nombre),
                    const Divider(height: 24, color: Colors.grey),
                    _buildInfoRow(Icons.assignment_ind, 'ID de usuario', user?.id),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.Lightsecondary),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.textDark.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value ?? 'No disponible',
                style: AppTextStyles.bodyText.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar'),
        content: const Text('¿Estás seguro que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                    (Route<dynamic> route) => false,
              );
            },
            child: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}