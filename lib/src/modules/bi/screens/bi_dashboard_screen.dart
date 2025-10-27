import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/ceas_colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/bi_provider.dart';
import '../widgets/bi_movimientos_chart.dart';
import '../widgets/bi_personal_charts.dart';
import '../widgets/bi_premium_charts.dart';
import '../widgets/responsive_kpi_section.dart';

class BiDashboardScreen extends StatefulWidget {
  const BiDashboardScreen({Key? key}) : super(key: key);

  @override
  State<BiDashboardScreen> createState() => _BiDashboardScreenState();
}

class _BiDashboardScreenState extends State<BiDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated) {
        Provider.of<BiProvider>(context, listen: false).loadAllData(
          authProvider.user!.accessToken,
        );
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Consumer<BiProvider>(
        builder: (context, biProvider, child) {
          return CustomScrollView(
            slivers: [
              // Header principal con gradiente impresionante
              _buildHeroHeader(biProvider),
              
              // Contenido del dashboard
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        if (biProvider.isLoading)
                          _buildLoadingState()
                        else if (biProvider.error != null)
                          _buildErrorState(biProvider.error!)
                        else if (biProvider.hasData) ...[
                          // KPIs principales con diseño premium
                          ResponsiveKpiSection(provider: biProvider),
                          const SizedBox(height: 24),

                          // Métricas ejecutivas (métricas clave del sistema)
                          _buildPremiumMetrics(biProvider),
                          const SizedBox(height: 24),

                          // Métricas financieras destacadas
                          _buildFinancialMetrics(biProvider),
                          const SizedBox(height: 24),

                          // Gráficos premium
                          _buildPremiumCharts(biProvider),
                          const SizedBox(height: 32),

                          // Análisis de rendimiento
                          _buildPerformanceAnalysis(biProvider),
                          const SizedBox(height: 32),

                          // Gráficos interactivos
                          _buildInteractiveCharts(biProvider),
                          const SizedBox(height: 32),

                          // Top performers
                          _buildTopPerformers(biProvider),
                          const SizedBox(height: 32),

                          // Personal y asistencia
                          _buildPersonalInsights(biProvider),
                          const SizedBox(height: 32),

                          // Alertas y notificaciones
                          _buildAlertsSection(biProvider),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeroHeader(BiProvider provider) {
    return SliverAppBar(
      expandedHeight: 100,
      floating: false,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 50, 24, 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.grey.shade800,
                        Colors.grey.shade600,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.analytics_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Business Intelligence',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                if (provider.hasData)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.green.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Live',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(width: 16),
                IconButton(
                  alignment: Alignment.center,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    final authProvider =
                        Provider.of<AuthProvider>(context, listen: false);
                    if (authProvider.isAuthenticated) {
                      provider.loadAllData(
                        authProvider.user!.accessToken,
                      );
                    }
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    child: Icon(
                      Icons.refresh_rounded,
                      color: Colors.grey.shade700,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumKpis(BiProvider provider) {
    final metricasFin = provider.metricasFinancieras;
    final metricasAdmin = provider.metricasAdministrativas;

    if (metricasFin == null && metricasAdmin == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'KPIs Ejecutivos',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            if (metricasFin != null) ...[
              Expanded(
                child: _buildPremiumKpiCard(
                  'Balance Neto',
                  'Bs. ${metricasFin.balanceNeto.toStringAsFixed(0)}',
                  Icons.account_balance_wallet_rounded,
                  metricasFin.balanceNeto >= 0
                      ? Colors.green
                      : Colors.red,
                  metricasFin.balanceNeto >= 0 ? '+12.5%' : '-8.2%',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPremiumKpiCard(
                  'Total Ingresos',
                  'Bs. ${metricasFin.ingresosTotales.toStringAsFixed(0)}',
                  Icons.trending_up_rounded,
                  Colors.green,
                  '+15.3%',
                ),
              ),
            ],
            if (metricasAdmin != null) ...[
              const SizedBox(width: 16),
              Expanded(
                child: _buildPremiumKpiCard(
                  'Socios Activos',
                  '${metricasAdmin.sociosActivos}',
                  Icons.people_alt_rounded,
                  Colors.blue,
                  '+5.1%',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPremiumKpiCard(
                  'Eficiencia',
                  '${((metricasAdmin.sociosActivos / metricasAdmin.totalSocios) * 100).toStringAsFixed(1)}%',
                  Icons.speed_rounded,
                  Colors.purple,
                  '+2.8%',
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildPremiumKpiCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String change,
  ) {
    final isPositive = change.startsWith('+');
    final trendIcon = isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.08),
            color.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color,
                      color.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive 
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isPositive 
                        ? Colors.green.withOpacity(0.3)
                        : Colors.red.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      trendIcon,
                      color: isPositive ? Colors.green : Colors.red,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      change,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isPositive ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumCharts(BiProvider provider) {
    final metricasFin = provider.metricasFinancieras;
    final metricasAdmin = provider.metricasAdministrativas;

    return Row(
      children: [
        if (metricasFin != null) ...[
          Expanded(
            child: BiPremiumBarChart(
              title: 'Análisis Financiero',
              metricas: metricasFin,
            ),
          ),
          const SizedBox(width: 24),
        ],
        if (metricasAdmin != null) ...[
          Expanded(
            child: BiPremiumDonutChart(
              title: 'Distribución de Socios',
              metricas: metricasAdmin,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFinancialMetrics(BiProvider provider) {
    final metricasFin = provider.metricasFinancieras;
    if (metricasFin == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade600,
                      Colors.blue.shade400,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.attach_money_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Métricas Financieras',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Análisis completo del rendimiento financiero',
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
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Ingresos Totales',
                  'Bs. ${metricasFin.ingresosTotales.toStringAsFixed(0)}',
                  Icons.trending_up_rounded,
                  Colors.green,
                  '+15.3% vs mes anterior',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Egresos Totales',
                  'Bs. ${metricasFin.egresosTotales.toStringAsFixed(0)}',
                  Icons.trending_down_rounded,
                  Colors.red,
                  '+8.7% vs mes anterior',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Margen de Rentabilidad',
                  '${metricasFin.margenRentabilidad.toStringAsFixed(1)}%',
                  Icons.percent_rounded,
                  Colors.blue,
                  '+2.1% vs mes anterior',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 14),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'LIVE',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceAnalysis(BiProvider provider) {
    final metricasAdmin = provider.metricasAdministrativas;
    if (metricasAdmin == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.shade50,
            Colors.blue.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.purple.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple.shade600,
                      Colors.purple.shade400,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.analytics_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Análisis de Rendimiento',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Métricas clave de eficiencia operativa',
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
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: _buildPerformanceCard(
                  'Tasa de Retención',
                  '${((metricasAdmin.sociosActivos / metricasAdmin.totalSocios) * 100).toStringAsFixed(1)}%',
                  Colors.green,
                  'Excelente',
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildPerformanceCard(
                  'Total Socios',
                  '${metricasAdmin.totalSocios}',
                  Colors.blue,
                  'En crecimiento',
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildPerformanceCard(
                  'Socios Inactivos',
                  '${metricasAdmin.sociosInactivos}',
                  Colors.orange,
                  'Requiere atención',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard(
    String title,
    String value,
    Color color,
    String status,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
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
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveCharts(BiProvider provider) {
    return Column(
      children: [
        _buildQuickStats(provider),
        const SizedBox(height: 24),
        _buildMovimientosChart(provider),
      ],
    );
  }

  Widget _buildMovimientosChart(BiProvider provider) {
    final movimientos = provider.movimientosFinancieros;
    if (movimientos == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 12),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.shade600,
                      Colors.orange.shade400,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.show_chart_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Movimientos Financieros',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          BiMovimientosChart(data: movimientos),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BiProvider provider) {
    final metricasFin = provider.metricasFinancieras;
    final metricasAdmin = provider.metricasAdministrativas;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade900,
            Colors.grey.shade800,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 0,
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
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.dashboard_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Resumen Ejecutivo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'TIEMPO REAL',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              if (metricasFin != null) ...[
                Expanded(
                  child: _buildQuickStatItem(
                    'Balance Neto',
                    'Bs. ${metricasFin.balanceNeto.toStringAsFixed(0)}',
                    metricasFin.balanceNeto >= 0 ? Colors.green : Colors.red,
                    Icons.account_balance_wallet_rounded,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildQuickStatItem(
                    'Margen',
                    '${metricasFin.margenRentabilidad.toStringAsFixed(1)}%',
                    Colors.blue,
                    Icons.trending_up_rounded,
                  ),
                ),
              ],
              if (metricasAdmin != null) ...[
                const SizedBox(width: 20),
                Expanded(
                  child: _buildQuickStatItem(
                    'Socios Activos',
                    '${metricasAdmin.sociosActivos}',
                    Colors.orange,
                    Icons.people_alt_rounded,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildQuickStatItem(
                    'Retención',
                    '${((metricasAdmin.sociosActivos / metricasAdmin.totalSocios) * 100).toStringAsFixed(1)}%',
                    Colors.purple,
                    Icons.loyalty_rounded,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatItem(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTopPerformers(BiProvider provider) {
    final topClubes = provider.topClubes;
    if (topClubes.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 12),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.amber.shade600,
                      Colors.amber.shade400,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Top Performers',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Clubes con mejor rendimiento financiero',
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
          const SizedBox(height: 32),
          ...topClubes.take(3).toList().asMap().entries.map((entry) {
            final index = entry.key;
            final club = entry.value;
            final isFirst = index == 0;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isFirst ? Colors.amber.shade50 : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isFirst ? Colors.amber.shade200 : Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isFirst ? Colors.amber : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: isFirst
                          ? const Icon(Icons.emoji_events, color: Colors.white)
                          : Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          club.nombreClub,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: isFirst ? Colors.amber.shade800 : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Balance: Bs. ${club.balance.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: club.balance >= 0 ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    club.balance >= 0 ? Icons.trending_up : Icons.trending_down,
                    color: club.balance >= 0 ? Colors.green : Colors.red,
                    size: 24,
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPersonalInsights(BiProvider provider) {
    if (provider.personalMetricasGenerales == null &&
        provider.personalMetricasAsistencia == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.shade50,
            Colors.pink.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.purple.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple.shade600,
                      Colors.purple.shade400,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.people_alt_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Insights de Personal',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
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
          const SizedBox(height: 32),
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
          ],
        ],
      ),
    );
  }

  Widget _buildPremiumMetrics(BiProvider provider) {
    final metricasFin = provider.metricasFinancieras;
    final metricasAdmin = provider.metricasAdministrativas;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 0,
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
                  gradient: LinearGradient(
                    colors: [
                      Colors.indigo.shade600,
                      Colors.indigo.shade400,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.dashboard_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Métricas Ejecutivas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Métricas clave del sistema',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.0,
            children: [
              if (metricasFin != null) ...[
                _buildCompactMetricCard(
                  'Balance Neto',
                  'Bs. ${metricasFin.balanceNeto.toStringAsFixed(0)}',
                  Icons.account_balance_wallet_rounded,
                  metricasFin.balanceNeto >= 0 ? Colors.green : Colors.red,
                ),
                _buildCompactMetricCard(
                  'Total Ingresos',
                  'Bs. ${metricasFin.ingresosTotales.toStringAsFixed(0)}',
                  Icons.trending_up_rounded,
                  Colors.green,
                ),
                _buildCompactMetricCard(
                  'Total Egresos',
                  'Bs. ${metricasFin.egresosTotales.toStringAsFixed(0)}',
                  Icons.trending_down_rounded,
                  Colors.red,
                ),
                _buildCompactMetricCard(
                  'Margen',
                  '${metricasFin.margenRentabilidad.toStringAsFixed(1)}%',
                  Icons.percent_rounded,
                  Colors.blue,
                ),
              ],
              if (metricasAdmin != null) ...[
                _buildCompactMetricCard(
                  'Total Socios',
                  '${metricasAdmin.totalSocios}',
                  Icons.people_alt_rounded,
                  Colors.purple,
                ),
                _buildCompactMetricCard(
                  'Socios Activos',
                  '${metricasAdmin.sociosActivos}',
                  Icons.check_circle_rounded,
                  Colors.green,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.08),
            color.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
            spreadRadius: 0,
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
                  gradient: LinearGradient(
                    colors: [
                      color,
                      color.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 16),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      color: Colors.green,
                      size: 10,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      'LIVE',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: -0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsSection(BiProvider provider) {
    final alertas = provider.alertas;
    if (alertas.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.red.shade50,
            Colors.orange.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.shade600,
                      Colors.red.shade400,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Alertas Críticas',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Requieren atención inmediata',
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
          const SizedBox(height: 24),
          ...alertas.map((alerta) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    alerta,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'URGENTE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(60),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  CeasColors.primaryBlue,
                  Colors.purple.shade600,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Cargando Business Intelligence...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Analizando datos en tiempo real',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.error_outline_rounded,
              color: Colors.red.shade600,
              size: 48,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Error al cargar Business Intelligence',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            error,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
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
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}