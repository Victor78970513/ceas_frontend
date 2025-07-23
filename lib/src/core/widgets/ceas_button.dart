import 'package:flutter/material.dart';

class CeasButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isPrimary;

  const CeasButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isPrimary = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonStyle = isPrimary
        ? ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          )
        : OutlinedButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            side: BorderSide(color: Theme.of(context).primaryColor),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          );
    if (isPrimary) {
      return SizedBox(
        width: double.infinity,
        child: icon == null
            ? ElevatedButton(
                onPressed: onPressed,
                style: buttonStyle,
                child: Text(text),
              )
            : ElevatedButton.icon(
                onPressed: onPressed,
                style: buttonStyle,
                icon: Icon(icon),
                label: Text(text),
              ),
      );
    } else {
      return SizedBox(
        width: double.infinity,
        child: icon == null
            ? OutlinedButton(
                onPressed: onPressed,
                style: buttonStyle,
                child: Text(text),
              )
            : OutlinedButton.icon(
                onPressed: onPressed,
                style: buttonStyle,
                icon: Icon(icon),
                label: Text(text),
              ),
      );
    }
  }
}
