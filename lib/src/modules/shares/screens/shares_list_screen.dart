import 'package:flutter/material.dart';
import '../../../core/widgets/ceas_drawer.dart';

class SharesListScreen extends StatelessWidget {
  const SharesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de Acciones'),
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
                const Text('Acciones registradas',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/accion_venta');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Nueva acción'),
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
                      title: const Text('Acción #001'),
                      subtitle: const Text('Socio: Juan Pérez'),
                      onTap: () {
                        Navigator.of(context).pushNamed('/accion_certificado');
                      },
                    ),
                    ListTile(
                      title: const Text('Acción #002'),
                      subtitle: const Text('Socio: María López'),
                      onTap: () {
                        Navigator.of(context).pushNamed('/accion_certificado');
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
