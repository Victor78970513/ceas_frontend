import 'package:flutter/material.dart';
import '../../../core/widgets/ceas_drawer.dart';
import '../../../core/widgets/ceas_scaffold.dart';
import '../../../core/widgets/ceas_header.dart';
import '../../../core/widgets/ceas_kpi_card.dart';
import '../../../core/widgets/ceas_chart_card.dart';
import '../../../core/widgets/ceas_welcome_section.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CeasHeader(title: 'Panel principal'),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CeasWelcomeSection(),
                const SizedBox(height: 24),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: CeasChartCard(
                          title: 'Ingresos mensuales',
                          icon: Icons.show_chart,
                          chart: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text('Gráfico de barras (placeholder)',
                                  style: TextStyle(color: Colors.blueGrey)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CeasChartCard(
                          title: 'Acciones vendidas',
                          icon: Icons.pie_chart_outline,
                          chart: Container(
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text('Gráfico de pastel (placeholder)',
                                  style: TextStyle(color: Colors.blueGrey)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
