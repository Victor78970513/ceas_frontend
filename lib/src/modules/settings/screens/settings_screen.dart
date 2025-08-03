import 'package:flutter/material.dart';
import '../../../core/theme/ceas_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Variables de paginación
  int currentPage = 1;
  int itemsPerPage = 5;

  // Filtros
  String search = '';
  String filtroEstado = 'Todos';

  // Datos de Roles
  final List<Map<String, dynamic>> roles = [
    {
      'id': 'ROL001',
      'nombre': 'Administrador',
      'descripcion': 'Acceso completo al sistema',
      'estado': 'Activo',
      'permisos': 15
    },
    {
      'id': 'ROL002',
      'nombre': 'Gerente',
      'descripcion': 'Gestión de operaciones',
      'estado': 'Activo',
      'permisos': 12
    },
    {
      'id': 'ROL003',
      'nombre': 'Encargado de Ventas',
      'descripcion': 'Gestión de ventas y socios',
      'estado': 'Activo',
      'permisos': 8
    },
    {
      'id': 'ROL004',
      'nombre': 'Contadora',
      'descripcion': 'Gestión financiera',
      'estado': 'Activo',
      'permisos': 6
    },
    {
      'id': 'ROL005',
      'nombre': 'Instructor',
      'descripcion': 'Gestión de actividades',
      'estado': 'Activo',
      'permisos': 4
    },
    {
      'id': 'ROL006',
      'nombre': 'Recepcionista',
      'descripcion': 'Atención al público',
      'estado': 'Activo',
      'permisos': 3
    },
    {
      'id': 'ROL007',
      'nombre': 'Mantenimiento',
      'descripcion': 'Gestión de instalaciones',
      'estado': 'Activo',
      'permisos': 2
    },
    {
      'id': 'ROL008',
      'nombre': 'Auditor',
      'descripcion': 'Solo consultas y reportes',
      'estado': 'Inactivo',
      'permisos': 1
    },
  ];

  // Datos de Cargos
  final List<Map<String, dynamic>> cargos = [
    {
      'id': 'CAR001',
      'nombre': 'Administrador Principal',
      'departamento': 'Administración',
      'estado': 'Activo',
      'salarioBase': 8000
    },
    {
      'id': 'CAR002',
      'nombre': 'Gerente General',
      'departamento': 'Gerencia',
      'estado': 'Activo',
      'salarioBase': 6500
    },
    {
      'id': 'CAR003',
      'nombre': 'Encargado de Ventas',
      'departamento': 'Ventas',
      'estado': 'Activo',
      'salarioBase': 4500
    },
    {
      'id': 'CAR004',
      'nombre': 'Contadora Senior',
      'departamento': 'Finanzas',
      'estado': 'Activo',
      'salarioBase': 5200
    },
    {
      'id': 'CAR005',
      'nombre': 'Instructor de Equitación',
      'departamento': 'Deportes',
      'estado': 'Activo',
      'salarioBase': 3800
    },
    {
      'id': 'CAR006',
      'nombre': 'Recepcionista',
      'departamento': 'Administración',
      'estado': 'Activo',
      'salarioBase': 3200
    },
    {
      'id': 'CAR007',
      'nombre': 'Mantenimiento',
      'departamento': 'Mantenimiento',
      'estado': 'Activo',
      'salarioBase': 3500
    },
    {
      'id': 'CAR008',
      'nombre': 'Auxiliar Administrativo',
      'departamento': 'Administración',
      'estado': 'Inactivo',
      'salarioBase': 2800
    },
  ];

  // Datos de Modalidades de Pago
  final List<Map<String, dynamic>> modalidadesPago = [
    {
      'id': 'MOD001',
      'nombre': 'Efectivo',
      'descripcion': 'Pago en efectivo',
      'estado': 'Activo',
      'comision': 0.0
    },
    {
      'id': 'MOD002',
      'nombre': 'Tarjeta de Crédito',
      'descripcion': 'Pago con tarjeta de crédito',
      'estado': 'Activo',
      'comision': 3.5
    },
    {
      'id': 'MOD003',
      'nombre': 'Tarjeta de Débito',
      'descripcion': 'Pago con tarjeta de débito',
      'estado': 'Activo',
      'comision': 2.0
    },
    {
      'id': 'MOD004',
      'nombre': 'Transferencia Bancaria',
      'descripcion': 'Transferencia electrónica',
      'estado': 'Activo',
      'comision': 0.5
    },
    {
      'id': 'MOD005',
      'nombre': 'Cheque',
      'descripcion': 'Pago con cheque',
      'estado': 'Activo',
      'comision': 1.0
    },
    {
      'id': 'MOD006',
      'nombre': 'Pago Móvil',
      'descripcion': 'Pago a través de apps móviles',
      'estado': 'Activo',
      'comision': 1.5
    },
    {
      'id': 'MOD007',
      'nombre': 'Criptomonedas',
      'descripcion': 'Pago con criptomonedas',
      'estado': 'Inactivo',
      'comision': 5.0
    },
  ];

  // Datos de Estados
  final List<Map<String, dynamic>> estados = [
    {
      'id': 'EST001',
      'tipo': 'EstadoSocio',
      'nombre': 'Activo',
      'descripcion': 'Socio en buen estado',
      'color': 'Verde',
      'estado': 'Activo'
    },
    {
      'id': 'EST002',
      'tipo': 'EstadoSocio',
      'nombre': 'Inactivo',
      'descripcion': 'Socio suspendido temporalmente',
      'color': 'Gris',
      'estado': 'Activo'
    },
    {
      'id': 'EST003',
      'tipo': 'EstadoSocio',
      'nombre': 'Moroso',
      'descripcion': 'Socio con pagos pendientes',
      'color': 'Naranja',
      'estado': 'Activo'
    },
    {
      'id': 'EST004',
      'tipo': 'EstadoPago',
      'nombre': 'Pendiente',
      'descripcion': 'Pago pendiente de confirmación',
      'color': 'Amarillo',
      'estado': 'Activo'
    },
    {
      'id': 'EST005',
      'tipo': 'EstadoPago',
      'nombre': 'Confirmado',
      'descripcion': 'Pago confirmado',
      'color': 'Verde',
      'estado': 'Activo'
    },
    {
      'id': 'EST006',
      'tipo': 'EstadoPago',
      'nombre': 'Rechazado',
      'descripcion': 'Pago rechazado',
      'color': 'Rojo',
      'estado': 'Activo'
    },
    {
      'id': 'EST007',
      'tipo': 'EstadoAccion',
      'nombre': 'Activa',
      'descripcion': 'Acción activa',
      'color': 'Verde',
      'estado': 'Activo'
    },
    {
      'id': 'EST008',
      'tipo': 'EstadoAccion',
      'nombre': 'Vendida',
      'descripcion': 'Acción vendida',
      'color': 'Azul',
      'estado': 'Activo'
    },
    {
      'id': 'EST009',
      'tipo': 'EstadoEmpleado',
      'nombre': 'Activo',
      'descripcion': 'Empleado activo',
      'color': 'Verde',
      'estado': 'Activo'
    },
    {
      'id': 'EST010',
      'tipo': 'EstadoEmpleado',
      'nombre': 'Inactivo',
      'descripcion': 'Empleado inactivo',
      'color': 'Gris',
      'estado': 'Activo'
    },
    {
      'id': 'EST011',
      'tipo': 'EstadoEmpleado',
      'nombre': 'Bloqueado',
      'descripcion': 'Empleado bloqueado',
      'color': 'Rojo',
      'estado': 'Activo'
    },
  ];

  // Datos de Parametrizaciones
  final List<Map<String, dynamic>> parametrizaciones = [
    {
      'id': 'PAR001',
      'categoria': 'General',
      'parametro': 'Nombre del Club',
      'valor': 'CEAS - Campo Ecuestre Apóstol Santiago',
      'descripcion': 'Nombre oficial del club',
      'estado': 'Activo'
    },
    {
      'id': 'PAR002',
      'categoria': 'General',
      'parametro': 'Dirección',
      'valor': 'Av. Principal #123, La Paz, Bolivia',
      'descripcion': 'Dirección física del club',
      'estado': 'Activo'
    },
    {
      'id': 'PAR003',
      'categoria': 'General',
      'parametro': 'Teléfono',
      'valor': '+591 2 1234567',
      'descripcion': 'Teléfono de contacto',
      'estado': 'Activo'
    },
    {
      'id': 'PAR004',
      'categoria': 'General',
      'parametro': 'Email',
      'valor': 'info@ceas.com',
      'descripcion': 'Email de contacto',
      'estado': 'Activo'
    },
    {
      'id': 'PAR005',
      'categoria': 'Financiero',
      'parametro': 'Moneda',
      'valor': 'Boliviano (Bs.)',
      'descripcion': 'Moneda oficial',
      'estado': 'Activo'
    },
    {
      'id': 'PAR006',
      'categoria': 'Financiero',
      'parametro': 'IVA',
      'valor': '13%',
      'descripcion': 'Impuesto al Valor Agregado',
      'estado': 'Activo'
    },
    {
      'id': 'PAR007',
      'categoria': 'Financiero',
      'parametro': 'Días de Pago',
      'valor': '5',
      'descripcion': 'Días de gracia para pagos',
      'estado': 'Activo'
    },
    {
      'id': 'PAR008',
      'categoria': 'Socios',
      'parametro': 'Máximo Acciones por Socio',
      'valor': '10',
      'descripcion': 'Límite de acciones por socio',
      'estado': 'Activo'
    },
    {
      'id': 'PAR009',
      'categoria': 'Socios',
      'parametro': 'Edad Mínima',
      'valor': '18',
      'descripcion': 'Edad mínima para ser socio',
      'estado': 'Activo'
    },
    {
      'id': 'PAR010',
      'categoria': 'Sistema',
      'parametro': 'Sesión Timeout',
      'valor': '30 minutos',
      'descripcion': 'Tiempo de inactividad para cerrar sesión',
      'estado': 'Activo'
    },
    {
      'id': 'PAR011',
      'categoria': 'Sistema',
      'parametro': 'Backup Automático',
      'valor': 'Diario',
      'descripcion': 'Frecuencia de respaldo automático',
      'estado': 'Activo'
    },
    {
      'id': 'PAR012',
      'categoria': 'Sistema',
      'parametro': 'Máximo Intentos Login',
      'valor': '3',
      'descripcion': 'Intentos máximos de inicio de sesión',
      'estado': 'Activo'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                      Icons.settings_rounded,
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
                          'Configuración del Sistema',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Gestión de roles, cargos, modalidades y parámetros',
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
                      isScrollable: true,
                      tabs: const [
                        Tab(icon: Icon(Icons.security), text: 'Roles'),
                        Tab(icon: Icon(Icons.work), text: 'Cargos'),
                        Tab(
                            icon: Icon(Icons.payment),
                            text: 'Modalidades de Pago'),
                        Tab(icon: Icon(Icons.flag), text: 'Estados'),
                        Tab(icon: Icon(Icons.tune), text: 'Parametrizaciones'),
                      ],
                    ),
                  ),
                  Container(
                    height: 600,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: TabBarView(
                      controller: _tabController,
                      physics:
                          const NeverScrollableScrollPhysics(), // Deshabilitar swipe
                      children: [
                        _buildRolesTab(),
                        _buildCargosTab(),
                        _buildModalidadesTab(),
                        _buildEstadosTab(),
                        _buildParametrizacionesTab(),
                      ],
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
    return Row(
      children: [
        _buildStatCard('Roles', roles.length.toString(), Icons.security,
            CeasColors.kpiBlue, 'Roles configurados'),
        const SizedBox(width: 16),
        _buildStatCard('Cargos', cargos.length.toString(), Icons.work,
            CeasColors.kpiGreen, 'Cargos disponibles'),
        const SizedBox(width: 16),
        _buildStatCard('Modalidades', modalidadesPago.length.toString(),
            Icons.payment, CeasColors.kpiOrange, 'Formas de pago'),
        const SizedBox(width: 16),
        _buildStatCard('Estados', estados.length.toString(), Icons.flag,
            CeasColors.kpiPurple, 'Estados del sistema'),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color, String subtitle) {
    return Expanded(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
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
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRolesTab() {
    return _buildGenericTab(
      'Gestión de Roles',
      roles,
      ['ID', 'Nombre', 'Descripción', 'Estado', 'Permisos'],
      (item) => [
        item['id'],
        item['nombre'],
        item['descripcion'],
        item['estado'],
        '${item['permisos']}'
      ],
      () => _showCreateDialog('Rol'),
    );
  }

  Widget _buildCargosTab() {
    return _buildGenericTab(
      'Gestión de Cargos',
      cargos,
      ['ID', 'Nombre', 'Departamento', 'Estado', 'Salario Base'],
      (item) => [
        item['id'],
        item['nombre'],
        item['departamento'],
        item['estado'],
        'Bs. ${item['salarioBase']}'
      ],
      () => _showCreateDialog('Cargo'),
    );
  }

  Widget _buildModalidadesTab() {
    return _buildGenericTab(
      'Modalidades de Pago',
      modalidadesPago,
      ['ID', 'Nombre', 'Descripción', 'Estado', 'Comisión'],
      (item) => [
        item['id'],
        item['nombre'],
        item['descripcion'],
        item['estado'],
        '${item['comision']}%'
      ],
      () => _showCreateDialog('Modalidad de Pago'),
    );
  }

  Widget _buildEstadosTab() {
    return _buildGenericTab(
      'Estados del Sistema',
      estados,
      ['ID', 'Tipo', 'Nombre', 'Descripción', 'Color', 'Estado'],
      (item) => [
        item['id'],
        item['tipo'],
        item['nombre'],
        item['descripcion'],
        item['color'],
        item['estado']
      ],
      () => _showCreateDialog('Estado'),
    );
  }

  Widget _buildParametrizacionesTab() {
    return _buildGenericTab(
      'Parametrizaciones',
      parametrizaciones,
      ['ID', 'Categoría', 'Parámetro', 'Valor', 'Descripción', 'Estado'],
      (item) => [
        item['id'],
        item['categoria'],
        item['parametro'],
        item['valor'],
        item['descripcion'],
        item['estado']
      ],
      () => _showCreateDialog('Parametrización'),
    );
  }

  Widget _buildGenericTab(
      String title,
      List<Map<String, dynamic>> data,
      List<String> headers,
      List<String> Function(Map<String, dynamic>) getRowData,
      VoidCallback onCreate) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: CeasColors.primaryBlue,
                ),
              ),
              ElevatedButton.icon(
                onPressed: onCreate,
                icon: const Icon(Icons.add),
                label: const Text('Crear'),
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
          _buildGenericTable(data, headers, getRowData),
        ],
      ),
    );
  }

  Widget _buildGenericTable(
      List<Map<String, dynamic>> data,
      List<String> headers,
      List<String> Function(Map<String, dynamic>) getRowData) {
    final filtered = data.where((item) {
      final matchesSearch = search.isEmpty ||
          item.values.any((value) =>
              value.toString().toLowerCase().contains(search.toLowerCase()));
      final matchesEstado =
          filtroEstado == 'Todos' || item['estado'] == filtroEstado;
      return matchesSearch && matchesEstado;
    }).toList();

    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage).clamp(0, filtered.length);
    final paginatedData = filtered.sublist(startIndex, endIndex);
    final totalPages = (filtered.length / itemsPerPage).ceil();

    return Column(
      children: [
        // Filtros
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                onChanged: (value) => setState(() => search = value),
                decoration: InputDecoration(
                  hintText: 'Buscar...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 16),
            _buildFilterDropdown(
              'Estado',
              filtroEstado,
              ['Todos', 'Activo', 'Inactivo'],
              (value) => setState(() => filtroEstado = value!),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Tabla
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
                  children: headers
                      .map(
                          (header) => Expanded(child: _buildHeaderCell(header)))
                      .toList(),
                ),
              ),
              ...paginatedData.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final rowData = getRowData(item);
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
                      children: rowData
                          .map((cell) => Expanded(child: _buildCell(cell)))
                          .toList(),
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
              'Mostrando ${startIndex + 1}-${endIndex} de ${filtered.length} registros',
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left_rounded),
                  onPressed: currentPage > 1
                      ? () => setState(() => currentPage--)
                      : null,
                ),
                ...List.generate(
                  totalPages,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextButton(
                      onPressed: () => setState(() => currentPage = index + 1),
                      style: TextButton.styleFrom(
                        backgroundColor: currentPage == index + 1
                            ? CeasColors.primaryBlue
                            : Colors.transparent,
                        foregroundColor: currentPage == index + 1
                            ? Colors.white
                            : CeasColors.primaryBlue,
                      ),
                      child: Text('${index + 1}'),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right_rounded),
                  onPressed: currentPage < totalPages
                      ? () => setState(() => currentPage++)
                      : null,
                ),
              ],
            ),
          ],
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

  void _showCreateDialog(String tipo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Crear $tipo'),
        content: Text('Funcionalidad de crear $tipo (ficticia)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$tipo creado exitosamente')),
              );
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }
}
