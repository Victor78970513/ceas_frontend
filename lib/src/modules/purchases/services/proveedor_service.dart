import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/proveedor.dart';

class ProveedorService {
  static const String baseUrl = 'http://localhost:8000';

  /// Obtiene la lista de proveedores desde el backend
  static Future<List<Proveedor>> getProveedores(String token) async {
    try {
      print(
          'ProveedorService - Iniciando llamada HTTP a $baseUrl/proveedores/');
      print('ProveedorService - Token: ${token.substring(0, 20)}...');

      final response = await http.get(
        Uri.parse('$baseUrl/proveedores/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print('ProveedorService - Response status: ${response.statusCode}');
      print(
          'ProveedorService - Response body: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}...');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final proveedores =
            jsonData.map((json) => Proveedor.fromJson(json)).toList();
        print(
            'ProveedorService - Proveedores parseados: ${proveedores.length}');
        return proveedores;
      } else {
        print(
            'ProveedorService - Error HTTP: ${response.statusCode} - ${response.body}');
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('ProveedorService - Excepción: $e');
      throw Exception('Error al obtener proveedores: $e');
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
}
