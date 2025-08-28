import 'package:flutter/material.dart';

class BiMetricasFinancieras {
  final double ingresosTotales;
  final double egresosTotales;
  final double balanceNeto;
  final double margenRentabilidad;
  final double flujoCaja;
  final double proyeccionMensual;

  BiMetricasFinancieras({
    required this.ingresosTotales,
    required this.egresosTotales,
    required this.balanceNeto,
    required this.margenRentabilidad,
    required this.flujoCaja,
    required this.proyeccionMensual,
  });

  factory BiMetricasFinancieras.fromJson(Map<String, dynamic> json) {
    return BiMetricasFinancieras(
      ingresosTotales: (json['ingresos_totales'] as num).toDouble(),
      egresosTotales: (json['egresos_totales'] as num).toDouble(),
      balanceNeto: (json['balance_neto'] as num).toDouble(),
      margenRentabilidad: (json['margen_rentabilidad'] as num).toDouble(),
      flujoCaja: (json['flujo_caja'] as num).toDouble(),
      proyeccionMensual: (json['proyeccion_mensual'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ingresos_totales': ingresosTotales,
      'egresos_totales': egresosTotales,
      'balance_neto': balanceNeto,
      'margen_rentabilidad': margenRentabilidad,
      'flujo_caja': flujoCaja,
      'proyeccion_mensual': proyeccionMensual,
    };
  }

  // Getters para UI
  String get ingresosFormatted => 'Bs. ${ingresosTotales.toStringAsFixed(0)}';
  String get egresosFormatted => 'Bs. ${egresosTotales.toStringAsFixed(0)}';
  String get balanceFormatted => 'Bs. ${balanceNeto.toStringAsFixed(0)}';
  String get margenFormatted => '${margenRentabilidad.toStringAsFixed(1)}%';
  String get flujoCajaFormatted => 'Bs. ${flujoCaja.toStringAsFixed(0)}';
  String get proyeccionFormatted =>
      'Bs. ${proyeccionMensual.toStringAsFixed(0)}';

  Color get balanceColor => balanceNeto >= 0 ? Colors.green : Colors.red;
  Color get margenColor => margenRentabilidad >= 5
      ? Colors.green
      : margenRentabilidad >= 2
          ? Colors.orange
          : Colors.red;
}


