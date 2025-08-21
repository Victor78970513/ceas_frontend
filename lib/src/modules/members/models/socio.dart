class Socio {
  final int idSocio;
  final int idClub;
  final String nombres;
  final String apellidos;
  final String ciNit;
  final String telefono;
  final String correoElectronico;
  final String direccion;
  final int estado;
  final String fechaDeRegistro;
  final String? fechaNacimiento;
  final String tipoMembresia;

  Socio({
    required this.idSocio,
    required this.idClub,
    required this.nombres,
    required this.apellidos,
    required this.ciNit,
    required this.telefono,
    required this.correoElectronico,
    required this.direccion,
    required this.estado,
    required this.fechaDeRegistro,
    this.fechaNacimiento,
    required this.tipoMembresia,
  });

  factory Socio.fromJson(Map<String, dynamic> json) {
    return Socio(
      idSocio: json['id_socio'] ?? 0,
      idClub: json['id_club'] ?? 0,
      nombres: json['nombres'] ?? '',
      apellidos: json['apellidos'] ?? '',
      ciNit: json['ci_nit'] ?? '',
      telefono: json['telefono'] ?? '',
      correoElectronico: json['correo_electronico'] ?? '',
      direccion: json['direccion'] ?? '',
      estado: json['estado'] ?? 0,
      fechaDeRegistro: json['fecha_de_registro'] ?? '',
      fechaNacimiento: json['fecha_nacimiento'],
      tipoMembresia: json['tipo_membresia'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_socio': idSocio,
      'id_club': idClub,
      'nombres': nombres,
      'apellidos': apellidos,
      'ci_nit': ciNit,
      'telefono': telefono,
      'correo_electronico': correoElectronico,
      'direccion': direccion,
      'estado': estado,
      'fecha_de_registro': fechaDeRegistro,
      'fecha_nacimiento': fechaNacimiento,
      'tipo_membresia': tipoMembresia,
    };
  }

  // Método específico para crear socios (formato del backend)
  Map<String, dynamic> toCreateJson() {
    return {
      'id_club': idClub,
      'nombres': nombres,
      'apellidos': apellidos,
      'ci_nit': ciNit,
      'telefono': telefono,
      'correo_electronico': correoElectronico,
      'direccion': direccion,
      'estado': estado,
      'fecha_nacimiento': fechaNacimiento ?? '',
      'tipo_membresia': tipoMembresia,
    };
  }

  // Getters útiles
  String get nombreCompleto => '$nombres $apellidos';
  bool get estaActivo => estado == 1;
  String get estadoTexto => estaActivo ? 'Activo' : 'Inactivo';
}
