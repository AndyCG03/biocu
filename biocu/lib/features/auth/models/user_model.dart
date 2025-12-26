class UserModel {
  final String id;
  final String nombre;
  final String email;
  final String role;

  UserModel({
    required this.id,
    required this.nombre,
    required this.email,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Validación explícita de campos
    if (json['id'] == null ||
        json['nombre'] == null ||
        json['email'] == null ||
        json['role'] == null) {
      throw Exception('Faltan campos requeridos en la respuesta del perfil');
    }

    return UserModel(
      id: json['id'].toString(),
      nombre: json['nombre'].toString(),
      email: json['email'].toString(),
      role: json['role'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'email': email,
    'role': role,
  };
}