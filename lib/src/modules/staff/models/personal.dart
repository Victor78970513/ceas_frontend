import 'package:flutter/material.dart';

class Personal {
  final int idPersonal;
  final int idClub;
  final String nombres;
  final String apellidos;
  final int cargo;
  final DateTime fechaIngreso;
  final double salario;
  final String correo;
  final String departamento;
  final bool estado;
  final String nombreCargo;

  Personal({
    required this.idPersonal,
    required this.idClub,
    required this.nombres,
    required this.apellidos,
    required this.cargo,
    required this.fechaIngreso,
    required this.salario,
    required this.correo,
    required this.departamento,
    required this.estado,
    required this.nombreCargo,
  });

  factory Personal.fromJson(Map<String, dynamic> json) {
    return Personal(
      idPersonal: json['id_personal'] ?? 0,
      idClub: json['id_club'] ?? 0,
      nombres: json['nombres'] ?? '',
      apellidos: json['apellidos'] ?? '',
      cargo: json['cargo'] ?? 0,
      fechaIngreso: json['fecha_ingreso'] != null 
          ? DateTime.parse(json['fecha_ingreso'])
          : DateTime.now(),
      salario: (json['salario'] as num?)?.toDouble() ?? 0.0,
      correo: json['correo'] ?? '',
      departamento: json['departamento'] ?? '',
      estado: json['estado'] ?? false,
      nombreCargo: json['nombre_cargo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_personal': idPersonal,
      'id_club': idClub,
      'nombres': nombres,
      'apellidos': apellidos,
      'cargo': cargo,
      'fecha_ingreso': fechaIngreso.toIso8601String(),
      'salario': salario,
      'correo': correo,
      'departamento': departamento,
      'estado': estado,
      'nombre_cargo': nombreCargo,
    };
  }

  // Getters útiles para la UI
  String get id => 'EMP${idPersonal.toString().padLeft(3, '0')}';
  String get nombreCompleto => '$nombres $apellidos';
  String get cargoDisplay => nombreCargo;
  String get departamentoDisplay => departamento;
  String get fechaIngresoDisplay => _formatDate(fechaIngreso);
  String get salarioFormatted => 'Bs. ${salario.toStringAsFixed(0)}';
  String get estadoDisplay => estado ? 'Activo' : 'Inactivo';
  Color get estadoColor => estado ? Colors.green : Colors.red;
  String get email => correo;

  // Para compatibilidad con el código existente
  String get nombre => nombreCompleto;
  String get cargoCompatible => nombreCargo;
  String get fechaIngresoCompatible => fechaIngresoDisplay;
  String get telefono => 'N/A'; // No viene en el backend

  // Formateo de fechas
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
