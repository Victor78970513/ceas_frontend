import 'package:flutter/material.dart';
import '../theme/ceas_colors.dart';

class CeasHeader extends StatelessWidget {
  final String title;
  const CeasHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      color: CeasColors.headerBlue,
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.blue[700],
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 32),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white),
                onPressed: () {},
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text('Seving Aslanova',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  Text('seving@email.com',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: CeasColors.headerBlue),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
