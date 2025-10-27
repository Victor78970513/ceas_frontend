import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html;
import '../../../core/theme/ceas_colors.dart';
import '../providers/proveedor_provider.dart';
import '../providers/compra_provider.dart';
import '../models/proveedor.dart';
import '../models/compra.dart';
import '../services/compra_service.dart';
import '../../auth/providers/auth_provider.dart';
import '../widgets/proveedor_card.dart';
import '../widgets/compra_card.dart';

class PurchasesSuppliersScreen extends StatefulWidget {
  const PurchasesSuppliersScreen({Key? key}) : super(key: key);

  @override
  State<PurchasesSuppliersScreen> createState() =>
      _PurchasesSuppliersScreenState();
}

class _PurchasesSuppliersScreenState extends State<PurchasesSuppliersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Variables de paginación (ahora manejadas por los providers)

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Cargar datos al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      print(
          'InitState - AuthProvider isAuthenticated: ${authProvider.isAuthenticated}');
      if (authProvider.isAuthenticated) {
        print(
            'InitState - Token disponible: ${authProvider.user!.accessToken.substring(0, 20)}...');
        print('InitState - Cargando proveedores...');
        Provider.of<ProveedorProvider>(context, listen: false).loadProveedores(
          authProvider.user!.accessToken,
        );
        print('InitState - Cargando compras...');
        Provider.of<CompraProvider>(context, listen: false).loadCompras(
          authProvider.user!.accessToken,
        );
      } else {
        print('InitState - NO autenticado!');
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProveedorProvider, CompraProvider>(
      builder: (context, proveedorProvider, compraProvider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 1024;
              
              return SingleChildScrollView(
                padding: EdgeInsets.all(isMobile ? 12.0 : 24.0),
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header principal
                Container(
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
                  child: isMobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.shopping_cart_rounded,
                                    color: Colors.white,
                                    size: isMobile ? 24 : 28,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Compras y Proveedores',
                                    style: TextStyle(
                                      fontSize: isMobile ? 18 : 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Gestión de proveedores y control de compras',
                              style: TextStyle(
                                fontSize: isMobile ? 12 : 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  final authProvider =
                                      Provider.of<AuthProvider>(context, listen: false);
                                  if (authProvider.isAuthenticated) {
                                    proveedorProvider
                                        .refresh(authProvider.user!.accessToken);
                                    compraProvider
                                        .refresh(authProvider.user!.accessToken);
                                  }
                                },
                                icon: const Icon(Icons.refresh_rounded),
                                label: const Text('Actualizar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white.withOpacity(0.2),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
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
                            const SizedBox(width: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                final authProvider =
                                    Provider.of<AuthProvider>(context, listen: false);
                                if (authProvider.isAuthenticated) {
                                  proveedorProvider
                                      .refresh(authProvider.user!.accessToken);
                                  compraProvider
                                      .refresh(authProvider.user!.accessToken);
                                }
                              },
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text('Actualizar'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.2),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 24),

                // Estadísticas
                _buildStatsRow(proveedorProvider, compraProvider),
                const SizedBox(height: 24),

                // Mensajes de error
                if (proveedorProvider.error != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      border: Border.all(color: Colors.red.shade200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade600),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Error en Proveedores: ${proveedorProvider.error}',
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (compraProvider.error != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      border: Border.all(color: Colors.red.shade200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade600),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Error en Compras: ${compraProvider.error}',
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Acciones rápidas
                const SizedBox(height: 24),
                _buildQuickActionsRow(),

                // Tabs
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          tabs: const [
                            Tab(
                              icon: Icon(Icons.store_mall_directory),
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
                        constraints: const BoxConstraints(
                          minHeight: 400,
                          maxHeight: 800,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        child: TabBarView(
                          controller: _tabController,
                          physics: const ClampingScrollPhysics(),
                          children: [
                            _buildProveedoresTab(proveedorProvider),
                            _buildComprasTab(compraProvider),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildStatsRow(
      ProveedorProvider proveedorProvider, CompraProvider compraProvider) {
    final estadisticasProveedores = proveedorProvider.getEstadisticas();
    final estadisticasCompras = compraProvider.getEstadisticas();
    final totalProveedores = estadisticasProveedores['total'] ?? 0;
    final proveedoresActivos = estadisticasProveedores['activos'] ?? 0;
    final totalCompras = estadisticasCompras['total'] ?? 0;
    final montoTotalCompras = estadisticasCompras['montoTotal'] ?? 0.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 1024;

        if (isMobile) {
          // En mobile, mostrar 2 columnas
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              SizedBox(
                width: (constraints.maxWidth - 16) / 2,
                child: _buildStatCard(
                  title: 'Proveedores Totales',
                  value: totalProveedores.toString(),
                  icon: Icons.store_mall_directory_rounded,
                  color: Colors.indigo,
                  isMobile: true,
                ),
              ),
              SizedBox(
                width: (constraints.maxWidth - 16) / 2,
                child: _buildStatCard(
                  title: 'Proveedores Activos',
                  value: proveedoresActivos.toString(),
                  icon: Icons.verified_rounded,
                  color: Colors.green,
                  isMobile: true,
                ),
              ),
              SizedBox(
                width: (constraints.maxWidth - 16) / 2,
                child: _buildStatCard(
                  title: 'Compras Totales',
                  value: totalCompras.toString(),
                  icon: Icons.shopping_bag_rounded,
                  color: Colors.orange,
                  isMobile: true,
                ),
              ),
              SizedBox(
                width: (constraints.maxWidth - 16) / 2,
                child: _buildStatCard(
                  title: 'Monto Total (Bs.)',
                  value: montoTotalCompras.toStringAsFixed(0),
                  icon: Icons.payments_rounded,
                  color: Colors.teal,
                  isMobile: true,
                ),
              ),
            ],
          );
        }

        // En desktop, mostrar 4 columnas
        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Proveedores Totales',
                value: totalProveedores.toString(),
                icon: Icons.store_mall_directory_rounded,
                color: Colors.indigo,
                isMobile: false,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Proveedores Activos',
                value: proveedoresActivos.toString(),
                icon: Icons.verified_rounded,
                color: Colors.green,
                isMobile: false,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Compras Totales',
                value: totalCompras.toString(),
                icon: Icons.shopping_bag_rounded,
                color: Colors.orange,
                isMobile: false,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Monto Total (Bs.)',
                value: montoTotalCompras.toStringAsFixed(0),
                icon: Icons.payments_rounded,
                color: Colors.teal,
                isMobile: false,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isMobile,
  }) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isMobile ? 8 : 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: isMobile ? 20 : 24),
          ),
          SizedBox(width: isMobile ? 8 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 11 : 13,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: isMobile ? 2 : 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProveedoresTab(ProveedorProvider proveedorProvider) {
    final proveedores = proveedorProvider.filteredProveedores;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProveedoresFilters(proveedorProvider),
          const SizedBox(height: 16),
          if (proveedorProvider.isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else
            _buildProveedoresTable(proveedores, proveedorProvider),
        ],
      ),
    );
  }

  Widget _buildComprasTab(CompraProvider compraProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildComprasFilters(compraProvider),
          const SizedBox(height: 16),
          if (compraProvider.isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else
            _buildComprasTable(compraProvider),
        ],
      ),
    );
  }

  Widget _buildProveedoresFilters(ProveedorProvider proveedorProvider) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            onChanged: (value) => proveedorProvider.updateSearchQuery(value),
            decoration: InputDecoration(
              hintText: 'Buscar por nombre, email o categoría...',
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
          proveedorProvider.filterEstado,
          proveedorProvider.estados,
          (value) => proveedorProvider.updateFilterEstado(value),
        ),
      ],
    );
  }

  Widget _buildComprasFilters(CompraProvider compraProvider) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            onChanged: (value) => compraProvider.updateSearchQuery(value),
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
          compraProvider.filterEstado,
          compraProvider.estados,
          (value) => compraProvider.updateFilterEstado(value),
        ),
      ],
    );
  }

  Widget _buildFilterDropdown(
    String label,
    String currentValue,
    List<String> options,
    void Function(String?) onChanged,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: currentValue,
            items: options
                .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
                .toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProveedoresTable(
      List<Proveedor> proveedores, ProveedorProvider proveedorProvider) {
    final paginated = proveedorProvider.paginatedProveedores;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 1024;

        // En mobile, mostrar tarjetas
        if (isMobile) {
          if (paginated.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: const Center(
                child: Column(
                  children: [
                    Icon(Icons.inbox_outlined, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No hay proveedores para mostrar',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: paginated
                  .map((proveedor) => ProveedorCard(proveedor: proveedor))
                  .toList(),
            ),
          );
        }

        // En desktop, mostrar tabla
        return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!, width: 1),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12), // Reducido de 16 a 12
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(flex: 1, child: _buildHeaderCell('ID')),
                      Expanded(flex: 2, child: _buildHeaderCell('Nombre')),
                      Expanded(flex: 2, child: _buildHeaderCell('Email')),
                      Expanded(flex: 2, child: _buildHeaderCell('Categoría', TextAlign.center)),
                      Expanded(
                          flex: 1,
                          child: Center(child: _buildHeaderCell('Estado'))),
                      Expanded(flex: 2, child: _buildHeaderCell('Teléfono')),
                      Expanded(flex: 2, child: _buildHeaderCell('Dirección')),
                      Expanded(flex: 1, child: _buildHeaderCell('Acciones')),
                    ],
                  ),
                ),
                if (paginated.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24), // Reducido de 40 a 24
                    child: const Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 32, // Reducido de 48 a 32
                            color: Colors.grey,
                          ),
                          SizedBox(height: 12), // Reducido de 16 a 12
                          Text(
                            'No hay proveedores para mostrar',
                            style: TextStyle(
                              fontSize: 14, // Reducido de 16 a 14
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Column(
                    children: paginated.asMap().entries.map((entry) {
                      final index = entry.key;
                      final proveedor = entry.value;
                      return Container(
                        decoration: BoxDecoration(
                          color: index.isEven ? Colors.grey[50] : Colors.white,
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey[100]!, width: 0.5)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8), // Reducido de 12 a 8
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1, child: _buildCell(proveedor.id)),
                              Expanded(
                                  flex: 2, child: _buildCell(proveedor.nombre)),
                              Expanded(
                                  flex: 2, child: _buildCell(proveedor.email)),
                              Expanded(
                                  flex: 2,
                                  child: _buildCell(proveedor.categoriaDisplay, TextAlign.center)),
                              Expanded(
                                  flex: 1,
                                  child: Center(
                                      child: _buildEstadoCell(
                                          proveedor.estadoDisplay))),
                              Expanded(
                                  flex: 2,
                                  child: _buildCell(proveedor.telefono)),
                              Expanded(
                                  flex: 2,
                                  child: _buildCell(proveedor.direccion)),
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
              ],
            ),
          ),
          const SizedBox(height: 12), // Reducido de 16 a 12
          // Controles de paginación usando el provider
          if (proveedorProvider.totalPages > 1) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  // Información de la página
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Mostrando ${proveedorProvider.paginatedProveedores.length} de ${proveedorProvider.totalItems} proveedores',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Controles de navegación
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Botón anterior
                      IconButton(
                        onPressed: proveedorProvider.currentPage > 1
                            ? () => proveedorProvider.previousPage()
                            : null,
                        icon: const Icon(Icons.chevron_left),
                        color: proveedorProvider.currentPage > 1
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
                          '${proveedorProvider.currentPage}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      // Separador
                      Text(
                        ' de ${proveedorProvider.totalPages}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      // Botón siguiente
                      IconButton(
                        onPressed: proveedorProvider.hasMorePages
                            ? () => proveedorProvider.nextPage()
                            : null,
                        icon: const Icon(Icons.chevron_right),
                        color: proveedorProvider.hasMorePages
                            ? CeasColors.primaryBlue
                            : Colors.grey.shade400,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Selector de elementos por página
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        value: proveedorProvider.itemsPerPage,
                        onChanged: (int? newValue) {
                          if (newValue != null) {
                            proveedorProvider.setItemsPerPage(newValue);
                          }
                        },
                        items: [10, 20, 50, 100].map((int value) {
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
            ),
          ],
        ],
      ),
        );
      },
    );
  }

  Widget _buildComprasTable(CompraProvider compraProvider) {
    final paginatedCompras = compraProvider.paginatedCompras;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 1024;

        // En mobile, mostrar tarjetas
        if (isMobile) {
          if (paginatedCompras.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: const Center(
                child: Column(
                  children: [
                    Icon(Icons.shopping_bag_outlined, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No hay compras para mostrar',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: paginatedCompras
                  .map((compra) => CompraCard(compra: compra))
                  .toList(),
            ),
          );
        }

        // En desktop, mostrar tabla
        return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!, width: 1),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12), // Reducido de 16 a 12
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
                if (paginatedCompras.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24), // Reducido de 40 a 24
                    child: const Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 32, // Reducido de 48 a 32
                            color: Colors.grey,
                          ),
                          SizedBox(height: 12), // Reducido de 16 a 12
                          Text(
                            'No hay compras para mostrar',
                            style: TextStyle(
                              fontSize: 14, // Reducido de 16 a 14
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Column(
                    children: paginatedCompras.asMap().entries.map((entry) {
                      final index = entry.key;
                      final compra = entry.value;
                      return Container(
                        decoration: BoxDecoration(
                          color: index.isEven ? Colors.grey[50] : Colors.white,
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey[100]!, width: 0.5)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8), // Reducido de 12 a 8
                          child: Row(
                            children: [
                              Expanded(flex: 1, child: _buildCell(compra.id)),
                              Expanded(
                                  flex: 2, child: _buildCell(compra.proveedor)),
                              Expanded(
                                  flex: 1, child: _buildCell(compra.fecha)),
                              Expanded(
                                  flex: 1,
                                  child: _buildMoneyCell(compra.montoTotal)),
                              Expanded(
                                  flex: 1, child: _buildCell(compra.categoria)),
                              Expanded(
                                flex: 1,
                                child: Center(
                                    child:
                                        _buildCompraEstadoCell(compra.estado)),
                              ),
                              Expanded(
                                  flex: 1, child: _buildCell(compra.items)),
                              Expanded(
                                  flex: 1,
                                  child: _buildCell(compra.fechaEntrega)),
                              Expanded(
                                  flex: 1,
                                  child: _buildCompraOpcionesCell(compra)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12), // Reducido de 16 a 12
          // Controles de paginación usando el provider
          if (compraProvider.totalPages > 1) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  // Información de la página
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Mostrando ${compraProvider.paginatedCompras.length} de ${compraProvider.totalItems} compras',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Controles de navegación
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Botón anterior
                      IconButton(
                        onPressed: compraProvider.currentPage > 1
                            ? () => compraProvider.previousPage()
                            : null,
                        icon: const Icon(Icons.chevron_left),
                        color: compraProvider.currentPage > 1
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
                          '${compraProvider.currentPage}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      // Separador
                      Text(
                        ' de ${compraProvider.totalPages}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      // Botón siguiente
                      IconButton(
                        onPressed: compraProvider.hasMorePages
                            ? () => compraProvider.nextPage()
                            : null,
                        icon: const Icon(Icons.chevron_right),
                        color: compraProvider.hasMorePages
                            ? CeasColors.primaryBlue
                            : Colors.grey.shade400,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Selector de elementos por página
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        value: compraProvider.itemsPerPage,
                        onChanged: (int? newValue) {
                          if (newValue != null) {
                            compraProvider.setItemsPerPage(newValue);
                          }
                        },
                        items: [10, 20, 50, 100].map((int value) {
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
            ),
          ],
        ],
      ),
        );
      },
    );
  }

  Widget _buildHeaderCell(String text, [TextAlign textAlign = TextAlign.left]) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: CeasColors.primaryBlue,
        fontSize: 14,
      ),
      textAlign: textAlign,
    );
  }

  Widget _buildCell(String text, [TextAlign textAlign = TextAlign.left]) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14),
      textAlign: textAlign,
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
      case 'Pendiente':
        color = Colors.amber;
        break;
      case 'Completada':
        color = Colors.green;
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

  Widget _buildProveedorOpcionesCell(Proveedor proveedor) {
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

  Widget _buildCompraOpcionesCell(Compra compra) {
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
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'view', child: Text('Ver Detalle')),
        PopupMenuItem(value: 'edit', child: Text('Editar')),
        PopupMenuItem(value: 'delete', child: Text('Eliminar')),
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

  void _showEditProviderDialog(Proveedor proveedor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar Proveedor - ${proveedor.nombre}'),
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

  void _showProviderHistoryDialog(Proveedor proveedor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Historial - ${proveedor.nombre}'),
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

  void _showDeleteProviderDialog(Proveedor proveedor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Proveedor - ${proveedor.nombre}'),
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

  void _showViewPurchaseDialog(Compra compra) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalle de Compra - ${compra.id}'),
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

  void _showEditPurchaseDialog(Compra compra) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar Compra - ${compra.id}'),
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

  void _showDeletePurchaseDialog(Compra compra) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Compra - ${compra.id}'),
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
            _descargarReporteCompras,
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

  /// Descarga el reporte de compras en formato PDF
  Future<void> _descargarReporteCompras() async {
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

      final pdfBytes = await CompraService.downloadReporteCompras(
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
        ..setAttribute('download', 'reporte_compras_${DateTime.now().millisecondsSinceEpoch}.pdf')
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
