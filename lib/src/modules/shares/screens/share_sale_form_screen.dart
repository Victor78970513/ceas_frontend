import 'package:flutter/material.dart';

class ShareSaleFormScreen extends StatelessWidget {
  const ShareSaleFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Venta de Acción'),
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
          children: [
            TextField(
              decoration: const InputDecoration(
                  labelText: 'Socio', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                  labelText: 'Modalidad de pago', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'contado', child: Text('Contado')),
                DropdownMenuItem(value: 'cuotas', child: Text('Cuotas')),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.blue[900]),
                child: const Text('Registrar venta'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
