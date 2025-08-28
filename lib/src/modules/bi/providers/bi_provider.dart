import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/bi_metricas_financieras.dart';
import '../models/bi_metricas_administrativas.dart';
import '../models/bi_top_club.dart';
// Modelos eliminados - comentados temporalmente
import '../models/bi_top_socio.dart';
import '../models/bi_distribucion_financiera.dart';
import '../models/bi_kpi.dart';
import '../models/bi_resumen_rapido.dart';
import '../models/bi_movimientos_financieros.dart';
import '../models/bi_personal_metricas_generales.dart';
import '../models/bi_personal_metricas_asistencia.dart';
import '../models/bi_personal_asistencia_departamento.dart';
import '../models/bi_personal_tendencias_mensuales.dart';
import '../services/bi_service.dart';
import '../services/bi_personal_service.dart';

class BiProvider extends ChangeNotifier {
  // Estado de los datos
  BiMetricasFinancieras? _metricasFinancieras;
  BiMetricasAdministrativas? _metricasAdministrativas;
  List<BiTopClub> _topClubes = [];
  List<BiTopSocio> _topSocios = [];
  BiDistribucionFinanciera? _distribucionFinanciera;
  List<BiKpi> _kpis = [];
  List<String> _alertas = [];
  BiResumenRapido? _resumenRapido;
  BiMovimientosFinancieros? _movimientosFinancieros;

  // Datos de personal
  BiPersonalMetricasGenerales? _personalMetricasGenerales;
  BiPersonalMetricasAsistencia? _personalMetricasAsistencia;
  List<BiPersonalAsistenciaDepartamento> _personalAsistenciaDepartamento = [];
  BiPersonalTendenciasMensuales? _personalTendenciasMensuales;

  // Estado de carga
  bool _isLoading = false;
  String? _error;
  DateTime _lastUpdated = DateTime.now();

  // Getters
  BiMetricasFinancieras? get metricasFinancieras => _metricasFinancieras;
  BiMetricasAdministrativas? get metricasAdministrativas =>
      _metricasAdministrativas;
  List<BiTopClub> get topClubes => _topClubes;
  List<BiTopSocio> get topSocios => _topSocios;
  BiDistribucionFinanciera? get distribucionFinanciera =>
      _distribucionFinanciera;
  List<BiKpi> get kpis => _kpis;
  List<String> get alertas => _alertas;
  BiResumenRapido? get resumenRapido => _resumenRapido;
  BiMovimientosFinancieros? get movimientosFinancieros =>
      _movimientosFinancieros;

  // Getters para personal
  BiPersonalMetricasGenerales? get personalMetricasGenerales =>
      _personalMetricasGenerales;
  BiPersonalMetricasAsistencia? get personalMetricasAsistencia =>
      _personalMetricasAsistencia;
  List<BiPersonalAsistenciaDepartamento> get personalAsistenciaDepartamento =>
      _personalAsistenciaDepartamento;
  BiPersonalTendenciasMensuales? get personalTendenciasMensuales =>
      _personalTendenciasMensuales;

  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime get lastUpdated => _lastUpdated;
  bool get hasData =>
      _metricasFinancieras != null && _metricasAdministrativas != null;

  // Cargar todos los datos de BI
  Future<void> loadAllData(String token) async {
    _setLoading(true);
    _clearError();

    try {
      // Cargar todos los datos en paralelo
      final results = await Future.wait([
        BiService.getMetricasFinancieras(token),
        BiService.getMetricasAdministrativas(token),
        BiService.getTopClubes(token),
        BiService.getTopSocios(token),
        BiService.getDistribucionFinanciera(token),
        BiService.getKpis(token),
        BiService.getAlertas(token),
        BiService.getResumenRapido(token),
        BiService.getMovimientosFinancieros(token),
        // Datos de personal
        BiPersonalService.getMetricasGenerales(token),
        BiPersonalService.getMetricasAsistencia(token),
        BiPersonalService.getAsistenciaDepartamento(token),
        BiPersonalService.getTendenciasMensuales(token, DateTime.now().year),
      ]);

      // Asignar resultados
      _metricasFinancieras = results[0] as BiMetricasFinancieras;
      _metricasAdministrativas = results[1] as BiMetricasAdministrativas;
      _topClubes = results[2] as List<BiTopClub>;
      _topSocios = results[3] as List<BiTopSocio>;
      _distribucionFinanciera = results[4] as BiDistribucionFinanciera;
      _kpis = results[5] as List<BiKpi>;
      _alertas = results[6] as List<String>;
      _resumenRapido = results[7] as BiResumenRapido;
      _movimientosFinancieros = results[8] as BiMovimientosFinancieros;

      // Asignar resultados de personal
      _personalMetricasGenerales = results[9] as BiPersonalMetricasGenerales;
      _personalMetricasAsistencia = results[10] as BiPersonalMetricasAsistencia;
      _personalAsistenciaDepartamento =
          results[11] as List<BiPersonalAsistenciaDepartamento>;
      _personalTendenciasMensuales =
          results[12] as BiPersonalTendenciasMensuales;

      _lastUpdated = DateTime.now();
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Error al cargar datos de BI: $e');
      _setLoading(false);
    }
  }

  // Cargar métricas financieras
  Future<void> loadMetricasFinancieras(String token) async {
    try {
      _metricasFinancieras = await BiService.getMetricasFinancieras(token);
      notifyListeners();
    } catch (e) {
      _setError('Error al cargar métricas financieras: $e');
    }
  }

  // Cargar métricas administrativas
  Future<void> loadMetricasAdministrativas(String token) async {
    try {
      _metricasAdministrativas =
          await BiService.getMetricasAdministrativas(token);
      notifyListeners();
    } catch (e) {
      _setError('Error al cargar métricas administrativas: $e');
    }
  }

  // Cargar top clubes
  Future<void> loadTopClubes(String token) async {
    try {
      _topClubes = await BiService.getTopClubes(token);
      notifyListeners();
    } catch (e) {
      _setError('Error al cargar top clubes: $e');
    }
  }

  // Cargar top socios
  Future<void> loadTopSocios(String token) async {
    try {
      _topSocios = await BiService.getTopSocios(token);
      notifyListeners();
    } catch (e) {
      _setError('Error al cargar top socios: $e');
    }
  }

  // Cargar distribución financiera
  Future<void> loadDistribucionFinanciera(String token) async {
    try {
      _distribucionFinanciera =
          await BiService.getDistribucionFinanciera(token);
      notifyListeners();
    } catch (e) {
      _setError('Error al cargar distribución financiera: $e');
    }
  }

  // Cargar KPIs
  Future<void> loadKpis(String token) async {
    try {
      _kpis = await BiService.getKpis(token);
      notifyListeners();
    } catch (e) {
      _setError('Error al cargar KPIs: $e');
    }
  }

  // Cargar alertas
  Future<void> loadAlertas(String token) async {
    try {
      _alertas = await BiService.getAlertas(token);
      notifyListeners();
    } catch (e) {
      _setError('Error al cargar alertas: $e');
    }
  }

  // Cargar resumen rápido
  Future<void> loadResumenRapido(String token) async {
    try {
      _resumenRapido = await BiService.getResumenRapido(token);
      notifyListeners();
    } catch (e) {
      _setError('Error al cargar resumen rápido: $e');
    }
  }

  // Cargar movimientos financieros
  Future<void> loadMovimientosFinancieros(String token) async {
    try {
      _movimientosFinancieros =
          await BiService.getMovimientosFinancieros(token);
      notifyListeners();
    } catch (e) {
      _setError('Error al cargar movimientos financieros: $e');
    }
  }

  // Refrescar todos los datos
  Future<void> refresh(String token) async {
    await loadAllData(token);
  }

  // Limpiar datos
  void clear() {
    _metricasFinancieras = null;
    _metricasAdministrativas = null;
    _topClubes = [];
    _topSocios = [];
    _distribucionFinanciera = null;
    _kpis = [];
    _alertas = [];
    _resumenRapido = null;
    _movimientosFinancieros = null;

    // Limpiar datos de personal
    _personalMetricasGenerales = null;
    _personalMetricasAsistencia = null;
    _personalAsistenciaDepartamento = [];
    _personalTendenciasMensuales = null;

    _error = null;
    _lastUpdated = DateTime.now();
    notifyListeners();
  }

  // Métodos privados
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

  // Getters para datos específicos
  String get periodoActual => _resumenRapido?.periodoActual ?? 'N/A';
  String get estadoGeneral => _resumenRapido?.estadoGeneralDisplay ?? 'N/A';
  Color get estadoGeneralColor =>
      _resumenRapido?.estadoGeneralColor ?? Colors.grey;
}
