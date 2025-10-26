import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/socio.dart';
import '../../auth/services/storage_service.dart';

class MembersService {
  static const String baseUrl = 'http://localhost:8000';
  static const String sociosEndpoint = '/socios';

  final StorageService _storageService = StorageService();

  Future<List<Socio>> getSocios() async {
    try {
      // Obtener el token guardado
      final token = await _storageService.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      final response = await http.get(
        Uri.parse('$baseUrl$sociosEndpoint'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((json) => Socio.fromJson(json)).toList();
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Error al obtener socios');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Socio> getSocioById(int id) async {
    try {
      final token = await _storageService.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      final response = await http.get(
        Uri.parse('$baseUrl$sociosEndpoint/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return Socio.fromJson(responseData);
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Error al obtener socio');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Socio> createSocio(Map<String, dynamic> socioData) async {
    try {
      final token = await _storageService.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      final response = await http.post(
        Uri.parse('$baseUrl$sociosEndpoint'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(socioData),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return Socio.fromJson(responseData);
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Error al crear socio');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Socio> updateSocio(int id, Map<String, dynamic> socioData) async {
    try {
      final token = await _storageService.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      final response = await http.put(
        Uri.parse('$baseUrl$sociosEndpoint/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(socioData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return Socio.fromJson(responseData);
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Error al actualizar socio');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error de conexión: $e');
    }
  }

  Future<void> deleteSocio(int id) async {
    try {
      final token = await _storageService.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl$sociosEndpoint/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 204) {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Error al eliminar socio');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error de conexión: $e');
    }
  }

  /// Descarga el reporte de socios en formato PDF
  Future<List<int>> downloadReporteSocios() async {
    try {
      final token = await _storageService.getToken();
      if (token == null) {
        throw Exception('No hay token de autenticación');
      }

      print('📊 Descargando reporte de socios...');

      final response = await http.get(
        Uri.parse('$baseUrl$sociosEndpoint/reporte/descargar'),
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
