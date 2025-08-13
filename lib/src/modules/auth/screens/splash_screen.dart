import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/ceas_colors.dart';
import '../../../core/widgets/ceas_main_layout.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Inicializar el AuthProvider
    await authProvider.initialize();

    // Esperar un poco para mostrar el splash
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      if (authProvider.isAuthenticated) {
        // Usuario autenticado, ir al dashboard
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const CeasMainLayout(initialRoute: '/dashboard'),
          ),
        );
      } else {
        // Usuario no autenticado, ir al login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CeasColors.primaryBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/logo_ceas_nobg.png',
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 40),
            // Título
            const Text(
              'CEAS ERP',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sistema de Gestión Integral',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 60),
            // Indicador de carga
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            const Text(
              'Iniciando...',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
