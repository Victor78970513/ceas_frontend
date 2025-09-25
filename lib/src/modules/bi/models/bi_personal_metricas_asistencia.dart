import 'package:flutter/material.dart';

class BiPersonalMetricasAsistencia {
  final int totalRegistros;
  final int asistenciasCompletas;
  final int tardanzas;
  final int ausencias;
  final double porcentajeAsistencia;
  final double promedioHorasTrabajadas;

  BiPersonalMetricasAsistencia({
    required this.totalRegistros,
    required this.asistenciasCompletas,
    required this.tardanzas,
    required this.ausencias,
    required this.porcentajeAsistencia,
    required this.promedioHorasTrabajadas,
  });

  factory BiPersonalMetricasAsistencia.fromJson(Map<String, dynamic> json) {
    return BiPersonalMetricasAsistencia(
      totalRegistros: json['total_registros'] ?? 0,
      asistenciasCompletas: json['asistencias_completas'] ?? 0,
      tardanzas: json['tardanzas'] ?? 0,
      ausencias: json['ausencias'] ?? 0,
      porcentajeAsistencia: (json['porcentaje_asistencia'] as num?)?.toDouble() ?? 0.0,
      promedioHorasTrabajadas:
          (json['promedio_horas_trabajadas'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Getters para UI
  String get totalRegistrosFormatted => totalRegistros.toString();
  String get asistenciasCompletasFormatted => asistenciasCompletas.toString();
  String get tardanzasFormatted => tardanzas.toString();
  String get ausenciasFormatted => ausencias.toString();
  String get porcentajeAsistenciaFormatted =>
      '${porcentajeAsistencia.toStringAsFixed(1)}%';
  String get promedioHorasTrabajadasFormatted =>
      '${promedioHorasTrabajadas.toStringAsFixed(1)}h';

  // Colores para UI
  Color get porcentajeAsistenciaColor {
    if (porcentajeAsistencia >= 90) return Colors.green.shade600;
    if (porcentajeAsistencia >= 75) return Colors.orange.shade600;
    if (porcentajeAsistencia >= 60) return Colors.yellow.shade600;
    return Colors.red.shade600;
  }

  Color get tardanzasColor => tardanzas > 100
      ? Colors.red.shade600
      : tardanzas > 50
          ? Colors.orange.shade600
          : Colors.green.shade600;

  Color get ausenciasColor => ausencias > 20
      ? Colors.red.shade600
      : ausencias > 10
          ? Colors.orange.shade600
          : Colors.green.shade600;

  Color get promedioHorasColor => promedioHorasTrabajadas >= 8
      ? Colors.green.shade600
      : promedioHorasTrabajadas >= 6
          ? Colors.orange.shade600
          : Colors.red.shade600;

  // Estados para UI
  String get estadoAsistencia {
    if (porcentajeAsistencia >= 90) return 'Excelente';
    if (porcentajeAsistencia >= 75) return 'Bueno';
    if (porcentajeAsistencia >= 60) return 'Regular';
    return 'Crítico';
  }

  String get estadoTardanzas {
    if (tardanzas <= 50) return 'Bajo';
    if (tardanzas <= 100) return 'Moderado';
    return 'Alto';
  }

  String get estadoAusencias {
    if (ausencias <= 10) return 'Bajo';
    if (ausencias <= 20) return 'Moderado';
    return 'Alto';
  }
}



