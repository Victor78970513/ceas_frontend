import 'package:flutter/material.dart';
import '../../../core/widgets/ceas_drawer.dart';

class PaymentsListScreen extends StatelessWidget {
  const PaymentsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de Pagos'),
        backgroundColor: Colors.blue[900],
      ),
      drawer: const CeasDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Pagos registrados',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/pago_form');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Nuevo pago'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900]),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: ListView(
                  children: [
                    ListTile(
                      title: const Text('Pago #001'),
                      subtitle: const Text('Socio: Juan Pérez - Bs. 500'),
                      onTap: () {
                        Navigator.of(context).pushNamed('/pago_historial');
                      },
                    ),
                    ListTile(
                      title: const Text('Pago #002'),
                      subtitle: const Text('Socio: María López - Bs. 300'),
                      onTap: () {
                        Navigator.of(context).pushNamed('/pago_historial');
                      },
                    ),
                    // ... más filas de ejemplo ...
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
