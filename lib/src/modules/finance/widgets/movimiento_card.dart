import 'package:flutter/material.dart';
import '../../../core/theme/ceas_colors.dart';
import '../models/movimiento_financiero.dart';

class MovimientoCard extends StatelessWidget {
  final MovimientoFinanciero movimiento;
  final VoidCallback? onVerDetalle;
  final VoidCallback? onEditar;

  const MovimientoCard({
    Key? key,
    required this.movimiento,
    this.onVerDetalle,
    this.onEditar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isIngreso = movimiento.tipo == 'Ingreso';
    final colorType = isIngreso ? Colors.green : Colors.red;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con gradiente
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorType,
                  colorType.withOpacity(0.7),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isIngreso ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                    color: colorType,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movimiento.tipo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        movimiento.id,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Text(
                    movimiento.estadoDisplay,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Información del movimiento
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(Icons.description, 'Descripción', movimiento.descripcion),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.attach_money, 'Monto', 'Bs. ${movimiento.monto.toStringAsFixed(0)}'),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.calendar_today, 'Fecha', movimiento.fechaDisplay),
                if (movimiento.categoria.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.category, 'Categoría', movimiento.categoria),
                ],
              ],
            ),
          ),
          
          // Botones de acción
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    'Ver',
                    Icons.visibility,
                    CeasColors.primaryBlue,
                    onVerDetalle ?? () {},
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    'Editar',
                    Icons.edit,
                    Colors.orange,
                    onEditar ?? () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: CeasColors.primaryBlue),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
