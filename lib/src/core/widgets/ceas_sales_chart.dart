import 'package:flutter/material.dart';
import '../theme/ceas_colors.dart';

class CeasSalesChart extends StatelessWidget {
  const CeasSalesChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
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
              const Text(
                'Tendencia de ventas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: CeasColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  _buildTimeFilter('1W', false),
                  const SizedBox(width: 8),
                  _buildTimeFilter('1M', true),
                  const SizedBox(width: 8),
                  _buildTimeFilter('3M', false),
                  const SizedBox(width: 8),
                  _buildTimeFilter('1Y', false),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            height: 300,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  // Ejes del gráfico
                  Positioned(
                    left: 40,
                    top: 20,
                    bottom: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Bs 100k',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text('Bs 75k',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text('Bs 50k',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text('Bs 25k',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text('Bs 0',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  // Área del gráfico con tendencia simulada
                  Positioned(
                    left: 80,
                    top: 20,
                    right: 20,
                    bottom: 40,
                    child: CustomPaint(
                      painter: SalesChartPainter(),
                      size: const Size(double.infinity, double.infinity),
                    ),
                  ),
                  // Etiquetas del eje X
                  Positioned(
                    left: 80,
                    right: 20,
                    bottom: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('18',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text('20',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text('22',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text('24',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text('26',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text('28',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text('30',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFilter(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? CeasColors.primaryBlue : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isSelected ? CeasColors.primaryBlue : Colors.grey),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class SalesChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CeasColors.primaryBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final fillPaint = Paint()
      ..color = CeasColors.primaryBlue.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    // Puntos de la tendencia (simulando los datos de la referencia)
    final points = [
      Offset(0, size.height * 0.8), // 18 - Bs 20k
      Offset(size.width * 0.2, size.height * 0.3), // 20 - Bs 70k
      Offset(size.width * 0.4, size.height * 0.2), // 22 - Bs 80k
      Offset(size.width * 0.6, size.height * 0.8), // 24 - Bs 20k
      Offset(size.width * 0.8, size.height * 0.4), // 26 - Bs 60k
      Offset(size.width, size.height * 0.3), // 30 - Bs 70k
    ];

    path.moveTo(points[0].dx, points[0].dy);
    fillPath.moveTo(points[0].dx, size.height);

    for (int i = 0; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
      fillPath.lineTo(points[i].dx, points[i].dy);
    }

    fillPath.lineTo(points.last.dx, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
