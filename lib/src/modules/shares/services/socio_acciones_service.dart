import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/socio_accion.dart';

class SocioAccionesService {
  static const String baseUrl = 'http://localhost:8000';

  static Future<List<SocioAccion>> getAccionesSocio(
    int socioId,
    String token,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/socios/$socioId/acciones'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => SocioAccion.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener acciones del socio: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener acciones del socio: $e');
    }
  }
}
