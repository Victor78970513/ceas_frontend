import 'package:flutter/material.dart';
import '../../../core/widgets/ceas_drawer.dart';

class MembersListScreen extends StatelessWidget {
  const MembersListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de Socios'),
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
                const Text('Socios registrados',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/socio_form');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Nuevo socio'),
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
                      title: const Text('Juan Pérez'),
                      subtitle: const Text('Socio #001'),
                      onTap: () {
                        Navigator.of(context).pushNamed('/socio_detalle');
                      },
                    ),
                    ListTile(
                      title: const Text('María López'),
                      subtitle: const Text('Socio #002'),
                      onTap: () {
                        Navigator.of(context).pushNamed('/socio_detalle');
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
