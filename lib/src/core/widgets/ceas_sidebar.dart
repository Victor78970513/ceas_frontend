import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/ceas_colors.dart';
import '../../modules/auth/providers/auth_provider.dart';
import '../../modules/auth/screens/login_screen.dart';

class CeasSidebar extends StatelessWidget {
  final String selected;
  final Function(String) onSelect;

  const CeasSidebar({
    Key? key,
    required this.selected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CeasColors.sidebarBlue,
      child: Container(
        width: 280,
        child: SafeArea(
          child: Column(
            children: [
              // Header del sidebar
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.sports_soccer,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CEAS ERP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Sistema de Gestión',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white24, thickness: 1, height: 0),
              // Navegación principal
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 16, left: 0, right: 0),
                  children: [
                    _sidebarItem(context, 'Panel principal', Icons.dashboard,
                        '/dashboard'),
                    _sidebarItem(context, 'Socios', Icons.groups, '/socios'),
                    _sidebarItem(context, 'Acciones',
                        Icons.assignment_turned_in, '/acciones'),
                    _sidebarItem(context, 'Finanzas', Icons.account_balance,
                        '/finanzas_reportes'),
                    _sidebarItem(context, 'Compras y Proveedores',
                        Icons.shopping_cart, '/compras_proveedores'),
                    _sidebarItem(
                        context, 'Recursos humanos', Icons.people, '/personal'),
                    const SizedBox(height: 12),
                    const Divider(
                        color: Colors.white24, thickness: 1, height: 0),
                    _sidebarItem(context, 'Usuarios y seguridad',
                        Icons.security, '/usuarios'),
                    _sidebarItem(context, 'Configuración', Icons.settings,
                        '/configuracion'),
                  ],
                ),
              ),
              // Información del usuario y botón de cerrar sesión
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return Column(
                    children: [
                      // Información del usuario
                      if (authProvider.user != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      authProvider.user!.nombreUsuario,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      authProvider.user!.correoElectronico,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      const Divider(
                          color: Colors.white24, thickness: 1, height: 0),
                      // Botón de cerrar sesión
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 16),
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await authProvider.logout();
                            if (context.mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                                (route) => false,
                              );
                            }
                          },
                          icon: const Icon(Icons.logout, color: Colors.white),
                          label: const Text('Cerrar sesión',
                              style: TextStyle(color: Colors.white)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white24),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 18),
                            textStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sidebarItem(
      BuildContext context, String title, IconData icon, String route) {
    final bool isActive = selected == route;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onSelect(route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: isActive
              ? BoxDecoration(
                  color: Colors.white.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(10),
                )
              : null,
          child: Row(
            children: [
              Icon(icon,
                  color: isActive ? Colors.amberAccent : Colors.white,
                  size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isActive ? Colors.amberAccent : Colors.white,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
