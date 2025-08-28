import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dashboard_administrativo.dart';

class DashboardService {
  static const String baseUrl = 'http://localhost:8000';

  /// Obtiene el dashboard administrativo desde el backend
  static Future<DashboardAdministrativo> getDashboardAdministrativo(
      String token) async {
    try {
      print(
          'DashboardService - Iniciando llamada HTTP a $baseUrl/bi/administrativo/dashboard');
      print('DashboardService - Token: ${token.substring(0, 20)}...');

      final response = await http.get(
        Uri.parse('$baseUrl/bi/administrativo/dashboard'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print('DashboardService - Response status: ${response.statusCode}');
      print(
          'DashboardService - Response body: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}...');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final dashboard = DashboardAdministrativo.fromJson(jsonData);
        print('DashboardService - Dashboard parseado exitosamente');
        return dashboard;
      } else {
        print(
            'DashboardService - Error HTTP: ${response.statusCode} - ${response.body}');
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('DashboardService - Excepción: $e');
      throw Exception('Error al obtener dashboard administrativo: $e');
    }
  }

  /// Prueba la conectividad con el backend
  static Future<bool> probarConectividad() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bi/administrativo/dashboard'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      return response.statusCode == 200 || response.statusCode == 401;
    } catch (e) {
      return false;
    }
  }
}


