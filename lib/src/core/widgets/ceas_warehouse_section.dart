import 'package:flutter/material.dart';
import '../theme/ceas_colors.dart';

class CeasWarehouseSection extends StatelessWidget {
  const CeasWarehouseSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildProductTable(),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildCategoryChart(),
        ),
      ],
    );
  }

  Widget _buildProductTable() {
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
            'Warehouse',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: CeasColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2.5),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(2),
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
                    child: Text('NOMBRE DE PRODUCTO',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('CODIGO DE PRODUCTO',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('CANTIDAD',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('FECHA DE MODIFICACION',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              _buildProductRow('İphone 14', 'ELEC-1001', '15', '20.11.2023'),
              _buildProductRow('Samsung S24', 'ELEC-1002', '20', '20.11.2023'),
              _buildProductRow(
                  'Black M Jacket', 'CLOTH-BLK-M', '20', '20.10.2023'),
              _buildProductRow(
                  'Black L Jacket', 'CLOTH-BLK-L', '20', '20.10.2023'),
              _buildProductRow(
                  'Armani Perfume', 'COSM-ARM-202', '30', '20.11.2023'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
              DropdownButton<String>(
                value: '5',
                items: const [
                  DropdownMenuItem(value: '5', child: Text('Mostrando 5')),
                  DropdownMenuItem(value: '10', child: Text('Mostrando 10')),
                  DropdownMenuItem(value: '20', child: Text('Mostrando 20')),
                ],
                onChanged: (value) {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChart() {
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
            'Distribución por categoría',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: CeasColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            height: 300,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange.withOpacity(0.1),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Categoria',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          Text(
                            '%',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildCategoryLegendItem('Hoteleria', 60.0, Colors.orange),
                  _buildCategoryLegendItem('Ecuestre', 25.0, Colors.blue[300]!),
                  _buildCategoryLegendItem(
                      'Salon de fiesta', 15.0, Colors.grey[400]!),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildProductRow(
      String name, String code, String quantity, String date) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(name),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(code),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(quantity),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(date),
        ),
      ],
    );
  }

  Widget _buildCategoryLegendItem(
      String label, double percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
          Text('${percentage.toStringAsFixed(0)}%'),
        ],
      ),
    );
  }
}
