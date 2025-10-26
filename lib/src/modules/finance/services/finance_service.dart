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

  /// Crea un nuevo movimiento financiero
  static Future<Map<String, dynamic>> crearMovimiento(
    String token,
    String tipoMovimiento,
    String descripcion,
    double monto,
  ) async {
    try {
      print('FinanceService - Creando movimiento: $tipoMovimiento - $descripcion - $monto');
      
      final body = {
        'id_club': 1,
        'tipo_movimiento': tipoMovimiento,
        'descripcion': descripcion,
        'monto': monto,
        'estado': 'confirmado',
        "referencia_relacionada": "CUOTA-001-2025",
        "metodo_pago": "transferencia"
      };

      print('FinanceService - Body: $body');

      final response = await http.post(
        Uri.parse('$baseUrl/finanzas/movimientos/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 30));

      print('FinanceService - Response status: ${response.statusCode}');
      print('FinanceService - Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('No autorizado. Token inválido o expirado.');
      } else if (response.statusCode == 400) {
        throw Exception('Datos inválidos. Verifique la información enviada.');
      } else if (response.statusCode == 500) {
        throw Exception('Error interno del servidor');
      } else {
        String errorMessage = 'Error al crear movimiento: ${response.statusCode}';
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

  /// Descarga el reporte de finanzas en formato PDF
  static Future<List<int>> downloadReporteFinanzas(String token) async {
    try {
      print('📊 FinanceService - Descargando reporte de finanzas...');

      final response = await http.get(
        Uri.parse('$baseUrl/finanzas/reporte/descargar'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));

      print('📡 FinanceService - Respuesta del servidor: ${response.statusCode}');
      print('📄 FinanceService - Content-Type: ${response.headers['content-type']}');
      print('📄 FinanceService - Content-Length: ${response.headers['content-length']}');

      if (response.statusCode == 200) {
        final pdfBytes = response.bodyBytes;
        print('✅ FinanceService - Reporte descargado exitosamente: ${pdfBytes.length} bytes');
        return pdfBytes;
      } else {
        final errorMessage = response.body.isNotEmpty 
            ? response.body 
            : 'Error al descargar el reporte';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ FinanceService - Error descargando reporte: $e');
      rethrow;
    }
  }
}
