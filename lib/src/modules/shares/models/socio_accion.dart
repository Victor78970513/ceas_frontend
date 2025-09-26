class SocioAccion {
  final int idAccion;
  final int idSocio;
  final int cantidadAcciones;
  final double precioUnitario;
  final double totalPago;
  final String metodoPago;
  final int estadoAccion;
  final String estadoNombre;
  final DateTime fechaCreacion;
  final String? certificadoPdf;

  SocioAccion({
    required this.idAccion,
    required this.idSocio,
    required this.cantidadAcciones,
    required this.precioUnitario,
    required this.totalPago,
    required this.metodoPago,
    required this.estadoAccion,
    required this.estadoNombre,
    required this.fechaCreacion,
    this.certificadoPdf,
  });

  factory SocioAccion.fromJson(Map<String, dynamic> json) {
    return SocioAccion(
      idAccion: json['id_accion'] ?? 0,
      idSocio: json['id_socio'] ?? 0,
      cantidadAcciones: json['cantidad_acciones'] ?? 0,
      precioUnitario: (json['precio_unitario'] as num?)?.toDouble() ?? 0.0,
      totalPago: (json['total_pago'] as num?)?.toDouble() ?? 0.0,
      metodoPago: json['metodo_pago'] ?? '',
      estadoAccion: json['estado_accion'] ?? 0,
      estadoNombre: json['estado_nombre'] ?? '',
      fechaCreacion: json['fecha_creacion'] != null
          ? DateTime.parse(json['fecha_creacion'])
          : DateTime.now(),
      certificadoPdf: json['certificado_pdf'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_accion': idAccion,
      'id_socio': idSocio,
      'cantidad_acciones': cantidadAcciones,
      'precio_unitario': precioUnitario,
      'total_pago': totalPago,
      'metodo_pago': metodoPago,
      'estado_accion': estadoAccion,
      'estado_nombre': estadoNombre,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'certificado_pdf': certificadoPdf,
    };
  }
}
