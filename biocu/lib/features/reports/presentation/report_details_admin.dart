import 'package:biocu/features/reports/providers/report_provider.dart';
import 'package:flutter/material.dart';
import 'package:biocu/core/styles/styles_colors.dart';
import 'package:biocu/core/styles/styles_texts.dart';
import 'package:provider/provider.dart';
import '../models/report_model_admin.dart';

class ReportDetailScreen extends StatelessWidget {
  final Report report;
  final VoidCallback onStatusChanged;

  const ReportDetailScreen({
    super.key,
    required this.report,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context, listen: false);

    Future<void> _handleDelete() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Estás seguro de que deseas eliminar este reporte?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        final success = await reportProvider.deleteReport(report.id);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Reporte eliminado correctamente'),
              backgroundColor: Colors.green,
            ),
          );
          onStatusChanged();
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(reportProvider.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }

    Future<void> _handleAccept() async {
      final success = await reportProvider.changeReportStatus(reportId: report.id);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reporte marcado como revisado'),
            backgroundColor: Colors.green,
          ),
        );
        onStatusChanged();
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(reportProvider.errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    }


    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Detalle del Reporte',
          style: AppTextStyles.buttonText.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEstadoFecha(report),
                  const Divider(height: 32),
                  _buildSection('Título:', report.titulo, isTitle: true),
                  const Divider(height: 32),
                  _buildSection('Descripción:', report.descripcion),
                  const Divider(height: 32),
                  _buildSection('Ubicación:', report.direccion, icon: Icons.location_on),
                  const Divider(height: 32),
                  _buildSection(
                    'Coordenadas:',
                    'Lat: ${report.latitud.toStringAsFixed(6)}, '
                        'Lng: ${report.longitud.toStringAsFixed(6)}',
                    icon: Icons.map,
                  ),
                  const Divider(height: 32),
                  _buildSection('Reportado por:', report.nombreUsuario),
                  if (report.imagenes.isNotEmpty) ...[
                    const Divider(height: 32),
                    Text(
                      'Imágenes:',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.textDark.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: report.imagenes.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap: () {
                                _showFullImageDialog(context, reportProvider.getFullImageUrl(report.imagenes[index]));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  reportProvider.getFullImageUrl(report.imagenes[index]),
                                  width: 300,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 300,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.broken_image),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _handleDelete,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'ELIMINAR',
                      style: AppTextStyles.buttonText.copyWith(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _handleAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.Lightsecondary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'ACEPTAR',
                      style: AppTextStyles.buttonText.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstadoFecha(Report report) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(report.estado),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            report.estado.replaceAll('_', ' ').capitalize(),
            style: AppTextStyles.bodyText.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Spacer(),
        Text(
          '${report.fechaCreacion.day}/${report.fechaCreacion.month}/${report.fechaCreacion.year}',
          style: AppTextStyles.bodyText,
        ),
      ],
    );
  }

  Widget _buildSection(String title, String content, {bool isTitle = false, IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textDark.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 8),
        icon != null
            ? Row(
          children: [
            Icon(icon, size: 20, color: AppColors.Lightsecondary),
            const SizedBox(width: 8),
            Expanded(child: Text(content, style: AppTextStyles.bodyText)),
          ],
        )
            : Text(
          content,
          style: isTitle
              ? AppTextStyles.headlineLarge.copyWith(fontWeight: FontWeight.bold)
              : AppTextStyles.bodyText,
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'revisado':
        return Colors.green;
    // case 'rechazado':
    //   return Colors.red;
      case 'sin_revisar':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // Método para mostrar la imagen en tamaño completo
  void _showFullImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop(); // Cierra el diálogo cuando se toca la imagen
            },
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              height: 400,
            ),
          ),
        );
      },
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return isNotEmpty
        ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}'
        : this;
  }
}