import 'package:flutter/foundation.dart';
import '../models/accion.dart';
import '../services/accion_service.dart';

class AccionProvider extends ChangeNotifier {
  final AccionService _accionService = AccionService();

  // Estado
  List<Accion> _acciones = [];
  Accion? _accionSeleccionada;
  bool _isLoading = false;
  String? _error;

  // Paginación
  int _currentPage = 1;
  int _itemsPerPage = 20;
  int _totalItems = 0;
  bool _hasMorePages = true;

  // Getters
  List<Accion> get acciones => _acciones;
  Accion? get accionSeleccionada => _accionSeleccionada;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  // Getters de paginación
  int get currentPage => _currentPage;
  int get itemsPerPage => _itemsPerPage;
  int get totalItems => _totalItems;
  bool get hasMorePages => _hasMorePages;
  int get totalPages => (_totalItems / _itemsPerPage).ceil();
  List<Accion> get paginatedAcciones {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return _acciones.sublist(
      startIndex,
      endIndex > _acciones.length ? _acciones.length : endIndex,
    );
  }

  // Limpiar error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Métodos de paginación
  void nextPage() {
    if (_hasMorePages) {
      _currentPage++;
      notifyListeners();
    }
  }

  void previousPage() {
    if (_currentPage > 1) {
      _currentPage--;
      notifyListeners();
    }
  }

  void goToPage(int page) {
    if (page >= 1 && page <= totalPages) {
      _currentPage = page;
      notifyListeners();
    }
  }

  void setItemsPerPage(int itemsPerPage) {
    _itemsPerPage = itemsPerPage;
    _currentPage = 1; // Reset a la primera página
    _hasMorePages = _totalItems > _itemsPerPage;
    notifyListeners();
  }

  void resetPagination() {
    _currentPage = 1;
    _hasMorePages = _totalItems > _itemsPerPage;
    notifyListeners();
  }

  // Cargar lista de acciones
  Future<void> loadAcciones({
    required String token,
    int? idClub,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final acciones = await _accionService.getAcciones(
        token: token,
        idClub: idClub,
      );

      _acciones = acciones;
      _totalItems = acciones.length;
      _hasMorePages = _totalItems > _itemsPerPage;
      resetPagination();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // Cargar una acción específica
  Future<void> loadAccionById({
    required String token,
    required int idAccion,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final accion = await _accionService.getAccionById(
        token: token,
        idAccion: idAccion,
      );

      _accionSeleccionada = accion;
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // Cargar acciones por socio
  Future<void> loadAccionesBySocio({
    required String token,
    required int idSocio,
    int? idClub,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final acciones = await _accionService.getAccionesBySocio(
        token: token,
        idSocio: idSocio,
        idClub: idClub,
      );

      _acciones = acciones;
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // Cargar acciones por estado de pago
  Future<void> loadAccionesByEstadoPago({
    required String token,
    required String estadoPago,
    int? idClub,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final acciones = await _accionService.getAccionesByEstadoPago(
        token: token,
        estadoPago: estadoPago,
        idClub: idClub,
      );

      _acciones = acciones;
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // Cargar acciones por tipo
  Future<void> loadAccionesByTipo({
    required String token,
    required String tipoAccion,
    int? idClub,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final acciones = await _accionService.getAccionesByTipo(
        token: token,
        tipoAccion: tipoAccion,
        idClub: idClub,
      );

      _acciones = acciones;
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // Seleccionar una acción
  void selectAccion(Accion? accion) {
    _accionSeleccionada = accion;
    notifyListeners();
  }

  // Buscar acciones por texto
  List<Accion> searchAcciones(String query) {
    if (query.isEmpty) return _acciones;

    final lowercaseQuery = query.toLowerCase();
    return _acciones.where((accion) {
      return accion.tipoAccion.toLowerCase().contains(lowercaseQuery) ||
          accion.estadoAccionInfo.nombre
              .toLowerCase()
              .contains(lowercaseQuery) ||
          accion.estadoPagos.estadoPago
              .toLowerCase()
              .contains(lowercaseQuery) ||
          accion.modalidadPagoInfo.descripcion
              .toLowerCase()
              .contains(lowercaseQuery);
    }).toList();
  }

  // Filtrar acciones por estado de pago
  List<Accion> filterAccionesByEstadoPago(String estadoPago) {
    if (estadoPago == 'Todos') return _acciones;
    return _acciones
        .where((accion) => accion.estadoPagos.estadoPago == estadoPago)
        .toList();
  }

  // Filtrar acciones por tipo
  List<Accion> filterAccionesByTipo(String tipoAccion) {
    if (tipoAccion == 'Todos') return _acciones;
    return _acciones
        .where((accion) => accion.tipoAccion == tipoAccion)
        .toList();
  }

  // Filtrar acciones por estado de acción
  List<Accion> filterAccionesByEstadoAccion(String estadoAccion) {
    if (estadoAccion == 'Todos') return _acciones;
    return _acciones
        .where((accion) => accion.estadoAccionInfo.nombre == estadoAccion)
        .toList();
  }

  // Obtener estadísticas
  Map<String, int> getEstadisticas() {
    final total = _acciones.length;
    final completamentePagadas =
        _acciones.where((a) => a.estaCompletamentePagada).length;
    final parcialmentePagadas =
        _acciones.where((a) => a.estaParcialmentePagada).length;
    final pendientes = _acciones.where((a) => a.estaPendiente).length;

    return {
      'total': total,
      'completamente_pagadas': completamentePagadas,
      'parcialmente_pagadas': parcialmentePagadas,
      'pendientes': pendientes,
    };
  }

  // Obtener tipos de acciones únicos
  List<String> getTiposAcciones() {
    final tipos = _acciones.map((a) => a.tipoAccion).toSet().toList();
    tipos.sort();
    return tipos;
  }

  // Obtener estados de acciones únicos
  List<String> getEstadosAcciones() {
    final estados =
        _acciones.map((a) => a.estadoAccionInfo.nombre).toSet().toList();
    estados.sort();
    return estados;
  }

  // Obtener estados de pago únicos
  List<String> getEstadosPagos() {
    final estados =
        _acciones.map((a) => a.estadoPagos.estadoPago).toSet().toList();
    estados.sort();
    return estados;
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
    _acciones = [];
    _accionSeleccionada = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
