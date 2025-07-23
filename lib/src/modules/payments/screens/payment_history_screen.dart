import 'package:flutter/material.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Pagos'),
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: ListView(
            children: const [
              ListTile(
                  title: Text('Pago #001'),
                  subtitle: Text('Fecha: 01/01/2024 - Bs. 500')),
              ListTile(
                  title: Text('Pago #002'),
                  subtitle: Text('Fecha: 15/01/2024 - Bs. 300')),
              // ... más filas de ejemplo ...
            ],
          ),
        ),
      ),
    );
  }
}
