import 'package:flutter/material.dart';

class BiPersonalAsistenciaDepartamento {
  final String departamento;
  final int totalEmpleados;
  final double promedioAsistencia;
  final int totalTardanzas;
  final int totalAusencias;

  BiPersonalAsistenciaDepartamento({
    required this.departamento,
    required this.totalEmpleados,
    required this.promedioAsistencia,
    required this.totalTardanzas,
    required this.totalAusencias,
  });

  factory BiPersonalAsistenciaDepartamento.fromJson(Map<String, dynamic> json) {
    return BiPersonalAsistenciaDepartamento(
      departamento: json['departamento'] as String,
      totalEmpleados: json['total_empleados'] as int,
      promedioAsistencia: (json['promedio_asistencia'] as num).toDouble(),
      totalTardanzas: json['total_tardanzas'] as int,
      totalAusencias: json['total_ausencias'] as int,
    );
  }

  // Getters para UI
  String get totalEmpleadosFormatted => totalEmpleados.toString();
  String get promedioAsistenciaFormatted =>
      '${promedioAsistencia.toStringAsFixed(1)}%';
  String get totalTardanzasFormatted => totalTardanzas.toString();
  String get totalAusenciasFormatted => totalAusencias.toString();

  // Colores para UI
  Color get promedioAsistenciaColor {
    if (promedioAsistencia >= 90) return Colors.green.shade600;
    if (promedioAsistencia >= 75) return Colors.orange.shade600;
    if (promedioAsistencia >= 60) return Colors.yellow.shade600;
    return Colors.red.shade600;
  }

  Color get tardanzasColor {
    if (totalTardanzas <= 50) return Colors.green.shade600;
    if (totalTardanzas <= 100) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  Color get ausenciasColor {
    if (totalAusencias <= 10) return Colors.green.shade600;
    if (totalAusencias <= 20) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  // Estados para UI
  String get estadoAsistencia {
    if (promedioAsistencia >= 90) return 'Excelente';
    if (promedioAsistencia >= 75) return 'Bueno';
    if (promedioAsistencia >= 60) return 'Regular';
    return 'Crítico';
  }

  String get estadoTardanzas {
    if (totalTardanzas <= 50) return 'Bajo';
    if (totalTardanzas <= 100) return 'Moderado';
    return 'Alto';
  }

  String get estadoAusencias {
    if (totalAusencias <= 10) return 'Bajo';
    if (totalAusencias <= 20) return 'Moderado';
    return 'Alto';
  }

  // Métricas calculadas
  double get porcentajeTardanzas =>
      totalEmpleados > 0 ? (totalTardanzas / totalEmpleados) : 0;
  double get porcentajeAusencias =>
      totalEmpleados > 0 ? (totalAusencias / totalEmpleados) : 0;

  String get porcentajeTardanzasFormatted =>
      '${porcentajeTardanzas.toStringAsFixed(1)}%';
  String get porcentajeAusenciasFormatted =>
      '${porcentajeAusencias.toStringAsFixed(1)}%';
}



