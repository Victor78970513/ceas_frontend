import 'package:flutter/material.dart';
import '../../../core/theme/ceas_colors.dart';
import '../widgets/usuario_card.dart';

class UsersSecurityScreen extends StatefulWidget {
  const UsersSecurityScreen({Key? key}) : super(key: key);

  @override
  State<UsersSecurityScreen> createState() => _UsersSecurityScreenState();
}

class _UsersSecurityScreenState extends State<UsersSecurityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Variables de paginación para usuarios
  int currentPageUsuarios = 1;
  int itemsPerPageUsuarios = 5;

  // Variables de paginación para logs
  int currentPageLogs = 1;
  int itemsPerPageLogs = 5;

  // Filtros para usuarios
  String searchUsuarios = '';
  String filtroEstado = 'Todos';
  String filtroRol = 'Todos';

  // Filtros para logs
  String searchLogs = '';
  String filtroModulo = 'Todos';
  String filtroUsuario = 'Todos';

  final List<Map<String, dynamic>> usuarios = [
    {
      'id': 'USR001',
      'usuario': 'admin',
      'nombre': 'Administrador Principal',
      'email': 'admin@ceas.com',
      'rol': 'Administrador',
      'estado': 'Activo',
      'ultimoAcceso': '15/12/2024 14:30',
      'fechaCreacion': '01/01/2024',
      'intentosFallidos': 0,
    },
    {
      'id': 'USR002',
      'usuario': 'seving',
      'nombre': 'Seving Aslanova',
      'email': 'seving@ceas.com',
      'rol': 'Gerente',
      'estado': 'Activo',
      'ultimoAcceso': '15/12/2024 13:45',
      'fechaCreacion': '15/03/2024',
      'intentosFallidos': 0,
    },
    {
      'id': 'USR003',
      'usuario': 'carlos.gomez',
      'nombre': 'Carlos Gómez',
      'email': 'carlos.gomez@ceas.com',
      'rol': 'Encargado de Ventas',
      'estado': 'Activo',
      'ultimoAcceso': '15/12/2024 12:20',
      'fechaCreacion': '20/02/2024',
      'intentosFallidos': 0,
    },
    {
      'id': 'USR004',
      'usuario': 'ana.torres',
      'nombre': 'Ana Torres',
      'email': 'ana.torres@ceas.com',
      'rol': 'Contadora',
      'estado': 'Activo',
      'ultimoAcceso': '15/12/2024 11:15',
      'fechaCreacion': '25/01/2024',
      'intentosFallidos': 0,
    },
    {
      'id': 'USR005',
      'usuario': 'luis.mendoza',
      'nombre': 'Luis Mendoza',
      'email': 'luis.mendoza@ceas.com',
      'rol': 'Instructor',
      'estado': 'Activo',
      'ultimoAcceso': '15/12/2024 10:30',
      'fechaCreacion': '10/06/2024',
      'intentosFallidos': 0,
    },
    {
      'id': 'USR006',
      'usuario': 'maria.rodriguez',
      'nombre': 'María Rodríguez',
      'email': 'maria.rodriguez@ceas.com',
      'rol': 'Recepcionista',
      'estado': 'Inactivo',
      'ultimoAcceso': '10/12/2024 16:45',
      'fechaCreacion': '05/09/2024',
      'intentosFallidos': 3,
    },
    {
      'id': 'USR007',
      'usuario': 'roberto.silva',
      'nombre': 'Roberto Silva',
      'email': 'roberto.silva@ceas.com',
      'rol': 'Mantenimiento',
      'estado': 'Activo',
      'ultimoAcceso': '15/12/2024 09:15',
      'fechaCreacion': '18/11/2024',
      'intentosFallidos': 0,
    },
    {
      'id': 'USR008',
      'usuario': 'carmen.vega',
      'nombre': 'Carmen Vega',
      'email': 'carmen.vega@ceas.com',
      'rol': 'Instructora',
      'estado': 'Activo',
      'ultimoAcceso': '15/12/2024 08:45',
      'fechaCreacion': '12/04/2024',
      'intentosFallidos': 0,
    },
    {
      'id': 'USR009',
      'usuario': 'diego.morales',
      'nombre': 'Diego Morales',
      'email': 'diego.morales@ceas.com',
      'rol': 'Encargado de Ventas',
      'estado': 'Bloqueado',
      'ultimoAcceso': '05/12/2024 14:20',
      'fechaCreacion': '08/07/2024',
      'intentosFallidos': 5,
    },
    {
      'id': 'USR010',
      'usuario': 'patricia.lopez',
      'nombre': 'Patricia López',
      'email': 'patricia.lopez@ceas.com',
      'rol': 'Contadora',
      'estado': 'Activo',
      'ultimoAcceso': '15/12/2024 07:30',
      'fechaCreacion': '25/02/2024',
      'intentosFallidos': 0,
    },
  ];

  final List<Map<String, dynamic>> logsSistema = [
    {
      'id': 'LOG001',
      'usuario': 'admin',
      'accion': 'Inicio de sesión',
      'modulo': 'Autenticación',
      'fecha': '15/12/2024 14:30:25',
      'ip': '192.168.1.100',
      'estado': 'Exitoso',
      'detalles': 'Sesión iniciada correctamente',
    },
    {
      'id': 'LOG002',
      'usuario': 'seving',
      'accion': 'Crear socio',
      'modulo': 'Socios',
      'fecha': '15/12/2024 14:25:10',
      'ip': '192.168.1.101',
      'estado': 'Exitoso',
      'detalles': 'Socio Juan Pérez creado',
    },
    {
      'id': 'LOG003',
      'usuario': 'carlos.gomez',
      'accion': 'Actualizar venta',
      'modulo': 'Ventas',
      'fecha': '15/12/2024 14:20:45',
      'ip': '192.168.1.102',
      'estado': 'Exitoso',
      'detalles': 'Venta VEN-001 actualizada',
    },
    {
      'id': 'LOG004',
      'usuario': 'ana.torres',
      'accion': 'Generar reporte',
      'modulo': 'Finanzas',
      'fecha': '15/12/2024 14:15:30',
      'ip': '192.168.1.103',
      'estado': 'Exitoso',
      'detalles': 'Reporte mensual generado',
    },
    {
      'id': 'LOG005',
      'usuario': 'luis.mendoza',
      'accion': 'Registrar asistencia',
      'modulo': 'Recursos Humanos',
      'fecha': '15/12/2024 14:10:15',
      'ip': '192.168.1.104',
      'estado': 'Exitoso',
      'detalles': 'Asistencia registrada para 5 empleados',
    },
    {
      'id': 'LOG006',
      'usuario': 'maria.rodriguez',
      'accion': 'Inicio de sesión',
      'modulo': 'Autenticación',
      'fecha': '15/12/2024 14:05:20',
      'ip': '192.168.1.105',
      'estado': 'Fallido',
      'detalles': 'Contraseña incorrecta',
    },
    {
      'id': 'LOG007',
      'usuario': 'roberto.silva',
      'accion': 'Eliminar registro',
      'modulo': 'Mantenimiento',
      'fecha': '15/12/2024 14:00:35',
      'ip': '192.168.1.106',
      'estado': 'Exitoso',
      'detalles': 'Registro de mantenimiento eliminado',
    },
    {
      'id': 'LOG008',
      'usuario': 'carmen.vega',
      'accion': 'Exportar datos',
      'modulo': 'Socios',
      'fecha': '15/12/2024 13:55:40',
      'ip': '192.168.1.107',
      'estado': 'Exitoso',
      'detalles': 'Lista de socios exportada a Excel',
    },
    {
      'id': 'LOG009',
      'usuario': 'diego.morales',
      'accion': 'Inicio de sesión',
      'modulo': 'Autenticación',
      'fecha': '15/12/2024 13:50:10',
      'ip': '192.168.1.108',
      'estado': 'Fallido',
      'detalles': 'Usuario bloqueado por intentos fallidos',
    },
    {
      'id': 'LOG010',
      'usuario': 'patricia.lopez',
      'accion': 'Cambiar configuración',
      'modulo': 'Configuración',
      'fecha': '15/12/2024 13:45:25',
      'ip': '192.168.1.109',
      'estado': 'Exitoso',
      'detalles': 'Configuración de notificaciones actualizada',
    },
    {
      'id': 'LOG011',
      'usuario': 'admin',
      'accion': 'Crear usuario',
      'modulo': 'Usuarios',
      'fecha': '15/12/2024 13:40:15',
      'ip': '192.168.1.100',
      'estado': 'Exitoso',
      'detalles': 'Usuario sofia.jimenez creado',
    },
    {
      'id': 'LOG012',
      'usuario': 'seving',
      'accion': 'Reset contraseña',
      'modulo': 'Usuarios',
      'fecha': '15/12/2024 13:35:50',
      'ip': '192.168.1.101',
      'estado': 'Exitoso',
      'detalles': 'Contraseña reseteada para maria.rodriguez',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredUsuarios {
    return usuarios.where((usuario) {
      final matchesSearch = searchUsuarios.isEmpty ||
          usuario['usuario']
              .toLowerCase()
              .contains(searchUsuarios.toLowerCase()) ||
          usuario['nombre']
              .toLowerCase()
              .contains(searchUsuarios.toLowerCase()) ||
          usuario['email'].toLowerCase().contains(searchUsuarios.toLowerCase());
      final matchesEstado =
          filtroEstado == 'Todos' || usuario['estado'] == filtroEstado;
      final matchesRol = filtroRol == 'Todos' || usuario['rol'] == filtroRol;
      return matchesSearch && matchesEstado && matchesRol;
    }).toList();
  }

  List<Map<String, dynamic>> get filteredLogs {
    return logsSistema.where((log) {
      final matchesSearch = searchLogs.isEmpty ||
          log['usuario'].toLowerCase().contains(searchLogs.toLowerCase()) ||
          log['accion'].toLowerCase().contains(searchLogs.toLowerCase()) ||
          log['detalles'].toLowerCase().contains(searchLogs.toLowerCase());
      final matchesModulo =
          filtroModulo == 'Todos' || log['modulo'] == filtroModulo;
      final matchesUsuario =
          filtroUsuario == 'Todos' || log['usuario'] == filtroUsuario;
      return matchesSearch && matchesModulo && matchesUsuario;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header principal
            Container(
              padding: const EdgeInsets.all(24),
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
                      Icons.security_rounded,
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
                          'Usuarios y Seguridad',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Gestión de usuarios, roles y logs del sistema',
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

            // Estadísticas
            _buildStatsRow(),
            const SizedBox(height: 24),

            // Tabs
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey[200]!, width: 1),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: CeasColors.primaryBlue,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: CeasColors.primaryBlue,
                      indicatorWeight: 3,
                      tabs: const [
                        Tab(
                          icon: Icon(Icons.people_alt_rounded),
                          text: 'Usuarios',
                        ),
                        Tab(
                          icon: Icon(Icons.assignment_rounded),
                          text: 'Logs del Sistema',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 600,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          SingleChildScrollView(child: _buildUsuariosTab()),
                          SingleChildScrollView(child: _buildLogsTab()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    final totalUsuarios = usuarios.length;
    final usuariosActivos =
        usuarios.where((u) => u['estado'] == 'Activo').length;
    final usuariosBloqueados =
        usuarios.where((u) => u['estado'] == 'Bloqueado').length;
    final logsHoy =
        logsSistema.where((l) => l['fecha'].startsWith('15/12/2024')).length;

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
                child: _buildStatCard('Total Usuarios', totalUsuarios.toString(),
                    Icons.people_rounded, CeasColors.kpiBlue, 'Usuarios registrados', false),
              ),
              SizedBox(
                width: (constraints.maxWidth - 8) / 2,
                child: _buildStatCard('Activos', usuariosActivos.toString(),
                    Icons.check_circle_rounded, CeasColors.kpiGreen, 'En buen estado', false),
              ),
              SizedBox(
                width: (constraints.maxWidth - 8) / 2,
                child: _buildStatCard('Bloqueados', usuariosBloqueados.toString(),
                    Icons.block_rounded, CeasColors.kpiOrange, 'Acceso restringido', false),
              ),
              SizedBox(
                width: (constraints.maxWidth - 8) / 2,
                child: _buildStatCard('Logs Hoy', logsHoy.toString(), Icons.assignment_rounded,
                    CeasColors.kpiPurple, 'Actividades registradas', false),
              ),
            ],
          );
        }

        // En desktop, mostrar 4 columnas
        return Row(
          children: [
            _buildStatCard('Total Usuarios', totalUsuarios.toString(),
                Icons.people_rounded, CeasColors.kpiBlue, 'Usuarios registrados', true),
            const SizedBox(width: 16),
            _buildStatCard('Activos', usuariosActivos.toString(),
                Icons.check_circle_rounded, CeasColors.kpiGreen, 'En buen estado', true),
            const SizedBox(width: 16),
            _buildStatCard('Bloqueados', usuariosBloqueados.toString(),
                Icons.block_rounded, CeasColors.kpiOrange, 'Acceso restringido', true),
            const SizedBox(width: 16),
            _buildStatCard('Logs Hoy', logsHoy.toString(), Icons.assignment_rounded,
                CeasColors.kpiPurple, 'Actividades registradas', true),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color, String subtitle, bool useExpanded) {
    final card = Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(useExpanded ? 20 : 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(useExpanded ? 8 : 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: useExpanded ? 20 : 18),
                ),
                SizedBox(width: useExpanded ? 12 : 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: useExpanded ? 14 : 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: useExpanded ? 24 : 20,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: useExpanded ? 12 : 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
    
    return useExpanded ? Expanded(child: card) : card;
  }

  Widget _buildUsuariosTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Gestión de Usuarios',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: CeasColors.primaryBlue,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showCreateUserDialog(),
                icon: const Icon(Icons.person_add_rounded),
                label: const Text('Crear Usuario'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CeasColors.primaryBlue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildUsuariosFilters(),
          const SizedBox(height: 20),
          _buildUsuariosTable(),
        ],
      ),
    );
  }

  Widget _buildLogsTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Logs del Sistema',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: CeasColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 20),
          _buildLogsFilters(),
          const SizedBox(height: 20),
          _buildLogsTable(),
        ],
      ),
    );
  }

  Widget _buildUsuariosFilters() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            onChanged: (value) => setState(() => searchUsuarios = value),
            decoration: InputDecoration(
              hintText: 'Buscar por usuario, nombre o email...',
              prefixIcon: const Icon(Icons.search),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // _buildFilterDropdown(
        //   'Estado',
        //   filtroEstado,
        //   ['Todos', 'Activo', 'Inactivo', 'Bloqueado'],
        //   (value) => setState(() => filtroEstado = value!),
        // ),
        // const SizedBox(width: 16),
        // _buildFilterDropdown(
        //   'Rol',
        //   filtroRol,
        //   [
        //     'Todos',
        //     'Administrador',
        //     'Gerente',
        //     'Encargado de Ventas',
        //     'Contadora',
        //     'Instructor',
        //     'Recepcionista',
        //     'Mantenimiento'
        //   ],
        //   (value) => setState(() => filtroRol = value!),
        // ),
      ],
    );
  }

  Widget _buildLogsFilters() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            onChanged: (value) => setState(() => searchLogs = value),
            decoration: InputDecoration(
              hintText: 'Buscar en logs...',
              prefixIcon: const Icon(Icons.search),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 16),
        _buildFilterDropdown(
          'Módulo',
          filtroModulo,
          [
            'Todos',
            'Autenticación',
            'Socios',
            'Ventas',
            'Finanzas',
            'Recursos Humanos',
            'Mantenimiento',
            'Usuarios',
            'Configuración'
          ],
          (value) => setState(() => filtroModulo = value!),
        ),
        const SizedBox(width: 16),
        _buildFilterDropdown(
          'Usuario',
          filtroUsuario,
          ['Todos', ...usuarios.map((u) => u['usuario']).toList()],
          (value) => setState(() => filtroUsuario = value!),
        ),
      ],
    );
  }

  Widget _buildFilterDropdown(String label, String value, List<String> items,
      Function(String?) onChanged) {
    return Container(
      width: 200,
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildUsuariosTable() {
    final filtered = filteredUsuarios;
    final startIndex = (currentPageUsuarios - 1) * itemsPerPageUsuarios;
    final endIndex =
        (startIndex + itemsPerPageUsuarios).clamp(0, filtered.length);
    final paginatedUsuarios = filtered.sublist(startIndex, endIndex);
    final totalPages = (filtered.length / itemsPerPageUsuarios).ceil();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth <= 768;
        
        if (isMobile) {
          // En mobile, mostrar tarjetas
          return Column(
            children: [
              ...paginatedUsuarios.map((usuario) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: UsuarioCard(usuario: usuario),
                );
              }).toList(),
              const SizedBox(height: 16),
              _buildPagination(startIndex, endIndex, filtered.length, totalPages),
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
                    Expanded(flex: 1, child: _buildHeaderCell('ID')),
                    Expanded(flex: 2, child: _buildHeaderCell('Usuario')),
                    Expanded(flex: 3, child: _buildHeaderCell('Nombre')),
                    Expanded(flex: 2, child: _buildHeaderCell('Email')),
                    Expanded(flex: 1, child: _buildHeaderCell('Rol')),
                    Expanded(
                        flex: 1,
                        child: Center(child: _buildHeaderCell('Estado'))),
                    Expanded(flex: 2, child: _buildHeaderCell('Último Acceso')),
                    Expanded(flex: 1, child: _buildHeaderCell('Acciones')),
                  ],
                ),
              ),
              ...paginatedUsuarios.asMap().entries.map((entry) {
                final index = entry.key;
                final usuario = entry.value;
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
                        Expanded(flex: 1, child: _buildCell(usuario['id'])),
                        Expanded(
                            flex: 2, child: _buildCell(usuario['usuario'])),
                        Expanded(flex: 3, child: _buildCell(usuario['nombre'])),
                        Expanded(flex: 2, child: _buildCell(usuario['email'])),
                        Expanded(flex: 1, child: _buildCell(usuario['rol'])),
                        Expanded(
                            flex: 1,
                            child: Center(
                                child: _buildEstadoCell(usuario['estado']))),
                        Expanded(
                            flex: 2,
                            child: _buildCell(usuario['ultimoAcceso'])),
                        Expanded(
                            flex: 1,
                            child: _buildUsuariosOpcionesCell(usuario)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Paginación
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Mostrando ${startIndex + 1}-${endIndex} de ${filtered.length} usuarios',
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left_rounded),
                  onPressed: currentPageUsuarios > 1
                      ? () => setState(() => currentPageUsuarios--)
                      : null,
                ),
                ...List.generate(
                  totalPages,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextButton(
                      onPressed: () =>
                          setState(() => currentPageUsuarios = index + 1),
                      style: TextButton.styleFrom(
                        backgroundColor: currentPageUsuarios == index + 1
                            ? CeasColors.primaryBlue
                            : Colors.transparent,
                        foregroundColor: currentPageUsuarios == index + 1
                            ? Colors.white
                            : CeasColors.primaryBlue,
                      ),
                      child: Text('${index + 1}'),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right_rounded),
                  onPressed: currentPageUsuarios < totalPages
                      ? () => setState(() => currentPageUsuarios++)
                      : null,
                ),
              ],
            ),
          ],
        ),
      ],
        );
      },
    );
  }
  
  Widget _buildPagination(int startIndex, int endIndex, int totalItems, int totalPages) {
    return Column(
      children: [
        Text(
          'Mostrando $startIndex-$endIndex de $totalItems usuarios',
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left_rounded),
              onPressed: currentPageUsuarios > 1
                  ? () => setState(() => currentPageUsuarios--)
                  : null,
            ),
            ...List.generate(
              totalPages,
              (index) => TextButton(
                onPressed: () => setState(() => currentPageUsuarios = index + 1),
                style: TextButton.styleFrom(
                  backgroundColor: currentPageUsuarios == index + 1
                      ? CeasColors.primaryBlue
                      : Colors.transparent,
                  foregroundColor: currentPageUsuarios == index + 1
                      ? Colors.white
                      : CeasColors.primaryBlue,
                ),
                child: Text('${index + 1}'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right_rounded),
              onPressed: currentPageUsuarios < totalPages
                  ? () => setState(() => currentPageUsuarios++)
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLogsTable() {
    final filtered = filteredLogs;
    final startIndex = (currentPageLogs - 1) * itemsPerPageLogs;
    final endIndex = (startIndex + itemsPerPageLogs).clamp(0, filtered.length);
    final paginatedLogs = filtered.sublist(startIndex, endIndex);
    final totalPages = (filtered.length / itemsPerPageLogs).ceil();

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
                    Expanded(flex: 1, child: _buildHeaderCell('ID')),
                    Expanded(flex: 2, child: _buildHeaderCell('Usuario')),
                    Expanded(flex: 2, child: _buildHeaderCell('Acción')),
                    Expanded(flex: 2, child: _buildHeaderCell('Módulo')),
                    Expanded(flex: 2, child: _buildHeaderCell('Fecha')),
                    Expanded(flex: 1, child: _buildHeaderCell('IP')),
                    Expanded(
                        flex: 1,
                        child: Center(child: _buildHeaderCell('Estado'))),
                    Expanded(flex: 2, child: _buildHeaderCell('Detalles')),
                  ],
                ),
              ),
              ...paginatedLogs.asMap().entries.map((entry) {
                final index = entry.key;
                final log = entry.value;
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
                        Expanded(flex: 1, child: _buildCell(log['id'])),
                        Expanded(flex: 2, child: _buildCell(log['usuario'])),
                        Expanded(flex: 2, child: _buildCell(log['accion'])),
                        Expanded(flex: 2, child: _buildCell(log['modulo'])),
                        Expanded(flex: 2, child: _buildCell(log['fecha'])),
                        Expanded(flex: 1, child: _buildCell(log['ip'])),
                        Expanded(
                            flex: 1,
                            child: Center(
                                child: _buildLogEstadoCell(log['estado']))),
                        Expanded(flex: 2, child: _buildCell(log['detalles'])),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Paginación
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Mostrando ${startIndex + 1}-${endIndex} de ${filtered.length} logs',
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left_rounded),
                  onPressed: currentPageLogs > 1
                      ? () => setState(() => currentPageLogs--)
                      : null,
                ),
                ...List.generate(
                  totalPages,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextButton(
                      onPressed: () =>
                          setState(() => currentPageLogs = index + 1),
                      style: TextButton.styleFrom(
                        backgroundColor: currentPageLogs == index + 1
                            ? Colors.orange
                            : Colors.transparent,
                        foregroundColor: currentPageLogs == index + 1
                            ? Colors.white
                            : Colors.orange,
                      ),
                      child: Text('${index + 1}'),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right_rounded),
                  onPressed: currentPageLogs < totalPages
                      ? () => setState(() => currentPageLogs++)
                      : null,
                ),
              ],
            ),
          ],
        ),
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
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget _buildEstadoCell(String estado) {
    Color color;
    switch (estado) {
      case 'Activo':
        color = Colors.green;
        break;
      case 'Inactivo':
        color = Colors.grey;
        break;
      case 'Bloqueado':
        color = Colors.red;
        break;
      default:
        color = Colors.blueGrey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        estado,
        style:
            TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildLogEstadoCell(String estado) {
    Color color = estado == 'Exitoso' ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        estado,
        style:
            TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildUsuariosOpcionesCell(Map<String, dynamic> usuario) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            _showEditUserDialog(usuario);
            break;
          case 'reset':
            _showResetPasswordDialog(usuario);
            break;
          case 'block':
            _showBlockUserDialog(usuario);
            break;
          case 'delete':
            _showDeleteUserDialog(usuario);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'edit', child: Text('Editar')),
        const PopupMenuItem(value: 'reset', child: Text('Reset Contraseña')),
        const PopupMenuItem(value: 'block', child: Text('Cambiar Estado')),
        const PopupMenuItem(value: 'delete', child: Text('Eliminar')),
      ],
    );
  }

  void _showCreateUserDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Crear Usuario'),
        content: const Text('Funcionalidad de crear usuario (ficticia)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Usuario creado exitosamente')),
              );
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  void _showEditUserDialog(Map<String, dynamic> usuario) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar Usuario - ${usuario['usuario']}'),
        content: const Text('Funcionalidad de editar usuario (ficticia)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Usuario actualizado exitosamente')),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showResetPasswordDialog(Map<String, dynamic> usuario) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset Contraseña - ${usuario['usuario']}'),
        content: const Text(
            '¿Está seguro de que desea resetear la contraseña de este usuario?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Contraseña reseteada exitosamente')),
              );
            },
            child: const Text('Resetear'),
          ),
        ],
      ),
    );
  }

  void _showBlockUserDialog(Map<String, dynamic> usuario) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cambiar Estado - ${usuario['usuario']}'),
        content:
            const Text('Funcionalidad de cambiar estado de usuario (ficticia)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Estado actualizado exitosamente')),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteUserDialog(Map<String, dynamic> usuario) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Usuario - ${usuario['usuario']}'),
        content: const Text(
            '¿Está seguro de que desea eliminar este usuario? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Usuario eliminado exitosamente')),
              );
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
