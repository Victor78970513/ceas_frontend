import 'package:flutter/material.dart';

class CeasSectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;

  const CeasSectionHeader({Key? key, required this.title, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) Icon(icon, color: Theme.of(context).primaryColor),
        if (icon != null) const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
