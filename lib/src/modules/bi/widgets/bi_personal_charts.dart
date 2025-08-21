import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/bi_personal_metricas_generales.dart';
import '../models/bi_personal_metricas_asistencia.dart';
import '../models/bi_personal_asistencia_departamento.dart';
import '../models/bi_personal_tendencias_mensuales.dart';

// Gráfica de métricas generales de personal
class BiPersonalMetricasGeneralesChart extends StatelessWidget {
  final BiPersonalMetricasGenerales data;

  const BiPersonalMetricasGeneralesChart({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header elegante
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade600,
                      Colors.blue.shade400,
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
                      'Métricas Generales de Personal',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Resumen del personal del CEAS',
                      style: TextStyle(
                        fontSize: 14,
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

          // Métricas principales
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Total Personal',
                  data.totalPersonalFormatted,
                  Icons.people_rounded,
                  Colors.blue.shade600,
                  Colors.blue.shade50,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  'Personal Activo',
                  data.personalActivoFormatted,
                  Icons.check_circle_rounded,
                  Colors.green.shade600,
                  Colors.green.shade50,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  'Personal Inactivo',
                  data.personalInactivoFormatted,
                  Icons.cancel_rounded,
                  Colors.red.shade600,
                  Colors.red.shade50,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Gráfico de dona para estado del personal
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(enabled: true),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: [
                        PieChartSectionData(
                          color: Colors.green.shade600,
                          value: data.personalActivo.toDouble(),
                          title: '${data.porcentajeActivoFormatted}',
                          radius: 60,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          color: Colors.red.shade600,
                          value: data.personalInactivo.toDouble(),
                          title: '${data.porcentajeInactivoFormatted}',
                          radius: 60,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 1,
                child: _buildEstadoLegend(),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Gráfico de barras para departamentos
          const Text(
            'Personal por Departamento',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _getMaxDepartamentos(),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.black.withOpacity(0.9),
                    tooltipRoundedRadius: 12,
                    tooltipPadding: const EdgeInsets.all(16),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final dept = data.departamentosOrdenados[group.x.toInt()];
                      return BarTooltipItem(
                        '🏢 ${dept.key}\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: '${dept.value} empleados',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() <
                                data.departamentosOrdenados.length) {
                          final dept =
                              data.departamentosOrdenados[value.toInt()];
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                dept.key.split(' ').first,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 40,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: _getMaxDepartamentos() / 5,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 12,
                          child: Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        );
                      },
                      reservedSize: 40,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups:
                    data.departamentosOrdenados.asMap().entries.map((entry) {
                  final index = entry.key;
                  final dept = entry.value;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: dept.value.toDouble(),
                        color: _getDepartamentoColor(index),
                        width: 20,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }).toList(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _getMaxDepartamentos() / 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEstadoLegend() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estado del Personal',
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          _buildLegendItem(
              'Activo', Colors.green.shade600, Icons.check_circle_rounded),
          const SizedBox(height: 12),
          _buildLegendItem(
              'Inactivo', Colors.red.shade600, Icons.cancel_rounded),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, IconData icon) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Icon(icon, color: color, size: 16),
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

  Color _getDepartamentoColor(int index) {
    final colors = [
      Colors.blue.shade600,
      Colors.green.shade600,
      Colors.orange.shade600,
      Colors.purple.shade600,
      Colors.teal.shade600,
      Colors.indigo.shade600,
      Colors.pink.shade600,
      Colors.amber.shade600,
    ];
    return colors[index % colors.length];
  }

  double _getMaxDepartamentos() {
    if (data.departamentosOrdenados.isEmpty) return 20;
    final max = data.departamentosOrdenados
        .map((e) => e.value)
        .reduce((a, b) => a > b ? a : b);
    return max.toDouble() * 1.2;
  }
}

// Gráfica de métricas de asistencia del personal
class BiPersonalMetricasAsistenciaChart extends StatelessWidget {
  final BiPersonalMetricasAsistencia data;

  const BiPersonalMetricasAsistenciaChart({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header elegante
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.shade600,
                      Colors.green.shade400,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.access_time_rounded,
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
                      'Métricas de Asistencia',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Control de asistencia y puntualidad',
                      style: TextStyle(
                        fontSize: 14,
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

          // Métricas principales
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Total Registros',
                  data.totalRegistrosFormatted,
                  Icons.assignment_rounded,
                  Colors.blue.shade600,
                  Colors.blue.shade50,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  'Asistencias',
                  data.asistenciasCompletasFormatted,
                  Icons.check_circle_rounded,
                  Colors.green.shade600,
                  Colors.green.shade50,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  'Tardanzas',
                  data.tardanzasFormatted,
                  Icons.warning_rounded,
                  Colors.orange.shade600,
                  Colors.orange.shade50,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  'Ausencias',
                  data.ausenciasFormatted,
                  Icons.cancel_rounded,
                  Colors.red.shade600,
                  Colors.red.shade50,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Gráfico de barras para métricas de asistencia
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: _getMaxAsistencia(),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: Colors.black.withOpacity(0.9),
                          tooltipRoundedRadius: 12,
                          tooltipPadding: const EdgeInsets.all(16),
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            String label = '';
                            String emoji = '';
                            Color color = Colors.blue;

                            switch (group.x.toInt()) {
                              case 0:
                                label = 'Total Registros';
                                emoji = '📊';
                                color = Colors.blue.shade600;
                                break;
                              case 1:
                                label = 'Asistencias';
                                emoji = '✅';
                                color = Colors.green.shade600;
                                break;
                              case 2:
                                label = 'Tardanzas';
                                emoji = '⏰';
                                color = Colors.orange.shade600;
                                break;
                              case 3:
                                label = 'Ausencias';
                                emoji = '❌';
                                color = Colors.red.shade600;
                                break;
                            }

                            return BarTooltipItem(
                              '$emoji $label\n',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: rod.toY.toInt().toString(),
                                  style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              const style = TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              );
                              Widget text;
                              switch (value.toInt()) {
                                case 0:
                                  text = const Text('Total', style: style);
                                  break;
                                case 1:
                                  text =
                                      const Text('Asistencias', style: style);
                                  break;
                                case 2:
                                  text = const Text('Tardanzas', style: style);
                                  break;
                                case 3:
                                  text = const Text('Ausencias', style: style);
                                  break;
                                default:
                                  text = const Text('', style: style);
                                  break;
                              }
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                space: 8,
                                child: text,
                              );
                            },
                            reservedSize: 40,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: _getMaxAsistencia() / 5,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                space: 12,
                                child: Text(
                                  value.toInt().toString(),
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                  ),
                                ),
                              );
                            },
                            reservedSize: 50,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: [
                        BarChartGroupData(
                          x: 0,
                          barRods: [
                            BarChartRodData(
                              toY: data.totalRegistros.toDouble(),
                              color: Colors.blue.shade600,
                              width: 30,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6),
                              ),
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [
                            BarChartRodData(
                              toY: data.asistenciasCompletas.toDouble(),
                              color: Colors.green.shade600,
                              width: 30,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6),
                              ),
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 2,
                          barRods: [
                            BarChartRodData(
                              toY: data.tardanzas.toDouble(),
                              color: Colors.orange.shade600,
                              width: 30,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6),
                              ),
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 3,
                          barRods: [
                            BarChartRodData(
                              toY: data.ausencias.toDouble(),
                              color: Colors.red.shade600,
                              width: 30,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6),
                              ),
                            ),
                          ],
                        ),
                      ],
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: _getMaxAsistencia() / 5,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.shade200,
                            strokeWidth: 1,
                            dashArray: [5, 5],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Métricas adicionales
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Porcentaje Asistencia',
                  data.porcentajeAsistenciaFormatted,
                  Icons.percent_rounded,
                  data.porcentajeAsistenciaColor,
                  data.porcentajeAsistenciaColor.withOpacity(0.1),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  'Promedio Horas',
                  data.promedioHorasTrabajadasFormatted,
                  Icons.schedule_rounded,
                  data.promedioHorasColor,
                  data.promedioHorasColor.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  double _getMaxAsistencia() {
    final values = [
      data.totalRegistros,
      data.asistenciasCompletas,
      data.tardanzas,
      data.ausencias,
    ];
    final max = values.reduce((a, b) => a > b ? a : b);
    return max.toDouble() * 1.2;
  }
}
