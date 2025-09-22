import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

class AuthService {
  // URL base del backend (web): usar 127.0.0.1
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String loginEndpoint = '/login';
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 12),
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      print('🔗 Intentando conectar a: $baseUrl$loginEndpoint');
      
      final response = await _dio.post(
        loginEndpoint,
        data: request.toJson(),
      );

      print('📡 Respuesta del servidor: ${response.statusCode}');
      print('📄 Cuerpo de la respuesta: ${response.data}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data is String
            ? jsonDecode(response.data)
            : Map<String, dynamic>.from(response.data);
        return LoginResponse.fromJson(responseData);
      } else {
        final data = response.data;
        final Map<String, dynamic> errorData = data is String
            ? jsonDecode(data)
            : (data is Map<String, dynamic> ? data : {});
        throw Exception(errorData['detail'] ?? 'Error en el login');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown) {
        throw Exception('$e No se pudo conectar al servidor ($baseUrl). Verifica CORS y que el backend esté activo.');
      }
      final data = e.response?.data;
      final Map<String, dynamic> errorData = data is String
          ? jsonDecode(data)
          : (data is Map<String, dynamic> ? data : {});
      throw Exception(errorData['detail'] ?? 'Error en el login');
    } on FormatException catch (e) {
      print('❌ Error de formato: $e');
      throw Exception('Error al procesar la respuesta del servidor: $e');
    } catch (e) {
      print('❌ Error inesperado: $e');
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error de conexión: $e');
    }
  }

  Future<bool> validateToken(String token) async {
    try {
      final response = await _dio.get(
        '/validate-token',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<LoginResponse?> verifyToken(String token) async {
    try {
      final response = await _dio.get(
        '/verify',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data is String
            ? jsonDecode(response.data)
            : Map<String, dynamic>.from(response.data);
        return LoginResponse.fromJson(responseData);
      } else if (response.statusCode == 401) {
        // Token no válido
        return null;
      } else {
        final data = response.data;
        final Map<String, dynamic> errorData = data is String
            ? jsonDecode(data)
            : (data is Map<String, dynamic> ? data : {});
        throw Exception(
            errorData['detail'] ?? 'Error en la verificación del token');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error de conexión: $e');
    }
  }
}
