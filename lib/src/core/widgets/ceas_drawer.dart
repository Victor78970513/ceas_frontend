import 'package:flutter/material.dart';

class CeasDrawer extends StatelessWidget {
  const CeasDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: const Text('Menú CEAS',
                style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          _drawerItem(context, 'Dashboard', Icons.dashboard, '/dashboard'),
          _drawerItem(context, 'Socios', Icons.people, '/socios'),
          _drawerItem(context, 'Acciones', Icons.assignment, '/acciones'),
          _drawerItem(context, 'Pagos', Icons.payment, '/pagos'),
          _drawerItem(context, 'Personal', Icons.badge, '/personal'),
          _drawerItem(
              context, 'Finanzas', Icons.account_balance, '/finanzas_reportes'),
          _drawerItem(context, 'Business Intelligence', Icons.bar_chart, '/bi'),
          _drawerItem(context, 'Logs del Sistema', Icons.list_alt, '/logs'),
          _drawerItem(
              context, 'Configuración', Icons.settings, '/configuracion'),
        ],
      ),
    );
  }

  Widget _drawerItem(
      BuildContext context, String title, IconData icon, String route) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(route);
      },
    );
  }
}
