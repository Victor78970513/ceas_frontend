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
    required String metodoPago,
  }) async {
    try {
      // Obtener token de autenticación
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token == null) {
        throw Exception('Token de autenticación no encontrado');
      }

      // Mapear método de pago a valor más corto para la base de datos
      String metodoPagoMapeado;
      switch (metodoPago.toLowerCase()) {
        case 'efectivo':
          metodoPagoMapeado = 'efectivo';
          break;
        case 'transferencia_bancaria':
          metodoPagoMapeado = 'transferencia';
          break;
        case 'cheque':
          metodoPagoMapeado = 'cheque';
          break;
        case 'tarjeta de crédito':
          metodoPagoMapeado = 'tarjeta_credito';
          break;
        case 'tarjeta de débito':
          metodoPagoMapeado = 'tarjeta_debito';
          break;
        case 'depósito bancario':
          metodoPagoMapeado = 'deposito';
          break;
        default:
          metodoPagoMapeado = 'efectivo';
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
        'metodo_pago': metodoPagoMapeado,
      };

      print('🚀 Enviando petición a generar QR de pago...');
      print('📋 Método de pago original: $metodoPago -> Mapeado: $metodoPagoMapeado');
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

  /// Confirma el pago usando la referencia temporal
  static Future<Map<String, dynamic>> confirmarPago(String referenciaTemporal) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token == null) {
        throw Exception('Token de autenticación no encontrado');
      }

      print('🔍 Confirmando pago para referencia: $referenciaTemporal');

      final response = await http.post(
        Uri.parse('$_baseUrl/acciones/simular-pago/confirmar-pago?referencia_temporal=$referenciaTemporal'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📡 Respuesta de confirmación: ${response.statusCode}');
      print('📄 Cuerpo de la respuesta: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('✅ Pago confirmado exitosamente');
        return responseData;
      } else {
        throw Exception('Error confirmando pago: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Error confirmando pago: $e');
      rethrow;
    }
  }
}

