import 'package:flutter/material.dart';
import '../theme/ceas_colors.dart';

class CeasSalesTable extends StatelessWidget {
  const CeasSalesTable({Key? key}) : super(key: key);

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
          const Text(
            'Resumen de ventas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: CeasColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1.5),
              3: FlexColumnWidth(1.5),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: CeasColors.backgroundLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                children: const [
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('NOMBRE DE LA VENTA',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('CANTIDAD',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('PRECIO TOTAL',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('FECHA DE COMPRA',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              _buildTableRow(
                  'Venta de Acciones', '2', 'Bs 10000', '20.09.2024'),
              _buildTableRow(
                  'Renovación de Membresía', '4', 'Bs 10000', '19.09.2024'),
              _buildTableRow(
                  'Reserva de Pista', '15', 'Bs 10000', '18.09.2024'),
              _buildTableRow(
                  'Alquiler de Caballo', '10', 'Bs 10000', '18.09.2024'),
              _buildTableRow(
                  'Clase de equitacion', '12', 'Bs 10000', '17.09.2024'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: const Icon(Icons.chevron_left), onPressed: () {}),
              const Text('1'),
              const SizedBox(width: 8),
              const Text('2'),
              const SizedBox(width: 8),
              const Text('3'),
              const SizedBox(width: 8),
              const Text('4'),
              const SizedBox(width: 8),
              const Text('...'),
              const SizedBox(width: 8),
              const Text('10'),
              IconButton(
                  icon: const Icon(Icons.chevron_right), onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(
      String name, String quantity, String price, String date) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(name),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(quantity),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(price),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(date),
        ),
      ],
    );
  }
}
