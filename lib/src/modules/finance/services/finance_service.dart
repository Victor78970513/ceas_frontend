import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movimiento_financiero.dart';
import '../models/finanzas_resumen.dart';

class FinanceService {
  static const String baseUrl = 'http://localhost:8000';

  /// Obtiene todos los movimientos financieros
  static Future<List<MovimientoFinanciero>> getMovimientos(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/finanzas/movimientos/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Timeout: La solicitud tardó demasiado en responder');
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map((json) => MovimientoFinanciero.fromJson(json))
            .toList();
      } else if (response.statusCode == 401) {
        throw Exception('No autorizado. Token inválido o expirado.');
      } else if (response.statusCode == 404) {
        throw Exception('Endpoint no encontrado');
      } else if (response.statusCode == 500) {
        throw Exception('Error interno del servidor');
      } else {
        String errorMessage =
            'Error al obtener movimientos: ${response.statusCode}';
        if (response.body.isNotEmpty) {
          try {
            final errorBody = response.body;
            errorMessage += ' - $errorBody';
          } catch (e) {
            // Ignorar errores de parsing del body
          }
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e.toString().contains('Timeout')) {
        rethrow;
      }
      throw Exception('Error de conexión: $e');
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

  /// Obtiene el resumen de finanzas para Business Intelligence
  static Future<FinanzasResumen> getFinanzasResumen(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bi/finanzas-resumen'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Timeout: La solicitud tardó demasiado en responder');
        },
      );

      if (response.statusCode == 200) {
        return FinanzasResumen.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('No autorizado. Token inválido o expirado.');
      } else if (response.statusCode == 404) {
        throw Exception('Endpoint de BI no encontrado');
      } else if (response.statusCode == 500) {
        throw Exception('Error interno del servidor');
      } else {
        String errorMessage =
            'Error al obtener resumen de finanzas: ${response.statusCode}';
        if (response.body.isNotEmpty) {
          try {
            final errorBody = response.body;
            errorMessage += ' - $errorBody';
          } catch (e) {
            // Ignorar errores de parsing del body
          }
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e.toString().contains('Timeout')) {
        rethrow;
      }
      throw Exception('Error de conexión: $e');
    }
  }
}
