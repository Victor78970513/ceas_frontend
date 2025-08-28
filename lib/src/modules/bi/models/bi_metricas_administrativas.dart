import 'package:flutter/material.dart';

class BiMetricasAdministrativas {
  final int totalSocios;
  final int sociosActivos;
  final int sociosInactivos;
  final double tasaRetencion;
  final double crecimientoMensual;
  final double eficienciaOperativa;

  BiMetricasAdministrativas({
    required this.totalSocios,
    required this.sociosActivos,
    required this.sociosInactivos,
    required this.tasaRetencion,
    required this.crecimientoMensual,
    required this.eficienciaOperativa,
  });

  factory BiMetricasAdministrativas.fromJson(Map<String, dynamic> json) {
    return BiMetricasAdministrativas(
      totalSocios: json['total_socios'] as int,
      sociosActivos: json['socios_activos'] as int,
      sociosInactivos: json['socios_inactivos'] as int,
      tasaRetencion: (json['tasa_retencion'] as num).toDouble(),
      crecimientoMensual: (json['crecimiento_mensual'] as num).toDouble(),
      eficienciaOperativa: (json['eficiencia_operativa'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_socios': totalSocios,
      'socios_activos': sociosActivos,
      'socios_inactivos': sociosInactivos,
      'tasa_retencion': tasaRetencion,
      'crecimiento_mensual': crecimientoMensual,
      'eficiencia_operativa': eficienciaOperativa,
    };
  }

  // Getters para UI
  String get tasaRetencionFormatted => '${tasaRetencion.toStringAsFixed(1)}%';
  String get crecimientoMensualFormatted =>
      '${crecimientoMensual.toStringAsFixed(1)}%';
  String get eficienciaOperativaFormatted =>
      '${eficienciaOperativa.toStringAsFixed(1)}%';

  Color get tasaRetencionColor => tasaRetencion >= 80
      ? Colors.green
      : tasaRetencion >= 60
          ? Colors.orange
          : Colors.red;
  Color get crecimientoMensualColor => crecimientoMensual >= 5
      ? Colors.green
      : crecimientoMensual >= 2
          ? Colors.orange
          : Colors.red;
  Color get eficienciaOperativaColor => eficienciaOperativa >= 80
      ? Colors.green
      : eficienciaOperativa >= 60
          ? Colors.orange
          : Colors.red;
}


