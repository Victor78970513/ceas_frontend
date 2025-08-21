import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/asistencia.dart';

class AsistenciaService {
  static const String baseUrl = 'http://localhost:8000';

  /// Obtiene la lista de asistencia desde el backend
  static Future<List<Asistencia>> getAsistencia(String token) async {
    try {
      print(
          'AsistenciaService - Iniciando llamada HTTP a $baseUrl/asistencia/');
      print('AsistenciaService - Token: ${token.substring(0, 20)}...');

      final response = await http.get(
        Uri.parse('$baseUrl/asistencia/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print('AsistenciaService - Response status: ${response.statusCode}');
      print(
          'AsistenciaService - Response body: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}...');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final asistencia =
            jsonData.map((json) => Asistencia.fromJson(json)).toList();
        print('AsistenciaService - Asistencia parseada: ${asistencia.length}');
        return asistencia;
      } else {
        print(
            'AsistenciaService - Error HTTP: ${response.statusCode} - ${response.body}');
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('AsistenciaService - Excepción: $e');
      throw Exception('Error al obtener asistencia: $e');
    }
  }

  /// Prueba la conectividad con el backend
  static Future<bool> probarConectividad() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/asistencia/'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      return response.statusCode == 200 || response.statusCode == 401;
    } catch (e) {
      return false;
    }
  }
}

