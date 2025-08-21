import 'package:flutter/material.dart';

class BiKpi {
  final String nombre;
  final double valorActual;
  final double valorAnterior;
  final double cambioPorcentual;
  final double meta;
  final String estado;

  BiKpi({
    required this.nombre,
    required this.valorActual,
    required this.valorAnterior,
    required this.cambioPorcentual,
    required this.meta,
    required this.estado,
  });

  factory BiKpi.fromJson(Map<String, dynamic> json) {
    return BiKpi(
      nombre: json['nombre'] as String,
      valorActual: (json['valor_actual'] as num).toDouble(),
      valorAnterior: (json['valor_anterior'] as num).toDouble(),
      cambioPorcentual: (json['cambio_porcentual'] as num).toDouble(),
      meta: (json['meta'] as num).toDouble(),
      estado: json['estado'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'valor_actual': valorActual,
      'valor_anterior': valorAnterior,
      'cambio_porcentual': cambioPorcentual,
      'meta': meta,
      'estado': estado,
    };
  }

  // Getters para UI
  String get valorActualFormatted => valorActual.toStringAsFixed(1);
  String get valorAnteriorFormatted => valorAnterior.toStringAsFixed(1);
  String get cambioPorcentualFormatted =>
      '${cambioPorcentual >= 0 ? '+' : ''}${cambioPorcentual.toStringAsFixed(1)}%';
  String get metaFormatted => meta.toStringAsFixed(1);
  String get estadoDisplay => estado.toUpperCase();

  Color get estadoColor {
    switch (estado.toLowerCase()) {
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

  Color get cambioColor => cambioPorcentual >= 0 ? Colors.green : Colors.red;
  IconData get cambioIcon =>
      cambioPorcentual >= 0 ? Icons.trending_up : Icons.trending_down;
}

