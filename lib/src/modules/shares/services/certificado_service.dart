import 'dart:typed_data';
import 'package:http/http.dart' as http;

class CertificadoService {
  static const String baseUrl = 'http://localhost:8000';

  /// Genera un certificado PDF para una acción específica
  static Future<Uint8List?> generarCertificado(
      int accionId, String token) async {
    try {
      if (token.isEmpty) {
        throw Exception('Token de autenticación no válido');
      }

      // Realizar la petición POST al endpoint con timeout
      final response = await http.post(
        Uri.parse('$baseUrl/acciones/$accionId/generar-certificado'),
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
        // Verificar que la respuesta contenga datos
        if (response.bodyBytes.isEmpty) {
          throw Exception('El servidor retornó un PDF vacío');
        }
        // Retornar el contenido del PDF como bytes
        return response.bodyBytes;
      } else if (response.statusCode == 401) {
        throw Exception('No autorizado. Token inválido o expirado.');
      } else if (response.statusCode == 404) {
        throw Exception('Acción no encontrada');
      } else if (response.statusCode == 500) {
        throw Exception('Error interno del servidor');
      } else {
        // Agregar más información del error
        String errorMessage =
            'Error al generar certificado: ${response.statusCode}';
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
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error de conexión: $e');
    }
  }

  /// Verifica si el certificado está disponible
  static Future<bool> verificarCertificadoDisponible(
      int accionId, String token) async {
    try {
      if (token.isEmpty) {
        return false;
      }

      final response = await http.head(
        Uri.parse('$baseUrl/acciones/$accionId/generar-certificado'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Timeout al verificar disponibilidad');
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
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
