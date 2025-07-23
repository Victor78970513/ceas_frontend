import 'package:flutter/material.dart';
import 'ceas_sidebar.dart';

class CeasScaffold extends StatelessWidget {
  final String selectedRoute;
  final Widget child;

  const CeasScaffold(
      {Key? key, required this.selectedRoute, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CeasSidebar(
          selected: selectedRoute,
          onSelect: (route) {
            if (route != selectedRoute) {
              Navigator.of(context).pushReplacementNamed(route);
            }
          },
        ),
        Expanded(
          child: Container(
            color: Colors.grey[50],
            child: child,
          ),
        ),
      ],
    );
  }
}
