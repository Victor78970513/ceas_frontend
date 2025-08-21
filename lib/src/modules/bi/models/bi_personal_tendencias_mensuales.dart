import 'package:flutter/material.dart';

class BiPersonalTendenciasMensuales {
  final Map<String, BiPersonalTendenciaMensual> tendencias;

  BiPersonalTendenciasMensuales({
    required this.tendencias,
  });

  factory BiPersonalTendenciasMensuales.fromJson(Map<String, dynamic> json) {
    final Map<String, BiPersonalTendenciaMensual> tendenciasMap = {};

    json.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        tendenciasMap[key] = BiPersonalTendenciaMensual.fromJson(value);
      }
    });

    return BiPersonalTendenciasMensuales(tendencias: tendenciasMap);
  }

  // Getters para UI
  List<String> get meses => tendencias.keys.toList()..sort();

  List<BiPersonalTendenciaMensual> get tendenciasOrdenadas {
    final sorted = tendencias.values.toList();
    return sorted;
  }

  double get promedioPorcentajeAsistencia {
    if (tendencias.isEmpty) return 0;
    final total = tendencias.values
        .map((t) => t.porcentajeAsistencia)
        .reduce((a, b) => a + b);
    return total / tendencias.length;
  }

  int get totalTardanzas {
    return tendencias.values.map((t) => t.tardanzas).reduce((a, b) => a + b);
  }

  int get totalAusencias {
    return tendencias.values.map((t) => t.ausencias).reduce((a, b) => a + b);
  }

  String get promedioPorcentajeAsistenciaFormatted =>
      '${promedioPorcentajeAsistencia.toStringAsFixed(1)}%';
  String get totalTardanzasFormatted => totalTardanzas.toString();
  String get totalAusenciasFormatted => totalAusencias.toString();

  // Colores para UI
  Color get promedioAsistenciaColor {
    if (promedioPorcentajeAsistencia >= 90) return Colors.green.shade600;
    if (promedioPorcentajeAsistencia >= 75) return Colors.orange.shade600;
    if (promedioPorcentajeAsistencia >= 60) return Colors.yellow.shade600;
    return Colors.red.shade600;
  }

  Color get tardanzasColor {
    if (totalTardanzas <= 100) return Colors.green.shade600;
    if (totalTardanzas <= 300) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  Color get ausenciasColor {
    if (totalAusencias <= 20) return Colors.green.shade600;
    if (totalAusencias <= 50) return Colors.orange.shade600;
    return Colors.red.shade600;
  }
}

class BiPersonalTendenciaMensual {
  final int totalRegistros;
  final int asistencias;
  final int tardanzas;
  final int ausencias;
  final double porcentajeAsistencia;

  BiPersonalTendenciaMensual({
    required this.totalRegistros,
    required this.asistencias,
    required this.tardanzas,
    required this.ausencias,
    required this.porcentajeAsistencia,
  });

  factory BiPersonalTendenciaMensual.fromJson(Map<String, dynamic> json) {
    return BiPersonalTendenciaMensual(
      totalRegistros: json['total_registros'] as int,
      asistencias: json['asistencias'] as int,
      tardanzas: json['tardanzas'] as int,
      ausencias: json['ausencias'] as int,
      porcentajeAsistencia: (json['porcentaje_asistencia'] as num).toDouble(),
    );
  }

  // Getters para UI
  String get totalRegistrosFormatted => totalRegistros.toString();
  String get asistenciasFormatted => asistencias.toString();
  String get tardanzasFormatted => tardanzas.toString();
  String get ausenciasFormatted => ausencias.toString();
  String get porcentajeAsistenciaFormatted =>
      '${porcentajeAsistencia.toStringAsFixed(1)}%';

  // Colores para UI
  Color get porcentajeAsistenciaColor {
    if (porcentajeAsistencia >= 90) return Colors.green.shade600;
    if (porcentajeAsistencia >= 75) return Colors.orange.shade600;
    if (porcentajeAsistencia >= 60) return Colors.yellow.shade600;
    return Colors.red.shade600;
  }

  Color get tardanzasColor {
    if (tardanzas <= 100) return Colors.green.shade600;
    if (tardanzas <= 300) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  Color get ausenciasColor {
    if (ausencias <= 20) return Colors.green.shade600;
    if (ausencias <= 50) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  // Estado para UI
  String get estadoAsistencia {
    if (porcentajeAsistencia >= 90) return 'Excelente';
    if (porcentajeAsistencia >= 75) return 'Bueno';
    if (porcentajeAsistencia >= 60) return 'Regular';
    return 'Crítico';
  }

  // Métricas calculadas
  double get porcentajeTardanzas =>
      totalRegistros > 0 ? (tardanzas / totalRegistros) * 100 : 0;
  double get porcentajeAusencias =>
      totalRegistros > 0 ? (ausencias / totalRegistros) * 100 : 0;

  String get porcentajeTardanzasFormatted =>
      '${porcentajeTardanzas.toStringAsFixed(1)}%';
  String get porcentajeAusenciasFormatted =>
      '${porcentajeAusencias.toStringAsFixed(1)}%';
}
