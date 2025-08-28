import 'package:flutter/material.dart';
import '../models/bi_top_club.dart';
// import '../models/bi_distribucion_financiera.dart'; // Modelo eliminado
// import '../models/bi_kpi.dart'; // Modelo eliminado

// Gráfico de barras para métricas financieras
class BiBarChart extends StatelessWidget {
  final String title;
  final List<BiTopClub> data; // Cambiado a BiTopClub
  final Color barColor;
  final bool isHorizontal;

  const BiBarChart({
    super.key,
    required this.title,
    required this.data,
    required this.barColor,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return _buildEmptyChart();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: isHorizontal ? _buildHorizontalBars() : _buildVerticalBars(),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalBars() {
    final maxValue =
        data.map((e) => e.balance.abs()).reduce((a, b) => a > b ? a : b);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: data.map((item) {
        final height = (item.balance.abs() / maxValue) * 150;
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 40,
              height: height,
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [barColor, barColor.withValues(alpha: 0.7)],
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 60,
              child: Text(
                item.nombreClub,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Bs. ${item.balance.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildHorizontalBars() {
    final maxValue =
        data.map((e) => e.balance.abs()).reduce((a, b) => a > b ? a : b);

    return Column(
      children: data.map((item) {
        final width = (item.balance.abs() / maxValue) * 300;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  item.nombreClub,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Container(
                      height: 20,
                      width: width,
                      decoration: BoxDecoration(
                        color: barColor,
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [barColor, barColor.withValues(alpha: 0.7)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 60,
                child: Text(
                  'Bs. ${item.balance.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'No hay datos disponibles',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

// Gráfico circular para distribución - Comentado temporalmente por modelo eliminado
// class BiPieChart extends StatelessWidget {
//   final String title;
//   final List<BiCategoriaFinanciera> data;
//   final List<Color> colors;
//   // ... implementación comentada
// }

// Gráfico de líneas para tendencias - Comentado temporalmente por modelo eliminado
// class BiLineChart extends StatelessWidget {
//   final String title;
//   final List<BiKpi> data;
//   final Color lineColor;
//   // ... implementación comentada
// }

// Custom Painters para los gráficos - Comentados temporalmente
// class PieChartPainter extends CustomPainter {
//   final List<BiCategoriaFinanciera> data;
//   final List<Color> colors;
//   // ... implementación comentada
// }

// class LineChartPainter extends CustomPainter {
//   final List<BiKpi> data;
//   final Color lineColor;
//   // ... implementación comentada
// }

// Archivo restaurado con funcionalidades principales
// Solo se comentaron las clases que dependen de modelos eliminados
