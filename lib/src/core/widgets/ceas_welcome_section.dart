import 'package:flutter/material.dart';

class CeasWelcomeSection extends StatelessWidget {
  const CeasWelcomeSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bienvenido, Seving!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1565C0),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _WelcomeKpiCard(
                title: 'Ganancias totales',
                value: 'Bs. 100.000',
                subtitle: '1 month indicator',
                icon: Icons.attach_money,
                color: Colors.blue,
              ),
              const SizedBox(width: 16),
              _WelcomeKpiCard(
                title: 'Total de acciones vendidas',
                value: '3400',
                subtitle: '1 month indicator',
                icon: Icons.assignment_turned_in,
                color: Colors.green,
              ),
              const SizedBox(width: 16),
              _WelcomeKpiCard(
                title: 'Servicio mas solicitado',
                value: 'Hoteleria',
                subtitle: '1 month indicator',
                icon: Icons.hotel,
                color: Colors.orange,
              ),
              const SizedBox(width: 16),
              _WelcomeKpiCard(
                title: 'Best Selling Product',
                value: 'Iphone 15 Pro',
                subtitle: '1 month indicator',
                icon: Icons.phone_android,
                color: Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WelcomeKpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _WelcomeKpiCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1565C0),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
