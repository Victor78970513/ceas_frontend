import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/core/routing/app_router.dart';
import 'src/core/theme/app_theme.dart';
import 'src/modules/auth/screens/splash_screen.dart';
import 'src/modules/auth/providers/auth_provider.dart';
import 'src/modules/members/providers/members_provider.dart';
import 'src/modules/members/providers/socio_provider.dart';
import 'src/modules/shares/providers/accion_provider.dart';
import 'src/modules/finance/providers/finance_provider.dart';
import 'src/modules/purchases/providers/proveedor_provider.dart';
import 'src/modules/purchases/providers/compra_provider.dart';
import 'src/modules/staff/providers/personal_provider.dart';
import 'src/modules/staff/providers/asistencia_provider.dart';
import 'src/modules/dashboard/providers/dashboard_provider.dart';
import 'src/modules/bi/providers/bi_provider.dart';

void main() {
  runApp(const CeasApp());
}

class CeasApp extends StatelessWidget {
  const CeasApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MembersProvider()),
        ChangeNotifierProvider(create: (_) => SocioProvider()),
        ChangeNotifierProvider(create: (_) => AccionProvider()),
        ChangeNotifierProvider(create: (_) => FinanceProvider()),
        ChangeNotifierProvider(create: (_) => ProveedorProvider()),
        ChangeNotifierProvider(create: (_) => CompraProvider()),
        ChangeNotifierProvider(create: (_) => PersonalProvider()),
        ChangeNotifierProvider(create: (_) => AsistenciaProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => BiProvider()),
      ],
      child: MaterialApp(
        title: 'CEAS ERP',
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        theme: AppTheme.theme,
      ),
    );
  }
}
