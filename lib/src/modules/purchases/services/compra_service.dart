import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/compra.dart';

class CompraService {
  static const String baseUrl = 'http://localhost:8000';

  /// Obtiene la lista de compras desde el backend
  static Future<List<Compra>> getCompras(String token) async {
    try {
      print('CompraService - Iniciando llamada HTTP a $baseUrl/compras/');
      print('CompraService - Token: ${token.substring(0, 20)}...');

      final response = await http.get(
        Uri.parse('$baseUrl/compras/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print('CompraService - Response status: ${response.statusCode}');
      print(
          'CompraService - Response body: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}...');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final compras = jsonData.map((json) => Compra.fromJson(json)).toList();
        print('CompraService - Compras parseadas: ${compras.length}');
        return compras;
      } else {
        print(
            'CompraService - Error HTTP: ${response.statusCode} - ${response.body}');
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('CompraService - Excepción: $e');
      throw Exception('Error al obtener compras: $e');
    }
  }

  /// Prueba la conectividad con el backend
  static Future<bool> probarConectividad() async {
    try {
      final response = await http
          .get(
        Uri.parse('$baseUrl/'),
      )
          .timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw Exception('Timeout al conectar con el backend');
        },
      );

      return response.statusCode <
          500; // Cualquier respuesta que no sea error del servidor
    } catch (e) {
      return false;
    }
  }

  /// Descarga el reporte de compras en formato PDF
  static Future<List<int>> downloadReporteCompras(String token) async {
    try {
      print('📊 CompraService - Descargando reporte de compras...');

      final response = await http.get(
        Uri.parse('$baseUrl/compras/reporte/descargar'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('📡 CompraService - Respuesta del servidor: ${response.statusCode}');
      print('📄 CompraService - Content-Type: ${response.headers['content-type']}');
      print('📄 CompraService - Content-Length: ${response.headers['content-length']}');

      if (response.statusCode == 200) {
        final pdfBytes = response.bodyBytes;
        print('✅ CompraService - Reporte descargado exitosamente: ${pdfBytes.length} bytes');
        return pdfBytes;
      } else {
        final errorMessage = response.body.isNotEmpty 
            ? response.body 
            : 'Error al descargar el reporte';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ CompraService - Error descargando reporte: $e');
      rethrow;
    }
  }
}
