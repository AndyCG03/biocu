import 'package:biocu/core/network/api_service.dart';
import 'package:biocu/features/reports/providers/report_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:biocu/core/styles/styles_colors.dart';
import 'package:biocu/core/styles/styles_texts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/images_converter.dart';
import '../../../core/widgets/custom_show_dialog.dart';
import '../../auth/providers/auth_provider.dart';
import '../../homepage/homepage_view.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isSubmitting = false;

  late List<File?> _images = List.generate(3, (_) => null);
  int _currentImageIndex = 0;

  String _location = 'Obteniendo ubicación...';
  bool _isLoadingLocation = false;
  String _locationError = '';
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _locationError = '';
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationServiceDisabledDialog();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationError = 'Permisos de ubicación denegados';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationError = 'Permisos de ubicación permanentemente denegados';
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _location =
            'Latitud: ${position.latitude.toStringAsFixed(6)}, Longitud: ${position.longitude.toStringAsFixed(6)}';
      });
    } catch (e) {
      setState(() {
        _locationError = 'Error al obtener ubicación: $e';
      });
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  void _showLocationServiceDisabledDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (BuildContext context) => AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ubicación deshabilitada',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
            content: const Text(
              'Por favor, habilite la ubicación para reportar problemas.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancelar',
                  style: AppTextStyles.bodyText.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await Geolocator.openLocationSettings();
                  _getCurrentLocation();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.Lightsecondary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Abrir ajustes',
                  style: AppTextStyles.buttonText.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _images[_currentImageIndex] = File(pickedFile.path);

        if (_currentImageIndex < 2 && _images[_currentImageIndex + 1] == null) {
          _currentImageIndex++;
        }
      });
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _images[index] = null;

      for (int i = index; i < 2; i++) {
        _images[i] = _images[i + 1];
        _images[i + 1] = null;
      }

      if (_currentImageIndex >= index) {
        _currentImageIndex = _images.indexWhere((img) => img == null);
        if (_currentImageIndex == -1) _currentImageIndex = 2;
      }
    });
  }

  Future<bool> hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> _submitReport() async {

    // Verificar conexión inicial
    final isConnected = await hasInternetConnection();
    if (!isConnected) {
      _showErrorDialog(
        'No hay conexión a internet. Por favor, conéctese y vuelva a intentarlo.',
      );
      return;
    }

    // Validaciones de campos existentes
    if (_titleController.text.isEmpty) {
      _showErrorDialog('Por favor ingrese un título para el reporte');
      return;
    }

    if (_descriptionController.text.isEmpty) {
      _showErrorDialog('Por favor ingrese una descripción del problema');
      return;
    }

    if (_addressController.text.isEmpty) {
      _showErrorDialog('Por favor ingrese una dirección');
      return;
    }

    if (_images.every((img) => img == null)) {
      _showErrorDialog('Por favor tome al menos una foto del problema');
      return;
    }

    if (_currentPosition == null) {
      _showErrorDialog(
        'No se pudo obtener la ubicación. Por favor intente nuevamente.',
      );
      return;
    }

    // Verificar conexión nuevamente antes de enviar
    final isStillConnected = await hasInternetConnection();
    if (!isStillConnected) {
      _showErrorDialog(
        'Perdiste la conexión a internet durante el proceso. Por favor, reconéctate.',
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final reportProvider = Provider.of<ReportProvider>(context, listen: false);
    //final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      final success = await reportProvider.createReport(
        titulo: _titleController.text.trim(),
        direccion: _addressController.text.trim(),
        descripcion: _descriptionController.text.trim(),
        latitud: _currentPosition!.latitude,
        longitud: _currentPosition!.longitude,
        imagenesFiles: _images.whereType<File>().toList(),
      );

      if (success) {
        // Redirigir a HomePage con la pestaña de contenidos seleccionada
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder:
                (context) => HomePage(
                  initialIndex: 0, // Índice para la pestaña de contenidos
                ),
          ),
          (Route<dynamic> route) => false,
        );

        _showSuccessDialog();
        // Opcional: Mostrar mensaje de éxito
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Reporte enviado con éxito'),
        //     backgroundColor: Colors.green,
        //   ),
        // );
      } else {
        _showErrorDialog(
          reportProvider.errorMessage ??
              'Ocurrió un error al enviar el reporte.',
        );
      }
    } catch (e) {
      _showErrorDialog('Error inesperado: $e');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => CustomAlertDialog(
            title: 'Reporte creado',
            message: 'Tu reporte se ha enviado correctamente.',
            confirmText: 'Aceptar',
            confirmColor: AppColors.Lightsecondary,
            // Verde de éxito
            onConfirm: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => HomePage(initialIndex: 0),
                ),
                (Route<dynamic> route) => false,
              );
            },
          ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => CustomAlertDialog(
            title: 'Error',
            message: message,
            confirmText: 'Entendido',
            confirmColor: AppColors.accent,
            // Rojo/naranja para errores
            onConfirm: () => print('exit'),
          ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.Lightsecondary,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.primary),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Título del Reporte',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Ej: Basura acumulada en parque',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: AppColors.card,
                  ),
                  style: AppTextStyles.bodyText,
                ),
                const SizedBox(height: 20),

                Text(
                  'Descripción del Problema',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Describa el problema en detalle...',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: AppColors.card,
                  ),
                  style: AppTextStyles.bodyText,
                  maxLines: 4,
                ),
                const SizedBox(height: 20),

                Text(
                  'Dirección',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    hintText: 'Ej: Calle 42 #123 entre 1ra y 3ra',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: AppColors.card,
                  ),
                  style: AppTextStyles.bodyText,
                ),
                const SizedBox(height: 20),

                Text(
                  'Ubicación Actual',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 2,
                  color: AppColors.card,
                  child: ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: AppColors.Lightsecondary,
                    ),
                    title: Text(
                      _locationError.isNotEmpty ? _locationError : _location,
                      style: AppTextStyles.bodyText,
                    ),
                    trailing:
                        _isLoadingLocation
                            ? const CircularProgressIndicator(
                              color: AppColors.Lightsecondary,
                            ) // O el verde que quieras
                            : IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: _getCurrentLocation,
                            ),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  'Fotos del Problema',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Máximo 3 fotos (${_images.where((img) => img != null).length}/3)',
                  style: AppTextStyles.bodyText.copyWith(
                    color: AppColors.textDark.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 12),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (_images[index] == null) {
                          setState(() => _currentImageIndex = index);
                          _takePhoto();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                _images[index] == null
                                    ? AppColors.primary.withOpacity(0.5)
                                    : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child:
                            _images[index] != null
                                ? Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.file(
                                        _images[index]!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () => _removePhoto(index),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                              0.5,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          padding: const EdgeInsets.all(4),
                                          child: const Icon(
                                            Icons.close,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                                : Center(
                                  child: Icon(
                                    Icons.add_a_photo,
                                    size: 30,
                                    color: AppColors.textDark.withOpacity(0.7),
                                  ),
                                ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.Lightsecondary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'ENVIAR REPORTE',
                      style: AppTextStyles.buttonText.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          if (_isSubmitting)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.Lightsecondary),
                      strokeWidth: 5,
                    ),
                    // Lottie.asset(
                    //   'assets/lottie/carga.json',  // Ruta de tu archivo Lottie
                    //   width: 100,  // Ajusta el tamaño
                    //   height: 100,  // Ajusta el tamaño
                    //   fit: BoxFit.cover,
                    // ),
                    const SizedBox(height: 20),
                    Text(
                      'Creando reporte...',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
