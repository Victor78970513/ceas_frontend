import 'package:flutter/material.dart';
import '../../../core/theme/ceas_colors.dart';

class PurchasesSuppliersScreen extends StatefulWidget {
  const PurchasesSuppliersScreen({Key? key}) : super(key: key);

  @override
  State<PurchasesSuppliersScreen> createState() =>
      _PurchasesSuppliersScreenState();
}

class _PurchasesSuppliersScreenState extends State<PurchasesSuppliersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Variables de paginación
  int currentPageProveedores = 1;
  int currentPageCompras = 1;
  int itemsPerPage = 5;

  // Filtros para proveedores
  String searchProveedores = '';
  String filtroEstadoProveedor = 'Todos';

  // Filtros para compras
  String searchCompras = '';
  String filtroEstadoCompra = 'Todos';

  // Datos de Proveedores
  final List<Map<String, dynamic>> proveedores = [
    {
      'id': 'PROV001',
      'nombre': 'Equipos Ecuestres S.A.',
      'contacto': 'Juan Pérez',
      'telefono': '76543210',
      'email': 'juan@equiposecuestres.com',
      'direccion': 'Av. Comercio #123, La Paz',
      'estado': 'Activo',
      'categoria': 'Equipos',
      'ultimaCompra': '15/12/2024',
      'totalCompras': 45000.0,
    },
    {
      'id': 'PROV002',
      'nombre': 'Alimentos para Caballos Ltda.',
      'contacto': 'María González',
      'telefono': '76543211',
      'email': 'maria@alimentoscaballos.com',
      'direccion': 'Calle Industrial #456, Santa Cruz',
      'estado': 'Activo',
      'categoria': 'Alimentos',
      'ultimaCompra': '12/12/2024',
      'totalCompras': 28000.0,
    },
    {
      'id': 'PROV003',
      'nombre': 'Veterinaria Equina Central',
      'contacto': 'Dr. Carlos Rodríguez',
      'telefono': '76543212',
      'email': 'carlos@vetequina.com',
      'direccion': 'Plaza Mayor #789, Cochabamba',
      'estado': 'Activo',
      'categoria': 'Veterinaria',
      'ultimaCompra': '10/12/2024',
      'totalCompras': 15000.0,
    },
    {
      'id': 'PROV004',
      'nombre': 'Herramientas y Mantenimiento',
      'contacto': 'Roberto Silva',
      'telefono': '76543213',
      'email': 'roberto@herramientas.com',
      'direccion': 'Zona Industrial #321, La Paz',
      'estado': 'Activo',
      'categoria': 'Herramientas',
      'ultimaCompra': '08/12/2024',
      'totalCompras': 12000.0,
    },
    {
      'id': 'PROV005',
      'nombre': 'Transporte Ecuestre Express',
      'contacto': 'Ana Torres',
      'telefono': '76543214',
      'email': 'ana@transporteecuestre.com',
      'direccion': 'Terminal #654, El Alto',
      'estado': 'Inactivo',
      'categoria': 'Transporte',
      'ultimaCompra': '05/12/2024',
      'totalCompras': 8000.0,
    },
    {
      'id': 'PROV006',
      'nombre': 'Seguros para Equinos',
      'contacto': 'Luis Mendoza',
      'telefono': '76543215',
      'email': 'luis@segurosequinos.com',
      'direccion': 'Centro Comercial #987, La Paz',
      'estado': 'Activo',
      'categoria': 'Seguros',
      'ultimaCompra': '03/12/2024',
      'totalCompras': 5000.0,
    },
    {
      'id': 'PROV007',
      'nombre': 'Ropa y Accesorios Ecuestres',
      'contacto': 'Carmen Vega',
      'telefono': '76543216',
      'email': 'carmen@ropaecuestre.com',
      'direccion': 'Mall Center #147, Santa Cruz',
      'estado': 'Activo',
      'categoria': 'Ropa',
      'ultimaCompra': '01/12/2024',
      'totalCompras': 18000.0,
    },
    {
      'id': 'PROV008',
      'nombre': 'Construcción de Instalaciones',
      'contacto': 'Diego Morales',
      'telefono': '76543217',
      'email': 'diego@construccion.com',
      'direccion': 'Zona Norte #258, La Paz',
      'estado': 'Activo',
      'categoria': 'Construcción',
      'ultimaCompra': '28/11/2024',
      'totalCompras': 75000.0,
    },
  ];

  // Datos de Compras
  final List<Map<String, dynamic>> compras = [
    {
      'id': 'COMP001',
      'proveedor': 'Equipos Ecuestres S.A.',
      'fecha': '15/12/2024',
      'montoTotal': 8500.0,
      'estado': 'Confirmada',
      'categoria': 'Equipos',
      'items': 12,
      'metodoPago': 'Transferencia',
      'fechaEntrega': '20/12/2024',
    },
    {
      'id': 'COMP002',
      'proveedor': 'Alimentos para Caballos Ltda.',
      'fecha': '12/12/2024',
      'montoTotal': 3200.0,
      'estado': 'Entregada',
      'categoria': 'Alimentos',
      'items': 8,
      'metodoPago': 'Efectivo',
      'fechaEntrega': '15/12/2024',
    },
    {
      'id': 'COMP003',
      'proveedor': 'Veterinaria Equina Central',
      'fecha': '10/12/2024',
      'montoTotal': 1800.0,
      'estado': 'Entregada',
      'categoria': 'Veterinaria',
      'items': 5,
      'metodoPago': 'Tarjeta',
      'fechaEntrega': '12/12/2024',
    },
    {
      'id': 'COMP004',
      'proveedor': 'Herramientas y Mantenimiento',
      'fecha': '08/12/2024',
      'montoTotal': 4500.0,
      'estado': 'En Proceso',
      'categoria': 'Herramientas',
      'items': 15,
      'metodoPago': 'Transferencia',
      'fechaEntrega': '18/12/2024',
    },
    {
      'id': 'COMP005',
      'proveedor': 'Transporte Ecuestre Express',
      'fecha': '05/12/2024',
      'montoTotal': 1200.0,
      'estado': 'Cancelada',
      'categoria': 'Transporte',
      'items': 1,
      'metodoPago': 'Efectivo',
      'fechaEntrega': '10/12/2024',
    },
    {
      'id': 'COMP006',
      'proveedor': 'Seguros para Equinos',
      'fecha': '03/12/2024',
      'montoTotal': 2500.0,
      'estado': 'Confirmada',
      'categoria': 'Seguros',
      'items': 3,
      'metodoPago': 'Transferencia',
      'fechaEntrega': '05/12/2024',
    },
    {
      'id': 'COMP007',
      'proveedor': 'Ropa y Accesorios Ecuestres',
      'fecha': '01/12/2024',
      'montoTotal': 2800.0,
      'estado': 'Entregada',
      'categoria': 'Ropa',
      'items': 10,
      'metodoPago': 'Tarjeta',
      'fechaEntrega': '05/12/2024',
    },
    {
      'id': 'COMP008',
      'proveedor': 'Construcción de Instalaciones',
      'fecha': '28/11/2024',
      'montoTotal': 25000.0,
      'estado': 'En Proceso',
      'categoria': 'Construcción',
      'items': 1,
      'metodoPago': 'Transferencia',
      'fechaEntrega': '15/01/2025',
    },
    {
      'id': 'COMP009',
      'proveedor': 'Equipos Ecuestres S.A.',
      'fecha': '25/11/2024',
      'montoTotal': 12000.0,
      'estado': 'Entregada',
      'categoria': 'Equipos',
      'items': 20,
      'metodoPago': 'Transferencia',
      'fechaEntrega': '30/11/2024',
    },
    {
      'id': 'COMP010',
      'proveedor': 'Alimentos para Caballos Ltda.',
      'fecha': '20/11/2024',
      'montoTotal': 4500.0,
      'estado': 'Entregada',
      'categoria': 'Alimentos',
      'items': 12,
      'metodoPago': 'Efectivo',
      'fechaEntrega': '25/11/2024',
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

  List<Map<String, dynamic>> get filteredProveedores {
    return proveedores.where((proveedor) {
      final matchesSearch = searchProveedores.isEmpty ||
          proveedor['nombre']
              .toLowerCase()
              .contains(searchProveedores.toLowerCase()) ||
          proveedor['contacto']
              .toLowerCase()
              .contains(searchProveedores.toLowerCase()) ||
          proveedor['email']
              .toLowerCase()
              .contains(searchProveedores.toLowerCase());
      final matchesEstado = filtroEstadoProveedor == 'Todos' ||
          proveedor['estado'] == filtroEstadoProveedor;
      return matchesSearch && matchesEstado;
    }).toList();
  }

  List<Map<String, dynamic>> get filteredCompras {
    return compras.where((compra) {
      final matchesSearch = searchCompras.isEmpty ||
          compra['proveedor']
              .toLowerCase()
              .contains(searchCompras.toLowerCase()) ||
          compra['categoria']
              .toLowerCase()
              .contains(searchCompras.toLowerCase());
      final matchesEstado = filtroEstadoCompra == 'Todos' ||
          compra['estado'] == filtroEstadoCompra;
      return matchesSearch && matchesEstado;
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
                      Icons.shopping_cart_rounded,
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
                          'Compras y Proveedores',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Gestión de proveedores y control de compras',
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
                      physics: const NeverScrollableScrollPhysics(),
                      tabs: const [
                        Tab(
                          icon: Icon(Icons.business),
                          text: 'Proveedores',
                        ),
                        Tab(
                          icon: Icon(Icons.shopping_bag),
                          text: 'Compras',
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: TabBarView(
                      controller: _tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildProveedoresTab(),
                        _buildComprasTab(),
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
    final totalProveedores = proveedores.length;
    final proveedoresActivos =
        proveedores.where((p) => p['estado'] == 'Activo').length;
    final totalCompras = compras.length;
    final montoTotalCompras =
        compras.fold(0.0, (sum, c) => sum + (c['montoTotal'] as double));

    return Row(
      children: [
        _buildStatCard('Total Proveedores', totalProveedores.toString(),
            Icons.business, CeasColors.kpiBlue, 'Proveedores registrados'),
        const SizedBox(width: 16),
        _buildStatCard('Proveedores Activos', proveedoresActivos.toString(),
            Icons.check_circle, CeasColors.kpiGreen, 'En buen estado'),
        const SizedBox(width: 16),
        _buildStatCard('Total Compras', totalCompras.toString(),
            Icons.shopping_bag, CeasColors.kpiOrange, 'Compras realizadas'),
        const SizedBox(width: 16),
        _buildStatCard(
            'Monto Total',
            'Bs. ${montoTotalCompras.toStringAsFixed(0)}',
            Icons.attach_money,
            CeasColors.kpiPurple,
            'Valor total compras'),
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

  Widget _buildProveedoresTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Gestión de Proveedores',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: CeasColors.primaryBlue,
                ),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _showCreateProviderDialog(),
                    icon: const Icon(Icons.business),
                    label: const Text('Nuevo Proveedor'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CeasColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => _showRelateProviderDialog(),
                    icon: const Icon(Icons.link),
                    label: const Text('Relacionar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildProveedoresFilters(),
          const SizedBox(height: 20),
          Expanded(
            child: _buildProveedoresTable(),
          ),
        ],
      ),
    );
  }

  Widget _buildComprasTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Control de Compras',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: CeasColors.primaryBlue,
                ),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _showCreatePurchaseDialog(),
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Nueva Compra'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CeasColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => _showPurchaseHistoryDialog(),
                    icon: const Icon(Icons.history),
                    label: const Text('Ver Historial'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildComprasFilters(),
          const SizedBox(height: 20),
          Expanded(
            child: _buildComprasTable(),
          ),
        ],
      ),
    );
  }

  Widget _buildProveedoresFilters() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            onChanged: (value) => setState(() => searchProveedores = value),
            decoration: InputDecoration(
              hintText: 'Buscar por nombre, contacto o email...',
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
          'Estado',
          filtroEstadoProveedor,
          ['Todos', 'Activo', 'Inactivo'],
          (value) => setState(() => filtroEstadoProveedor = value!),
        ),
      ],
    );
  }

  Widget _buildComprasFilters() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            onChanged: (value) => setState(() => searchCompras = value),
            decoration: InputDecoration(
              hintText: 'Buscar por proveedor o categoría...',
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
          'Estado',
          filtroEstadoCompra,
          ['Todos', 'Confirmada', 'En Proceso', 'Entregada', 'Cancelada'],
          (value) => setState(() => filtroEstadoCompra = value!),
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

  Widget _buildProveedoresTable() {
    final filtered = filteredProveedores;
    final startIndex = (currentPageProveedores - 1) * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage).clamp(0, filtered.length);
    final paginatedProveedores = filtered.sublist(startIndex, endIndex);
    final totalPages = (filtered.length / itemsPerPage).ceil();

    return Column(
      children: [
        Expanded(
          child: Container(
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
                      Expanded(flex: 2, child: _buildHeaderCell('Proveedor')),
                      Expanded(flex: 2, child: _buildHeaderCell('Contacto')),
                      Expanded(flex: 2, child: _buildHeaderCell('Email')),
                      Expanded(flex: 1, child: _buildHeaderCell('Categoría')),
                      Expanded(
                          flex: 1,
                          child: Center(child: _buildHeaderCell('Estado'))),
                      Expanded(
                          flex: 1, child: _buildHeaderCell('Última Compra')),
                      Expanded(flex: 1, child: _buildHeaderCell('Total')),
                      Expanded(flex: 1, child: _buildHeaderCell('Acciones')),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children:
                          paginatedProveedores.asMap().entries.map((entry) {
                        final index = entry.key;
                        final proveedor = entry.value;
                        return Container(
                          decoration: BoxDecoration(
                            color:
                                index.isEven ? Colors.grey[50] : Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey[100]!, width: 0.5)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: _buildCell(proveedor['id'])),
                                Expanded(
                                    flex: 2,
                                    child: _buildCell(proveedor['nombre'])),
                                Expanded(
                                    flex: 2,
                                    child: _buildCell(proveedor['contacto'])),
                                Expanded(
                                    flex: 2,
                                    child: _buildCell(proveedor['email'])),
                                Expanded(
                                    flex: 1,
                                    child: _buildCell(proveedor['categoria'])),
                                Expanded(
                                    flex: 1,
                                    child: Center(
                                        child: _buildEstadoCell(
                                            proveedor['estado']))),
                                Expanded(
                                    flex: 1,
                                    child:
                                        _buildCell(proveedor['ultimaCompra'])),
                                Expanded(
                                    flex: 1,
                                    child: _buildMoneyCell(
                                        proveedor['totalCompras'])),
                                Expanded(
                                    flex: 1,
                                    child:
                                        _buildProveedorOpcionesCell(proveedor)),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildPagination(
            currentPageProveedores,
            totalPages,
            (page) => setState(() => currentPageProveedores = page),
            filtered.length,
            startIndex,
            endIndex),
      ],
    );
  }

  Widget _buildComprasTable() {
    final filtered = filteredCompras;
    final startIndex = (currentPageCompras - 1) * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage).clamp(0, filtered.length);
    final paginatedCompras = filtered.sublist(startIndex, endIndex);
    final totalPages = (filtered.length / itemsPerPage).ceil();

    return Column(
      children: [
        Expanded(
          child: Container(
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
                      Expanded(flex: 2, child: _buildHeaderCell('Proveedor')),
                      Expanded(flex: 1, child: _buildHeaderCell('Fecha')),
                      Expanded(flex: 1, child: _buildHeaderCell('Monto Total')),
                      Expanded(flex: 1, child: _buildHeaderCell('Categoría')),
                      Expanded(
                          flex: 1,
                          child: Center(child: _buildHeaderCell('Estado'))),
                      Expanded(flex: 1, child: _buildHeaderCell('Items')),
                      Expanded(flex: 1, child: _buildHeaderCell('Entrega')),
                      Expanded(flex: 1, child: _buildHeaderCell('Acciones')),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: paginatedCompras.asMap().entries.map((entry) {
                        final index = entry.key;
                        final compra = entry.value;
                        return Container(
                          decoration: BoxDecoration(
                            color:
                                index.isEven ? Colors.grey[50] : Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey[100]!, width: 0.5)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1, child: _buildCell(compra['id'])),
                                Expanded(
                                    flex: 2,
                                    child: _buildCell(compra['proveedor'])),
                                Expanded(
                                    flex: 1,
                                    child: _buildCell(compra['fecha'])),
                                Expanded(
                                    flex: 1,
                                    child:
                                        _buildMoneyCell(compra['montoTotal'])),
                                Expanded(
                                    flex: 1,
                                    child: _buildCell(compra['categoria'])),
                                Expanded(
                                    flex: 1,
                                    child: Center(
                                        child: _buildCompraEstadoCell(
                                            compra['estado']))),
                                Expanded(
                                    flex: 1,
                                    child: _buildCell('${compra['items']}')),
                                Expanded(
                                    flex: 1,
                                    child: _buildCell(compra['fechaEntrega'])),
                                Expanded(
                                    flex: 1,
                                    child: _buildCompraOpcionesCell(compra)),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildPagination(
            currentPageCompras,
            totalPages,
            (page) => setState(() => currentPageCompras = page),
            filtered.length,
            startIndex,
            endIndex),
      ],
    );
  }

  Widget _buildPagination(
      int currentPage,
      int totalPages,
      Function(int) onPageChange,
      int totalItems,
      int startIndex,
      int endIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Mostrando ${startIndex + 1}-${endIndex} de $totalItems registros',
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
                  currentPage > 1 ? () => onPageChange(currentPage - 1) : null,
            ),
            ...List.generate(
              totalPages,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: TextButton(
                  onPressed: () => onPageChange(index + 1),
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
                  ? () => onPageChange(currentPage + 1)
                  : null,
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

  Widget _buildMoneyCell(double amount) {
    return Text(
      'Bs. ${amount.toStringAsFixed(0)}',
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.green,
      ),
    );
  }

  Widget _buildEstadoCell(String estado) {
    Color color = estado == 'Activo' ? Colors.green : Colors.grey;
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

  Widget _buildCompraEstadoCell(String estado) {
    Color color;
    switch (estado) {
      case 'Confirmada':
        color = Colors.blue;
        break;
      case 'En Proceso':
        color = Colors.orange;
        break;
      case 'Entregada':
        color = Colors.green;
        break;
      case 'Cancelada':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
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

  Widget _buildProveedorOpcionesCell(Map<String, dynamic> proveedor) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            _showEditProviderDialog(proveedor);
            break;
          case 'history':
            _showProviderHistoryDialog(proveedor);
            break;
          case 'delete':
            _showDeleteProviderDialog(proveedor);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'edit', child: Text('Editar')),
        const PopupMenuItem(value: 'history', child: Text('Ver Historial')),
        const PopupMenuItem(value: 'delete', child: Text('Eliminar')),
      ],
    );
  }

  Widget _buildCompraOpcionesCell(Map<String, dynamic> compra) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value) {
          case 'view':
            _showViewPurchaseDialog(compra);
            break;
          case 'edit':
            _showEditPurchaseDialog(compra);
            break;
          case 'delete':
            _showDeletePurchaseDialog(compra);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'view', child: Text('Ver Detalle')),
        const PopupMenuItem(value: 'edit', child: Text('Editar')),
        const PopupMenuItem(value: 'delete', child: Text('Eliminar')),
      ],
    );
  }

  // Diálogos para Proveedores
  void _showCreateProviderDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Crear Proveedor'),
        content: const Text('Funcionalidad de crear proveedor (ficticia)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Proveedor creado exitosamente')),
              );
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  void _showEditProviderDialog(Map<String, dynamic> proveedor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar Proveedor - ${proveedor['nombre']}'),
        content: const Text('Funcionalidad de editar proveedor (ficticia)'),
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
                    content: Text('Proveedor actualizado exitosamente')),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showProviderHistoryDialog(Map<String, dynamic> proveedor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Historial - ${proveedor['nombre']}'),
        content:
            const Text('Funcionalidad de historial de proveedor (ficticia)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteProviderDialog(Map<String, dynamic> proveedor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Proveedor - ${proveedor['nombre']}'),
        content:
            const Text('¿Está seguro de que desea eliminar este proveedor?'),
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
                const SnackBar(
                    content: Text('Proveedor eliminado exitosamente')),
              );
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showRelateProviderDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Relacionar Proveedor'),
        content: const Text('Funcionalidad de relacionar proveedor (ficticia)'),
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
                    content: Text('Proveedor relacionado exitosamente')),
              );
            },
            child: const Text('Relacionar'),
          ),
        ],
      ),
    );
  }

  // Diálogos para Compras
  void _showCreatePurchaseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registrar Nueva Compra'),
        content:
            const Text('Funcionalidad de registrar nueva compra (ficticia)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Compra registrada exitosamente')),
              );
            },
            child: const Text('Registrar'),
          ),
        ],
      ),
    );
  }

  void _showViewPurchaseDialog(Map<String, dynamic> compra) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalle de Compra - ${compra['id']}'),
        content:
            const Text('Funcionalidad de ver detalle de compra (ficticia)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showEditPurchaseDialog(Map<String, dynamic> compra) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar Compra - ${compra['id']}'),
        content: const Text('Funcionalidad de editar compra (ficticia)'),
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
                    content: Text('Compra actualizada exitosamente')),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showDeletePurchaseDialog(Map<String, dynamic> compra) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Compra - ${compra['id']}'),
        content: const Text('¿Está seguro de que desea eliminar esta compra?'),
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
                const SnackBar(content: Text('Compra eliminada exitosamente')),
              );
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showPurchaseHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Historial de Compras'),
        content: const Text('Funcionalidad de historial de compras (ficticia)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
