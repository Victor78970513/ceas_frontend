import 'package:flutter/material.dart';
import '../models/socio.dart';
import '../services/members_service.dart';

class MembersProvider extends ChangeNotifier {
  final MembersService _membersService = MembersService();

  List<Socio> _socios = [];
  bool _isLoading = false;
  String? _error;
  Socio? _selectedSocio;

  List<Socio> get socios => _socios;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Socio? get selectedSocio => _selectedSocio;

  // Filtros
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

  // Cargar socios
  Future<void> loadSocios() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _socios = await _membersService.getSocios();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cargar socio específico
  Future<void> loadSocioById(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedSocio = await _membersService.getSocioById(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Crear socio
  Future<bool> createSocio(Map<String, dynamic> socioData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newSocio = await _membersService.createSocio(socioData);
      _socios.add(newSocio);
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

  // Actualizar socio
  Future<bool> updateSocio(int id, Map<String, dynamic> socioData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedSocio = await _membersService.updateSocio(id, socioData);
      final index = _socios.indexWhere((s) => s.idSocio == id);
      if (index != -1) {
        _socios[index] = updatedSocio;
      }
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

  // Eliminar socio
  Future<bool> deleteSocio(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _membersService.deleteSocio(id);
      _socios.removeWhere((s) => s.idSocio == id);
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

  // Actualizar filtros
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void updateFilterEstado(String estado) {
    _filterEstado = estado;
    notifyListeners();
  }

  void updateFilterTipoMembresia(String tipo) {
    _filterTipoMembresia = tipo;
    notifyListeners();
  }

  // Limpiar error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Limpiar socio seleccionado
  void clearSelectedSocio() {
    _selectedSocio = null;
    notifyListeners();
  }
}
