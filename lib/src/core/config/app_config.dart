import 'dart:io';

class AppConfig {
  static String get baseUrl {
    // Detectar la plataforma y configurar la URL apropiada
    if (Platform.isAndroid) {
      // Android Emulator usa 10.0.2.2 para acceder al localhost del host
      return 'http://10.0.2.2:8000';
    } else if (Platform.isIOS) {
      // iOS Simulator puede usar localhost
      return 'http://localhost:8000';
    } else {
      // Para web o desktop, usar localhost
      return 'http://localhost:8000';
    }
  }

  // URL para dispositivos físicos (cambiar por tu IP real)
  static const String physicalDeviceUrl = 'http://192.168.1.233:8000';
  
  // Detectar si estamos en un dispositivo físico
  static bool get isPhysicalDevice {
    return Platform.isAndroid || Platform.isIOS;
  }

  // Obtener la URL correcta según el entorno
  static String getApiUrl() {
    // Si estás en un dispositivo físico, descomenta la siguiente línea
    // y cambia la IP por la de tu máquina
    // return physicalDeviceUrl;
    
    return baseUrl;
  }
}
