import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/bi_movimientos_financieros.dart';
import '../../../core/theme/ceas_colors.dart';

class BiMovimientosChart extends StatelessWidget {
  final BiMovimientosFinancieros data;

  const BiMovimientosChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header elegante con tema claro
            _buildLightHeader(),
            const SizedBox(height: 32),

            // Métricas principales en cards claras
            _buildLightMetrics(),
            const SizedBox(height: 32),

            // Gráfico principal con tema claro
            _buildLightChart(),
            const SizedBox(height: 32),

            // Leyenda moderna con tema claro
            _buildLightLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildLightHeader() {
    return Row(
      children: [
        // Icono principal con gradiente
        Container(
          padding: const EdgeInsets.all(16),
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
                color: CeasColors.primaryBlue.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.trending_up_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(width: 20),

        // Información del título
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Movimientos Financieros',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  'Período: ${data.periodo.periodoDisplay}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Indicadores de tendencia modernos
        Column(
          children: [
            _buildDarkTrendIndicator(
              'Ingresos',
              data.tendencias.tendenciaIngresos,
              data.tendencias.colorTendenciaIngresos,
            ),
            const SizedBox(height: 12),
            _buildDarkTrendIndicator(
              'Egresos',
              data.tendencias.tendenciaEgresos,
              data.tendencias.colorTendenciaEgresos,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDarkTrendIndicator(String label, String tendencia, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: color.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getTrendIcon(tendencia),
            color: color,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            tendencia.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTrendIcon(String tendencia) {
    switch (tendencia.toLowerCase()) {
      case 'creciente':
        return Icons.trending_up_rounded;
      case 'decreciente':
        return Icons.trending_down_rounded;
      case 'estable':
        return Icons.trending_flat_rounded;
      default:
        return Icons.trending_flat_rounded;
    }
  }

  Widget _buildLightMetrics() {
    return Row(
      children: [
        Expanded(
          child: _buildLightMetricCard(
            'Total Ingresos',
            data.resumen.totalIngresosFormatted,
            Colors.green.shade600,
            Icons.arrow_upward_rounded,
            Colors.green.shade50,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildLightMetricCard(
            'Total Egresos',
            data.resumen.totalEgresosFormatted,
            Colors.red.shade600,
            Icons.arrow_downward_rounded,
            Colors.red.shade50,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildLightMetricCard(
            'Balance Total',
            data.resumen.balanceTotalFormatted,
            CeasColors.primaryBlue,
            Icons.account_balance_wallet_rounded,
            CeasColors.primaryBlue.withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildLightMetricCard(
      String title, String value, Color color, IconData icon, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLightChart() {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: _getMaxValue() / 6,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.shade300,
                strokeWidth: 1,
                dashArray: [5, 5],
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: _getInterval(),
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 &&
                      value.toInt() < data.movimientosDiarios.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        data.movimientosDiarios[value.toInt()].fechaDisplay,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: _getMaxValue() / 6,
                reservedSize: 70,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '\$${value.toInt()}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (data.movimientosDiarios.length - 1).toDouble(),
          minY: 0,
          maxY: _getMaxValue(),
          lineBarsData: [
            // Línea de ingresos
            LineChartBarData(
              spots: _getIngresosSpots(),
              isCurved: true,
              color: Colors.green.shade600,
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: false,
              ),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.green.withOpacity(0.3),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.green.withOpacity(0.4),
                    Colors.green.withOpacity(0.05),
                  ],
                ),
              ),
            ),
            // Línea de egresos
            LineChartBarData(
              spots: _getEgresosSpots(),
              isCurved: true,
              color: Colors.red.shade600,
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: false,
              ),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.red.withOpacity(0.3),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.red.withOpacity(0.4),
                    Colors.red.withOpacity(0.05),
                  ],
                ),
              ),
            ),
            // Línea de balance acumulado
            LineChartBarData(
              spots: _getBalanceSpots(),
              isCurved: true,
              color: CeasColors.primaryBlue,
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: false,
              ),
              belowBarData: BarAreaData(
                show: true,
                color: CeasColors.primaryBlue.withOpacity(0.3),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    CeasColors.primaryBlue.withOpacity(0.4),
                    CeasColors.primaryBlue.withOpacity(0.05),
                  ],
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            enabled: true,
            touchSpotThreshold: 20,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.black.withOpacity(0.9),
              tooltipRoundedRadius: 16,
              tooltipPadding: const EdgeInsets.all(20),
              tooltipMargin: 8,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((touchedSpot) {
                  final index = touchedSpot.x.toInt();
                  if (index >= 0 && index < data.movimientosDiarios.length) {
                    final movimiento = data.movimientosDiarios[index];
                    return LineTooltipItem(
                      '${movimiento.fechaDisplay}\n',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                      children: [
                        TextSpan(
                          text: '💰 Ingresos: ',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14),
                          children: [
                            TextSpan(
                              text:
                                  '\$${movimiento.ingresos.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: Colors.green.shade400,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const TextSpan(text: '\n'),
                        TextSpan(
                          text: '💸 Egresos: ',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14),
                          children: [
                            TextSpan(
                              text:
                                  '\$${movimiento.egresos.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: Colors.red.shade400,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const TextSpan(text: '\n'),
                        TextSpan(
                          text: '📊 Balance: ',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14),
                          children: [
                            TextSpan(
                              text:
                                  '\$${movimiento.balanceAcumulado.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: CeasColors.primaryBlue,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                  return null;
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLightLegend() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildLightLegendItem(
              'Ingresos', Colors.green.shade600, Icons.arrow_upward_rounded),
          _buildLightLegendItem(
              'Egresos', Colors.red.shade600, Icons.arrow_downward_rounded),
          _buildLightLegendItem('Balance Acumulado', CeasColors.primaryBlue,
              Icons.trending_up_rounded),
        ],
      ),
    );
  }

  Widget _buildLightLegendItem(String label, Color color, IconData icon) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  List<FlSpot> _getIngresosSpots() {
    return data.movimientosDiarios.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.ingresos);
    }).toList();
  }

  List<FlSpot> _getEgresosSpots() {
    return data.movimientosDiarios.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.egresos);
    }).toList();
  }

  List<FlSpot> _getBalanceSpots() {
    return data.movimientosDiarios.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.balanceAcumulado);
    }).toList();
  }

  double _getMaxValue() {
    double maxIngresos = data.movimientosDiarios
        .fold(0.0, (max, item) => item.ingresos > max ? item.ingresos : max);
    double maxEgresos = data.movimientosDiarios
        .fold(0.0, (max, item) => item.egresos > max ? item.egresos : max);
    double maxBalance = data.movimientosDiarios.fold(
        0.0,
        (max, item) =>
            item.balanceAcumulado > max ? item.balanceAcumulado : max);

    double maxValue =
        [maxIngresos, maxEgresos, maxBalance].reduce((a, b) => a > b ? a : b);
    return (maxValue * 1.3).ceilToDouble();
  }

  double _getInterval() {
    int totalDias = data.movimientosDiarios.length;
    if (totalDias <= 7) return 1;
    if (totalDias <= 30) return 3;
    if (totalDias <= 90) return 7;
    return 15;
  }
}
