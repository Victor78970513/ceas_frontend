import 'package:flutter/material.dart';
import '../models/bi_distribucion_financiera.dart';
import '../models/bi_top_club.dart';
import '../models/bi_kpi.dart';

// Gráfico de barras para métricas financieras
class BiBarChart extends StatelessWidget {
  final String title;
  final List<BiCategoriaFinanciera> data;
  final Color barColor;
  final bool isHorizontal;

  const BiBarChart({
    Key? key,
    required this.title,
    required this.data,
    required this.barColor,
    this.isHorizontal = false,
  }) : super(key: key);

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
    final maxValue = data.map((e) => e.monto).reduce((a, b) => a > b ? a : b);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: data.map((item) {
        final height = (item.monto / maxValue) * 150;
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
                  colors: [barColor, barColor.withOpacity(0.7)],
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 60,
              child: Text(
                item.categoria,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.montoFormatted,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildHorizontalBars() {
    final maxValue = data.map((e) => e.monto).reduce((a, b) => a > b ? a : b);

    return Column(
      children: data.map((item) {
        final width = (item.monto / maxValue) * 300;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  item.categoria,
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
                          colors: [barColor, barColor.withOpacity(0.7)],
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
                  item.montoFormatted,
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
            color: Colors.grey.withOpacity(0.1),
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

// Gráfico circular para distribución
class BiPieChart extends StatelessWidget {
  final String title;
  final List<BiCategoriaFinanciera> data;
  final List<Color> colors;

  const BiPieChart({
    Key? key,
    required this.title,
    required this.data,
    required this.colors,
  }) : super(key: key);

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
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildPieChart(),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 1,
                child: _buildLegend(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    return SizedBox(
      height: 150,
      child: CustomPaint(
        size: const Size(150, 150),
        painter: PieChartPainter(data: data, colors: colors),
      ),
    );
  }

  Widget _buildLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: colors[index % colors.length],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.categoria,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${item.porcentaje.toStringAsFixed(1)}%',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
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
            color: Colors.grey.withOpacity(0.1),
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

// Gráfico de líneas para tendencias
class BiLineChart extends StatelessWidget {
  final String title;
  final List<BiKpi> data;
  final Color lineColor;

  const BiLineChart({
    Key? key,
    required this.title,
    required this.data,
    required this.lineColor,
  }) : super(key: key);

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
            child: CustomPaint(
              size: const Size(double.infinity, 200),
              painter: LineChartPainter(data: data, lineColor: lineColor),
            ),
          ),
        ],
      ),
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
            color: Colors.grey.withOpacity(0.1),
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

// Custom Painters para los gráficos
class PieChartPainter extends CustomPainter {
  final List<BiCategoriaFinanciera> data;
  final List<Color> colors;

  PieChartPainter({required this.data, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final total = data.map((e) => e.monto).reduce((a, b) => a + b);
    double startAngle = 0;

    for (int i = 0; i < data.length; i++) {
      final sweepAngle = (data[i].monto / total) * 2 * 3.14159;

      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LineChartPainter extends CustomPainter {
  final List<BiKpi> data;
  final Color lineColor;

  LineChartPainter({required this.data, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - (data[i].valorActual / 100) * size.height;
      points.add(Offset(x, y));
    }

    path.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);

    // Dibujar puntos
    final pointPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

