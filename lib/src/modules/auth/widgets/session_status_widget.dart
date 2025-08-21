import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../../../core/theme/ceas_colors.dart';

class SessionStatusWidget extends StatelessWidget {
  const SessionStatusWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (!authProvider.isAuthenticated) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.security_rounded,
                    color: CeasColors.primaryBlue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Estado de Sesión',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: CeasColors.primaryBlue,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: const Text(
                      'Activa',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (authProvider.user != null) ...[
                Text(
                  'Usuario: ${authProvider.user!.nombreUsuario}',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  'Rol: ${_getRolText(authProvider.user!.rol)}',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  'Club ID: ${authProvider.user!.idClub}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _checkSession(context, authProvider),
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: const Text('Verificar Sesión'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: CeasColors.primaryBlue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => authProvider.logout(),
                      icon: const Icon(Icons.logout_rounded, size: 16),
                      label: const Text('Cerrar Sesión'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _getRolText(int rol) {
    switch (rol) {
      case 1:
        return 'Administrador';
      case 2:
        return 'Usuario';
      case 3:
        return 'Socio';
      default:
        return 'Desconocido';
    }
  }

  Future<void> _checkSession(
      BuildContext context, AuthProvider authProvider) async {
    try {
      final isValid = await authProvider.checkSession();
      if (isValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Sesión verificada correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Sesión expirada, redirigiendo al login'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⚠️ Error al verificar sesión: $e'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
}

