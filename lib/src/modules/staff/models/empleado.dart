import 'package:flutter/material.dart';

class Empleado {
  final int idEmpleado;
  final String nombreCompleto;
  final String cargo;
  final String departamento;
  final String estado;
  final String? email;
  final String? telefono;
  final DateTime fechaContratacion;
  final double salario;
  final String? foto;

  Empleado({
    required this.idEmpleado,
    required this.nombreCompleto,
    required this.cargo,
    required this.departamento,
    required this.estado,
    this.email,
    this.telefono,
    required this.fechaContratacion,
    required this.salario,
    this.foto,
  });

  factory Empleado.fromJson(Map<String, dynamic> json) {
    return Empleado(
      idEmpleado: json['id_empleado'] ?? 0,
      nombreCompleto: json['nombre_completo'] ?? '',
      cargo: json['cargo'] ?? '',
      departamento: json['departamento'] ?? '',
      estado: json['estado'] ?? 'ACTIVO',
      email: json['email'],
      telefono: json['telefono'],
      fechaContratacion: DateTime.parse(
          json['fecha_contratacion'] ?? DateTime.now().toIso8601String()),
      salario: (json['salario'] ?? 0.0).toDouble(),
      foto: json['foto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_empleado': idEmpleado,
      'nombre_completo': nombreCompleto,
      'cargo': cargo,
      'departamento': departamento,
      'estado': estado,
      'email': email,
      'telefono': telefono,
      'fecha_contratacion': fechaContratacion.toIso8601String(),
      'salario': salario,
      'foto': foto,
    };
  }

  // Getters para UI
  String get fechaContratacionDisplay =>
      '${fechaContratacion.day.toString().padLeft(2, '0')}/${fechaContratacion.month.toString().padLeft(2, '0')}/${fechaContratacion.year}';
  String get salarioFormatted => 'Bs. ${salario.toStringAsFixed(2)}';
  String get estadoDisplay => estado.replaceAll('_', ' ').toUpperCase();

  Color get estadoColor {
    switch (estado.toLowerCase()) {
      case 'activo':
        return Colors.green;
      case 'inactivo':
        return Colors.red;
      case 'vacaciones':
        return Colors.orange;
      case 'licencia':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData get estadoIcon {
    switch (estado.toLowerCase()) {
      case 'activo':
        return Icons.check_circle;
      case 'inactivo':
        return Icons.cancel;
      case 'vacaciones':
        return Icons.beach_access;
      case 'licencia':
        return Icons.medical_services;
      default:
        return Icons.help;
    }
  }

  // Métodos de utilidad
  bool get isActivo => estado.toLowerCase() == 'activo';
  bool get isInactivo => estado.toLowerCase() == 'inactivo';
  bool get isVacaciones => estado.toLowerCase() == 'vacaciones';
  bool get isLicencia => estado.toLowerCase() == 'licencia';

  // Copiar con cambios
  Empleado copyWith({
    int? idEmpleado,
    String? nombreCompleto,
    String? cargo,
    String? departamento,
    String? estado,
    String? email,
    String? telefono,
    DateTime? fechaContratacion,
    double? salario,
    String? foto,
  }) {
    return Empleado(
      idEmpleado: idEmpleado ?? this.idEmpleado,
      nombreCompleto: nombreCompleto ?? this.nombreCompleto,
      cargo: cargo ?? this.cargo,
      departamento: departamento ?? this.departamento,
      estado: estado ?? this.estado,
      email: email ?? this.email,
      telefono: telefono ?? this.telefono,
      fechaContratacion: fechaContratacion ?? this.fechaContratacion,
      salario: salario ?? this.salario,
      foto: foto ?? this.foto,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Empleado && other.idEmpleado == idEmpleado;
  }

  @override
  int get hashCode => idEmpleado.hashCode;

  @override
  String toString() {
    return 'Empleado(idEmpleado: $idEmpleado, nombreCompleto: $nombreCompleto, cargo: $cargo, departamento: $departamento, estado: $estado)';
  }
}



