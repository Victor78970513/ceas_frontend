import 'package:flutter/foundation.dart';
import '../models/compra.dart';
import '../services/compra_service.dart';

class CompraProvider extends ChangeNotifier {
  List<Compra> _compras = [];
  List<Compra> _filteredCompras = [];
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
  List<Compra> get compras => _compras;
  List<Compra> get filteredCompras => _filteredCompras;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String get filterEstado => _filterEstado;

  // Listas para filtros
  List<String> get estados => ['Todos', 'Completada', 'Pendiente', 'Cancelada'];
  List<String> get categorias => ['Todos', ..._getUniqueCategorias()];

  // Getters de paginación
  int get currentPage => _currentPage;
  int get itemsPerPage => _itemsPerPage;
  int get totalItems => _totalItems;
  bool get hasMorePages => _hasMorePages;
  int get totalPages => (_totalItems / _itemsPerPage).ceil();
  List<Compra> get paginatedCompras {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return _filteredCompras.sublist(
      startIndex,
      endIndex > _filteredCompras.length ? _filteredCompras.length : endIndex,
    );
  }

  /// Carga las compras desde el backend
  Future<void> loadCompras(String token) async {
    try {
      print('CompraProvider - Iniciando carga de compras...');
      _isLoading = true;
      _error = null;
      notifyListeners();

      print('CompraProvider - Llamando a CompraService.getCompras...');
      final compras = await CompraService.getCompras(token);
      print('CompraProvider - Compras recibidas: ${compras.length}');

      _compras = compras;
      _applyFilters();
      print(
          'CompraProvider - Filtros aplicados, filteredCompras: ${_filteredCompras.length}');

      _error = null;
    } catch (e) {
      print('CompraProvider - ERROR: $e');
      _error = e.toString();
      _compras = [];
      _filteredCompras = [];
    } finally {
      _isLoading = false;
      notifyListeners();
      print(
          'CompraProvider - Carga completada, isLoading: $_isLoading, error: $_error');
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
    _filteredCompras = _compras.where((compra) {
      final matchesSearch = _searchQuery.isEmpty ||
          compra.proveedor.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          compra.categoria.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesEstado =
          _filterEstado == 'Todos' || compra.estado == _filterEstado;

      return matchesSearch && matchesEstado;
    }).toList();

    // Actualizar paginación
    _totalItems = _filteredCompras.length;
    _hasMorePages = _totalItems > _itemsPerPage;
    resetPagination();
  }

  /// Obtiene estadísticas de compras
  Map<String, dynamic> getEstadisticas() {
    final total = _compras.length;
    final completadas = _compras.where((c) => c.estado == 'Completada').length;
    final pendientes = _compras.where((c) => c.estado == 'Pendiente').length;
    final canceladas = _compras.where((c) => c.estado == 'Cancelada').length;
    final montoTotal = _compras.fold(0.0, (sum, c) => sum + c.montoTotal);

    return {
      'total': total,
      'completadas': completadas,
      'pendientes': pendientes,
      'canceladas': canceladas,
      'montoTotal': montoTotal,
    };
  }

  /// Obtiene listas únicas para filtros
  List<String> _getUniqueCategorias() {
    return _compras.map((c) => c.categoria).toSet().toList()..sort();
  }

  /// Selecciona una compra específica
  Compra? selectCompra(int idCompra) {
    try {
      return _compras.firstWhere((c) => c.idCompra == idCompra);
    } catch (e) {
      return null;
    }
  }

  /// Refresca los datos
  Future<void> refresh(String token) async {
    await loadCompras(token);
  }
}
