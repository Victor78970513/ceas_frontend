import 'package:flutter/foundation.dart';
import '../models/proveedor.dart';
import '../services/proveedor_service.dart';

class ProveedorProvider extends ChangeNotifier {
  List<Proveedor> _proveedores = [];
  List<Proveedor> _filteredProveedores = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String _filterEstado = 'Todos';

  // Paginación
  int _currentPage = 1;
  int _itemsPerPage = 20;
  int _totalItems = 0;
  bool _hasMorePages = true;

  // Getters
  List<Proveedor> get proveedores => _proveedores;
  List<Proveedor> get filteredProveedores => _filteredProveedores;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String get filterEstado => _filterEstado;

  // Listas para filtros
  List<String> get estados => ['Todos', 'Activo', 'Inactivo'];
  List<String> get categorias => ['Todos', ..._getUniqueCategorias()];

  // Getters de paginación
  int get currentPage => _currentPage;
  int get itemsPerPage => _itemsPerPage;
  int get totalItems => _totalItems;
  bool get hasMorePages => _hasMorePages;
  int get totalPages => (_totalItems / _itemsPerPage).ceil();
  List<Proveedor> get paginatedProveedores {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return _filteredProveedores.sublist(
      startIndex,
      endIndex > _filteredProveedores.length
          ? _filteredProveedores.length
          : endIndex,
    );
  }

  /// Carga los proveedores desde el backend
  Future<void> loadProveedores(String token) async {
    try {
      print('ProveedorProvider - Iniciando carga de proveedores...');
      _isLoading = true;
      _error = null;
      notifyListeners();

      print(
          'ProveedorProvider - Llamando a ProveedorService.getProveedores...');
      final proveedores = await ProveedorService.getProveedores(token);
      print('ProveedorProvider - Proveedores recibidos: ${proveedores.length}');

      _proveedores = proveedores;
      _applyFilters();
      print(
          'ProveedorProvider - Filtros aplicados, filteredProveedores: ${_filteredProveedores.length}');

      _error = null;
    } catch (e) {
      print('ProveedorProvider - ERROR: $e');
      _error = e.toString();
      _proveedores = [];
      _filteredProveedores = [];
    } finally {
      _isLoading = false;
      notifyListeners();
      print(
          'ProveedorProvider - Carga completada, isLoading: $_isLoading, error: $_error');
    }
  }

  /// Actualiza la consulta de búsqueda
  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  /// Actualiza el filtro de estado
  void updateFilterEstado(String? estado) {
    if (estado != null) {
      _filterEstado = estado;
      _applyFilters();
      notifyListeners();
    }
  }

  /// Limpia todos los filtros
  void clearFilters() {
    _searchQuery = '';
    _filterEstado = 'Todos';
    _applyFilters();
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

  /// Aplica todos los filtros activos
  void _applyFilters() {
    _filteredProveedores = _proveedores.where((proveedor) {
      final matchesSearch = _searchQuery.isEmpty ||
          proveedor.nombre.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          proveedor.contacto
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          proveedor.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          proveedor.categoria
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      final matchesEstado =
          _filterEstado == 'Todos' || proveedor.estadoDisplay == _filterEstado;

      return matchesSearch && matchesEstado;
    }).toList();

    // Actualizar paginación
    _totalItems = _filteredProveedores.length;
    _hasMorePages = _totalItems > _itemsPerPage;
    resetPagination();
  }

  /// Obtiene estadísticas de proveedores
  Map<String, int> getEstadisticas() {
    final total = _proveedores.length;
    final activos = _proveedores.where((p) => p.estado).length;
    final inactivos = total - activos;

    return {
      'total': total,
      'activos': activos,
      'inactivos': inactivos,
    };
  }

  /// Obtiene listas únicas para filtros
  List<String> _getUniqueCategorias() {
    return _proveedores.map((p) => p.categoria).toSet().toList()..sort();
  }

  /// Selecciona un proveedor específico
  Proveedor? selectProveedor(int idProveedor) {
    try {
      return _proveedores.firstWhere((p) => p.idProveedor == idProveedor);
    } catch (e) {
      return null;
    }
  }

  /// Refresca los datos
  Future<void> refresh(String token) async {
    await loadProveedores(token);
  }
}
