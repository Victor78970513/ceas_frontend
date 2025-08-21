import 'package:flutter/material.dart';

class BiPersonalMetricasGenerales {
  final int totalPersonal;
  final int personalActivo;
  final int personalInactivo;
  final Map<String, int> personalPorDepartamento;
  final Map<String, int> personalPorCargo;

  BiPersonalMetricasGenerales({
    required this.totalPersonal,
    required this.personalActivo,
    required this.personalInactivo,
    required this.personalPorDepartamento,
    required this.personalPorCargo,
  });

  factory BiPersonalMetricasGenerales.fromJson(Map<String, dynamic> json) {
    return BiPersonalMetricasGenerales(
      totalPersonal: json['total_personal'] as int,
      personalActivo: json['personal_activo'] as int,
      personalInactivo: json['personal_inactivo'] as int,
      personalPorDepartamento:
          Map<String, int>.from(json['personal_por_departamento']),
      personalPorCargo: Map<String, int>.from(json['personal_por_cargo']),
    );
  }

  // Getters para UI
  double get porcentajeActivo =>
      totalPersonal > 0 ? (personalActivo / totalPersonal) * 100 : 0;
  double get porcentajeInactivo =>
      totalPersonal > 0 ? (personalInactivo / totalPersonal) * 100 : 0;

  String get totalPersonalFormatted => totalPersonal.toString();
  String get personalActivoFormatted => personalActivo.toString();
  String get personalInactivoFormatted => personalInactivo.toString();
  String get porcentajeActivoFormatted =>
      '${porcentajeActivo.toStringAsFixed(1)}%';
  String get porcentajeInactivoFormatted =>
      '${porcentajeInactivo.toStringAsFixed(1)}%';

  // Colores para UI
  Color get estadoActivoColor => Colors.green.shade600;
  Color get estadoInactivoColor => Colors.red.shade600;
  Color get estadoGeneralColor => porcentajeActivo >= 90
      ? Colors.green.shade600
      : porcentajeActivo >= 75
          ? Colors.orange.shade600
          : Colors.red.shade600;

  // Lista ordenada de departamentos por cantidad de personal
  List<MapEntry<String, int>> get departamentosOrdenados {
    final sorted = personalPorDepartamento.entries.toList();
    sorted.sort((a, b) => b.value.compareTo(a.value));
    return sorted;
  }

  // Lista ordenada de cargos por cantidad de personal
  List<MapEntry<String, int>> get cargosOrdenados {
    final sorted = personalPorCargo.entries.toList();
    sorted.sort((a, b) => b.value.compareTo(a.value));
    return sorted;
  }
}
