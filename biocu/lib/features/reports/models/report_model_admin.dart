class Report {
  final String id;
  final String titulo;
  final String direccion;
  final String descripcion;
  final double latitud;
  final double longitud;
  final String estado;
  final String usuarioId;
  final DateTime fechaCreacion;
  final DateTime fechaActualizacion;
  final List<String> imagenes;
  final String nombreUsuario;

  Report({
    required this.id,
    required this.titulo,
    required this.direccion,
    required this.descripcion,
    required this.latitud,
    required this.longitud,
    required this.estado,
    required this.usuarioId,
    required this.fechaCreacion,
    required this.fechaActualizacion,
    required this.imagenes,
    required this.nombreUsuario,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      direccion: json['direccion'] as String,
      descripcion: json['descripcion'] as String,
      latitud: double.parse(json['latitud'].toString()),
      longitud: double.parse(json['longitud'].toString()),
      estado: json['estado'] as String,
      usuarioId: json['usuario_id'] as String,
      fechaCreacion: DateTime.parse(json['fecha_creacion'] as String),
      fechaActualizacion: DateTime.parse(json['fecha_actualizacion'] as String),
      imagenes: List<String>.from(json['imagenes'] as List),
      nombreUsuario: json['usuarios']?['nombre'] as String? ?? 'Anónimo',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'direccion': direccion,
      'descripcion': descripcion,
      'latitud': latitud,
      'longitud': longitud,
      'estado': estado,
      'usuario_id': usuarioId,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'fecha_actualizacion': fechaActualizacion.toIso8601String(),
      'imagenes': imagenes,
      'usuarios': {'nombre': nombreUsuario},
    };
  }

  Report copyWith({
    String? id,
    String? titulo,
    String? direccion,
    String? descripcion,
    double? latitud,
    double? longitud,
    String? estado,
    String? usuarioId,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
    List<String>? imagenes,
    String? nombreUsuario,
  }) {
    return Report(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      direccion: direccion ?? this.direccion,
      descripcion: descripcion ?? this.descripcion,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      estado: estado ?? this.estado,
      usuarioId: usuarioId ?? this.usuarioId,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
      imagenes: imagenes ?? this.imagenes,
      nombreUsuario: nombreUsuario ?? this.nombreUsuario,
    );
  }

}