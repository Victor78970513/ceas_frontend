import 'package:flutter/material.dart';
import '../models/empleado.dart';
import '../models/personal.dart';
import '../services/personal_service.dart';

class PersonalProvider extends ChangeNotifier {
  List<Empleado> _empleados = [];
  List<Empleado> _empleadosFiltrados = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  // Getters
  List<Empleado> get empleados => _empleadosFiltrados;
  List<Empleado> get personal =>
      _empleadosFiltrados; // Alias para compatibilidad
  List<Empleado> get todosEmpleados => _empleados;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  // Cargar empleados desde /empleados/
  Future<void> loadEmpleados() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _empleados =
          await PersonalService.getEmpleados(''); // Token vacío por ahora
      _aplicarFiltros();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Cargar personal desde /personal/
  Future<void> loadPersonal([String? token]) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      print('PersonalProvider - Iniciando carga de personal...');
      print('PersonalProvider - Token: ${token != null ? token.substring(0, 20) + "..." : "VACÍO"}');
      
      try {
        // El endpoint /personal/ retorna datos con estructura de Empleado, no Personal
        final empleados = await PersonalService.getEmpleados(token ?? '');
        print('PersonalProvider - Empleados recibidos del backend: ${empleados.length} registros');
        
        _empleados = empleados;
        print('PersonalProvider - Empleados asignados directamente: ${_empleados.length}');
      } catch (e) {
        print('PersonalProvider - Error al cargar del backend: $e');
        print('PersonalProvider - Usando datos de prueba como fallback');
        
        // DATOS DE PRUEBA COMO FALLBACK
        _empleados = [
          Empleado(
            idEmpleado: 1,
            nombreCompleto: 'Juan Pérez García',
            cargo: 'Desarrollador Senior',
            departamento: 'Tecnología',
            estado: 'ACTIVO',
            email: 'juan.perez@empresa.com',
            telefono: '+591 77777777',
            fechaContratacion: DateTime.now(),
            salario: 15000.00,
            foto: null,
          ),
          Empleado(
            idEmpleado: 2,
            nombreCompleto: 'María López Silva',
            cargo: 'Gerente de Ventas',
            departamento: 'Ventas',
            estado: 'ACTIVO',
            email: 'maria.lopez@empresa.com',
            telefono: '+591 88888888',
            fechaContratacion: DateTime.now(),
            salario: 18000.00,
            foto: null,
          ),
        ];
        print('PersonalProvider - Empleados de prueba creados: ${_empleados.length}');
      }
      
      _aplicarFiltros();
      print('PersonalProvider - Empleados filtrados: ${_empleadosFiltrados.length}');

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      print('PersonalProvider - ERROR GENERAL: $e');
      notifyListeners();
    }
  }

  // Crear empleado
  Future<bool> createEmpleado(Empleado empleado) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final nuevoEmpleado = await PersonalService.createEmpleado(empleado);
      _empleados.add(nuevoEmpleado);
      _aplicarFiltros();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Actualizar empleado
  Future<bool> updateEmpleado(Empleado empleado) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final empleadoActualizado =
          await PersonalService.updateEmpleado(empleado);
      final index =
          _empleados.indexWhere((e) => e.idEmpleado == empleado.idEmpleado);

      if (index != -1) {
        _empleados[index] = empleadoActualizado;
        _aplicarFiltros();
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Eliminar empleado
  Future<bool> deleteEmpleado(int idEmpleado) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await PersonalService.deleteEmpleado(idEmpleado);
      _empleados.removeWhere((e) => e.idEmpleado == idEmpleado);
      _aplicarFiltros();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Buscar empleados
  void searchEmpleados(String query) {
    _searchQuery = query;
    _aplicarFiltros();
    notifyListeners();
  }

  // Aplicar filtros
  void _aplicarFiltros() {
    if (_searchQuery.isEmpty) {
      _empleadosFiltrados = List.from(_empleados);
    } else {
      _empleadosFiltrados = _empleados.where((empleado) {
        return empleado.nombreCompleto
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            empleado.cargo.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            empleado.departamento
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
      }).toList();
    }
  }

  // Limpiar error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Obtener empleado por ID
  Empleado? getEmpleadoById(int idEmpleado) {
    try {
      return _empleados.firstWhere((e) => e.idEmpleado == idEmpleado);
    } catch (e) {
      return null;
    }
  }

  // Obtener empleados por departamento
  List<Empleado> getEmpleadosPorDepartamento(String departamento) {
    return _empleados.where((e) => e.departamento == departamento).toList();
  }

  // Obtener empleados activos
  List<Empleado> get empleadosActivos {
    return _empleados.where((e) => e.estado == 'ACTIVO').toList();
  }

  // Obtener empleados inactivos
  List<Empleado> get empleadosInactivos {
    return _empleados.where((e) => e.estado == 'INACTIVO').toList();
  }
}
