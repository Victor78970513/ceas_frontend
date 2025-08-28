import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bi_personal_metricas_generales.dart';
import '../models/bi_personal_metricas_asistencia.dart';
import '../models/bi_personal_asistencia_departamento.dart';
import '../models/bi_personal_tendencias_mensuales.dart';

class BiPersonalService {
  static const String baseUrl = 'http://localhost:8000';

  // 1. Métricas Generales de Personal
  static Future<BiPersonalMetricasGenerales> getMetricasGenerales(
      String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bi/personal/metricas-generales/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return BiPersonalMetricasGenerales.fromJson(jsonData);
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener métricas generales de personal: $e');
    }
  }

  // 2. Métricas de Asistencia
  static Future<BiPersonalMetricasAsistencia> getMetricasAsistencia(
      String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bi/personal/metricas-asistencia/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return BiPersonalMetricasAsistencia.fromJson(jsonData);
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener métricas de asistencia: $e');
    }
  }

  // 3. Asistencia por Departamento
  static Future<List<BiPersonalAsistenciaDepartamento>>
      getAsistenciaDepartamento(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bi/personal/asistencia-departamento/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData
            .map((item) => BiPersonalAsistenciaDepartamento.fromJson(item))
            .toList();
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener asistencia por departamento: $e');
    }
  }

  // 4. Tendencias Mensuales
  static Future<BiPersonalTendenciasMensuales> getTendenciasMensuales(
      String token, int anio) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bi/personal/tendencias-mensuales?anio=$anio'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return BiPersonalTendenciasMensuales.fromJson(jsonData);
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener tendencias mensuales: $e');
    }
  }
}



