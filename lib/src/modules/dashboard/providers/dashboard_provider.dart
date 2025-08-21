import 'package:flutter/foundation.dart';
import '../models/dashboard_administrativo.dart';
import '../services/dashboard_service.dart';

class DashboardProvider extends ChangeNotifier {
  DashboardAdministrativo? _dashboard;
  bool _isLoading = false;
  String? _error;
  DateTime _lastUpdated = DateTime.now();

  // Getters
  DashboardAdministrativo? get dashboard => _dashboard;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime get lastUpdated => _lastUpdated;
  bool get hasData => _dashboard != null;

  /// Carga el dashboard administrativo desde el backend
  Future<void> loadDashboard(String token) async {
    try {
      print('DashboardProvider - Iniciando carga del dashboard...');
      _isLoading = true;
      _error = null;
      notifyListeners();

      print(
          'DashboardProvider - Llamando a DashboardService.getDashboardAdministrativo...');
      final dashboard =
          await DashboardService.getDashboardAdministrativo(token);
      print('DashboardProvider - Dashboard recibido exitosamente');

      _dashboard = dashboard;
      _lastUpdated = DateTime.now();
      _error = null;
    } catch (e) {
      print('DashboardProvider - ERROR: $e');
      _error = e.toString();
      _dashboard = null;
    } finally {
      _isLoading = false;
      notifyListeners();
      print(
          'DashboardProvider - Carga completada, isLoading: $_isLoading, error: $_error');
    }
  }

  /// Refresca los datos del dashboard
  Future<void> refresh(String token) async {
    await loadDashboard(token);
  }

  /// Limpia el estado del dashboard
  void clear() {
    _dashboard = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Obtiene métricas financieras resumidas
  Map<String, dynamic> getMetricasFinancierasResumen() {
    if (_dashboard == null) return {};

    return {
      'ingresos': _dashboard!.metricasFinancieras.ingresosFormatted,
      'egresos': _dashboard!.metricasFinancieras.egresosFormatted,
      'balance': _dashboard!.metricasFinancieras.balanceFormatted,
      'margen': _dashboard!.metricasFinancieras.margenFormatted,
      'flujo_caja': _dashboard!.metricasFinancieras.flujoCajaFormatted,
      'proyeccion': _dashboard!.metricasFinancieras.proyeccionFormatted,
    };
  }

  /// Obtiene métricas administrativas resumidas
  Map<String, dynamic> getMetricasAdministrativasResumen() {
    if (_dashboard == null) return {};

    return {
      'total_socios': _dashboard!.metricasAdministrativas.totalSocios,
      'socios_activos': _dashboard!.metricasAdministrativas.sociosActivos,
      'socios_inactivos': _dashboard!.metricasAdministrativas.sociosInactivos,
      'tasa_retencion':
          _dashboard!.metricasAdministrativas.tasaRetencionFormatted,
      'crecimiento': _dashboard!.metricasAdministrativas.crecimientoFormatted,
      'eficiencia': _dashboard!.metricasAdministrativas.eficienciaFormatted,
    };
  }

  /// Obtiene el top de clubes
  List<TopClub> getTopClubes() {
    return _dashboard?.topClubes ?? [];
  }

  /// Obtiene el top de socios
  List<TopSocio> getTopSocios() {
    return _dashboard?.topSocios ?? [];
  }

  /// Obtiene la distribución de ingresos
  List<DistribucionIngreso> getDistribucionIngresos() {
    return _dashboard?.distribucionIngresos ?? [];
  }

  /// Obtiene la distribución de egresos
  List<DistribucionEgreso> getDistribucionEgresos() {
    return _dashboard?.distribucionEgresos ?? [];
  }

  /// Obtiene los KPIs principales
  List<KpiPrincipal> getKpisPrincipales() {
    return _dashboard?.kpisPrincipales ?? [];
  }

  /// Obtiene las tendencias mensuales
  Map<String, TendenciaMensual> getTendenciasMensuales() {
    return _dashboard?.tendenciasMensuales ?? {};
  }

  /// Obtiene las alertas críticas
  List<String> getAlertasCriticas() {
    return _dashboard?.alertasCriticas ?? [];
  }

  /// Obtiene el período del dashboard
  String getPeriodo() {
    return _dashboard?.periodo ?? 'N/A';
  }
}

