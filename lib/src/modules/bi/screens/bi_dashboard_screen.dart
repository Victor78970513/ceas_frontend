import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/ceas_colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/bi_provider.dart';
import '../widgets/bi_fl_charts.dart';
import '../widgets/bi_movimientos_chart.dart';
import '../widgets/bi_personal_charts.dart';
import '../models/bi_kpi.dart';
import '../models/bi_top_club.dart';
import '../models/bi_top_socio.dart';

class BiDashboardScreen extends StatefulWidget {
  const BiDashboardScreen({Key? key}) : super(key: key);

  @override
  State<BiDashboardScreen> createState() => _BiDashboardScreenState();
}

class _BiDashboardScreenState extends State<BiDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated) {
        Provider.of<BiProvider>(context, listen: false).loadAllData(
          authProvider.user!.accessToken,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Consumer<BiProvider>(
        builder: (context, biProvider, child) {
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
              //       'Business Intelligence - Dashboard Avanzado',
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
              //           biProvider.refresh(authProvider.user!.accessToken);
              //         }
              //       },
              //       icon:
              //           const Icon(Icons.refresh_rounded, color: Colors.white),
              //       tooltip: 'Actualizar dashboard',
              //     ),
              //   ],
              // ),

              // Contenido del dashboard BI
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Información del período y estado general
                      if (biProvider.hasData) ...[
                        _buildPeriodoHeader(biProvider),
                        const SizedBox(height: 24),
                      ],

                      // Estado de carga o error
                      if (biProvider.isLoading)
                        const Center(
                          child: Column(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('Cargando Business Intelligence...'),
                            ],
                          ),
                        )
                      else if (biProvider.error != null)
                        _buildErrorCard(biProvider.error!)
                      else if (biProvider.hasData) ...[
                        // Métricas principales
                        _buildMetricasPrincipales(biProvider),
                        const SizedBox(height: 24),

                        // Gráficas de Personal del CEAS
                        _buildPersonalSection(biProvider),
                        const SizedBox(height: 24),

                        // Alertas críticas (más arriba para mayor visibilidad)
                        _buildAlertasCriticas(biProvider),
                        const SizedBox(height: 24),

                        // Gráfico de movimientos financieros
                        _buildGraficoMovimientosFinancieros(biProvider),
                        const SizedBox(height: 24),

                        // Gráfico de barras para métricas financieras
                        _buildGraficoMetricasFinancieras(biProvider),
                        const SizedBox(height: 24),

                        // KPIs principales
                        _buildKpisPrincipales(biProvider),
                        const SizedBox(height: 24),

                        // Gráfico de líneas para KPIs
                        _buildGraficoLineas(biProvider),
                        const SizedBox(height: 24),

                        // Gráficos de distribución
                        _buildGraficosDistribucion(biProvider),
                        const SizedBox(height: 24),

                        // Top clubes y socios con gráficos
                        _buildTopRankings(biProvider),
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

  Widget _buildPeriodoHeader(BiProvider provider) {
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
              Icons.analytics,
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
                  'Período: ${provider.periodoActual}',
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: provider.estadoGeneralColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: provider.estadoGeneralColor),
            ),
            child: Text(
              provider.estadoGeneral,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: provider.estadoGeneralColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumenRapido(BiProvider provider) {
    final resumen = provider.resumenRapido;
    if (resumen == null) return const SizedBox.shrink();

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
                child:
                    const Icon(Icons.summarize, color: Colors.blue, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Resumen Rápido',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  child: _buildResumenCard('Balance Neto',
                      resumen.balanceNetoFormatted, resumen.balanceNetoColor)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildResumenCard(
                      'Margen',
                      resumen.margenRentabilidadFormatted,
                      resumen.margenRentabilidadColor)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildResumenCard(
                      'Socios', '${resumen.totalSocios}', Colors.blue)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildResumenCard(
                      'Retención',
                      resumen.tasaRetencionFormatted,
                      resumen.tasaRetencionColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResumenCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricasPrincipales(BiProvider provider) {
    final metricasFin = provider.metricasFinancieras;
    final metricasAdmin = provider.metricasAdministrativas;

    if (metricasFin == null || metricasAdmin == null)
      return const SizedBox.shrink();

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
              metricasFin.ingresosFormatted,
              Icons.trending_up,
              Colors.green,
            )),
            const SizedBox(width: 16),
            Expanded(
                child: _buildMetricaCard(
              'Egresos Totales',
              metricasFin.egresosFormatted,
              Icons.trending_down,
              Colors.red,
            )),
            const SizedBox(width: 16),
            Expanded(
                child: _buildMetricaCard(
              'Balance Neto',
              metricasFin.balanceFormatted,
              Icons.account_balance_wallet,
              metricasFin.balanceColor,
            )),
            const SizedBox(width: 16),
            Expanded(
                child: _buildMetricaCard(
              'Margen Rentabilidad',
              metricasFin.margenFormatted,
              Icons.percent,
              metricasFin.margenColor,
            )),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
                child: _buildMetricaCard(
              'Total Socios',
              '${metricasAdmin.totalSocios}',
              Icons.people,
              CeasColors.primaryBlue,
            )),
            const SizedBox(width: 16),
            Expanded(
                child: _buildMetricaCard(
              'Socios Activos',
              '${metricasAdmin.sociosActivos}',
              Icons.check_circle,
              Colors.green,
            )),
            const SizedBox(width: 16),
            Expanded(
                child: _buildMetricaCard(
              'Tasa Retención',
              metricasAdmin.tasaRetencionFormatted,
              Icons.loyalty,
              metricasAdmin.tasaRetencionColor,
            )),
            const SizedBox(width: 16),
            Expanded(
                child: _buildMetricaCard(
              'Eficiencia Operativa',
              metricasAdmin.eficienciaOperativaFormatted,
              Icons.speed,
              metricasAdmin.eficienciaOperativaColor,
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

  Widget _buildGraficoMetricasFinancieras(BiProvider provider) {
    final metricasFin = provider.metricasFinancieras;
    if (metricasFin == null) return const SizedBox.shrink();

    return BiBarChart(
      title: 'Métricas Financieras Principales',
      metricas: metricasFin,
    );
  }

  Widget _buildKpisPrincipales(BiProvider provider) {
    final kpis = provider.kpis;

    if (kpis.isEmpty) return const SizedBox.shrink();

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

  Widget _buildKpiCard(BiKpi kpi) {
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
                  kpi.estadoDisplay,
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
                    kpi.cambioPorcentualFormatted,
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

  Widget _buildGraficosDistribucion(BiProvider provider) {
    final distribucion = provider.distribucionFinanciera;
    if (distribucion == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Distribución Financiera',
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
              child: BiPieChart(
                title: 'Distribución de Ingresos',
                data: distribucion.ingresos,
                colors: [
                  Colors.green,
                  Colors.blue,
                  Colors.orange,
                  Colors.purple
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: BiPieChart(
                title: 'Distribución de Egresos',
                data: distribucion.egresos,
                colors: [Colors.red, Colors.pink, Colors.deepOrange],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopRankings(BiProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rankings y Top Performers',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 20),

        // Gráficos de rankings
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BiHorizontalBarChart(
                title: 'Balance por Club',
                data: provider.topClubes,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildTopSociosChart(provider),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Datos detallados de rankings
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildTopClubes(provider)),
            const SizedBox(width: 24),
            Expanded(child: _buildTopSocios(provider)),
          ],
        ),
      ],
    );
  }

  Widget _buildTopClubes(BiProvider provider) {
    final clubes = provider.topClubes;

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

  Widget _buildClubItem(BiTopClub club) {
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

  Widget _buildTopSocios(BiProvider provider) {
    final socios = provider.topSocios;

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
          // const SizedBox(height: 20),
          ...socios.map((socio) => _buildSocioItem(socio)).toList(),
        ],
      ),
    );
  }

  Widget _buildSocioItem(BiTopSocio socio) {
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

  Widget _buildGraficoLineas(BiProvider provider) {
    final kpis = provider.kpis;

    if (kpis.isEmpty) return const SizedBox.shrink();

    return BiLineChart(
      title: 'Tendencia de KPIs',
      data: kpis,
    );
  }

  Widget _buildAlertasCriticas(BiProvider provider) {
    final alertas = provider.alertas;

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
            'Error al cargar Business Intelligence',
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
                Provider.of<BiProvider>(context, listen: false).loadAllData(
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

  Widget _buildTopSociosChart(BiProvider provider) {
    final socios = provider.topSocios;
    if (socios.isEmpty) return const SizedBox.shrink();

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
          Text(
            'Acciones por Socio',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            // height: 200,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: socios.length,
              itemBuilder: (context, index) {
                final socio = socios[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: Text(
                          socio.nombreCompleto.split(' ').take(2).join(' '),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(flex: 1, child: SizedBox()),
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: socio.accionesCompradas /
                                _getMaxAcciones(provider.topSocios),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 35,
                        child: Text(
                          '${socio.accionesCompradas}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  double _getMaxAcciones(List<BiTopSocio> socios) {
    if (socios.isEmpty) return 5;
    final maxAcciones =
        socios.map((e) => e.accionesCompradas).reduce((a, b) => a > b ? a : b);
    return maxAcciones.toDouble() * 1.2;
  }

  Widget _buildGraficoMovimientosFinancieros(BiProvider provider) {
    final movimientos = provider.movimientosFinancieros;
    if (movimientos == null) return const SizedBox.shrink();

    return BiMovimientosChart(data: movimientos);
  }

  // Sección de Personal del CEAS
  Widget _buildPersonalSection(BiProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header de la sección
        Container(
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
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple.shade600,
                      Colors.purple.shade400,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.people_alt_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personal del CEAS',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Análisis completo del personal y asistencia',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Gráficas de personal
        if (provider.personalMetricasGenerales != null) ...[
          BiPersonalMetricasGeneralesChart(
            data: provider.personalMetricasGenerales!,
          ),
          const SizedBox(height: 24),
        ],

        if (provider.personalMetricasAsistencia != null) ...[
          BiPersonalMetricasAsistenciaChart(
            data: provider.personalMetricasAsistencia!,
          ),
          const SizedBox(height: 24),
        ],

        // Placeholder para gráficas futuras
        if (provider.personalMetricasGenerales == null &&
            provider.personalMetricasAsistencia == null) ...[
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.people_alt_outlined,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Cargando datos de personal...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
