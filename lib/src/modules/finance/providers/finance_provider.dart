import 'package:flutter/foundation.dart';
import '../models/movimiento_financiero.dart';
import '../models/finanzas_resumen.dart';
import '../services/finance_service.dart';

class FinanceProvider extends ChangeNotifier {
  List<MovimientoFinanciero> _movimientos = [];
  List<MovimientoFinanciero> _filteredMovimientos = [];
  FinanzasResumen? _resumen;
  bool _isLoading = false;
  bool _isLoadingResumen = false;
  String? _error;
  String? _errorResumen;
  String _searchQuery = '';
  String _filterTipo = 'Todos';
  String _filterEstado = 'Todos';
  String _filterClub = 'Todos';
  String _filterCategoria = 'Todos';

  // Paginación
  int _currentPage = 1;
  int _itemsPerPage = 20;
  int _totalItems = 0;
  bool _hasMorePages = true;

  // Getters
  List<MovimientoFinanciero> get movimientos => _movimientos;
  List<MovimientoFinanciero> get filteredMovimientos => _filteredMovimientos;
  FinanzasResumen? get resumen => _resumen;
  bool get isLoading => _isLoading;
  bool get isLoadingResumen => _isLoadingResumen;
  String? get error => _error;
  String? get errorResumen => _errorResumen;
  String get searchQuery => _searchQuery;
  String get filterTipo => _filterTipo;
  String get filterEstado => _filterEstado;
  String get filterClub => _filterClub;
  String get filterCategoria => _filterCategoria;

  // Listas para filtros
  List<String> get tiposMovimiento => ['Todos', 'Ingreso', 'Egreso'];
  List<String> get estadosMovimiento =>
      ['Todos', 'Confirmado', 'Pendiente', 'Cancelado'];
  List<String> get clubs => ['Todos', ..._getUniqueClubs()];
  List<String> get categorias => ['Todos', ..._getUniqueCategorias()];

  // Getters de paginación
  int get currentPage => _currentPage;
  int get itemsPerPage => _itemsPerPage;
  int get totalItems => _totalItems;
  bool get hasMorePages => _hasMorePages;
  int get totalPages => (_totalItems / _itemsPerPage).ceil();
  List<MovimientoFinanciero> get paginatedMovimientos {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return _filteredMovimientos.sublist(
      startIndex,
      endIndex > _filteredMovimientos.length
          ? _filteredMovimientos.length
          : endIndex,
    );
  }

  /// Carga los movimientos financieros desde el backend
  Future<void> loadMovimientos(String token) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final movimientos = await FinanceService.getMovimientos(token);
      _movimientos = movimientos;
      _applyFilters();

      _error = null;
    } catch (e) {
      _error = e.toString();
      _movimientos = [];
      _filteredMovimientos = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Carga el resumen de finanzas desde el endpoint de BI
  Future<void> loadResumen(String token) async {
    try {
      _isLoadingResumen = true;
      _errorResumen = null;
      notifyListeners();

      final resumen = await FinanceService.getFinanzasResumen(token);
      _resumen = resumen;

      _errorResumen = null;
    } catch (e) {
      _errorResumen = e.toString();
      _resumen = null;
    } finally {
      _isLoadingResumen = false;
      notifyListeners();
    }
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
    _filteredMovimientos = _movimientos.where((m) {
      final matchesTipo = _filterTipo == 'Todos' || m.tipo == _filterTipo;
      final matchesEstado =
          _filterEstado == 'Todos' || m.estadoDisplay == _filterEstado;
      final matchesClub = _filterClub == 'Todos' || m.club == _filterClub;
      final matchesCategoria =
          _filterCategoria == 'Todos' || m.categoriaDisplay == _filterCategoria;
      final matchesSearch = _searchQuery.isEmpty ||
          m.descripcion.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.id.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesTipo &&
          matchesEstado &&
          matchesClub &&
          matchesCategoria &&
          matchesSearch;
    }).toList();

    // Actualizar paginación
    _totalItems = _filteredMovimientos.length;
    _hasMorePages = _totalItems > _itemsPerPage;
    resetPagination();
  }

  /// Actualiza la búsqueda
  void updateSearch(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  /// Actualiza el filtro de tipo
  void updateFilterTipo(String? tipo) {
    if (tipo != null) {
      _filterTipo = tipo;
      _applyFilters();
      notifyListeners();
    }
  }

  /// Actualiza el filtro de estado
  void updateFilterEstado(String? estado) {
    if (estado != null) {
      _filterEstado = estado;
      _applyFilters();
      notifyListeners();
    }
  }

  /// Actualiza el filtro de club
  void updateFilterClub(String? club) {
    if (club != null) {
      _filterClub = club;
      _applyFilters();
      notifyListeners();
    }
  }

  /// Actualiza el filtro de categoría
  void updateFilterCategoria(String? categoria) {
    if (categoria != null) {
      _filterCategoria = categoria;
      _applyFilters();
      notifyListeners();
    }
  }

  /// Limpia todos los filtros
  void clearFilters() {
    _searchQuery = '';
    _filterTipo = 'Todos';
    _filterEstado = 'Todos';
    _filterClub = 'Todos';
    _filterCategoria = 'Todos';
    _applyFilters();
    notifyListeners();
  }

  /// Obtiene estadísticas de ingresos y egresos
  Map<String, double> getEstadisticas() {
    // Si tenemos resumen de BI, usarlo; si no, calcular desde movimientos
    if (_resumen != null) {
      return {
        'ingresos': _resumen!.ingresos,
        'egresos': _resumen!.egresos,
        'balance': _resumen!.balance,
      };
    }

    // Fallback a cálculo desde movimientos
    final ingresos = _movimientos
        .where((m) => m.tipo == 'Ingreso' && m.estadoDisplay == 'Confirmado')
        .fold(0.0, (sum, m) => sum + m.monto);

    final egresos = _movimientos
        .where((m) => m.tipo == 'Egreso' && m.estadoDisplay == 'Confirmado')
        .fold(0.0, (sum, m) => sum + m.monto);

    final balance = ingresos - egresos;

    return {
      'ingresos': ingresos,
      'egresos': egresos,
      'balance': balance,
    };
  }

  /// Obtiene saldos por club
  Map<String, Map<String, double>> getSaldosPorClub() {
    // Si tenemos resumen de BI, usarlo; si no, calcular desde movimientos
    if (_resumen != null) {
      final Map<String, Map<String, double>> saldos = {};

      for (final entry in _resumen!.distribucionPorClub.entries) {
        saldos[entry.key] = {
          'ingresos': entry.value.ingresos,
          'egresos': entry.value.egresos,
          'balance': entry.value.balance,
        };
      }

      return saldos;
    }

    // Fallback a cálculo desde movimientos
    final Map<String, Map<String, double>> saldos = {};

    for (final movimiento in _movimientos) {
      final club = movimiento.club;
      if (!saldos.containsKey(club)) {
        saldos[club] = {'ingresos': 0.0, 'egresos': 0.0};
      }

      if (movimiento.tipo == 'Ingreso' &&
          movimiento.estadoDisplay == 'Confirmado') {
        saldos[club]!['ingresos'] =
            saldos[club]!['ingresos']! + movimiento.monto;
      } else if (movimiento.tipo == 'Egreso' &&
          movimiento.estadoDisplay == 'Confirmado') {
        saldos[club]!['egresos'] = saldos[club]!['egresos']! + movimiento.monto;
      }
    }

    return saldos;
  }

  /// Obtiene listas únicas para filtros
  List<String> _getUniqueClubs() {
    return _movimientos.map((m) => m.club).toSet().toList()..sort();
  }

  List<String> _getUniqueCategorias() {
    return _movimientos.map((m) => m.categoriaDisplay).toSet().toList()..sort();
  }

  /// Selecciona un movimiento específico
  MovimientoFinanciero? selectMovimiento(int idMovimiento) {
    try {
      return _movimientos.firstWhere((m) => m.idMovimiento == idMovimiento);
    } catch (e) {
      return null;
    }
  }

  /// Refresca los datos
  Future<void> refresh(String token) async {
    await loadMovimientos(token);
  }

  /// Obtiene el conteo de movimientos
  int getMovimientosCount() {
    if (_resumen != null) {
      return _resumen!.movimientos;
    }
    return _movimientos.length;
  }

  /// Obtiene el período del resumen
  String? getPeriodoResumen() {
    return _resumen?.periodoDisplay;
  }
}
