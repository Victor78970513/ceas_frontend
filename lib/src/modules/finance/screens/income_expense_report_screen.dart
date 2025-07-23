import 'package:flutter/material.dart';
import '../../../core/widgets/ceas_drawer.dart';

class IncomeExpenseReportScreen extends StatelessWidget {
  const IncomeExpenseReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte de Ingresos y Egresos'),
        backgroundColor: Colors.blue[900],
      ),
      drawer: const CeasDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: ListView(
            children: const [
              ListTile(
                  title: Text('Ingreso: Cuota mensual'),
                  subtitle: Text('Bs. 500 - 01/06/2024')),
              ListTile(
                  title: Text('Egreso: Mantenimiento'),
                  subtitle: Text('Bs. 200 - 02/06/2024')),
              // ... más filas de ejemplo ...
            ],
          ),
        ),
      ),
    );
  }
}
