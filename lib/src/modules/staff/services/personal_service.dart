import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/personal.dart';
import '../models/empleado.dart';

class PersonalService {
  static const String baseUrl = 'http://localhost:8000';

  /// Obtiene la lista de personal desde el backend
  static Future<List<Personal>> getPersonal(String token) async {
    try {
      print('PersonalService - Iniciando llamada HTTP a $baseUrl/personal/');
      print('PersonalService - Token: ${token.substring(0, 20)}...');

      final response = await http.get(
        Uri.parse('$baseUrl/personal/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print('PersonalService - Response status: ${response.statusCode}');
      print(
          'PersonalService - Response body: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}...');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final personal =
            jsonData.map((json) => Personal.fromJson(json)).toList();
        print('PersonalService - Personal parseado: ${personal.length}');
        return personal;
      } else {
        print(
            'PersonalService - Error HTTP: ${response.statusCode} - ${response.body}');
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('PersonalService - Excepción: $e');
      throw Exception('Error al obtener personal: $e');
    }
  }

  /// Obtiene la lista de empleados desde el backend
  static Future<List<Empleado>> getEmpleados(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/empleados/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Empleado.fromJson(json)).toList();
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener empleados: $e');
    }
  }

  /// Crea un nuevo empleado
  static Future<Empleado> createEmpleado(Empleado empleado) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/empleados/'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode(empleado.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return Empleado.fromJson(jsonData);
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al crear empleado: $e');
    }
  }

  /// Actualiza un empleado existente
  static Future<Empleado> updateEmpleado(Empleado empleado) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/empleados/${empleado.idEmpleado}/'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode(empleado.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Empleado.fromJson(jsonData);
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al actualizar empleado: $e');
    }
  }

  /// Elimina un empleado
  static Future<void> deleteEmpleado(int idEmpleado) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/empleados/$idEmpleado/'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 204) {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al eliminar empleado: $e');
    }
  }

  /// Prueba la conectividad con el backend
  static Future<bool> probarConectividad() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/personal/'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      return response.statusCode == 200 || response.statusCode == 401;
    } catch (e) {
      return false;
    }
  }
}
