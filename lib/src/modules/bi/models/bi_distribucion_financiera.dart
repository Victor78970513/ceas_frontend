import 'package:flutter/material.dart';

class BiDistribucionFinanciera {
  final List<BiCategoriaFinanciera> ingresos;
  final List<BiCategoriaFinanciera> egresos;
  final BiResumenFinanciero resumen;

  BiDistribucionFinanciera({
    required this.ingresos,
    required this.egresos,
    required this.resumen,
  });

  factory BiDistribucionFinanciera.fromJson(Map<String, dynamic> json) {
    return BiDistribucionFinanciera(
      ingresos: (json['ingresos'] as List)
          .map((e) => BiCategoriaFinanciera.fromJson(e))
          .toList(),
      egresos: (json['egresos'] as List)
          .map((e) => BiCategoriaFinanciera.fromJson(e))
          .toList(),
      resumen: BiResumenFinanciero.fromJson(json['resumen']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ingresos': ingresos.map((e) => e.toJson()).toList(),
      'egresos': egresos.map((e) => e.toJson()).toList(),
      'resumen': resumen.toJson(),
    };
  }
}

class BiCategoriaFinanciera {
  final String categoria;
  final double monto;
  final double porcentaje;
  final String tendencia;

  BiCategoriaFinanciera({
    required this.categoria,
    required this.monto,
    required this.porcentaje,
    required this.tendencia,
  });

  factory BiCategoriaFinanciera.fromJson(Map<String, dynamic> json) {
    return BiCategoriaFinanciera(
      categoria: json['categoria'] as String,
      monto: (json['monto'] as num).toDouble(),
      porcentaje: (json['porcentaje'] as num).toDouble(),
      tendencia: json['tendencia'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoria': categoria,
      'monto': monto,
      'porcentaje': porcentaje,
      'tendencia': tendencia,
    };
  }

  // Getters para UI
  String get montoFormatted => 'Bs. ${monto.toStringAsFixed(0)}';
  String get porcentajeFormatted => '${porcentaje.toStringAsFixed(1)}%';
  String get tendenciaDisplay => tendencia.toUpperCase();

  Color get tendenciaColor =>
      tendencia.toLowerCase() == 'creciente' ? Colors.green : Colors.red;
  IconData get tendenciaIcon => tendencia.toLowerCase() == 'creciente'
      ? Icons.trending_up
      : Icons.trending_down;
}

class BiResumenFinanciero {
  final double totalIngresos;
  final double totalEgresos;
  final double balance;

  BiResumenFinanciero({
    required this.totalIngresos,
    required this.totalEgresos,
    required this.balance,
  });

  factory BiResumenFinanciero.fromJson(Map<String, dynamic> json) {
    return BiResumenFinanciero(
      totalIngresos: (json['total_ingresos'] as num).toDouble(),
      totalEgresos: (json['total_egresos'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_ingresos': totalIngresos,
      'total_egresos': totalEgresos,
      'balance': balance,
    };
  }

  // Getters para UI
  String get totalIngresosFormatted =>
      'Bs. ${totalIngresos.toStringAsFixed(0)}';
  String get totalEgresosFormatted => 'Bs. ${totalEgresos.toStringAsFixed(0)}';
  String get balanceFormatted => 'Bs. ${balance.toStringAsFixed(0)}';
  Color get balanceColor => balance >= 0 ? Colors.green : Colors.red;
}

