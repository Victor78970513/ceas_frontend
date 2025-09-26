import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../modules/auth/providers/auth_provider.dart';

class CeasDrawer extends StatelessWidget {
  const CeasDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final isSocio = authProvider.user?.rol == 4;
        
        return Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isSocio ? 'Mi Cuenta CEAS' : 'Menú CEAS',
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    if (authProvider.user != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        authProvider.user!.nombreUsuario,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        isSocio ? 'Socio' : 'Administrador',
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSocio) ...[
                // Menú para socios
                _drawerItem(context, 'Mis Acciones', Icons.assignment, '/socio-acciones'),
              ] else ...[
                // Menú para administradores
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
            ],
          ),
        );
      },
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
