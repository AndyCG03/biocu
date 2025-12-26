class ReportModel {
  final String id;
  final String titulo;
  final String direccion;
  final String descripcion;
  final double latitud;
  final double longitud;
  final List<String> imagenesBase64; // Cambiado de imagenesUrls a imagenesBase64
  final String usuarioId;
  final DateTime fechaCreacion;

  ReportModel({
    required this.id,
    required this.titulo,
    required this.direccion,
    required this.descripcion,
    required this.latitud,
    required this.longitud,
    required this.imagenesBase64,
    required this.usuarioId,
    required this.fechaCreacion,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'],
      titulo: json['titulo'],
      direccion: json['direccion'],
      descripcion: json['descripcion'],
      latitud: double.parse(json['latitud']),
      longitud: double.parse(json['longitud']),
      imagenesBase64: List<String>.from(json['imagenes_base64']),
      usuarioId: json['usuario_id'],
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'direccion': direccion,
      'descripcion': descripcion,
      'latitud': latitud.toString(),
      'longitud': longitud.toString(),
      'imagenes_base64': imagenesBase64,
      'usuario_id': usuarioId,
    };
  }
}