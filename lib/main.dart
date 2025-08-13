import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/core/routing/app_router.dart';
import 'src/core/theme/app_theme.dart';
import 'src/modules/auth/screens/splash_screen.dart';
import 'src/modules/auth/providers/auth_provider.dart';
import 'src/modules/members/providers/members_provider.dart';

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
