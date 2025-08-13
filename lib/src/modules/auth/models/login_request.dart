class LoginRequest {
  final String correoElectronico;
  final String contrasena;

  LoginRequest({
    required this.correoElectronico,
    required this.contrasena,
  });

  Map<String, dynamic> toJson() {
    return {
      'correo_electronico': correoElectronico,
      'contrasena': contrasena,
    };
  }
}
