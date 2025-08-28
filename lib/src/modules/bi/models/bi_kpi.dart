import 'package:flutter/material.dart';

class BiKpi {
  final String nombre;
  final double valor;
  final String unidad;
  final DateTime fecha;
  final String tipo; // 'ingreso', 'egreso', 'balance', 'socios', etc.
  final double valorAnterior;
  final double variacion;
  final String tendencia; // 'creciente', 'decreciente', 'estable'

  BiKpi({
    required this.nombre,
    required this.valor,
    required this.unidad,
    required this.fecha,
    required this.tipo,
    required this.valorAnterior,
    required this.variacion,
    required this.tendencia,
  });

  factory BiKpi.fromJson(Map<String, dynamic> json) {
    return BiKpi(
      nombre: json['nombre'] ?? '',
      valor: (json['valor'] ?? 0.0).toDouble(),
      unidad: json['unidad'] ?? '',
      fecha: DateTime.tryParse(json['fecha'] ?? '') ?? DateTime.now(),
      tipo: json['tipo'] ?? '',
      valorAnterior: (json['valor_anterior'] ?? 0.0).toDouble(),
      variacion: (json['variacion'] ?? 0.0).toDouble(),
      tendencia: json['tendencia'] ?? 'estable',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'valor': valor,
      'unidad': unidad,
      'fecha': fecha.toIso8601String(),
      'tipo': tipo,
      'valor_anterior': valorAnterior,
      'variacion': variacion,
      'tendencia': tendencia,
    };
  }

  // Getters para UI
  String get valorFormatted {
    if (unidad.toLowerCase() == 'bs' || unidad.toLowerCase() == 'bs.') {
      return 'Bs. ${valor.toStringAsFixed(0)}';
    } else if (unidad.toLowerCase() == '%') {
      return '${valor.toStringAsFixed(1)}%';
    } else {
      return '${valor.toStringAsFixed(0)} $unidad';
    }
  }

  String get variacionFormatted {
    final signo = variacion >= 0 ? '+' : '';
    return '$signo${variacion.toStringAsFixed(1)}%';
  }

  String get fechaFormatted {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }

  bool get esCreciente => tendencia.toLowerCase() == 'creciente';
  bool get esDecreciente => tendencia.toLowerCase() == 'decreciente';
  bool get esEstable => tendencia.toLowerCase() == 'estable';

  Color get colorTendencia {
    if (esCreciente) return Colors.green;
    if (esDecreciente) return Colors.red;
    return Colors.orange;
  }

  IconData get iconoTendencia {
    if (esCreciente) return Icons.trending_up;
    if (esDecreciente) return Icons.trending_down;
    return Icons.trending_flat;
  }
}
