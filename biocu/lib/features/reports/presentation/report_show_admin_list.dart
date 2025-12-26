import 'package:biocu/features/reports/presentation/report_details_admin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biocu/features/reports/models/report_model.dart';
import 'package:biocu/features/reports/providers/report_provider.dart';
import 'package:biocu/core/styles/styles_colors.dart';
import 'package:biocu/core/styles/styles_texts.dart';

import '../models/report_model_admin.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Todos';

  final Map<String, Color> _statusColors = {
    'Todos': Colors.grey,
    'sin_revisar': Colors.orange,
    'revisado': Colors.green,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReports();
    });
  }

  Future<void> _loadReports() async {
    await Provider.of<ReportProvider>(context, listen: false).loadReports();
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar reportes...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),

          // Selector de filtros horizontal
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _statusColors.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      StringExtension(entry.key.replaceAll('_', ' ')).capitalize(),
                      style: AppTextStyles.bodyText.copyWith(
                        color: _selectedFilter == entry.key
                            ? Colors.white
                            : AppColors.textDark,
                      ),
                    ),
                    selected: _selectedFilter == entry.key,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = selected ? entry.key : 'Todos';
                      });
                    },
                    backgroundColor: entry.value.withOpacity(0.2),
                    selectedColor: entry.value,
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Lista de reportes
          Expanded(
            child: reportProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : reportProvider.errorMessage.isNotEmpty
                ? Center(
              child: Text(
                reportProvider.errorMessage,
                style: AppTextStyles.bodyText,
              ),
            )
                : _buildReportsList(reportProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsList(ReportProvider reportProvider) {
    List<Report> filteredReports = reportProvider.reports
        .where((report) =>
    _selectedFilter == 'Todos' || report.estado == _selectedFilter)
        .where((report) =>
    _searchController.text.isEmpty ||
        report.titulo.toLowerCase().contains(_searchController.text.toLowerCase()) ||
        report.descripcion.toLowerCase().contains(_searchController.text.toLowerCase()))
        .toList();

    if (filteredReports.isEmpty) {
      return Center(
        child: Text(
          'No se encontraron reportes',
          style: AppTextStyles.bodyText,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadReports,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: filteredReports.length,
        itemBuilder: (context, index) {
          final report = filteredReports[index];
          return _buildReportCard(report, reportProvider);
        },
      ),
    );
  }

  Widget _buildReportCard(Report report, ReportProvider reportProvider) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReportDetailScreen(
              report: report,
              onStatusChanged: () {
                reportProvider.loadReports(); // Recargar la lista después de cambios
              },
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado con estado y fecha
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColors[report.estado] ?? Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      StringExtension(report.estado.replaceAll('_', ' ')).capitalize(),
                      style: AppTextStyles.bodyText.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${report.fechaCreacion.day}/${report.fechaCreacion.month}/${report.fechaCreacion.year}',
                    style: AppTextStyles.bodyText,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Título y descripción
              Text(
                report.titulo,
                style: AppTextStyles.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                report.descripcion,
                style: AppTextStyles.bodyText,
              ),
              const SizedBox(height: 8),

              // Dirección
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: AppColors.textDark.withOpacity(0.5)),
                  const SizedBox(width: 4),
                  Text(
                    report.direccion,
                    style: AppTextStyles.bodyText.copyWith(
                      color: AppColors.textDark.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Imágenes (si existen)
              if (report.imagenes.isNotEmpty) ...[
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: report.imagenes.length,
                    itemBuilder: (context, index) {
                      final imageUrl = report.imagenes[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            reportProvider.getFullImageUrl(imageUrl),
                            width: 160,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 160,
                                color: Colors.grey[200],
                                child: const Icon(Icons.broken_image),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Usuario que reportó
              Text(
                'Reportado por: ${report.nombreUsuario}',
                style: AppTextStyles.bodyText.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

extension StringExtension on String {
  String capitalize() {
    return isNotEmpty
        ? "${this[0].toUpperCase()}${substring(1).toLowerCase()}"
        : this;
  }
}