import 'package:flutter/material.dart';

class CeasSidebar extends StatelessWidget {
  final String selected;
  final Function(String) onSelect;

  const CeasSidebar({Key? key, required this.selected, required this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF0D1A36),
      child: Container(
        width: 240,
        color: const Color(0xFF0D1A36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text('ERP Dashboard',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1)),
            ),
            const SizedBox(height: 32),
            _sidebarItem(
                context, 'Panel principal', Icons.dashboard, '/dashboard'),
            _sidebarItem(context, 'Ventas', Icons.shopping_cart, '/acciones'),
            _sidebarItem(context, 'Finanzas', Icons.account_balance,
                '/finanzas_reportes'),
            _sidebarItem(
                context, 'Recursos humanos', Icons.people, '/personal'),
          ],
        ),
      ),
    );
  }

  Widget _sidebarItem(
      BuildContext context, String title, IconData icon, String route) {
    final bool isActive = selected == route;
    return InkWell(
      onTap: () => onSelect(route),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: isActive
            ? BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                border: Border(
                    left: BorderSide(color: Colors.lightBlueAccent, width: 4)),
              )
            : null,
        child: Row(
          children: [
            Icon(icon,
                color: isActive ? Colors.lightBlueAccent : Colors.white,
                size: 22),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.lightBlueAccent : Colors.white,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
