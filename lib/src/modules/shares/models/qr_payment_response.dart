class QrPaymentResponse {
  final String mensaje;
  final String referenciaTemporal;
  final QrData qrData;
  final PagoInfo pagoInfo;
  final List<String> instrucciones;

  const QrPaymentResponse({
    required this.mensaje,
    required this.referenciaTemporal,
    required this.qrData,
    required this.pagoInfo,
    required this.instrucciones,
  });

  factory QrPaymentResponse.fromJson(Map<String, dynamic> json) {
    return QrPaymentResponse(
      mensaje: json['mensaje'] ?? '',
      referenciaTemporal: json['referencia_temporal'] ?? '',
      qrData: QrData.fromJson(json['qr_data'] ?? {}),
      pagoInfo: PagoInfo.fromJson(json['pago_info'] ?? {}),
      instrucciones: List<String>.from(json['instrucciones'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mensaje': mensaje,
      'referencia_temporal': referenciaTemporal,
      'qr_data': qrData.toJson(),
      'pago_info': pagoInfo.toJson(),
      'instrucciones': instrucciones,
    };
  }
}

class QrData {
  final String tipo;
  final QrDataInner qrDataInner;
  final List<String> instrucciones;

  const QrData({
    required this.tipo,
    required this.qrDataInner,
    required this.instrucciones,
  });

  factory QrData.fromJson(Map<String, dynamic> json) {
    return QrData(
      tipo: json['tipo'] ?? '',
      qrDataInner: QrDataInner.fromJson(json['qr_data'] ?? {}),
      instrucciones: List<String>.from(json['instrucciones'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tipo': tipo,
      'qr_data': qrDataInner.toJson(),
      'instrucciones': instrucciones,
    };
  }
}

class QrDataInner {
  final String banco;
  final String cuenta;
  final String titular;
  final double monto;
  final String concepto;
  final String referencia;
  final String fechaLimite;
  final String telefonoContacto;
  final String emailContacto;

  const QrDataInner({
    required this.banco,
    required this.cuenta,
    required this.titular,
    required this.monto,
    required this.concepto,
    required this.referencia,
    required this.fechaLimite,
    required this.telefonoContacto,
    required this.emailContacto,
  });

  factory QrDataInner.fromJson(Map<String, dynamic> json) {
    return QrDataInner(
      banco: json['banco'] ?? '',
      cuenta: json['cuenta'] ?? '',
      titular: json['titular'] ?? '',
      monto: (json['monto'] ?? 0).toDouble(),
      concepto: json['concepto'] ?? '',
      referencia: json['referencia'] ?? '',
      fechaLimite: json['fecha_limite'] ?? '',
      telefonoContacto: json['telefono_contacto'] ?? '',
      emailContacto: json['email_contacto'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'banco': banco,
      'cuenta': cuenta,
      'titular': titular,
      'monto': monto,
      'concepto': concepto,
      'referencia': referencia,
      'fecha_limite': fechaLimite,
      'telefono_contacto': telefonoContacto,
      'email_contacto': emailContacto,
    };
  }
}

class PagoInfo {
  final int idSocio;
  final int cantidadAcciones;
  final double precioUnitario;
  final double totalPago;
  final String metodoPago;
  final int modalidadPago;
  final String tipoAccion;

  const PagoInfo({
    required this.idSocio,
    required this.cantidadAcciones,
    required this.precioUnitario,
    required this.totalPago,
    required this.metodoPago,
    required this.modalidadPago,
    required this.tipoAccion,
  });

  factory PagoInfo.fromJson(Map<String, dynamic> json) {
    return PagoInfo(
      idSocio: json['id_socio'] ?? 0,
      cantidadAcciones: json['cantidad_acciones'] ?? 0,
      precioUnitario: (json['precio_unitario'] ?? 0).toDouble(),
      totalPago: (json['total_pago'] ?? 0).toDouble(),
      metodoPago: json['metodo_pago'] ?? '',
      modalidadPago: json['modalidad_pago'] ?? 0,
      tipoAccion: json['tipo_accion'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_socio': idSocio,
      'cantidad_acciones': cantidadAcciones,
      'precio_unitario': precioUnitario,
      'total_pago': totalPago,
      'metodo_pago': metodoPago,
      'modalidad_pago': modalidadPago,
      'tipo_accion': tipoAccion,
    };
  }
}

