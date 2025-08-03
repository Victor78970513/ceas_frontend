import 'package:flutter/material.dart';
import 'src/core/routing/app_router.dart';
import 'src/core/theme/app_theme.dart';
import 'src/modules/auth/screens/login_screen.dart';

void main() {
  runApp(const CeasApp());
}

class CeasApp extends StatelessWidget {
  const CeasApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CEAS ERP',
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
      theme: AppTheme.theme,
    );
  }
}
