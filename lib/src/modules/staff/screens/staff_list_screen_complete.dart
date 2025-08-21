import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/ceas_colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/personal_provider.dart';
import '../providers/asistencia_provider.dart';
import '../models/asistencia.dart';
import '../models/empleado.dart';

class StaffListScreenComplete extends StatefulWidget {
  const StaffListScreenComplete({Key? key}) : super(key: key);

  @override
  State<StaffListScreenComplete> createState() =>
      _StaffListScreenCompleteState();
}

class _StaffListScreenCompleteState extends State<StaffListScreenComplete> {
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
        Provider.of<PersonalProvider>(context, listen: false).loadPersonal();
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
    return Row(
      children: [
        _buildStatCard('Total Empleados', '${personalProvider.personal.length}',
            Icons.people, CeasColors.primaryBlue),
        const SizedBox(width: 16),
        _buildStatCard(
          'Activos',
          '${personalProvider.personal.where((e) => e.estado == 'ACTIVO').length}',
          Icons.check_circle,
          Colors.green,
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          'Presentes Hoy',
          '${asistenciaProvider.asistencia.where((a) => a.estado == 'Presente').length}',
          Icons.today,
          Colors.orange,
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          'Retrasos Hoy',
          '${asistenciaProvider.asistencia.where((a) => a.estado == 'Retraso').length}',
          Icons.schedule,
          Colors.red,
        ),
      ],
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
                  const Text(
                    'Lista de Empleados',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: CeasColors.primaryBlue,
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
                    Expanded(flex: 2, child: _buildHeaderCell('ID')),
                    Expanded(flex: 4, child: _buildHeaderCell('Empleado')),
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
                            flex: 2,
                            child: _buildCell(empleado.idEmpleado.toString())),
                        Expanded(
                            flex: 4,
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
                            child: _buildMoneyCell(empleado.salarioFormatted)),
                        Expanded(
                            flex: 2,
                            child: Center(
                                child: _buildEstadoCell(empleado.estadoDisplay,
                                    empleado.estadoColor))),
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
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: CeasColors.primaryBlue.withOpacity(0.1),
          child: Text(
            nombreCompleto
                .split(' ')
                .map((n) => n.isNotEmpty ? n[0] : '')
                .join(''),
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Mostrando ${((currentPage - 1) * itemsPerPage) + 1}-${(currentPage * itemsPerPage).clamp(0, totalItems)} de $totalItems registros',
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left_rounded),
              onPressed:
                  currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
            ),
            for (int i = 1; i <= totalPages && i <= 5; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: TextButton(
                  onPressed: () => onPageChanged(i),
                  style: TextButton.styleFrom(
                    backgroundColor: currentPage == i
                        ? CeasColors.primaryBlue
                        : Colors.transparent,
                    foregroundColor: currentPage == i
                        ? Colors.white
                        : CeasColors.primaryBlue,
                  ),
                  child: Text('$i'),
                ),
              ),
            IconButton(
              icon: const Icon(Icons.chevron_right_rounded),
              onPressed: currentPage < totalPages
                  ? () => onPageChanged(currentPage + 1)
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}
