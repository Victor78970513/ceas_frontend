import 'package:flutter/material.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro y Reporte de Asistencia'),
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
        child: Card(
          child: ListView(
            children: const [
              ListTile(
                  title: Text('Carlos Gómez'),
                  subtitle: Text('01/06/2024 - Presente')),
              ListTile(
                  title: Text('Ana Torres'),
                  subtitle: Text('01/06/2024 - Ausente')),
              // ... más filas de ejemplo ...
            ],
          ),
        ),
      ),
    );
  }
}
