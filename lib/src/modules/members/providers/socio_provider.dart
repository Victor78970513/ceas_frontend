import 'package:flutter/foundation.dart';
import '../models/socio.dart';
import '../services/socio_service.dart';

class SocioProvider extends ChangeNotifier {
  final SocioService _socioService = SocioService();

  // Estado
  List<Socio> _socios = [];
  Socio? _socioSeleccionado;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Socio> get socios => _socios;
  Socio? get socioSeleccionado => _socioSeleccionado;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  // Limpiar error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Cargar lista de socios
  Future<void> loadSocios({
    required String token,
    int? idClub,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final socios = await _socioService.getSocios(
        token: token,
        idClub: idClub,
      );

      _socios = socios;
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // Cargar un socio específico
  Future<void> loadSocioById({
    required String token,
    required int idSocio,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final socio = await _socioService.getSocioById(
        token: token,
        idSocio: idSocio,
      );

      _socioSeleccionado = socio;
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // Crear un nuevo socio
  Future<bool> createSocio({
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
      _setLoading(true);
      _clearError();

      final nuevoSocio = await _socioService.createSocio(
        token: token,
        idClub: idClub,
        nombres: nombres,
        apellidos: apellidos,
        ciNit: ciNit,
        telefono: telefono,
        correoElectronico: correoElectronico,
        direccion: direccion,
        estado: estado,
        fechaNacimiento: fechaNacimiento,
        tipoMembresia: tipoMembresia,
      );

      // Agregar el nuevo socio a la lista
      _socios.add(nuevoSocio);
      _setLoading(false);

      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Actualizar un socio existente
  Future<bool> updateSocio({
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
      _setLoading(true);
      _clearError();

      final socioActualizado = await _socioService.updateSocio(
        token: token,
        idSocio: idSocio,
        idClub: idClub,
        nombres: nombres,
        apellidos: apellidos,
        ciNit: ciNit,
        telefono: telefono,
        correoElectronico: correoElectronico,
        direccion: direccion,
        estado: estado,
        fechaNacimiento: fechaNacimiento,
        tipoMembresia: tipoMembresia,
      );

      // Actualizar en la lista
      final index = _socios.indexWhere((s) => s.idSocio == idSocio);
      if (index != -1) {
        _socios[index] = socioActualizado;
      }

      // Actualizar socio seleccionado si es el mismo
      if (_socioSeleccionado?.idSocio == idSocio) {
        _socioSeleccionado = socioActualizado;
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Eliminar un socio
  Future<bool> deleteSocio({
    required String token,
    required int idSocio,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      await _socioService.deleteSocio(
        token: token,
        idSocio: idSocio,
      );

      // Remover de la lista
      _socios.removeWhere((s) => s.idSocio == idSocio);

      // Limpiar socio seleccionado si es el mismo
      if (_socioSeleccionado?.idSocio == idSocio) {
        _socioSeleccionado = null;
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Seleccionar un socio
  void selectSocio(Socio? socio) {
    _socioSeleccionado = socio;
    notifyListeners();
  }

  // Buscar socios por texto
  List<Socio> searchSocios(String query) {
    if (query.isEmpty) return _socios;

    final lowercaseQuery = query.toLowerCase();
    return _socios.where((socio) {
      return socio.nombres.toLowerCase().contains(lowercaseQuery) ||
          socio.apellidos.toLowerCase().contains(lowercaseQuery) ||
          socio.ciNit.toLowerCase().contains(lowercaseQuery) ||
          socio.correoElectronico.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Filtrar socios por estado
  List<Socio> filterSociosByEstado(int estado) {
    return _socios.where((socio) => socio.estado == estado).toList();
  }

  // Filtrar socios por tipo de membresía
  List<Socio> filterSociosByTipoMembresia(String tipoMembresia) {
    return _socios
        .where((socio) => socio.tipoMembresia == tipoMembresia)
        .toList();
  }

  // Métodos para filtros y búsqueda
  String _searchQuery = '';
  String _filterEstado = 'Todos';
  String _filterTipoMembresia = 'Todos';

  String get searchQuery => _searchQuery;
  String get filterEstado => _filterEstado;
  String get filterTipoMembresia => _filterTipoMembresia;

  // Socios filtrados
  List<Socio> get filteredSocios {
    return _socios.where((socio) {
      final matchesSearch = _searchQuery.isEmpty ||
          socio.nombreCompleto
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          socio.ciNit.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          socio.correoElectronico
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      final matchesEstado = _filterEstado == 'Todos' ||
          (_filterEstado == 'Activo' && socio.estaActivo) ||
          (_filterEstado == 'Inactivo' && !socio.estaActivo);

      final matchesTipo = _filterTipoMembresia == 'Todos' ||
          socio.tipoMembresia == _filterTipoMembresia;

      return matchesSearch && matchesEstado && matchesTipo;
    }).toList();
  }

  // Actualizar búsqueda
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Actualizar filtro de estado
  void updateFilterEstado(String estado) {
    _filterEstado = estado;
    notifyListeners();
  }

  // Actualizar filtro de tipo de membresía
  void updateFilterTipoMembresia(String tipo) {
    _filterTipoMembresia = tipo;
    notifyListeners();
  }

  // Métodos privados para manejar estado
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  // Limpiar estado
  void clearState() {
    _socios = [];
    _socioSeleccionado = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
