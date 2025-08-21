import 'package:flutter/material.dart';

class BiMovimientosFinancieros {
  final PeriodoMovimientos periodo;
  final ResumenMovimientos resumen;
  final List<MovimientoDiario> movimientosDiarios;
  final TendenciasMovimientos tendencias;

  BiMovimientosFinancieros({
    required this.periodo,
    required this.resumen,
    required this.movimientosDiarios,
    required this.tendencias,
  });

  factory BiMovimientosFinancieros.fromJson(Map<String, dynamic> json) {
    return BiMovimientosFinancieros(
      periodo: PeriodoMovimientos.fromJson(json['periodo']),
      resumen: ResumenMovimientos.fromJson(json['resumen']),
      movimientosDiarios: (json['movimientos_diarios'] as List)
          .map((item) => MovimientoDiario.fromJson(item))
          .toList(),
      tendencias: TendenciasMovimientos.fromJson(json['tendencias']),
    );
  }
}

class PeriodoMovimientos {
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final int diasAnalizados;
  final int diasConMovimientos;

  PeriodoMovimientos({
    required this.fechaInicio,
    required this.fechaFin,
    required this.diasAnalizados,
    required this.diasConMovimientos,
  });

  factory PeriodoMovimientos.fromJson(Map<String, dynamic> json) {
    return PeriodoMovimientos(
      fechaInicio: DateTime.parse(json['fecha_inicio']),
      fechaFin: DateTime.parse(json['fecha_fin']),
      diasAnalizados: json['dias_analizados'],
      diasConMovimientos: json['dias_con_movimientos'],
    );
  }

  String get periodoDisplay =>
      '${fechaInicio.day}/${fechaInicio.month} - ${fechaFin.day}/${fechaFin.month}';
}

class ResumenMovimientos {
  final double totalIngresos;
  final double totalEgresos;
  final double balanceTotal;
  final double promedioIngresosDiario;
  final double promedioEgresosDiario;

  ResumenMovimientos({
    required this.totalIngresos,
    required this.totalEgresos,
    required this.balanceTotal,
    required this.promedioIngresosDiario,
    required this.promedioEgresosDiario,
  });

  factory ResumenMovimientos.fromJson(Map<String, dynamic> json) {
    return ResumenMovimientos(
      totalIngresos: (json['total_ingresos'] as num).toDouble(),
      totalEgresos: (json['total_egresos'] as num).toDouble(),
      balanceTotal: (json['balance_total'] as num).toDouble(),
      promedioIngresosDiario:
          (json['promedio_ingresos_diario'] as num).toDouble(),
      promedioEgresosDiario:
          (json['promedio_egresos_diario'] as num).toDouble(),
    );
  }

  String get totalIngresosFormatted => '\$${totalIngresos.toStringAsFixed(0)}';
  String get totalEgresosFormatted => '\$${totalEgresos.toStringAsFixed(0)}';
  String get balanceTotalFormatted => '\$${balanceTotal.toStringAsFixed(0)}';
  String get promedioIngresosFormatted =>
      '\$${promedioIngresosDiario.toStringAsFixed(0)}';
  String get promedioEgresosFormatted =>
      '\$${promedioEgresosDiario.toStringAsFixed(0)}';
}

class MovimientoDiario {
  final DateTime fecha;
  final double ingresos;
  final double egresos;
  final double balanceDia;
  final double balanceAcumulado;
  final int totalMovimientos;

  MovimientoDiario({
    required this.fecha,
    required this.ingresos,
    required this.egresos,
    required this.balanceDia,
    required this.balanceAcumulado,
    required this.totalMovimientos,
  });

  factory MovimientoDiario.fromJson(Map<String, dynamic> json) {
    return MovimientoDiario(
      fecha: DateTime.parse(json['fecha']),
      ingresos: (json['ingresos'] as num).toDouble(),
      egresos: (json['egresos'] as num).toDouble(),
      balanceDia: (json['balance_dia'] as num).toDouble(),
      balanceAcumulado: (json['balance_acumulado'] as num).toDouble(),
      totalMovimientos: json['total_movimientos'],
    );
  }

  String get fechaDisplay => '${fecha.day}/${fecha.month}';
}

class TendenciasMovimientos {
  final String tendenciaIngresos;
  final String tendenciaEgresos;
  final double volatilidad;

  TendenciasMovimientos({
    required this.tendenciaIngresos,
    required this.tendenciaEgresos,
    required this.volatilidad,
  });

  factory TendenciasMovimientos.fromJson(Map<String, dynamic> json) {
    return TendenciasMovimientos(
      tendenciaIngresos: json['tendencia_ingresos'],
      tendenciaEgresos: json['tendencia_egresos'],
      volatilidad: (json['volatilidad'] as num).toDouble(),
    );
  }

  Color get colorTendenciaIngresos {
    switch (tendenciaIngresos.toLowerCase()) {
      case 'creciente':
        return Colors.green;
      case 'decreciente':
        return Colors.red;
      case 'estable':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color get colorTendenciaEgresos {
    switch (tendenciaEgresos.toLowerCase()) {
      case 'creciente':
        return Colors.red;
      case 'decreciente':
        return Colors.green;
      case 'estable':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
