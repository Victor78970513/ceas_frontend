import 'package:flutter/material.dart';
import 'src/core/routing/app_router.dart';
import 'src/core/theme/app_theme.dart';
import 'src/core/widgets/ceas_main_layout.dart';

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
      home: const CeasMainLayout(initialRoute: '/dashboard'),
      theme: AppTheme.theme,
    );
  }
}
