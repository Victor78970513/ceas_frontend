import 'package:flutter/material.dart';

class BiResumenRapido {
  final String periodoActual;
  final double balanceNeto;
  final double margenRentabilidad;
  final int totalSocios;
  final double tasaRetencion;
  final int alertasActivas;
  final String estadoGeneral;

  BiResumenRapido({
    required this.periodoActual,
    required this.balanceNeto,
    required this.margenRentabilidad,
    required this.totalSocios,
    required this.tasaRetencion,
    required this.alertasActivas,
    required this.estadoGeneral,
  });

  factory BiResumenRapido.fromJson(Map<String, dynamic> json) {
    return BiResumenRapido(
      periodoActual: json['periodo_actual'] as String,
      balanceNeto: (json['balance_neto'] as num).toDouble(),
      margenRentabilidad: (json['margen_rentabilidad'] as num).toDouble(),
      totalSocios: json['total_socios'] as int,
      tasaRetencion: (json['tasa_retencion'] as num).toDouble(),
      alertasActivas: json['alertas_activas'] as int,
      estadoGeneral: json['estado_general'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'periodo_actual': periodoActual,
      'balance_neto': balanceNeto,
      'margen_rentabilidad': margenRentabilidad,
      'total_socios': totalSocios,
      'tasa_retencion': tasaRetencion,
      'alertas_activas': alertasActivas,
      'estado_general': estadoGeneral,
    };
  }

  // Getters para UI
  String get balanceNetoFormatted => 'Bs. ${balanceNeto.toStringAsFixed(0)}';
  String get margenRentabilidadFormatted =>
      '${margenRentabilidad.toStringAsFixed(1)}%';
  String get tasaRetencionFormatted => '${tasaRetencion.toStringAsFixed(1)}%';
  String get estadoGeneralDisplay => estadoGeneral.toUpperCase();

  Color get estadoGeneralColor {
    switch (estadoGeneral.toLowerCase()) {
      case 'excelente':
        return Colors.green;
      case 'bueno':
        return Colors.blue;
      case 'regular':
        return Colors.orange;
      case 'malo':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color get balanceNetoColor => balanceNeto >= 0 ? Colors.green : Colors.red;
  Color get margenRentabilidadColor => margenRentabilidad >= 5
      ? Colors.green
      : margenRentabilidad >= 2
          ? Colors.orange
          : Colors.red;
  Color get tasaRetencionColor => tasaRetencion >= 80
      ? Colors.green
      : tasaRetencion >= 60
          ? Colors.orange
          : Colors.red;
}

