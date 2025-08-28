import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bi_metricas_financieras.dart';
import '../models/bi_metricas_administrativas.dart';
import '../models/bi_top_club.dart';
import '../models/bi_top_socio.dart';
import '../models/bi_distribucion_financiera.dart';
import '../models/bi_kpi.dart';
import '../models/bi_resumen_rapido.dart';
import '../models/bi_movimientos_financieros.dart';

class BiService {
  static const String baseUrl = 'http://localhost:8000';

  // 1. Métricas Financieras
  static Future<BiMetricasFinancieras> getMetricasFinancieras(
      String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bi/administrativo/metricas-financieras'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return BiMetricasFinancieras.fromJson(jsonData);
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener métricas financieras: $e');
    }
  }

  // 2. Métricas Administrativas
  static Future<BiMetricasAdministrativas> getMetricasAdministrativas(
      String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bi/administrativo/metricas-administrativas'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return BiMetricasAdministrativas.fromJson(jsonData);
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener métricas administrativas: $e');
    }
  }

  // 3. Top Clubes
  static Future<List<BiTopClub>> getTopClubes(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bi/administrativo/top-clubes'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => BiTopClub.fromJson(json)).toList();
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener top clubes: $e');
    }
  }

  // 4. Top Socios
  static Future<List<BiTopSocio>> getTopSocios(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bi/administrativo/top-socios'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => BiTopSocio.fromJson(json)).toList();
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener top socios: $e');
    }
  }

  // 5. Distribución Financiera
  static Future<BiDistribucionFinanciera> getDistribucionFinanciera(
      String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bi/administrativo/distribucion-financiera'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return BiDistribucionFinanciera.fromJson(jsonData);
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener distribución financiera: $e');
    }
  }

  // 6. KPIs
  static Future<List<BiKpi>> getKpis(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bi/administrativo/kpis'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => BiKpi.fromJson(json)).toList();
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener KPIs: $e');
    }
  }

  // 7. Alertas
  static Future<List<String>> getAlertas(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bi/administrativo/alertas'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => json.toString()).toList();
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener alertas: $e');
    }
  }

  // 8. Resumen Rápido
  static Future<BiResumenRapido> getResumenRapido(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bi/administrativo/resumen-rapido'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return BiResumenRapido.fromJson(jsonData);
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener resumen rápido: $e');
    }
  }

  // 9. Movimientos Financieros Detallados
  static Future<BiMovimientosFinancieros> getMovimientosFinancieros(
      String token) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/bi/administrativo/movimientos-financieros-detallados'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return BiMovimientosFinancieros.fromJson(jsonData);
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener movimientos financieros: $e');
    }
  }
}
