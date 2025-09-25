import 'package:flutter/material.dart';

class Proveedor {
  final int idProveedor;
  final String nombreProveedor;
  final String contacto;
  final String telefono;
  final String correoElectronico;
  final String direccion;
  final bool estado;
  final String productosServicios;

  Proveedor({
    required this.idProveedor,
    required this.nombreProveedor,
    required this.contacto,
    required this.telefono,
    required this.correoElectronico,
    required this.direccion,
    required this.estado,
    required this.productosServicios,
  });

  factory Proveedor.fromJson(Map<String, dynamic> json) {
    return Proveedor(
      idProveedor: json['id_proveedor'] ?? 0,
      nombreProveedor: json['nombre_proveedor'] ?? '',
      contacto: json['contacto'] ?? '',
      telefono: json['telefono'] ?? '',
      correoElectronico: json['correo_electronico'] ?? '',
      direccion: json['direccion'] ?? '',
      estado: json['estado'] ?? false,
      productosServicios: json['productos_servicios'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_proveedor': idProveedor,
      'nombre_proveedor': nombreProveedor,
      'contacto': contacto,
      'telefono': telefono,
      'correo_electronico': correoElectronico,
      'direccion': direccion,
      'estado': estado,
      'productos_servicios': productosServicios,
    };
  }

  // Getters útiles para la UI
  String get id => 'PROV${idProveedor.toString().padLeft(3, '0')}';
  String get nombre => nombreProveedor;
  String get email => correoElectronico;
  String get categoria => productosServicios;
  String get estadoDisplay => estado ? 'Activo' : 'Inactivo';
  Color get estadoColor => estado ? Colors.green : Colors.red;

  // Para compatibilidad con el código existente
  String get ultimaCompra => 'N/A'; // No viene en el endpoint
  double get totalCompras => 0.0; // No viene en el endpoint
}

