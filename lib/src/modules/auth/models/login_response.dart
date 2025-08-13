class LoginResponse {
  final String accessToken;
  final String tokenType;
  final String nombreUsuario;
  final int rol;
  final int idUsuario;
  final int idClub;
  final String correoElectronico;

  LoginResponse({
    required this.accessToken,
    required this.tokenType,
    required this.nombreUsuario,
    required this.rol,
    required this.idUsuario,
    required this.idClub,
    required this.correoElectronico,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'] ?? '',
      tokenType: json['token_type'] ?? '',
      nombreUsuario: json['nombre_usuario'] ?? '',
      rol: json['rol'] ?? 0,
      idUsuario: json['id_usuario'] ?? 0,
      idClub: json['id_club'] ?? 0,
      correoElectronico: json['correo_electronico'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      'nombre_usuario': nombreUsuario,
      'rol': rol,
      'id_usuario': idUsuario,
      'id_club': idClub,
      'correo_electronico': correoElectronico,
    };
  }
}
