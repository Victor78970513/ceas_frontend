import 'package:flutter/material.dart';

class BiTopSocio {
  final int id;
  final String nombreCompleto;
  final String clubPrincipal;
  final int accionesCompradas;
  final double totalInvertido;
  final String estadoPagos;
  final int antiguedadDias;
  final String email;
  final String telefono;

  BiTopSocio({
    required this.id,
    required this.nombreCompleto,
    required this.clubPrincipal,
    required this.accionesCompradas,
    required this.totalInvertido,
    required this.estadoPagos,
    required this.antiguedadDias,
    required this.email,
    required this.telefono,
  });

  factory BiTopSocio.fromJson(Map<String, dynamic> json) {
    return BiTopSocio(
      id: json['id'] ?? 0,
      nombreCompleto: json['nombre_completo'] ?? '',
      clubPrincipal: json['club_principal'] ?? '',
      accionesCompradas: json['acciones_compradas'] ?? 0,
      totalInvertido: (json['total_invertido'] ?? 0.0).toDouble(),
      estadoPagos: json['estado_pagos'] ?? 'pendiente',
      antiguedadDias: json['antiguedad_dias'] ?? 0,
      email: json['email'] ?? '',
      telefono: json['telefono'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre_completo': nombreCompleto,
      'club_principal': clubPrincipal,
      'acciones_compradas': accionesCompradas,
      'total_invertido': totalInvertido,
      'estado_pagos': estadoPagos,
      'antiguedad_dias': antiguedadDias,
      'email': email,
      'telefono': telefono,
    };
  }

  // Getters para UI
  String get totalInvertidoFormatted =>
      'Bs. ${totalInvertido.toStringAsFixed(0)}';
  String get antiguedadFormatted => '${antiguedadDias} días';

  String get estadoPagosDisplay {
    switch (estadoPagos.toLowerCase()) {
      case 'al_dia':
        return 'Al día';
      case 'pendiente':
        return 'Pendiente';
      case 'atrasado':
        return 'Atrasado';
      default:
        return estadoPagos;
    }
  }

  Color get estadoPagosColor {
    switch (estadoPagos.toLowerCase()) {
      case 'al_dia':
        return Colors.green;
      case 'pendiente':
        return Colors.orange;
      case 'atrasado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
