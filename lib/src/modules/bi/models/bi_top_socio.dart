import 'package:flutter/material.dart';

class BiTopSocio {
  final int idSocio;
  final String nombreCompleto;
  final String clubPrincipal;
  final int accionesCompradas;
  final double totalInvertido;
  final String estadoPagos;
  final int antiguedadMeses;

  BiTopSocio({
    required this.idSocio,
    required this.nombreCompleto,
    required this.clubPrincipal,
    required this.accionesCompradas,
    required this.totalInvertido,
    required this.estadoPagos,
    required this.antiguedadMeses,
  });

  factory BiTopSocio.fromJson(Map<String, dynamic> json) {
    return BiTopSocio(
      idSocio: json['id_socio'] as int,
      nombreCompleto: json['nombre_completo'] as String,
      clubPrincipal: json['club_principal'] as String,
      accionesCompradas: json['acciones_compradas'] as int,
      totalInvertido: (json['total_invertido'] as num).toDouble(),
      estadoPagos: json['estado_pagos'] as String,
      antiguedadMeses: json['antiguedad_meses'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_socio': idSocio,
      'nombre_completo': nombreCompleto,
      'club_principal': clubPrincipal,
      'acciones_compradas': accionesCompradas,
      'total_invertido': totalInvertido,
      'estado_pagos': estadoPagos,
      'antiguedad_meses': antiguedadMeses,
    };
  }

  // Getters para UI
  String get totalInvertidoFormatted =>
      'Bs. ${totalInvertido.toStringAsFixed(0)}';
  String get antiguedadFormatted => '$antiguedadMeses meses';
  String get estadoPagosDisplay =>
      estadoPagos.replaceAll('_', ' ').toUpperCase();

  Color get estadoPagosColor {
    switch (estadoPagos.toUpperCase()) {
      case 'COMPLETAMENTE_PAGADO':
        return Colors.green;
      case 'PARCIALMENTE_PAGADO':
        return Colors.orange;
      case 'PENDIENTE':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

