import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/accion.dart';

class AccionService {
  static const String baseUrl = 'http://localhost:8000';

  // Obtener lista de acciones
  Future<List<Accion>> getAcciones({
    required String token,
    int? idClub,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (idClub != null) {
        queryParams['id_club'] = idClub.toString();
      }

      final uri =
          Uri.parse('$baseUrl/acciones/').replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((json) => Accion.fromJson(json)).toList();
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Error al obtener las acciones');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener una acción específica por ID
  Future<Accion> getAccionById({
    required String token,
    required int idAccion,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/acciones/$idAccion'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return Accion.fromJson(responseData);
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Error al obtener la acción');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener acciones por socio
  Future<List<Accion>> getAccionesBySocio({
    required String token,
    required int idSocio,
    int? idClub,
  }) async {
    try {
      final queryParams = <String, String>{
        'id_socio': idSocio.toString(),
      };
      if (idClub != null) {
        queryParams['id_club'] = idClub.toString();
      }

      final uri =
          Uri.parse('$baseUrl/acciones/').replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((json) => Accion.fromJson(json)).toList();
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception(
            errorData['detail'] ?? 'Error al obtener las acciones del socio');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener acciones por estado de pago
  Future<List<Accion>> getAccionesByEstadoPago({
    required String token,
    required String estadoPago,
    int? idClub,
  }) async {
    try {
      final queryParams = <String, String>{
        'estado_pago': estadoPago,
      };
      if (idClub != null) {
        queryParams['id_club'] = idClub.toString();
      }

      final uri =
          Uri.parse('$baseUrl/acciones/').replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((json) => Accion.fromJson(json)).toList();
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ??
            'Error al obtener las acciones por estado de pago');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener acciones por tipo
  Future<List<Accion>> getAccionesByTipo({
    required String token,
    required String tipoAccion,
    int? idClub,
  }) async {
    try {
      final queryParams = <String, String>{
        'tipo_accion': tipoAccion,
      };
      if (idClub != null) {
        queryParams['id_club'] = idClub.toString();
      }

      final uri =
          Uri.parse('$baseUrl/acciones/').replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((json) => Accion.fromJson(json)).toList();
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception(
            errorData['detail'] ?? 'Error al obtener las acciones por tipo');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error de conexión: $e');
    }
  }

  /// Descarga el reporte de acciones en formato PDF
  Future<List<int>> downloadReporteAcciones({
    required String token,
  }) async {
    try {
      print('📊 Descargando reporte de acciones...');

      final response = await http.get(
        Uri.parse('$baseUrl/acciones/reporte/descargar'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('📡 Respuesta del servidor: ${response.statusCode}');
      print('📄 Content-Type: ${response.headers['content-type']}');
      print('📄 Content-Length: ${response.headers['content-length']}');

      if (response.statusCode == 200) {
        final pdfBytes = response.bodyBytes;
        print('✅ Reporte descargado exitosamente: ${pdfBytes.length} bytes');
        return pdfBytes;
      } else {
        final errorMessage = response.body.isNotEmpty 
            ? response.body 
            : 'Error al descargar el reporte';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Error descargando reporte: $e');
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error de conexión: $e');
    }
  }
}

