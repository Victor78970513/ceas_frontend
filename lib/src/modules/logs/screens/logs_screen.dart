import 'package:flutter/material.dart';
import '../../../core/widgets/ceas_drawer.dart';

class LogsScreen extends StatelessWidget {
  const LogsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logs del Sistema'),
        backgroundColor: Colors.blue[900],
      ),
      drawer: const CeasDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                        labelText: 'Buscar evento',
                        border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                        labelText: 'Tipo', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'todos', child: Text('Todos')),
                      DropdownMenuItem(value: 'info', child: Text('Info')),
                      DropdownMenuItem(value: 'error', child: Text('Error')),
                    ],
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: ListView(
                  children: const [
                    ListTile(
                        title: Text('Login exitoso'),
                        subtitle: Text('Usuario: admin - 01/06/2024 10:00')),
                    ListTile(
                        title: Text('Error de pago'),
                        subtitle: Text('Usuario: juanp - 01/06/2024 11:00')),
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
