import 'package:flutter/material.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();

  LoginResponse? _user;
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;

  LoginResponse? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  bool get isInitialized => _isInitialized;

  // Inicializar el provider y cargar datos guardados
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final savedUser = await _storageService.getUserData();
      if (savedUser != null) {
        _user = savedUser;
        // Validar token al iniciar
        final isValid = await validateToken();
        if (!isValid) {
          _user = null;
        }
      }
    } catch (e) {
      // En caso de error, limpiar datos
      await _storageService.clearAuthData();
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final request = LoginRequest(
        correoElectronico: email,
        contrasena: password,
      );

      final response = await _authService.login(request);
      _user = response;

      // Guardar datos localmente
      await _storageService.saveAuthData(response);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    _error = null;
    await _storageService.clearAuthData();
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<bool> validateToken() async {
    if (_user?.accessToken == null) return false;

    try {
      final isValid = await _authService.validateToken(_user!.accessToken);
      if (!isValid) {
        await logout();
      }
      return isValid;
    } catch (e) {
      await logout();
      return false;
    }
  }
}
