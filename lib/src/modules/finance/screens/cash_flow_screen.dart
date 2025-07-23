import 'package:flutter/material.dart';

class CashFlowScreen extends StatelessWidget {
  const CashFlowScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flujo de Caja'),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Gráfico de flujo de caja (placeholder)',
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            Expanded(
              child: Card(
                child: Center(
                    child: Text(
                        'Aquí irá el gráfico o tabla de flujo de caja')), // Placeholder
              ),
            ),
          ],
        ),
      ),
    );
  }
}
