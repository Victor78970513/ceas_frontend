import 'package:flutter/material.dart';

class FinancialStateScreen extends StatelessWidget {
  const FinancialStateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estado Financiero'),
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Resumen financiero (placeholder)',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 16),
                Text('Activos: Bs. 100,000'),
                Text('Pasivos: Bs. 20,000'),
                Text('Patrimonio: Bs. 80,000'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
