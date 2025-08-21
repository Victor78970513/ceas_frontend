import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/ceas_colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';
import '../models/dashboard_administrativo.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated) {
        Provider.of<DashboardProvider>(context, listen: false).loadDashboard(
          authProvider.user!.accessToken,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Consumer<DashboardProvider>(
        builder: (context, dashboardProvider, child) {
          return CustomScrollView(
            slivers: [
              // Header principal
              // SliverAppBar(
              //   expandedHeight: 120,
              //   floating: false,
              //   pinned: true,
              //   backgroundColor: CeasColors.primaryBlue,
              //   flexibleSpace: FlexibleSpaceBar(
              //     title: const Text(
              //       'Dashboard',
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //     background: Container(
              //       decoration: BoxDecoration(
              //         gradient: LinearGradient(
              //           begin: Alignment.topLeft,
              //           end: Alignment.bottomRight,
              //           colors: [
              //             CeasColors.primaryBlue,
              //             CeasColors.primaryBlue.withOpacity(0.8),
              //           ],
              //         ),
              //       ),
              //       child: Stack(
              //         children: [
              //           Positioned(
              //             right: -50,
              //             top: -50,
              //             child: Container(
              //               width: 200,
              //               height: 200,
              //               decoration: BoxDecoration(
              //                 color: Colors.white.withOpacity(0.1),
              //                 shape: BoxShape.circle,
              //               ),
              //             ),
              //           ),
              //           Positioned(
              //             left: -30,
              //             bottom: -30,
              //             child: Container(
              //               width: 150,
              //               height: 150,
              //               decoration: BoxDecoration(
              //                 color: Colors.white.withOpacity(0.05),
              //                 shape: BoxShape.circle,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              //   actions: [
              //     IconButton(
              //       onPressed: () {
              //         final authProvider =
              //             Provider.of<AuthProvider>(context, listen: false);
              //         if (authProvider.isAuthenticated) {
              //           dashboardProvider
              //               .refresh(authProvider.user!.accessToken);
              //         }
              //       },
              //       icon:
              //           const Icon(Icons.refresh_rounded, color: Colors.white),
              //       tooltip: 'Actualizar dashboard',
              //     ),
              //   ],
              // ),

              // Contenido del dashboard
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Información del período
                      if (dashboardProvider.hasData) ...[
                        _buildPeriodoHeader(dashboardProvider),
                        const SizedBox(height: 24),
                      ],

                      // Estado de carga o error
                      if (dashboardProvider.isLoading)
                        const Center(
                          child: Column(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('Cargando dashboard...'),
                            ],
                          ),
                        )
                      else if (dashboardProvider.error != null)
                        _buildErrorCard(dashboardProvider.error!)
                      else if (dashboardProvider.hasData) ...[
                        // Métricas principales
                        _buildMetricasPrincipales(dashboardProvider),
                        const SizedBox(height: 24),

                        // KPIs principales
                        _buildKpisPrincipales(dashboardProvider),
                        const SizedBox(height: 24),

                        // Distribuciones
                        Row(
                          children: [
                            Expanded(
                                child: _buildDistribucionIngresos(
                                    dashboardProvider)),
                            const SizedBox(width: 24),
                            Expanded(
                                child: _buildDistribucionEgresos(
                                    dashboardProvider)),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Top clubes y socios
                        Row(
                          children: [
                            Expanded(child: _buildTopClubes(dashboardProvider)),
                            const SizedBox(width: 24),
                            Expanded(child: _buildTopSocios(dashboardProvider)),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Alertas críticas
                        _buildAlertasCriticas(dashboardProvider),
                        const SizedBox(height: 24),

                        // Tendencias mensuales
                        _buildTendenciasMensuales(dashboardProvider),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPeriodoHeader(DashboardProvider provider) {
    return Container(
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: CeasColors.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.calendar_today_rounded,
              color: CeasColors.primaryBlue,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Período: ${provider.getPeriodo()}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Última actualización: ${_formatDateTime(provider.lastUpdated)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricasPrincipales(DashboardProvider provider) {
    final metricasFin = provider.getMetricasFinancierasResumen();
    final metricasAdmin = provider.getMetricasAdministrativasResumen();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Métricas Principales',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
                child: _buildMetricaCard(
              'Ingresos Totales',
              metricasFin['ingresos'] ?? 'N/A',
              Icons.trending_up,
              Colors.green,
            )),
            const SizedBox(width: 16),
            Expanded(
                child: _buildMetricaCard(
              'Egresos Totales',
              metricasFin['egresos'] ?? 'N/A',
              Icons.trending_down,
              Colors.red,
            )),
            const SizedBox(width: 16),
            Expanded(
                child: _buildMetricaCard(
              'Balance Neto',
              metricasFin['balance'] ?? 'N/A',
              Icons.account_balance_wallet,
              provider.dashboard?.metricasFinancieras.balanceColor ??
                  Colors.grey,
            )),
            const SizedBox(width: 16),
            Expanded(
                child: _buildMetricaCard(
              'Margen Rentabilidad',
              metricasFin['margen'] ?? 'N/A',
              Icons.percent,
              provider.dashboard?.metricasFinancieras.margenColor ??
                  Colors.grey,
            )),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
                child: _buildMetricaCard(
              'Total Socios',
              '${metricasAdmin['total_socios'] ?? 0}',
              Icons.people,
              CeasColors.primaryBlue,
            )),
            const SizedBox(width: 16),
            Expanded(
                child: _buildMetricaCard(
              'Socios Activos',
              '${metricasAdmin['socios_activos'] ?? 0}',
              Icons.check_circle,
              Colors.green,
            )),
            const SizedBox(width: 16),
            Expanded(
                child: _buildMetricaCard(
              'Tasa Retención',
              metricasAdmin['tasa_retencion'] ?? 'N/A',
              Icons.loyalty,
              provider.dashboard?.metricasAdministrativas.tasaRetencionColor ??
                  Colors.grey,
            )),
            const SizedBox(width: 16),
            Expanded(
                child: _buildMetricaCard(
              'Eficiencia Operativa',
              metricasAdmin['eficiencia'] ?? 'N/A',
              Icons.speed,
              provider.dashboard?.metricasAdministrativas.eficienciaColor ??
                  Colors.grey,
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricaCard(
      String title, String value, IconData icon, Color color) {
    return Container(
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
                child: Icon(icon, color: color, size: 20),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
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
    );
  }

  Widget _buildKpisPrincipales(DashboardProvider provider) {
    final kpis = provider.getKpisPrincipales();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'KPIs Principales',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 20),
        ...kpis.map((kpi) => _buildKpiCard(kpi)).toList(),
      ],
    );
  }

  Widget _buildKpiCard(KpiPrincipal kpi) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kpi.estadoColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              kpi.cambioIcon,
              color: kpi.estadoColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kpi.nombre,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Actual: ${kpi.valorActualFormatted}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Meta: ${kpi.metaFormatted}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: kpi.estadoColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  kpi.estado.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: kpi.estadoColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    kpi.cambioIcon,
                    color: kpi.cambioColor,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    kpi.cambioFormatted,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: kpi.cambioColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDistribucionIngresos(DashboardProvider provider) {
    final distribucion = provider.getDistribucionIngresos();

    return Container(
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
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.trending_up,
                    color: Colors.green, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Distribución de Ingresos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...distribucion.map((item) => _buildDistribucionItem(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildDistribucionEgresos(DashboardProvider provider) {
    final distribucion = provider.getDistribucionEgresos();

    return Container(
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
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.trending_down,
                    color: Colors.red, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Distribución de Egresos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...distribucion.map((item) => _buildDistribucionItem(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildDistribucionItem(dynamic item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              item.categoria,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.montoFormatted,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              item.porcentajeFormatted,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: item.tendenciaColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              item.tendenciaIcon,
              color: item.tendenciaColor,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopClubes(DashboardProvider provider) {
    final clubes = provider.getTopClubes();

    return Container(
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
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: CeasColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.business,
                    color: CeasColors.primaryBlue, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Top Clubes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...clubes.map((club) => _buildClubItem(club)).toList(),
        ],
      ),
    );
  }

  Widget _buildClubItem(TopClub club) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  club.nombreClub,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: club.rentabilidadColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  club.rentabilidadFormatted,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: club.rentabilidadColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ingresos: ${club.ingresosFormatted}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      'Egresos: ${club.egresosFormatted}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Balance: ${club.balanceFormatted}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: club.balanceColor,
                      ),
                    ),
                    Text(
                      'Socios: ${club.sociosActivos}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopSocios(DashboardProvider provider) {
    final socios = provider.getTopSocios();

    return Container(
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
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.person, color: Colors.orange, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Top Socios',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...socios.map((socio) => _buildSocioItem(socio)).toList(),
        ],
      ),
    );
  }

  Widget _buildSocioItem(TopSocio socio) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  socio.nombreCompleto,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: socio.estadoPagosColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  socio.estadoPagosDisplay,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: socio.estadoPagosColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Club: ${socio.clubPrincipal}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      'Acciones: ${socio.accionesCompradas}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Invertido: ${socio.totalInvertidoFormatted}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      'Antigüedad: ${socio.antiguedadFormatted}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlertasCriticas(DashboardProvider provider) {
    final alertas = provider.getAlertasCriticas();

    if (alertas.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.warning_rounded,
                    color: Colors.red, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Alertas Críticas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...alertas
              .map((alerta) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[100]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline,
                            color: Colors.red[600], size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            alerta,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.red[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildTendenciasMensuales(DashboardProvider provider) {
    final tendencias = provider.getTendenciasMensuales();

    if (tendencias.isEmpty) return const SizedBox.shrink();

    return Container(
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
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.timeline, color: Colors.blue, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Tendencias Mensuales',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...tendencias.values
              .map((tendencia) => _buildTendenciaItem(tendencia))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildTendenciaItem(TendenciaMensual tendencia) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Período ${tendencia.periodo}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Valor: ${tendencia.valorFormatted}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Anterior: ${tendencia.cambioFormatted}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Proyección: ${tendencia.proyeccionFormatted}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: tendencia.variacionColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  tendencia.variacionColor == Colors.green
                      ? Icons.trending_up
                      : Icons.trending_down,
                  color: tendencia.variacionColor,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  tendencia.variacionFormatted,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: tendencia.variacionColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String error) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red[600],
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Error al cargar el dashboard',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
              fontSize: 14,
              color: Colors.red[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              if (authProvider.isAuthenticated) {
                Provider.of<DashboardProvider>(context, listen: false)
                    .loadDashboard(
                  authProvider.user!.accessToken,
                );
              }
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Reintentar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
