import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_request.dart';
import '../models/login_response.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:8000';
  static const String loginEndpoint = '/login';

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$loginEndpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return LoginResponse.fromJson(responseData);
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Error en el login');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error de conexión: $e');
    }
  }

  Future<bool> validateToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/validate-token'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
