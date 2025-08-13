import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/ceas_colors.dart';
import '../../../core/widgets/ceas_main_layout.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool keepSession = false;
  bool obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const CeasMainLayout(initialRoute: '/dashboard'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo institucional
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Image.asset(
                      'assets/logo_ceas_nobg.png',
                      width: 90,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const Text(
                    'Centro Ecuestre Apostol Santiago',
                    style: TextStyle(
                      color: CeasColors.primaryBlue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sistema de Gestión Integral',
                    style: TextStyle(
                      color: CeasColors.textSecondary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      if (authProvider.error != null) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red[200]!),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline,
                                    color: Colors.red[600], size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    authProvider.error!,
                                    style: TextStyle(
                                      color: Colors.red[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close,
                                      color: Colors.red[600], size: 18),
                                  onPressed: () => authProvider.clearError(),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Correo electrónico',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey[50],
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese su correo';
                      }
                      if (!value.contains('@')) {
                        return 'Correo inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: obscurePassword,
                    textInputAction: TextInputAction.done,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey[50],
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese su contraseña';
                      }
                      if (value.length < 6) {
                        return 'Mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: keepSession,
                        onChanged: (v) =>
                            setState(() => keepSession = v ?? false),
                        activeColor: CeasColors.primaryBlue,
                        checkColor: Colors.white,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                      const Text('Mantener sesión',
                          style: TextStyle(fontSize: 13)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {},
                        child: const Text('¿Olvidaste tu contraseña?',
                            style: TextStyle(
                                color: CeasColors.primaryBlue,
                                fontSize: 13,
                                decoration: TextDecoration.underline)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CeasColors.primaryBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          onPressed:
                              authProvider.isLoading ? null : _handleLogin,
                          child: authProvider.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text('Iniciar Sesión'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                          foregroundColor: CeasColors.primaryBlue),
                      child: const Text('Crear Cuenta',
                          style:
                              TextStyle(decoration: TextDecoration.underline)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
