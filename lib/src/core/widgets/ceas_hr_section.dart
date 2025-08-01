import 'package:flutter/material.dart';
import '../theme/ceas_colors.dart';

class CeasHrSection extends StatelessWidget {
  const CeasHrSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildEmployeeTable(),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildEmployeeChart(),
        ),
      ],
    );
  }

  Widget _buildEmployeeTable() {
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
            'Recursos humanos',
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
              2: FlexColumnWidth(1.5),
              3: FlexColumnWidth(1),
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
                    child: Text('NOMBRE COMPLETO',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('PUESTO',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('DIA INICIAL',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('SUELDO',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              _buildEmployeeRow(
                  'Parviz Aslanov', 'UI Dizayner', '20.11.2023', 'Bs. 2500'),
              _buildEmployeeRow(
                  'Seving Aslanova', 'UX Dizayner', '19.02.2023', 'Bs. 2500'),
              _buildEmployeeRow('Ceyhun Aslanov', 'React Developer',
                  '18.05.2024', 'Bs. 2500'),
              _buildEmployeeRow('Ayla Məmmədova', 'UX resacher itern',
                  '18.07.2024', 'Bs. 2500'),
              _buildEmployeeRow(
                  'Orxan Hüseyinov', 'Mühasib', '17.09.2022', 'Bs. 2500'),
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

  Widget _buildEmployeeChart() {
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
            'Distribución de empleados',
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
                      color: CeasColors.primaryBlue.withOpacity(0.1),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '300',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: CeasColors.primaryBlue,
                            ),
                          ),
                          Text(
                            'Total empleados',
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
                  _buildLegendItem(
                      'Hoteleria', 186, 62.5, CeasColors.primaryBlue),
                  _buildLegendItem('Gimnasio', 75, 25.0, Colors.blue[300]!),
                  _buildLegendItem('Ecuestre', 37, 12.5, Colors.grey[400]!),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildEmployeeRow(
      String name, String position, String startDate, String salary) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: CeasColors.primaryBlue.withOpacity(0.1),
                child: Text(
                  name.split(' ').map((e) => e[0]).join(''),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: CeasColors.primaryBlue,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(name)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(position),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(startDate),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(salary),
        ),
      ],
    );
  }

  Widget _buildLegendItem(
      String label, int count, double percentage, Color color) {
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
          Text('$count'),
          const SizedBox(width: 8),
          Text('${percentage.toStringAsFixed(1)}%'),
        ],
      ),
    );
  }
}
