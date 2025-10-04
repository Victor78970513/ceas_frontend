import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/ceas_colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/finance_provider.dart';
import '../models/movimiento_financiero.dart';
import '../widgets/agregar_movimiento_bottom_sheet.dart';

class IncomeExpenseReportScreen extends StatefulWidget {
  const IncomeExpenseReportScreen({Key? key}) : super(key: key);

  @override
  State<IncomeExpenseReportScreen> createState() =>
      _IncomeExpenseReportScreenState();
}

class _IncomeExpenseReportScreenState extends State<IncomeExpenseReportScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar datos al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated) {
        final financeProvider =
            Provider.of<FinanceProvider>(context, listen: false);
        // Cargar tanto movimientos como resumen de BI
        financeProvider.loadMovimientos(authProvider.user!.accessToken);
        financeProvider.loadResumen(authProvider.user!.accessToken);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FinanceProvider>(
      builder: (context, financeProvider, child) {
        final estadisticas = financeProvider.getEstadisticas();
        final saldosPorClub = financeProvider.getSaldosPorClub();

        final totalIngresos = estadisticas['ingresos'] ?? 0.0;
        final totalEgresos = estadisticas['egresos'] ?? 0.0;
        final balance = estadisticas['balance'] ?? 0.0;

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
                          Icons.account_balance_rounded,
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
                              'Gestión Financiera',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Administra ingresos, egresos y reportes financieros',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _showAgregarMovimientoDialog(context),
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Agregar Movimiento'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: CeasColors.primaryBlue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Estadísticas principales
                financeProvider.isLoadingResumen
                    ? Row(
                        children: [
                          Expanded(
                            child: _buildLoadingStatCard('Balance Total'),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildLoadingStatCard('Ingresos'),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildLoadingStatCard('Egresos'),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildLoadingStatCard('Movimientos'),
                          ),
                        ],
                      )
                    : financeProvider.errorResumen != null
                        ? _buildErrorCard(financeProvider.errorResumen!)
                        : Row(
                            children: [
                              _buildStatCard(
                                  'Balance Total',
                                  'Bs. ${balance.toStringAsFixed(0)}',
                                  Icons.account_balance_wallet_rounded,
                                  balance >= 0 ? Colors.green : Colors.red,
                                  financeProvider.getPeriodoResumen() ??
                                      'Saldo actual'),
                              const SizedBox(width: 16),
                              _buildStatCard(
                                  'Ingresos',
                                  'Bs. ${totalIngresos.toStringAsFixed(0)}',
                                  Icons.trending_up_rounded,
                                  Colors.green,
                                  financeProvider.getPeriodoResumen() ??
                                      'Este mes'),
                              const SizedBox(width: 16),
                              _buildStatCard(
                                  'Egresos',
                                  'Bs. ${totalEgresos.toStringAsFixed(0)}',
                                  Icons.trending_down_rounded,
                                  Colors.red,
                                  financeProvider.getPeriodoResumen() ??
                                      'Este mes'),
                              const SizedBox(width: 16),
                              _buildStatCard(
                                  'Movimientos',
                                  financeProvider
                                      .getMovimientosCount()
                                      .toString(),
                                  Icons.swap_horiz_rounded,
                                  CeasColors.primaryBlue,
                                  'Total del período'),
                            ],
                          ),
                const SizedBox(height: 24),

                // Saldos mensuales por club
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey[200]!, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: CeasColors.primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.account_balance_rounded,
                                color: CeasColors.primaryBlue,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Saldos Mensuales por Club',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: CeasColors.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            ...saldosPorClub.entries.map((entry) {
                              final clubName = entry.key;
                              final saldo = entry.value;
                              final ingresos = saldo['ingresos'] ?? 0.0;
                              final egresos = saldo['egresos'] ?? 0.0;
                              final balance = saldo['balance'] ?? 0.0;

                              // Asignar colores basados en el balance
                              Color color;
                              IconData icon;
                              if (clubName.contains('La Paz')) {
                                color = Colors.blue;
                                icon = Icons.location_city_rounded;
                              } else if (clubName.contains('Santa Cruz')) {
                                color = Colors.green;
                                icon = Icons.north_rounded;
                              } else if (clubName.contains('Cochabamba')) {
                                color = Colors.orange;
                                icon = Icons.south_rounded;
                              } else {
                                color = Colors.purple;
                                icon = Icons.east_rounded;
                              }

                              return Expanded(
                                child: _buildClubBalanceCard(
                                  clubName,
                                  ingresos,
                                  egresos,
                                  icon,
                                  color,
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Filtros
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey[200]!, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: CeasColors.primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.filter_alt_rounded,
                                color: CeasColors.primaryBlue,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Filtros y Búsqueda',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: CeasColors.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Filtros con títulos descriptivos
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Título de la sección de filtros
                            const Text(
                              'Filtros de Búsqueda',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 12),

                            Row(
                              children: [
                                // Filtro de búsqueda
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Buscar',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.grey[200]!),
                                        ),
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText:
                                                'Buscar por descripción o ID...',
                                            hintStyle: TextStyle(
                                                color: Colors.grey[500]),
                                            prefixIcon: const Icon(
                                                Icons.search_rounded,
                                                color: Colors.grey),
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 16),
                                          ),
                                          onChanged: (v) =>
                                              financeProvider.updateSearch(v),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Filtro de tipo
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Tipo de Movimiento',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      _buildFilterDropdown(
                                          'Tipo',
                                          financeProvider.filterTipo,
                                          financeProvider.tiposMovimiento,
                                          (v) => financeProvider
                                              .updateFilterTipo(v)),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Filtro de estado
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Estado del Movimiento',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      _buildFilterDropdown(
                                          'Estado',
                                          financeProvider.filterEstado,
                                          financeProvider.estadosMovimiento,
                                          (v) => financeProvider
                                              .updateFilterEstado(v)),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Filtro de club
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Club',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      _buildFilterDropdown(
                                          'Club',
                                          financeProvider.filterClub,
                                          financeProvider.clubs,
                                          (v) => financeProvider
                                              .updateFilterClub(v)),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Botón de limpiar filtros
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                        height:
                                            20), // Espacio para alinear con los campos
                                    ElevatedButton.icon(
                                      onPressed: () =>
                                          _limpiarTodosLosFiltros(),
                                      icon: const Icon(Icons.clear_all_rounded),
                                      label: const Text('Limpiar'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey.shade300,
                                        foregroundColor: Colors.grey.shade700,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Tabla de movimientos financieros
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey[200]!, width: 1),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: CeasColors.primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.swap_horiz_rounded,
                                color: CeasColors.primaryBlue,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Movimientos Financieros',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: CeasColors.primaryBlue,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: CeasColors.primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${financeProvider.totalItems} movimientos encontrados (Página ${financeProvider.currentPage} de ${financeProvider.totalPages})',
                                style: const TextStyle(
                                  color: CeasColors.primaryBlue,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton.icon(
                              onPressed: () => _exportarBalances(),
                              icon: const Icon(Icons.download_rounded),
                              label: const Text('Exportar'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CeasColors.primaryBlue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            // Header de la tabla
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              decoration: BoxDecoration(
                                color: CeasColors.primaryBlue.withOpacity(0.05),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey[200]!, width: 1),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1, child: _buildHeaderCell('ID')),
                                  Expanded(
                                      flex: 2,
                                      child: _buildHeaderCell('Descripción')),
                                  Expanded(
                                      flex: 1,
                                      child: _buildHeaderCell(
                                          'Tipo', TextAlign.center)),
                                  Flexible(
                                      flex: 1,
                                      child: Center(
                                          child: _buildHeaderCell('Estado'))),
                                  Expanded(
                                      flex: 1, child: _buildHeaderCell('Club')),
                                  Expanded(
                                      flex: 1,
                                      child: _buildHeaderCell('Monto')),
                                  Expanded(
                                      flex: 1,
                                      child: _buildHeaderCell('Fecha')),
                                  Expanded(
                                      flex: 1,
                                      child: _buildHeaderCell(
                                          'Acciones', TextAlign.center)),
                                ],
                              ),
                            ),
                            // Filas de la tabla
                            ...financeProvider.paginatedMovimientos
                                .asMap()
                                .entries
                                .map((entry) {
                              final index = entry.key;
                              final m = entry.value;
                              return Container(
                                decoration: BoxDecoration(
                                  color: index.isEven
                                      ? Colors.grey[50]
                                      : Colors.white,
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey[100]!, width: 0.5),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 1, child: _buildCell(m.id)),
                                      Expanded(
                                          flex: 2,
                                          child: _buildCell(m.descripcion)),
                                      Expanded(
                                          flex: 1,
                                          child: Center(
                                              child: _buildTipoMovimientoCell(
                                                  m.tipo))),
                                      Flexible(
                                          flex: 1,
                                          child: Center(
                                              child: _buildEstadoMovimientoCell(
                                                  m.estadoDisplay))),
                                      Expanded(
                                          flex: 1, child: _buildCell(m.club)),
                                      Expanded(
                                          flex: 1,
                                          child: _buildMoneyCell(m.monto)),
                                      Expanded(
                                          flex: 1,
                                          child: _buildCell(m.fechaDisplay)),
                                      Expanded(
                                          flex: 1,
                                          child: _buildAccionesCell(m)),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),

                            // Controles de paginación
                            if (financeProvider.totalPages > 1) ...[
                              Container(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Información de la página
                                    Text(
                                      'Mostrando ${financeProvider.paginatedMovimientos.length} de ${financeProvider.totalItems} movimientos',
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
                                          onPressed:
                                              financeProvider.currentPage > 1
                                                  ? () => financeProvider
                                                      .previousPage()
                                                  : null,
                                          icon: const Icon(Icons.chevron_left),
                                          color: financeProvider.currentPage > 1
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
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '${financeProvider.currentPage}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),

                                        // Separador
                                        Text(
                                          ' de ${financeProvider.totalPages}',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),

                                        // Botón siguiente
                                        IconButton(
                                          onPressed: financeProvider
                                                  .hasMorePages
                                              ? () => financeProvider.nextPage()
                                              : null,
                                          icon: const Icon(Icons.chevron_right),
                                          color: financeProvider.hasMorePages
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
                                          value: financeProvider.itemsPerPage,
                                          onChanged: (int? newValue) {
                                            if (newValue != null) {
                                              financeProvider
                                                  .setItemsPerPage(newValue);
                                            }
                                          },
                                          items: [10, 20, 50, 100]
                                              .map((int value) {
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color, String subtitle) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(value,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: color)),
                  Text(subtitle,
                      style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClubBalanceCard(String clubName, double ingresos, double egresos,
      IconData icon, Color color) {
    final balance = ingresos - egresos;
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(clubName,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('Saldo: Bs. ${balance.toStringAsFixed(0)}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: color)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildDetailRow(
                      'Ingresos', 'Bs. ${ingresos.toStringAsFixed(0)}'),
                  const SizedBox(width: 10),
                  _buildDetailRow(
                      'Egresos', 'Bs. ${egresos.toStringAsFixed(0)}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterDropdown(String label, String value, List<String> items,
      Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: DropdownButton<String>(
        value: value,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        underline: Container(),
        style: const TextStyle(
            fontWeight: FontWeight.w500, color: CeasColors.primaryBlue),
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
      ),
    );
  }

  Widget _buildHeaderCell(String text, [TextAlign textAlign = TextAlign.left]) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 13,
        color: CeasColors.primaryBlue,
      ),
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }

  Widget _buildCell(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildMoneyCell(double amount) {
    return Text(
      'Bs. ${amount.toStringAsFixed(0)}',
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: CeasColors.primaryBlue,
      ),
    );
  }

  Widget _buildTipoMovimientoCell(String tipo) {
    return _tipoMovimientoBadge(tipo);
  }

  Widget _buildEstadoMovimientoCell(String estado) {
    return _estadoMovimientoBadge(estado);
  }

  Widget _buildAccionesCell(MovimientoFinanciero movimiento) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Botón Ver Detalle
        Container(
          margin: const EdgeInsets.only(right: 4),
          child: Tooltip(
            message: 'Ver Detalle',
            child: InkWell(
              onTap: () => _showDetalleMovimientoDialog(context, movimiento),
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: CeasColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: CeasColors.primaryBlue.withOpacity(0.3),
                  ),
                ),
                child: Icon(
                  Icons.visibility,
                  color: CeasColors.primaryBlue,
                  size: 16,
                ),
              ),
            ),
          ),
        ),

        // Botón Editar
        Container(
          margin: const EdgeInsets.only(right: 4),
          child: Tooltip(
            message: 'Editar',
            child: InkWell(
              onTap: () => _showEditarMovimientoDialog(context, movimiento),
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Icon(
                  Icons.edit,
                  color: Colors.orange.shade600,
                  size: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _tipoMovimientoBadge(String tipo) {
    Color color = tipo == 'Ingreso' ? Colors.green : Colors.red;
    return IntrinsicWidth(
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Text(tipo,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 11)),
        ),
      ),
    );
  }

  Widget _estadoMovimientoBadge(String estado) {
    Color color;
    switch (estado) {
      case 'Confirmado':
        color = Colors.green;
        break;
      case 'Pendiente':
        color = Colors.orange;
        break;
      case 'Cancelado':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(estado,
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 11)),
      ),
    );
  }

  void _showAgregarMovimientoDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AgregarMovimientoBottomSheet(
        onMovimientoCreado: () {
          // El provider ya recarga automáticamente
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showDetalleMovimientoDialog(
      BuildContext context, MovimientoFinanciero movimiento) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalle del Movimiento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRowForDialog('ID', movimiento.id),
            _buildDetailRowForDialog('Descripción', movimiento.descripcion),
            _buildDetailRowForDialog('Tipo', movimiento.tipo),
            _buildDetailRowForDialog('Monto', 'Bs. ${movimiento.monto}'),
            _buildDetailRowForDialog('Estado', movimiento.estadoDisplay),
            _buildDetailRowForDialog('Club', movimiento.club),
            _buildDetailRowForDialog('Fecha', movimiento.fechaDisplay),
            _buildDetailRowForDialog('Categoría', movimiento.categoriaDisplay),
            if (movimiento.socio != null)
              _buildDetailRowForDialog('Socio', movimiento.socio!),
            if (movimiento.proveedor != null)
              _buildDetailRowForDialog('Proveedor', movimiento.proveedor!),
            _buildDetailRowForDialog('Comprobante', movimiento.comprobante),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showEditarMovimientoDialog(
      BuildContext context, MovimientoFinanciero movimiento) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Movimiento'),
        content: const Text('Funcionalidad de editar movimiento (ficticia)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Movimiento editado (ficticio)')),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRowForDialog(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _exportarBalances() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reporte financiero exportado (ficticio)')),
    );
  }

  /// Limpia todos los filtros
  void _limpiarTodosLosFiltros() {
    // Limpiar filtros del provider
    Provider.of<FinanceProvider>(context, listen: false).clearFilters();

    // Mostrar confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Todos los filtros han sido limpiados'),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// Construye una card de estadística en estado de carga
  Widget _buildLoadingStatCard(String title) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Container(
                    width: 60,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 40,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
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

  /// Construye una card de error para las estadísticas
  Widget _buildErrorCard(String error) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Error al cargar estadísticas',
                      style: TextStyle(fontSize: 12, color: Colors.red)),
                  const SizedBox(height: 4),
                  Text(error,
                      style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      final authProvider =
                          Provider.of<AuthProvider>(context, listen: false);
                      if (authProvider.isAuthenticated) {
                        Provider.of<FinanceProvider>(context, listen: false)
                            .loadResumen(authProvider.user!.accessToken);
                      }
                    },
                    child: const Text('Reintentar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
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
}
