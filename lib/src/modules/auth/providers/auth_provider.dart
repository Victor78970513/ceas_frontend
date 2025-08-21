import 'package:flutter/material.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../services/session_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();
  SessionService? _sessionService;

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
        // Verificar token usando el endpoint /verify
        final verifiedUser =
            await _authService.verifyToken(savedUser.accessToken);
        if (verifiedUser != null) {
          _user = verifiedUser;
          // Actualizar datos guardados con la información más reciente
          await _storageService.saveAuthData(verifiedUser);
          // Iniciar verificación periódica
          _sessionService = SessionService(this);
          _sessionService!.startPeriodicCheck();
        } else {
          // Token no válido, limpiar datos
          _user = null;
          await _storageService.clearAuthData();
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

      // Iniciar verificación periódica
      _sessionService = SessionService(this);
      _sessionService!.startPeriodicCheck();

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

    // Detener verificación periódica
    _sessionService?.stopPeriodicCheck();
    _sessionService = null;

    await _storageService.clearAuthData();
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Verificar token periódicamente para mantener la sesión activa
  Future<void> refreshToken() async {
    if (_user?.accessToken == null) return;

    try {
      final verifiedUser = await _authService.verifyToken(_user!.accessToken);
      if (verifiedUser != null) {
        _user = verifiedUser;
        await _storageService.saveAuthData(verifiedUser);
        notifyListeners();
      } else {
        // Token expirado, hacer logout
        await logout();
      }
    } catch (e) {
      // En caso de error, mantener la sesión actual
      // Solo hacer logout si es un error de autenticación
      if (e.toString().contains('Not authenticated')) {
        await logout();
      }
    }
  }

  // Verificar sesión manualmente (útil para verificar antes de operaciones críticas)
  Future<bool> checkSession() async {
    if (_user?.accessToken == null) return false;

    try {
      final verifiedUser = await _authService.verifyToken(_user!.accessToken);
      if (verifiedUser != null) {
        _user = verifiedUser;
        await _storageService.saveAuthData(verifiedUser);
        notifyListeners();
        return true;
      } else {
        // Token no válido, hacer logout
        await logout();
        return false;
      }
    } catch (e) {
      // En caso de error, mantener la sesión actual
      return true;
    }
  }

  Future<bool> validateToken() async {
    if (_user?.accessToken == null) return false;

    try {
      final verifiedUser = await _authService.verifyToken(_user!.accessToken);
      if (verifiedUser != null) {
        // Token válido, actualizar datos del usuario
        _user = verifiedUser;
        await _storageService.saveAuthData(verifiedUser);
        notifyListeners();
        return true;
      } else {
        // Token no válido, hacer logout
        await logout();
        return false;
      }
    } catch (e) {
      // En caso de error, hacer logout
      await logout();
      return false;
    }
  }
}
