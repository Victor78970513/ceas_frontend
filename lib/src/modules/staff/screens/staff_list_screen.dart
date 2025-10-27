import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html;
import '../../../core/theme/ceas_colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/personal_provider.dart';
import '../providers/asistencia_provider.dart';
import '../services/personal_service.dart';
import '../models/asistencia.dart';
import '../models/empleado.dart';
import '../widgets/agregar_empleado_bottom_sheet.dart';
import '../widgets/registrar_asistencia_bottom_sheet.dart';
import '../widgets/empleado_card.dart';
import '../widgets/asistencia_card.dart';

class StaffListScreen extends StatefulWidget {
  const StaffListScreen({Key? key}) : super(key: key);

  @override
  State<StaffListScreen> createState() => _StaffListScreenState();
}

class _StaffListScreenState extends State<StaffListScreen> {
  // Variables de paginación
  int currentPage = 1;
  int itemsPerPage = 5;
  int currentPageAsistencia = 1;
  int itemsPerPageAsistencia = 5;

  @override
  void initState() {
    super.initState();
    // Cargar datos al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated) {
        Provider.of<PersonalProvider>(context, listen: false).loadPersonal(
          authProvider.user!.accessToken,
        );
        Provider.of<AsistenciaProvider>(context, listen: false).loadAsistencia(
          authProvider.user!.accessToken,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth <= 768;

          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header principal
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isMobile ? 16 : 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        CeasColors.primaryBlue,
                        CeasColors.primaryBlue.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: CeasColors.primaryBlue.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.people_alt_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Recursos Humanos',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Gestión de empleados y control de asistencia',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Consumer<PersonalProvider>(
                  builder: (context, personalProvider, child) {
                    return Consumer<AsistenciaProvider>(
                      builder: (context, asistenciaProvider, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStatsRow(
                                personalProvider, asistenciaProvider),
                            const SizedBox(height: 24),
                            _buildQuickActionsRow(),
                            const SizedBox(height: 24),
                            _buildEmpleadosSection(personalProvider),
                            const SizedBox(height: 24),
                            _buildAsistenciaSection(asistenciaProvider),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsRow(PersonalProvider personalProvider,
      AsistenciaProvider asistenciaProvider) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth <= 768;

        if (isMobile) {
          // En mobile, mostrar 2 columnas
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              SizedBox(
                width: (constraints.maxWidth - 8) / 2,
                child: _buildStatCard('Total Empleados', '${personalProvider.personal.length}',
                    Icons.people, CeasColors.primaryBlue),
              ),
              SizedBox(
                width: (constraints.maxWidth - 8) / 2,
                child: _buildStatCard(
                  'Activos',
                  '${personalProvider.personal.where((e) => e.estado == 'ACTIVO').length}',
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
              SizedBox(
                width: (constraints.maxWidth - 8) / 2,
                child: _buildStatCard(
                  'Presentes Hoy',
                  '${asistenciaProvider.asistencia.where((a) => a.estado == 'Presente').length}',
                  Icons.today,
                  Colors.orange,
                ),
              ),
              SizedBox(
                width: (constraints.maxWidth - 8) / 2,
                child: _buildStatCard(
                  'Retrasos Hoy',
                  '${asistenciaProvider.asistencia.where((a) => a.estado == 'Retraso').length}',
                  Icons.schedule,
                  Colors.red,
                ),
              ),
            ],
          );
        }

        // En desktop, mostrar 4 columnas
        return Row(
          children: [
            Expanded(
              child: _buildStatCard('Total Empleados', '${personalProvider.personal.length}',
                  Icons.people, CeasColors.primaryBlue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Activos',
                '${personalProvider.personal.where((e) => e.estado == 'ACTIVO').length}',
                Icons.check_circle,
                Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Presentes Hoy',
                '${asistenciaProvider.asistencia.where((a) => a.estado == 'Presente').length}',
                Icons.today,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Retrasos Hoy',
                '${asistenciaProvider.asistencia.where((a) => a.estado == 'Retraso').length}',
                Icons.schedule,
                Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpleadosSection(PersonalProvider personalProvider) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: CeasColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.people_alt_rounded,
                      color: CeasColors.primaryBlue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Lista de Empleados',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: CeasColors.primaryBlue,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showAgregarEmpleadoDialog(context),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Agregar Empleado'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CeasColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (personalProvider.isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else
              _buildEmpleadosTable(personalProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpleadosTable(PersonalProvider personalProvider) {
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex =
        (startIndex + itemsPerPage).clamp(0, personalProvider.personal.length);
    final paginatedEmpleados =
        personalProvider.personal.sublist(startIndex, endIndex);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth <= 768;

        if (isMobile) {
          // En mobile, mostrar tarjetas
          if (paginatedEmpleados.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('No hay empleados para mostrar'),
              ),
            );
          }

          return Column(
            children: [
              Column(
                children: paginatedEmpleados
                    .map((empleado) => EmpleadoCard(empleado: empleado))
                    .toList(),
              ),
              const SizedBox(height: 16),
              _buildPagination(
                  personalProvider.personal.length, currentPage, itemsPerPage,
                  (page) {
                setState(() => currentPage = page);
              }),
            ],
          );
        }

        // En desktop, mostrar tabla
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: CeasColors.primaryBlue.withOpacity(0.05),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(flex: 5, child: _buildHeaderCell('Empleado')),
                        Expanded(flex: 3, child: _buildHeaderCell('Cargo')),
                        Expanded(flex: 3, child: _buildHeaderCell('Departamento')),
                        Expanded(flex: 2, child: _buildHeaderCell('F. Ingreso')),
                        Expanded(flex: 2, child: _buildHeaderCell('Salario')),
                        Expanded(
                            flex: 2,
                            child: Center(child: _buildHeaderCell('Estado'))),
                        Expanded(flex: 2, child: _buildHeaderCell('Acciones')),
                      ],
                    ),
                  ),
                  ...paginatedEmpleados.asMap().entries.map((entry) {
                    final index = entry.key;
                    final empleado = entry.value;
                    return Container(
                      decoration: BoxDecoration(
                        color: index.isEven ? Colors.grey[50] : Colors.white,
                        border: Border(
                            bottom:
                                BorderSide(color: Colors.grey[100]!, width: 0.5)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 5,
                                child: _buildEmpleadoCell(empleado.nombreCompleto)),
                            Expanded(flex: 3, child: _buildCell(empleado.cargo)),
                            Expanded(
                                flex: 3, child: _buildCell(empleado.departamento)),
                            Expanded(
                                flex: 2,
                                child:
                                    _buildCell(empleado.fechaContratacionDisplay)),
                            Expanded(
                                flex: 2,
                                child:
                                    _buildMoneyCell(empleado.salario.toString())),
                            Expanded(
                                flex: 2,
                                child: Center(
                                    child: _buildEstadoCell(empleado.estado,
                                        _getEstadoColor(empleado.estado)))),
                            Expanded(flex: 2, child: _buildOpcionesCell(empleado)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildPagination(
                personalProvider.personal.length, currentPage, itemsPerPage,
                (page) {
              setState(() => currentPage = page);
            }),
          ],
        );
      },
    );
  }

  Widget _buildAsistenciaSection(AsistenciaProvider asistenciaProvider) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.schedule_rounded,
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
                          'Control de Asistencia',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Registro diario de entrada y salida del personal',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showRegistrarAsistenciaDialog(context),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Registrar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      final authProvider =
                          Provider.of<AuthProvider>(context, listen: false);
                      if (authProvider.isAuthenticated) {
                        asistenciaProvider
                            .refresh(authProvider.user!.accessToken);
                      }
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    tooltip: 'Actualizar asistencia',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (asistenciaProvider.isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else
              _buildAsistenciaTable(asistenciaProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildAsistenciaTable(AsistenciaProvider asistenciaProvider) {
    final startIndex = (currentPageAsistencia - 1) * itemsPerPageAsistencia;
    final endIndex = (startIndex + itemsPerPageAsistencia)
        .clamp(0, asistenciaProvider.asistencia.length);
    final paginatedAsistencia =
        asistenciaProvider.asistencia.sublist(startIndex, endIndex);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth <= 768;

        if (isMobile) {
          // En mobile, mostrar tarjetas
          if (paginatedAsistencia.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.schedule_outlined,
                      size: 32,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'No hay registros de asistencia para mostrar',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              Column(
                children: paginatedAsistencia
                    .map((asistencia) => AsistenciaCard(asistencia: asistencia))
                    .toList(),
              ),
              const SizedBox(height: 16),
              _buildPagination(asistenciaProvider.asistencia.length,
                  currentPageAsistencia, itemsPerPageAsistencia, (page) {
                setState(() => currentPageAsistencia = page);
              }),
            ],
          );
        }

        // En desktop, mostrar tabla
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.05),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: _buildHeaderCell('Empleado')),
                        Expanded(flex: 1, child: _buildHeaderCell('Fecha')),
                        Expanded(flex: 1, child: _buildHeaderCell('Entrada')),
                        Expanded(flex: 1, child: _buildHeaderCell('Salida')),
                        Expanded(flex: 1, child: _buildHeaderCell('Horas')),
                        Expanded(
                            flex: 1,
                            child: Center(child: _buildHeaderCell('Estado'))),
                        Expanded(flex: 1, child: _buildHeaderCell('Acciones')),
                      ],
                    ),
                  ),
                  if (paginatedAsistencia.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      child: const Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.schedule_outlined,
                              size: 32,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'No hay registros de asistencia para mostrar',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...paginatedAsistencia.asMap().entries.map((entry) {
                      final index = entry.key;
                      final registro = entry.value;
                      return Container(
                        decoration: BoxDecoration(
                          color: index.isEven ? Colors.grey[50] : Colors.white,
                          border: Border(
                              bottom:
                                  BorderSide(color: Colors.grey[100]!, width: 0.5)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: _buildCell(registro.nombreEmpleado)),
                              Expanded(
                                  flex: 1,
                                  child: _buildCell(registro.fechaDisplay)),
                              Expanded(
                                  flex: 1,
                                  child: _buildCell(registro.horaEntrada ?? 'N/A')),
                              Expanded(
                                  flex: 1,
                                  child: _buildCell(registro.horaSalida ?? 'N/A')),
                              Expanded(
                                  flex: 1,
                                  child: _buildCell(
                                      '${registro.horaEntrada ?? 'N/A'} - ${registro.horaSalida ?? 'N/A'}')),
                              Expanded(
                                  flex: 1,
                                  child: Center(
                                      child: _buildAsistenciaEstadoCell(
                                          registro.estado))),
                              Expanded(
                                  flex: 1,
                                  child: _buildAsistenciaOpcionesCell(registro)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildPagination(asistenciaProvider.asistencia.length,
                currentPageAsistencia, itemsPerPageAsistencia, (page) {
              setState(() => currentPageAsistencia = page);
            }),
          ],
        );
      },
    );
  }

  Widget _buildHeaderCell(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: CeasColors.primaryBlue,
        fontSize: 14,
      ),
    );
  }

  Widget _buildCell(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildMoneyCell(String amount) {
    return Text(
      amount,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildEmpleadoCell(String nombreCompleto) {
    // Obtener las 2 primeras letras del nombre completo
    String iniciales = '';
    if (nombreCompleto.isNotEmpty) {
      String nombreLimpio = nombreCompleto.trim();
      if (nombreLimpio.length >= 2) {
        iniciales = nombreLimpio.substring(0, 2).toUpperCase();
      } else {
        iniciales = nombreLimpio.toUpperCase();
      }
    }
    
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: CeasColors.primaryBlue.withOpacity(0.1),
          child: Text(
            iniciales,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: CeasColors.primaryBlue,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nombreCompleto,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Empleado',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEstadoCell(String estado, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        estado,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildAsistenciaEstadoCell(String estado) {
    Color color;
    switch (estado.toLowerCase()) {
      case 'presente':
        color = Colors.green;
        break;
      case 'retraso':
        color = Colors.orange;
        break;
      case 'faltando':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        estado,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildOpcionesCell(Empleado empleado) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value) {
          case 'ver':
            // _showEmployeeDetails(empleado);
            break;
          case 'editar':
            // _showEditEmployeeDialog(empleado);
            break;
          case 'asistencia':
            // _showAttendanceHistoryDialog(empleado);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'ver',
          child: Row(
            children: [
              Icon(Icons.visibility, size: 16),
              SizedBox(width: 8),
              Text('Ver detalles'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'editar',
          child: Row(
            children: [
              Icon(Icons.edit, size: 16),
              SizedBox(width: 8),
              Text('Editar'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'asistencia',
          child: Row(
            children: [
              Icon(Icons.history, size: 16),
              SizedBox(width: 8),
              Text('Historial'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAsistenciaOpcionesCell(Asistencia registro) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value) {
          case 'editar':
            // _showEditAttendanceDialog(registro);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'editar',
          child: Row(
            children: [
              Icon(Icons.edit, size: 16),
              SizedBox(width: 8),
              Text('Editar asistencia'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPagination(int totalItems, int currentPage, int itemsPerPage,
      Function(int) onPageChanged) {
    final totalPages = (totalItems / itemsPerPage).ceil();
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage).clamp(0, totalItems);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Información de la página
          Text(
            'Mostrando ${endIndex - startIndex} de $totalItems registros',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          // Controles de navegación
          Row(
            children: [
              // Botón anterior
              IconButton(
                onPressed: currentPage > 1
                    ? () => onPageChanged(currentPage - 1)
                    : null,
                icon: const Icon(Icons.chevron_left),
                color: currentPage > 1
                    ? CeasColors.primaryBlue
                    : Colors.grey.shade400,
              ),

              // Número de página actual
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: CeasColors.primaryBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$currentPage',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),

              // Separador
              Text(
                ' de $totalPages',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // Botón siguiente
              IconButton(
                onPressed: currentPage < totalPages
                    ? () => onPageChanged(currentPage + 1)
                    : null,
                icon: const Icon(Icons.chevron_right),
                color: currentPage < totalPages
                    ? CeasColors.primaryBlue
                    : Colors.grey.shade400,
              ),
            ],
          ),

          // Selector de elementos por página
          Row(
            children: [
              Text(
                'Mostrar: ',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<int>(
                value: itemsPerPage,
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    // Actualizar itemsPerPage según la tabla
                    if (totalItems ==
                        Provider.of<PersonalProvider>(context, listen: false)
                            .personal
                            .length) {
                      setState(() {
                        this.itemsPerPage = newValue;
                        onPageChanged(1); // Reset a la primera página
                      });
                    } else {
                      setState(() {
                        itemsPerPageAsistencia = newValue;
                        onPageChanged(1); // Reset a la primera página
                      });
                    }
                  }
                },
                items: [5, 10, 20, 50].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value'),
                  );
                }).toList(),
                underline: Container(),
                style: TextStyle(
                  color: CeasColors.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showRegistrarAsistenciaDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RegistrarAsistenciaBottomSheet(
        onAsistenciaRegistrada: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showAgregarEmpleadoDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AgregarEmpleadoBottomSheet(
        onEmpleadoCreado: () {
          // El provider ya recarga automáticamente
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Color _getEstadoColor(String estado) {
    switch (estado.toUpperCase()) {
      case 'ACTIVO':
        return Colors.green;
      case 'INACTIVO':
        return Colors.red;
      case 'SUSPENDIDO':
        return Colors.orange;
      case 'VACACIONES':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildQuickActionsRow() {
    return Wrap(
      spacing: 16,
      children: [
        SizedBox(
          width: 250,
          child: _buildQuickAction(
            'Generar Reporte',
            Icons.assessment,
            Colors.purple,
            _descargarReportePersonal,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAction(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Descarga el reporte de personal en formato PDF
  Future<void> _descargarReportePersonal() async {
    try {
      // Mostrar diálogo de carga
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Generando reporte PDF...'),
            ],
          ),
        ),
      );

      // Obtener token de autenticación
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (!authProvider.isAuthenticated) {
        throw Exception('No autenticado');
      }

      final pdfBytes = await PersonalService.downloadReportePersonal(
        authProvider.user!.accessToken,
      );

      // Cerrar diálogo de carga
      if (mounted) Navigator.of(context).pop();

      if (pdfBytes.isEmpty) {
        throw Exception('El archivo PDF está vacío');
      }

      // Crear URL del blob para descarga en web
      final blob = html.Blob([pdfBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      
      // Crear un elemento de enlace temporal
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'reporte_personal_${DateTime.now().millisecondsSinceEpoch}.pdf')
        ..click();
      
      // Limpiar la URL del blob
      html.Url.revokeObjectUrl(url);

      if (mounted) {
        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Reporte descargado exitosamente',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Cerrar diálogo de carga si está abierto
      if (mounted) Navigator.of(context).pop();

      print('❌ Error descargando reporte: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Error al descargar reporte: $e',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }
}
