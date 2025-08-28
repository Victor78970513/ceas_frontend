import 'package:flutter/foundation.dart';
import '../models/asistencia.dart';
import '../services/asistencia_service.dart';

class AsistenciaProvider extends ChangeNotifier {
  List<Asistencia> _asistencia = [];
  List<Asistencia> _filteredAsistencia = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String _filterEstado = 'Todos';
  String _filterFecha = 'Todas';

  // Getters
  List<Asistencia> get asistencia => _asistencia;
  List<Asistencia> get filteredAsistencia => _filteredAsistencia;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String get filterEstado => _filterEstado;
  String get filterFecha => _filterFecha;

  // Listas para filtros
  List<String> get estados => ['Todos', 'Presente', 'Retraso', 'Faltando'];
  List<String> get fechas => ['Todas', ..._getUniqueFechas()];

  /// Carga la asistencia desde el backend
  Future<void> loadAsistencia(String token) async {
    try {
      print('AsistenciaProvider - Iniciando carga de asistencia...');
      _isLoading = true;
      _error = null;
      notifyListeners();

      print(
          'AsistenciaProvider - Llamando a AsistenciaService.getAsistencia...');
      final asistencia = await AsistenciaService.getAsistencia(token);
      print('AsistenciaProvider - Asistencia recibida: ${asistencia.length}');

      _asistencia = asistencia;
      _applyFilters();
      print(
          'AsistenciaProvider - Filtros aplicados, filteredAsistencia: ${_filteredAsistencia.length}');

      _error = null;
    } catch (e) {
      print('AsistenciaProvider - ERROR: $e');
      _error = e.toString();
      _asistencia = [];
      _filteredAsistencia = [];
    } finally {
      _isLoading = false;
      notifyListeners();
      print(
          'AsistenciaProvider - Carga completada, isLoading: $_isLoading, error: $_error');
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

  /// Actualiza el filtro de fecha
  void updateFilterFecha(String? fecha) {
    if (fecha != null) {
      _filterFecha = fecha;
      _applyFilters();
      notifyListeners();
    }
  }

  /// Limpia todos los filtros
  void clearFilters() {
    _searchQuery = '';
    _filterEstado = 'Todos';
    _filterFecha = 'Todas';
    _applyFilters();
    notifyListeners();
  }

  /// Aplica todos los filtros activos
  void _applyFilters() {
    _filteredAsistencia = _asistencia.where((a) {
      final matchesSearch = _searchQuery.isEmpty ||
          a.nombreEmpleado.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          a.estado.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesEstado =
          _filterEstado == 'Todos' || a.estado == _filterEstado;
      final matchesFecha =
          _filterFecha == 'Todas' || a.fechaDisplay == _filterFecha;

      return matchesSearch && matchesEstado && matchesFecha;
    }).toList();
  }

  /// Obtiene estadísticas de asistencia
  Map<String, int> getEstadisticas() {
    final total = _asistencia.length;
    final presentes = _asistencia.where((a) => a.estado == 'Presente').length;
    final retrasos = _asistencia.where((a) => a.estado == 'Retraso').length;
    final faltando = _asistencia.where((a) => a.estado == 'Faltando').length;

    return {
      'total': total,
      'presentes': presentes,
      'retrasos': retrasos,
      'faltando': faltando,
    };
  }

  /// Obtiene listas únicas para filtros
  List<String> _getUniqueFechas() {
    return _asistencia.map((a) => a.fechaDisplay).toSet().toList()..sort();
  }

  /// Selecciona una asistencia específica
  Asistencia? selectAsistencia(int idAsistencia) {
    try {
      return _asistencia.firstWhere((a) => a.idAsistencia == idAsistencia);
    } catch (e) {
      return null;
    }
  }

  /// Refresca los datos
  Future<void> refresh(String token) async {
    await loadAsistencia(token);
  }
}


