import 'package:flutter/material.dart';

class BiTopClub {
  final int idClub;
  final String nombreClub;
  final double ingresos;
  final double egresos;
  final double balance;
  final double rentabilidad;
  final int sociosActivos;
  final int accionesVendidas;

  BiTopClub({
    required this.idClub,
    required this.nombreClub,
    required this.ingresos,
    required this.egresos,
    required this.balance,
    required this.rentabilidad,
    required this.sociosActivos,
    required this.accionesVendidas,
  });

  factory BiTopClub.fromJson(Map<String, dynamic> json) {
    return BiTopClub(
      idClub: json['id_club'] as int,
      nombreClub: json['nombre_club'] as String,
      ingresos: (json['ingresos'] as num).toDouble(),
      egresos: (json['egresos'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
      rentabilidad: (json['rentabilidad'] as num).toDouble(),
      sociosActivos: json['socios_activos'] as int,
      accionesVendidas: json['acciones_vendidas'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_club': idClub,
      'nombre_club': nombreClub,
      'ingresos': ingresos,
      'egresos': egresos,
      'balance': balance,
      'rentabilidad': rentabilidad,
      'socios_activos': sociosActivos,
      'acciones_vendidas': accionesVendidas,
    };
  }

  // Getters para UI
  String get ingresosFormatted => 'Bs. ${ingresos.toStringAsFixed(0)}';
  String get egresosFormatted => 'Bs. ${egresos.toStringAsFixed(0)}';
  String get balanceFormatted => 'Bs. ${balance.toStringAsFixed(0)}';
  String get rentabilidadFormatted => '${rentabilidad.toStringAsFixed(1)}%';
  String get accionesVendidasFormatted => '$accionesVendidas';

  Color get balanceColor => balance >= 0 ? Colors.green : Colors.red;
  Color get rentabilidadColor => rentabilidad >= 15
      ? Colors.green
      : rentabilidad >= 5
          ? Colors.orange
          : Colors.red;
}


