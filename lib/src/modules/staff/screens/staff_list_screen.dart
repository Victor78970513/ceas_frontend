import 'package:flutter/material.dart';
import '../../../core/widgets/ceas_drawer.dart';

class StaffListScreen extends StatelessWidget {
  const StaffListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de Empleados'),
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
                const Text('Empleados registrados',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/personal_form');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Nuevo empleado'),
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
                      title: const Text('Carlos Gómez'),
                      subtitle: const Text('Encargado de ventas'),
                      onTap: () {
                        Navigator.of(context).pushNamed('/asistencia');
                      },
                    ),
                    ListTile(
                      title: const Text('Ana Torres'),
                      subtitle: const Text('Finanzas'),
                      onTap: () {
                        Navigator.of(context).pushNamed('/asistencia');
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
