import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/login_response.dart';

class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';

  // Guardar token y datos del usuario
  Future<void> saveAuthData(LoginResponse loginResponse) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, loginResponse.accessToken);
    await prefs.setString(_userDataKey, jsonEncode(loginResponse.toJson()));
  }

  // Obtener token guardado
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Obtener datos del usuario guardados
  Future<LoginResponse?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userDataKey);

    if (userDataString != null) {
      try {
        final userData = jsonDecode(userDataString);
        return LoginResponse.fromJson(userData);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Limpiar datos de autenticación
  Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userDataKey);
  }

  // Verificar si hay datos de autenticación guardados
  Future<bool> hasAuthData() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
