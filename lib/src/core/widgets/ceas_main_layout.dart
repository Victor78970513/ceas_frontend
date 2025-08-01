import 'package:flutter/material.dart';
import 'ceas_sidebar.dart';
import '../../modules/dashboard/screens/dashboard_screen.dart';
import '../../modules/shares/screens/shares_list_screen.dart';
import '../../modules/finance/screens/income_expense_report_screen.dart';
import '../../modules/staff/screens/staff_list_screen.dart';
import '../../modules/shares/screens/shares_screen.dart';
import '../../modules/members/screens/members_list_screen.dart';
// Agrega más imports según módulos

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
      case '/personal':
        return const StaffListScreen();
      case '/usuarios':
        return const Center(
            child: Text('Pantalla de Usuarios y Seguridad',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)));
      case '/configuracion':
        return const Center(
            child: Text('Pantalla de Configuración',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)));
      default:
        return const Center(child: Text('Pantalla no encontrada'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
