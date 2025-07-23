import 'package:flutter/material.dart';
import '../../../core/widgets/ceas_drawer.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración General'),
        backgroundColor: Colors.blue[900],
      ),
      drawer: const CeasDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const ListTile(
              leading: Icon(Icons.security),
              title: Text('Gestión de roles y permisos'),
              subtitle: Text('Administrar los roles y permisos del sistema'),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text('Parámetros generales'),
              subtitle: Text('Configurar parámetros globales del sistema'),
            ),
          ],
        ),
      ),
    );
  }
}
