class Accion {
  final int idAccion;
  final int idClub;
  final int idSocio;
  final int modalidadPago;
  final int estadoAccion;
  final String? certificadoPdf;
  final bool certificadoCifrado;
  final String fechaEmisionCertificado;
  final String tipoAccion;
  final String socioTitular;
  final EstadoAccionInfo estadoAccionInfo;
  final EstadoPagos estadoPagos;
  final ModalidadPagoInfo modalidadPagoInfo;

  Accion({
    required this.idAccion,
    required this.idClub,
    required this.idSocio,
    required this.modalidadPago,
    required this.estadoAccion,
    this.certificadoPdf,
    required this.certificadoCifrado,
    required this.fechaEmisionCertificado,
    required this.tipoAccion,
    required this.socioTitular,
    required this.estadoAccionInfo,
    required this.estadoPagos,
    required this.modalidadPagoInfo,
  });

  factory Accion.fromJson(Map<String, dynamic> json) {
    return Accion(
      idAccion: json['id_accion'] ?? 0,
      idClub: json['id_club'] ?? 0,
      idSocio: json['id_socio'] ?? 0,
      modalidadPago: json['modalidad_pago'] ?? 0,
      estadoAccion: json['estado_accion'] ?? 0,
      certificadoPdf: json['certificado_pdf'],
      certificadoCifrado: json['certificado_cifrado'] ?? false,
      fechaEmisionCertificado: json['fecha_emision_certificado'] ?? '',
      tipoAccion: json['tipo_accion'] ?? '',
      socioTitular: json['socio_titular'] ?? '',
      estadoAccionInfo:
          EstadoAccionInfo.fromJson(json['estado_accion_info'] ?? {}),
      estadoPagos: EstadoPagos.fromJson(json['estado_pagos'] ?? {}),
      modalidadPagoInfo:
          ModalidadPagoInfo.fromJson(json['modalidad_pago_info'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_accion': idAccion,
      'id_club': idClub,
      'id_socio': idSocio,
      'modalidad_pago': modalidadPago,
      'estado_accion': estadoAccion,
      'certificado_pdf': certificadoPdf,
      'certificado_cifrado': certificadoCifrado,
      'fecha_emision_certificado': fechaEmisionCertificado,
      'tipo_accion': tipoAccion,
      'socio_titular': socioTitular,
      'estado_accion_info': estadoAccionInfo.toJson(),
      'estado_pagos': estadoPagos.toJson(),
      'modalidad_pago_info': modalidadPagoInfo.toJson(),
    };
  }

  // Getters útiles
  String get estadoAccionTexto => estadoAccionInfo.nombre;
  String get estadoPagoTexto => estadoPagos.estadoPago;
  String get modalidadPagoTexto => modalidadPagoInfo.descripcion;
  String get socioTitularTexto =>
      socioTitular.isNotEmpty ? socioTitular : 'Socio $idSocio';
  bool get estaCompletamentePagada =>
      estadoPagos.estadoPago == 'COMPLETAMENTE_PAGADA';
  bool get estaParcialmentePagada =>
      estadoPagos.estadoPago == 'PARCIALMENTE_PAGADA';
  bool get estaPendiente => estadoPagos.estadoPago == 'PENDIENTE';
}

class EstadoAccionInfo {
  final int id;
  final String nombre;

  EstadoAccionInfo({
    required this.id,
    required this.nombre,
  });

  factory EstadoAccionInfo.fromJson(Map<String, dynamic> json) {
    return EstadoAccionInfo(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
    };
  }
}

class EstadoPagos {
  final String estadoPago;
  final double porcentajePagado;
  final double saldoPendiente;
  final int pagosRestantes;
  final double precioRenovacion;
  final double totalPagado;
  final int pagosRealizados;

  EstadoPagos({
    required this.estadoPago,
    required this.porcentajePagado,
    required this.saldoPendiente,
    required this.pagosRestantes,
    required this.precioRenovacion,
    required this.totalPagado,
    required this.pagosRealizados,
  });

  factory EstadoPagos.fromJson(Map<String, dynamic> json) {
    return EstadoPagos(
      estadoPago: json['estado_pago'] ?? '',
      porcentajePagado: (json['porcentaje_pagado'] ?? 0.0).toDouble(),
      saldoPendiente: (json['saldo_pendiente'] ?? 0.0).toDouble(),
      pagosRestantes: json['pagos_restantes'] ?? 0,
      precioRenovacion: (json['precio_renovacion'] ?? 0.0).toDouble(),
      totalPagado: (json['total_pagado'] ?? 0.0).toDouble(),
      pagosRealizados: json['pagos_realizados'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'estado_pago': estadoPago,
      'porcentaje_pagado': porcentajePagado,
      'saldo_pendiente': saldoPendiente,
      'pagos_restantes': pagosRestantes,
      'precio_renovacion': precioRenovacion,
      'total_pagado': totalPagado,
      'pagos_realizados': pagosRealizados,
    };
  }
}

class ModalidadPagoInfo {
  final String descripcion;
  final int mesesDeGracia;
  final double porcentajeRenovacionInicial;
  final double porcentajeRenovacionMensual;
  final double costoRenovacionEstandar;
  final int cantidadCuotas;

  ModalidadPagoInfo({
    required this.descripcion,
    required this.mesesDeGracia,
    required this.porcentajeRenovacionInicial,
    required this.porcentajeRenovacionMensual,
    required this.costoRenovacionEstandar,
    required this.cantidadCuotas,
  });

  factory ModalidadPagoInfo.fromJson(Map<String, dynamic> json) {
    return ModalidadPagoInfo(
      descripcion: json['descripcion'] ?? '',
      mesesDeGracia: json['meses_de_gracia'] ?? 0,
      porcentajeRenovacionInicial:
          (json['porcentaje_renovacion_inicial'] ?? 0.0).toDouble(),
      porcentajeRenovacionMensual:
          (json['porcentaje_renovacion_mensual'] ?? 0.0).toDouble(),
      costoRenovacionEstandar:
          (json['costo_renovacion_estandar'] ?? 0.0).toDouble(),
      cantidadCuotas: json['cantidad_cuotas'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'descripcion': descripcion,
      'meses_de_gracia': mesesDeGracia,
      'porcentaje_renovacion_inicial': porcentajeRenovacionInicial,
      'porcentaje_renovacion_mensual': porcentajeRenovacionMensual,
      'costo_renovacion_estandar': costoRenovacionEstandar,
      'cantidad_cuotas': cantidadCuotas,
    };
  }
}
