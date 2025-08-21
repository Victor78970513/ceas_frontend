import 'package:flutter/material.dart';

class Asistencia {
  final int idAsistencia;
  final int idEmpleado;
  final String nombreEmpleado;
  final DateTime fecha;
  final String estado;
  final String? horaEntrada;
  final String? horaSalida;
  final String? observaciones;

  Asistencia({
    required this.idAsistencia,
    required this.idEmpleado,
    required this.nombreEmpleado,
    required this.fecha,
    required this.estado,
    this.horaEntrada,
    this.horaSalida,
    this.observaciones,
  });

  factory Asistencia.fromJson(Map<String, dynamic> json) {
    return Asistencia(
      idAsistencia: json['id_asistencia'] ?? 0,
      idEmpleado: json['id_empleado'] ?? 0,
      nombreEmpleado: json['nombre_empleado'] ?? '',
      fecha: DateTime.parse(json['fecha'] ?? DateTime.now().toIso8601String()),
      estado: json['estado'] ?? 'PENDIENTE',
      horaEntrada: json['hora_entrada'],
      horaSalida: json['hora_salida'],
      observaciones: json['observaciones'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_asistencia': idAsistencia,
      'id_empleado': idEmpleado,
      'nombre_empleado': nombreEmpleado,
      'fecha': fecha.toIso8601String(),
      'estado': estado,
      'hora_entrada': horaEntrada,
      'hora_salida': horaSalida,
      'observaciones': observaciones,
    };
  }

  // Getters para UI
  String get fechaDisplay =>
      '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
  String get estadoDisplay => estado.replaceAll('_', ' ').toUpperCase();

  Color get estadoColor {
    switch (estado.toLowerCase()) {
      case 'presente':
        return Colors.green;
      case 'ausente':
        return Colors.red;
      case 'tardanza':
        return Colors.orange;
      case 'justificado':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData get estadoIcon {
    switch (estado.toLowerCase()) {
      case 'presente':
        return Icons.check_circle;
      case 'ausente':
        return Icons.cancel;
      case 'tardanza':
        return Icons.schedule;
      case 'justificado':
        return Icons.info;
      default:
        return Icons.help;
    }
  }
}
