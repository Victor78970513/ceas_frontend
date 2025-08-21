import 'dart:async';
import '../providers/auth_provider.dart';

class SessionService {
  static const Duration _checkInterval =
      Duration(minutes: 5); // Verificar cada 5 minutos
  Timer? _timer;
  final AuthProvider _authProvider;

  SessionService(this._authProvider);

  // Iniciar verificación periódica
  void startPeriodicCheck() {
    _timer?.cancel();
    _timer = Timer.periodic(_checkInterval, (timer) {
      _checkSession();
    });
  }

  // Detener verificación periódica
  void stopPeriodicCheck() {
    _timer?.cancel();
    _timer = null;
  }

  // Verificar sesión
  Future<void> _checkSession() async {
    if (_authProvider.isAuthenticated) {
      await _authProvider.refreshToken();
    }
  }

  // Verificar sesión manualmente
  Future<void> checkSession() async {
    if (_authProvider.isAuthenticated) {
      await _authProvider.refreshToken();
    }
  }

  // Disposal
  void dispose() {
    stopPeriodicCheck();
  }
}
