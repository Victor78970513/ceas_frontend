import 'package:flutter/material.dart';
import 'ceas_sidebar.dart';
import '../../modules/dashboard/screens/dashboard_screen.dart';
import '../../modules/shares/screens/shares_screen.dart';
import '../../modules/finance/screens/income_expense_report_screen.dart';
import '../../modules/staff/screens/staff_list_screen.dart';
import '../../modules/members/screens/members_list_screen.dart';
import '../../modules/users/screens/users_security_screen.dart';
import '../../modules/settings/screens/settings_screen.dart';
import '../../modules/purchases/screens/purchases_suppliers_screen.dart';
import '../../modules/bi/screens/bi_dashboard_screen.dart';

class CeasMainLayout extends StatefulWidget {
  final String initialRoute;
  const CeasMainLayout({Key? key, required this.initialRoute})
      : super(key: key);

  @override
  State<CeasMainLayout> createState() => _CeasMainLayoutState();
}

class _CeasMainLayoutState extends State<CeasMainLayout> {
  late String _selectedRoute;

  @override
  void initState() {
    super.initState();
    _selectedRoute = widget.initialRoute;
  }

  Widget _getScreen(String route) {
    switch (route) {
      case '/dashboard':
        return const DashboardScreen();
      case '/socios':
        return const MembersListScreen();
      case '/acciones':
        return const SharesScreen();
      case '/finanzas_reportes':
        return const IncomeExpenseReportScreen();
      case '/compras_proveedores':
        return const PurchasesSuppliersScreen();
      case '/personal':
        return const StaffListScreen();
      case '/usuarios':
        return const UsersSecurityScreen();
      case '/configuracion':
        return const SettingsScreen();
      case '/bi':
        return const BiDashboardScreen();
      default:
        return const Center(child: Text('Pantalla no encontrada'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth <= 768;

        if (isMobile) {
          return _buildMobileLayout();
        } else {
          return _buildDesktopLayout();
        }
      },
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
            ''), // Título vacío para que solo se vea el icono del drawer
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: const [], // Sin acciones adicionales
      ),
      drawer: Drawer(
        child: CeasSidebar(
          selected: _selectedRoute,
          onSelect: (route) {
            setState(() {
              _selectedRoute = route;
            });
            Navigator.of(context).pop(); // Cerrar el drawer
          },
        ),
      ),
      body: _getScreen(_selectedRoute),
    );
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Row(
        children: [
          CeasSidebar(
            selected: _selectedRoute,
            onSelect: (route) {
              setState(() {
                _selectedRoute = route;
              });
            },
          ),
          Expanded(
            child: Container(
              color: const Color(0xFFF5F5F5),
              child: _getScreen(_selectedRoute),
            ),
          ),
        ],
      ),
    );
  }
}
