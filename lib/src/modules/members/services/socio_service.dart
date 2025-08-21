import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/socio.dart';

class SocioService {
  static const String baseUrl = 'http://localhost:8000';

  // Crear un nuevo socio
  Future<Socio> createSocio({
    required String token,
    required int idClub,
    required String nombres,
    required String apellidos,
    required String ciNit,
    required String telefono,
    required String correoElectronico,
    required String direccion,
    required int estado,
    required String fechaNacimiento,
    required String tipoMembresia,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/socios/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id_club': idClub,
          'nombres': nombres,
          'apellidos': apellidos,
          'ci_nit': ciNit,
          'telefono': telefono,
          'correo_electronico': correoElectronico,
          'direccion': direccion,
          'estado': estado,
          'fecha_nacimiento': fechaNacimiento,
          'tipo_membresia': tipoMembresia,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return Socio.fromJson(responseData);
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Error al crear el socio');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener lista de socios
  Future<List<Socio>> getSocios({
    required String token,
    int? idClub,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (idClub != null) {
        queryParams['id_club'] = idClub.toString();
      }

      final uri =
          Uri.parse('$baseUrl/socios/').replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
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
        throw Exception(errorData['detail'] ?? 'Error al obtener los socios');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener un socio específico por ID
  Future<Socio> getSocioById({
    required String token,
    required int idSocio,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/socios/$idSocio'),
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
        throw Exception(errorData['detail'] ?? 'Error al obtener el socio');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error de conexión: $e');
    }
  }

  // Actualizar un socio existente
  Future<Socio> updateSocio({
    required String token,
    required int idSocio,
    required int idClub,
    required String nombres,
    required String apellidos,
    required String ciNit,
    required String telefono,
    required String correoElectronico,
    required String direccion,
    required int estado,
    required String fechaNacimiento,
    required String tipoMembresia,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/socios/$idSocio'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id_club': idClub,
          'nombres': nombres,
          'apellidos': apellidos,
          'ci_nit': ciNit,
          'telefono': telefono,
          'correo_electronico': correoElectronico,
          'direccion': direccion,
          'estado': estado,
          'fecha_nacimiento': fechaNacimiento,
          'tipo_membresia': tipoMembresia,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return Socio.fromJson(responseData);
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Error al actualizar el socio');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error de conexión: $e');
    }
  }

  // Eliminar un socio
  Future<void> deleteSocio({
    required String token,
    required int idSocio,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/socios/$idSocio'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Error al eliminar el socio');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error de conexión: $e');
    }
  }
}

