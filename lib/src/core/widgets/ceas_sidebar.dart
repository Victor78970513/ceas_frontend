import 'package:flutter/material.dart';
import '../theme/ceas_colors.dart';

class CeasSidebar extends StatelessWidget {
  final String selected;
  final Function(String) onSelect;

  const CeasSidebar({Key? key, required this.selected, required this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CeasColors.sidebarBlue,
      child: Container(
        width: 240,
        child: SafeArea(
          child: Column(
            children: [
              // Logo y nombre
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/logo_ceas_nobg.png',
                      width: 60,
                      height: 60,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 12),
                    const Flexible(
                      fit: FlexFit.loose,
                      child: Text(
                        'CEAS ERP',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: 1.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
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
              // Botón de cerrar sesión
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text('Cerrar sesión',
                      style: TextStyle(color: Colors.white)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 18),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
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
