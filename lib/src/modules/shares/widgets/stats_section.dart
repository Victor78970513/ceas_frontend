import 'package:flutter/material.dart';
import '../../../core/theme/ceas_colors.dart';

class StatsSection extends StatelessWidget {
  final int totalAcciones;
  final int completamentePagadas;
  final int parcialmentePagadas;
  final int pendientes;
  final bool isMobile;

  const StatsSection({
    Key? key,
    required this.totalAcciones,
    required this.completamentePagadas,
    required this.parcialmentePagadas,
    required this.pendientes,
    required this.isMobile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          _buildStatCard(
              'Total Acciones',
              totalAcciones.toString(),
              Icons.assignment_rounded,
              CeasColors.kpiBlue,
              'Acciones emitidas'),
          _buildStatCard(
              'Completamente Pagadas',
              completamentePagadas.toString(),
              Icons.check_circle_rounded,
              CeasColors.kpiGreen,
              '100% pagadas'),
          _buildStatCard(
              'Parcialmente Pagadas',
              parcialmentePagadas.toString(),
              Icons.payment_rounded,
              CeasColors.kpiOrange,
              'Pagos parciales'),
          _buildStatCard(
              'Pendientes',
              pendientes.toString(),
              Icons.warning_rounded,
              CeasColors.kpiPurple,
              'Sin pagos'),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: _buildStatCard(
                'Total Acciones',
                totalAcciones.toString(),
                Icons.assignment_rounded,
                CeasColors.kpiBlue,
                'Acciones emitidas'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
                'Completamente Pagadas',
                completamentePagadas.toString(),
                Icons.check_circle_rounded,
                CeasColors.kpiGreen,
                '100% pagadas'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
                'Parcialmente Pagadas',
                parcialmentePagadas.toString(),
                Icons.payment_rounded,
                CeasColors.kpiOrange,
                'Pagos parciales'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
                'Pendientes',
                pendientes.toString(),
                Icons.warning_rounded,
                CeasColors.kpiPurple,
                'Sin pagos'),
          ),
        ],
      );
    }
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color, String subtitle) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color.withOpacity(0.2),
                        color.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(value,
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color)),
            const SizedBox(height: 4),
            Text(subtitle,
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
