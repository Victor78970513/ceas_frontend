// Configuración para manejar CORS en desarrollo
class CorsConfig {
  // Headers necesarios para peticiones CORS
  static Map<String, String> get corsHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
  };

  // Headers para peticiones de autenticación
  static Map<String, String> get authHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
