import 'package:flutter/material.dart';
import '../providers/bi_provider.dart';

class ResponsiveKpiSection extends StatelessWidget {
  final BiProvider provider;

  const ResponsiveKpiSection({
    Key? key,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final metricasFin = provider.metricasFinancieras;
    final metricasAdmin = provider.metricasAdministrativas;

    if (metricasFin == null && metricasAdmin == null) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 1024;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'KPIs Ejecutivos',
              style: TextStyle(
                fontSize: isMobile ? 18 : 24,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: isMobile ? 12 : 20),
            if (isMobile)
              _buildMobileLayout(metricasFin, metricasAdmin)
            else
              _buildDesktopLayout(metricasFin, metricasAdmin),
          ],
        );
      },
    );
  }

  Widget _buildMobileLayout(metricasFin, metricasAdmin) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.05,
      children: [
        if (metricasFin != null)
          _buildCompactKpiCard(
            'Balance',
            'Bs. ${metricasFin.balanceNeto.toStringAsFixed(0)}',
            Icons.account_balance_wallet_rounded,
            metricasFin.balanceNeto >= 0 ? Colors.green : Colors.red,
            metricasFin.balanceNeto >= 0 ? '+12.5%' : '-8.2%',
          ),
        if (metricasFin != null)
          _buildCompactKpiCard(
            'Ingresos',
            'Bs. ${metricasFin.ingresosTotales.toStringAsFixed(0)}',
            Icons.trending_up_rounded,
            Colors.green,
            '+15.3%',
          ),
        if (metricasAdmin != null)
          _buildCompactKpiCard(
            'Socios',
            '${metricasAdmin.sociosActivos}',
            Icons.people_alt_rounded,
            Colors.blue,
            '+5.1%',
          ),
        if (metricasAdmin != null)
          _buildCompactKpiCard(
            'Eficiencia',
            '${((metricasAdmin.sociosActivos / metricasAdmin.totalSocios) * 100).toStringAsFixed(1)}%',
            Icons.speed_rounded,
            Colors.purple,
            '+2.8%',
          ),
      ],
    );
  }

  Widget _buildDesktopLayout(metricasFin, metricasAdmin) {
    return Row(
      children: [
        if (metricasFin != null) ...[
          Expanded(
            child: _buildKpiCard(
              'Balance Neto',
              'Bs. ${metricasFin.balanceNeto.toStringAsFixed(0)}',
              Icons.account_balance_wallet_rounded,
              metricasFin.balanceNeto >= 0 ? Colors.green : Colors.red,
              metricasFin.balanceNeto >= 0 ? '+12.5%' : '-8.2%',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildKpiCard(
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
            child: _buildKpiCard(
              'Socios Activos',
              '${metricasAdmin.sociosActivos}',
              Icons.people_alt_rounded,
              Colors.blue,
              '+5.1%',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildKpiCard(
              'Eficiencia',
              '${((metricasAdmin.sociosActivos / metricasAdmin.totalSocios) * 100).toStringAsFixed(1)}%',
              Icons.speed_rounded,
              Colors.purple,
              '+2.8%',
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCompactKpiCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String change,
  ) {
    final isPositive = change.startsWith('+');
    final trendIcon = isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded;

    return Container(
      padding: const EdgeInsets.all(12),
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
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 14),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: isPositive
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(trendIcon, color: isPositive ? Colors.green : Colors.red, size: 10),
                    const SizedBox(width: 2),
                    Text(
                      change,
                      style: TextStyle(
                        color: isPositive ? Colors.green : Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              letterSpacing: -0.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard(
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
                    colors: [color, color.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(10),
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
                        color: isPositive ? Colors.green : Colors.red,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}
