import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
// Importación condicional para web
import 'dart:html' as html;

class CertificateService {
  static const String _baseUrl = 'http://localhost:8000';

  /// Descarga un certificado PDF desde el servidor
  static Future<String?> downloadCertificate(String fileName) async {
    try {
      // Obtener token de autenticación
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token == null) {
        throw Exception('Token de autenticación no encontrado');
      }

      print('📥 Descargando certificado: $fileName');

      // Hacer la petición GET para descargar el certificado
      final response = await http.get(
        Uri.parse('$_baseUrl/acciones/certificados/$fileName'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('📡 Respuesta de descarga: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Para web, manejar la descarga de manera diferente
        if (kIsWeb) {
          // Crear un blob y descargar directamente en el navegador
          final blob = html.Blob([response.bodyBytes]);
          final url = html.Url.createObjectUrlFromBlob(blob);
          html.AnchorElement(href: url)
            ..setAttribute('download', fileName)
            ..click();
          html.Url.revokeObjectUrl(url);
          
          print('✅ Certificado descargado para web: $fileName');
          return 'Descargado en navegador';
        } else {
          // Para móvil, guardar en directorio local
          Directory? downloadsDir;
          try {
            if (Platform.isAndroid) {
              downloadsDir = Directory('/storage/emulated/0/Download');
            } else if (Platform.isIOS) {
              downloadsDir = await getApplicationDocumentsDirectory();
            } else {
              downloadsDir = await getTemporaryDirectory();
            }

            // Crear el directorio si no existe
            if (!await downloadsDir.exists()) {
              await downloadsDir.create(recursive: true);
            }

            // Guardar el archivo
            final file = File('${downloadsDir.path}/$fileName');
            await file.writeAsBytes(response.bodyBytes);

            print('✅ Certificado descargado: ${file.path}');
            return file.path;
          } catch (e) {
            print('⚠️ Error guardando archivo localmente: $e');
            // Fallback: devolver que se descargó pero sin ruta específica
            return 'Descargado';
          }
        }
      } else {
        throw Exception('Error descargando certificado: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Error descargando certificado: $e');
      rethrow;
    }
  }

  /// Abre un archivo PDF descargado
  static Future<void> openCertificate(String filePath) async {
    try {
      // En web, crear un enlace de descarga
      if (kIsWeb) {
        // Para web, el archivo ya se descarga automáticamente
        print('✅ Archivo descargado para web');
        return;
      }

      // Para móviles, usar el paquete open_file si está disponible
      // Nota: Necesitarías agregar open_file a pubspec.yaml
      print('📂 Abriendo archivo: $filePath');
      
      // Aquí podrías usar open_file para abrir el PDF
      // await OpenFile.open(filePath);
      
    } catch (e) {
      print('❌ Error abriendo certificado: $e');
      rethrow;
    }
  }

  /// Verifica si un certificado existe en el servidor
  static Future<bool> certificateExists(String fileName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token == null) {
        return false;
      }

      final response = await http.head(
        Uri.parse('$_baseUrl/acciones/certificados/$fileName'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Error verificando certificado: $e');
      return false;
    }
  }
}
