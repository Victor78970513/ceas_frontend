import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/ceas_colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/personal_provider.dart';
import '../models/empleado.dart';

class RegistrarAsistenciaBottomSheet extends StatefulWidget {
  final VoidCallback onAsistenciaRegistrada;

  const RegistrarAsistenciaBottomSheet({
    Key? key,
    required this.onAsistenciaRegistrada,
  }) : super(key: key);

  @override
  State<RegistrarAsistenciaBottomSheet> createState() => _RegistrarAsistenciaBottomSheetState();
}

class _RegistrarAsistenciaBottomSheetState extends State<RegistrarAsistenciaBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _horaIngresoController = TextEditingController();
  final _horaSalidaController = TextEditingController();
  final _observacionesController = TextEditingController();
  final _busquedaEmpleadoController = TextEditingController();
  
  Empleado? _empleadoSeleccionado;
  List<Empleado> _empleadosFiltrados = [];
  String _estadoSeleccionado = 'presente';
  DateTime _fechaSeleccionada = DateTime.now();
  bool _isLoading = false;
  bool _mostrarSugerencias = false;

  // Lista de estados de asistencia
  final List<String> _estados = ['presente', 'ausente', 'tardanza'];

  @override
  void initState() {
    super.initState();
    // Establecer horarios por defecto
    _horaIngresoController.text = '08:30';
    _horaSalidaController.text = '17:30';
    
    // Inicializar lista de empleados filtrados
    final personalProvider = Provider.of<PersonalProvider>(context, listen: false);
    _empleadosFiltrados = personalProvider.todosEmpleados;
    
    // Agregar listener para el buscador
    _busquedaEmpleadoController.addListener(_filtrarEmpleados);
  }

  @override
  void dispose() {
    _horaIngresoController.dispose();
    _horaSalidaController.dispose();
    _observacionesController.dispose();
    _busquedaEmpleadoController.dispose();
    super.dispose();
  }

  void _filtrarEmpleados() {
    final personalProvider = Provider.of<PersonalProvider>(context, listen: false);
    final query = _busquedaEmpleadoController.text.toLowerCase();
    
    if (query.isEmpty) {
      _empleadosFiltrados = personalProvider.todosEmpleados;
    } else {
      _empleadosFiltrados = personalProvider.todosEmpleados.where((empleado) {
        return empleado.nombreCompleto.toLowerCase().contains(query) ||
               empleado.idEmpleado.toString().contains(query) ||
               empleado.cargo.toLowerCase().contains(query) ||
               empleado.departamento.toLowerCase().contains(query);
      }).toList();
    }
    
    setState(() {
      _mostrarSugerencias = query.isNotEmpty && _empleadosFiltrados.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle del bottomsheet
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.access_time,
                    color: Colors.orange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Registrar Asistencia',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Registra la asistencia de un empleado',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          
          // Contenido del formulario
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Selección de Empleado con Buscador
                    const Text(
                      'Empleado',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _busquedaEmpleadoController,
                        decoration: InputDecoration(
                          labelText: 'Buscar Empleado',
                          hintText: 'Escriba el nombre, cargo o departamento',
                          prefixIcon: const Icon(Icons.search, color: Colors.orange),
                          suffixIcon: _empleadoSeleccionado != null
                              ? IconButton(
                                  icon: const Icon(Icons.clear, color: Colors.grey),
                                  onPressed: () {
                                    setState(() {
                                      _empleadoSeleccionado = null;
                                      _busquedaEmpleadoController.clear();
                                      _mostrarSugerencias = false;
                                    });
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        onTap: () {
                          if (_busquedaEmpleadoController.text.isNotEmpty) {
                            setState(() {
                              _mostrarSugerencias = true;
                            });
                          }
                        },
                        onChanged: (value) {
                          _filtrarEmpleados();
                        },
                        validator: (value) {
                          if (_empleadoSeleccionado == null) {
                            return 'Por favor seleccione un empleado';
                          }
                          return null;
                        },
                      ),
                    ),
                    
                    // Mostrar empleado seleccionado
                    if (_empleadoSeleccionado != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.orange.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.orange,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _empleadoSeleccionado!.nombreCompleto,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    'ID: ${_empleadoSeleccionado!.idEmpleado} | ${_empleadoSeleccionado!.cargo}',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    // Mostrar sugerencias
                    if (_mostrarSugerencias && _empleadosFiltrados.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _empleadosFiltrados.length,
                          itemBuilder: (context, index) {
                            final empleado = _empleadosFiltrados[index];
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _empleadoSeleccionado = empleado;
                                  _busquedaEmpleadoController.text = empleado.nombreCompleto;
                                  _mostrarSugerencias = false;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: index < _empleadosFiltrados.length - 1
                                      ? Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade200,
                                            width: 1,
                                          ),
                                        )
                                      : null,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Icon(
                                        Icons.person_outline,
                                        color: Colors.orange,
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            empleado.nombreCompleto,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            'ID: ${empleado.idEmpleado} | ${empleado.cargo} | ${empleado.departamento}',
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 20),
                    
                    // Fecha
                    const Text(
                      'Fecha',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _selectDate,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, color: Colors.grey),
                            const SizedBox(width: 12),
                            Text(
                              _formatDateDisplay(_fechaSeleccionada),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Hora de Ingreso
                    const Text(
                      'Hora de Ingreso',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _horaIngresoController,
                      decoration: InputDecoration(
                        hintText: '08:30',
                        prefixIcon: const Icon(Icons.access_time),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: CeasColors.primaryBlue),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9:]')),
                        LengthLimitingTextInputFormatter(5),
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor ingresa la hora de ingreso';
                        }
                        if (!RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$').hasMatch(value)) {
                          return 'Formato inválido (HH:MM)';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Hora de Salida
                    const Text(
                      'Hora de Salida',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _horaSalidaController,
                      decoration: InputDecoration(
                        hintText: '17:30',
                        prefixIcon: const Icon(Icons.access_time),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: CeasColors.primaryBlue),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9:]')),
                        LengthLimitingTextInputFormatter(5),
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor ingresa la hora de salida';
                        }
                        if (!RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$').hasMatch(value)) {
                          return 'Formato inválido (HH:MM)';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Estado
                    const Text(
                      'Estado de Asistencia',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: _estados.map((estado) {
                        final isSelected = _estadoSeleccionado == estado;
                        Color color;
                        switch (estado) {
                          case 'presente':
                            color = Colors.green;
                            break;
                          case 'tardanza':
                            color = Colors.orange;
                            break;
                          case 'ausente':
                            color = Colors.red;
                            break;
                          default:
                            color = Colors.grey;
                        }
                        
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _estadoSeleccionado = estado;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? color.withOpacity(0.1) : Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected ? color : Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                estado.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? color : Colors.grey.shade700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Observaciones
                    const Text(
                      'Observaciones',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _observacionesController,
                      decoration: InputDecoration(
                        hintText: 'Ej: Entrada puntual, salida normal',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: CeasColors.primaryBlue),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor ingresa observaciones';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Botones
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            child: Text(
                              'Cancelar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _registrarAsistencia,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Registrar Asistencia',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatDateDisplay(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _fechaSeleccionada) {
      setState(() {
        _fechaSeleccionada = picked;
      });
    }
  }

  Future<void> _registrarAsistencia() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_empleadoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona un empleado'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final personalProvider = Provider.of<PersonalProvider>(context, listen: false);

      if (authProvider.user == null) {
        throw Exception('Usuario no autenticado');
      }

      final fecha = _formatDate(_fechaSeleccionada);
      final horaIngreso = '${_horaIngresoController.text}:00';
      final horaSalida = '${_horaSalidaController.text}:00';

      final success = await personalProvider.registrarAsistencia(
        authProvider.user!.accessToken,
        _empleadoSeleccionado!.idEmpleado,
        fecha,
        horaIngreso,
        horaSalida,
        _observacionesController.text.trim(),
        _estadoSeleccionado,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text('Asistencia de ${_empleadoSeleccionado!.nombreCompleto} registrada exitosamente'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
        
        widget.onAsistenciaRegistrada();
      } else if (mounted) {
        throw Exception('Error al registrar la asistencia');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Error: ${e.toString()}')),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
