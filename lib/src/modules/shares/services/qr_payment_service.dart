import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/qr_payment_response.dart';

class QrPaymentService {
  static const String _baseUrl = 'http://localhost:8000';

  /// Genera un QR de pago para una acción
  static Future<QrPaymentResponse> generarQrPago({
    required int idClub,
    required int idSocio,
    required int modalidadPago,
    required int estadoAccion,
    required String tipoAccion,
    required double totalPago,
    required String metodoPago,
  }) async {
    try {
      // Obtener token de autenticación
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token == null) {
        throw Exception('Token de autenticación no encontrado');
      }

      // Preparar el body de la petición
      final body = {
        'id_club': idClub,
        'id_socio': idSocio,
        'modalidad_pago': modalidadPago,
        'estado_accion': estadoAccion,
        'certificado_pdf': null,
        'certificado_cifrado': false,
        'tipo_accion': tipoAccion,
        'total_pago': totalPago,
        'metodo_pago': metodoPago,
      };

      print('🚀 Enviando petición a generar QR de pago...');
      print('📋 Body: ${json.encode(body)}');

      // Hacer la petición POST
      final response = await http.post(
        Uri.parse('$_baseUrl/acciones/simular-pago/crear-qr'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(body),
      );

      print('📡 Respuesta del servidor: ${response.statusCode}');
      print('📄 Cuerpo de la respuesta: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final qrResponse = QrPaymentResponse.fromJson(responseData);
        print('✅ QR de pago generado exitosamente');
        return qrResponse;
      } else {
        throw Exception('Error del servidor: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Error generando QR de pago: $e');
      rethrow;
    }
  }

  /// Verifica el estado de un pago
  static Future<Map<String, dynamic>> verificarPago(String referenciaTemporal) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token == null) {
        throw Exception('Token de autenticación no encontrado');
      }

      print('🔍 Verificando pago para referencia: $referenciaTemporal');

      final response = await http.get(
        Uri.parse('$_baseUrl/acciones/verificar-pago/$referenciaTemporal'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📡 Respuesta de verificación: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('✅ Estado de pago obtenido');
        return responseData;
      } else {
        throw Exception('Error verificando pago: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Error verificando pago: $e');
      rethrow;
    }
  }
}
