import 'package:flutter/material.dart';
import '../../../core/theme/ceas_colors.dart';

class MemberDetailScreen extends StatelessWidget {
  const MemberDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: CeasColors.primaryBlue),
        title: const Text('Detalle de Socio',
            style: TextStyle(
                color: CeasColors.primaryBlue, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info personal y estado
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 38,
                  backgroundColor: CeasColors.primaryBlue.withOpacity(0.1),
                  child: const Icon(Icons.person,
                      color: CeasColors.primaryBlue, size: 40),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Juan Pérez',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: CeasColors.primaryBlue)),
                      const SizedBox(height: 4),
                      const Text('CI: 1234567',
                          style: TextStyle(
                              fontSize: 16, color: CeasColors.textSecondary)),
                      const SizedBox(height: 4),
                      const Text('Correo: juan.perez@email.com',
                          style: TextStyle(
                              fontSize: 16, color: CeasColors.textSecondary)),
                      const SizedBox(height: 4),
                      const Text('Teléfono: 78945612',
                          style: TextStyle(
                              fontSize: 16, color: CeasColors.textSecondary)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _estadoBadge('Activo'),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('Membresía vigente',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Botones de acción
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CeasColors.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.block, color: Colors.red),
                      label: const Text('Desactivar',
                          style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Acciones asociadas
            _SectionCard(
              title: 'Acciones asociadas',
              icon: Icons.assignment_turned_in,
              child: Column(
                children: [
                  _accionRow('ACC-001', 'Acción Preferente', 'Activa'),
                  _accionRow('ACC-002', 'Acción Ordinaria', 'Activa'),
                ],
              ),
              action: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Asignar acción'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CeasColors.primaryBlue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Historial de pagos
            _SectionCard(
              title: 'Historial de pagos',
              icon: Icons.payments,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(
                        label: Text('Fecha',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Concepto',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Monto',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Facturación',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: [
                    _pagoRow('01/06/2024', 'Cuota mensual', 'Bs 500', true),
                    _pagoRow('01/05/2024', 'Cuota mensual', 'Bs 500', true),
                    _pagoRow('01/04/2024', 'Cuota mensual', 'Bs 500', false),
                  ],
                ),
              ),
              action: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.receipt_long),
                label: const Text('Generar facturación'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CeasColors.primaryBlue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _estadoBadge(String estado) {
    Color color;
    switch (estado) {
      case 'Activo':
        color = Colors.green;
        break;
      case 'Inactivo':
        color = Colors.grey;
        break;
      case 'Moroso':
        color = Colors.red;
        break;
      default:
        color = Colors.blueGrey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(estado,
          style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }

  Widget _accionRow(String codigo, String tipo, String estado) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(Icons.label, color: CeasColors.primaryBlue, size: 20),
          const SizedBox(width: 10),
          Text(codigo, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 16),
          Text(tipo),
          const SizedBox(width: 16),
          _estadoBadge(estado),
        ],
      ),
    );
  }

  DataRow _pagoRow(
      String fecha, String concepto, String monto, bool facturado) {
    return DataRow(
      cells: [
        DataCell(Text(fecha)),
        DataCell(Text(concepto)),
        DataCell(Text(monto)),
        DataCell(facturado
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.cancel, color: Colors.red)),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final Widget? action;
  const _SectionCard(
      {required this.title,
      required this.icon,
      required this.child,
      this.action});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: CeasColors.primaryBlue, size: 22),
                const SizedBox(width: 10),
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                if (action != null) action!,
              ],
            ),
            const SizedBox(height: 18),
            child,
          ],
        ),
      ),
    );
  }
}
