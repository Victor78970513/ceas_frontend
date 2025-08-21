import 'package:flutter/material.dart';
// Auth
import '../../modules/auth/screens/login_screen.dart';
// Dashboard
import '../../modules/dashboard/screens/dashboard_screen.dart';
// Socios
import '../../modules/members/screens/members_list_screen.dart';
import '../../modules/members/screens/member_detail_screen.dart';
import '../../modules/members/screens/member_form_screen.dart';
import '../../modules/members/models/socio.dart';
// Acciones
import '../../modules/shares/screens/shares_list_screen.dart';
import '../../modules/shares/screens/share_sale_form_screen.dart';
import '../../modules/shares/screens/share_certificate_screen.dart';
import '../../modules/shares/screens/share_emission_screen.dart';
// Pagos
import '../../modules/payments/screens/payments_list_screen.dart';
import '../../modules/payments/screens/payment_form_screen.dart';
import '../../modules/payments/screens/payment_history_screen.dart';
// Personal
import '../../modules/staff/screens/staff_list_screen.dart';
import '../../modules/staff/screens/staff_form_screen.dart';
import '../../modules/staff/screens/attendance_screen.dart';
// Finanzas
import '../../modules/finance/screens/income_expense_report_screen.dart';
import '../../modules/finance/screens/cash_flow_screen.dart';
import '../../modules/finance/screens/financial_state_screen.dart';
// BI
import '../../modules/bi/screens/bi_dashboard_screen.dart';
// Logs
import '../../modules/logs/screens/logs_screen.dart';
// Configuración
import '../../modules/settings/screens/settings_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case '/socios':
        return MaterialPageRoute(builder: (_) => const MembersListScreen());
      case '/socio_detalle':
        return MaterialPageRoute(builder: (_) => const MemberDetailScreen());
      case '/socio_form':
        return MaterialPageRoute(
            builder: (_) => const MemberFormScreen(socio: null));
      case '/socio_editar':
        final socio = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => MemberFormScreen(
            socio: socio != null ? Socio.fromJson(socio) : null,
          ),
        );
      case '/acciones':
        return MaterialPageRoute(builder: (_) => const SharesListScreen());
      case '/accion_venta':
        return MaterialPageRoute(builder: (_) => const ShareSaleFormScreen());
      case '/accion_certificado':
        return MaterialPageRoute(
            builder: (_) => const ShareCertificateScreen());
      case '/accion_emision':
        return MaterialPageRoute(builder: (_) => const ShareEmissionScreen());
      case '/pagos':
        return MaterialPageRoute(builder: (_) => const PaymentsListScreen());
      case '/pago_form':
        return MaterialPageRoute(builder: (_) => const PaymentFormScreen());
      case '/pago_historial':
        return MaterialPageRoute(builder: (_) => const PaymentHistoryScreen());
      case '/personal':
        return MaterialPageRoute(builder: (_) => const StaffListScreen());
      case '/personal_form':
        return MaterialPageRoute(builder: (_) => const StaffFormScreen());
      case '/asistencia':
        return MaterialPageRoute(builder: (_) => const AttendanceScreen());
      case '/finanzas_reportes':
        return MaterialPageRoute(
            builder: (_) => const IncomeExpenseReportScreen());
      case '/finanzas_flujo':
        return MaterialPageRoute(builder: (_) => const CashFlowScreen());
      case '/finanzas_estado':
        return MaterialPageRoute(builder: (_) => const FinancialStateScreen());
      case '/bi':
        return MaterialPageRoute(builder: (_) => const BiDashboardScreen());
      case '/logs':
        return MaterialPageRoute(builder: (_) => const LogsScreen());
      case '/configuracion':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
                child: Text('Pantalla no encontrada: \'${settings.name}\'')),
          ),
        );
    }
  }
}
