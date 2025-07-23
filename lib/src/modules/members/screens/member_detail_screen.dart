import 'package:flutter/material.dart';

class MemberDetailScreen extends StatelessWidget {
  const MemberDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Socio'),
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nombre: Juan Pérez', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            const Text('Socio #001', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/socio_form');
                  },
                  child: const Text('Editar'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900]),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Ver pagos'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
