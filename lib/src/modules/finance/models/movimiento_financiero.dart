class MovimientoFinanciero {
  final int idMovimiento;
  final int idClub;
  final String tipoMovimiento;
  final String descripcion;
  final double monto;
  final DateTime fecha;
  final String estado;
  final String referenciaRelacionada;
  final String metodoPago;
  final String nombreClub;
  final String categoria;
  final String? nombreSocio;
  final String? nombreProveedor;
  final String numeroComprobante;

  MovimientoFinanciero({
    required this.idMovimiento,
    required this.idClub,
    required this.tipoMovimiento,
    required this.descripcion,
    required this.monto,
    required this.fecha,
    required this.estado,
    required this.referenciaRelacionada,
    required this.metodoPago,
    required this.nombreClub,
    required this.categoria,
    this.nombreSocio,
    this.nombreProveedor,
    required this.numeroComprobante,
  });

  factory MovimientoFinanciero.fromJson(Map<String, dynamic> json) {
    return MovimientoFinanciero(
      idMovimiento: json['id_movimiento'],
      idClub: json['id_club'],
      tipoMovimiento: json['tipo_movimiento'],
      descripcion: json['descripcion'],
      monto: double.parse(json['monto']),
      fecha: DateTime.parse(json['fecha']),
      estado: json['estado'],
      referenciaRelacionada: json['referencia_relacionada'],
      metodoPago: json['metodo_pago'],
      nombreClub: json['nombre_club'],
      categoria: json['categoria'],
      nombreSocio: json['nombre_socio'],
      nombreProveedor: json['nombre_proveedor'],
      numeroComprobante: json['numero_comprobante'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_movimiento': idMovimiento,
      'id_club': idClub,
      'tipo_movimiento': tipoMovimiento,
      'descripcion': descripcion,
      'monto': monto.toString(),
      'fecha': fecha.toIso8601String(),
      'estado': estado,
      'referencia_relacionada': referenciaRelacionada,
      'metodo_pago': metodoPago,
      'nombre_club': nombreClub,
      'categoria': categoria,
      'nombre_socio': nombreSocio,
      'nombre_proveedor': nombreProveedor,
      'numero_comprobante': numeroComprobante,
    };
  }

  // Getters para compatibilidad con la UI existente
  String get id => 'MOV-${idMovimiento.toString().padLeft(3, '0')}';
  String get tipo => tipoMovimiento == 'INGRESO' ? 'Ingreso' : 'Egreso';
  String get club => nombreClub;
  String get categoriaDisplay => categoria;

  // Mapeo de estados para la UI
  String get estadoDisplay {
    switch (estado) {
      case 'ACTIVO':
        return 'Confirmado';
      case 'PENDIENTE':
        return 'Pendiente';
      case 'CANCELADO':
        return 'Cancelado';
      default:
        return estado;
    }
  }

  // Formato de fecha para la UI
  String get fechaDisplay {
    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
  }

  // Información adicional para detalles
  String? get socio => nombreSocio;
  String? get proveedor => nombreProveedor;
  String get comprobante => numeroComprobante;
}

