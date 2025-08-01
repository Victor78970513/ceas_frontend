import 'package:flutter/material.dart';
import '../../../core/theme/ceas_colors.dart';

class MemberFormScreen extends StatefulWidget {
  const MemberFormScreen({Key? key}) : super(key: key);

  @override
  State<MemberFormScreen> createState() => _MemberFormScreenState();
}

class _MemberFormScreenState extends State<MemberFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _ciController = TextEditingController();
  final _correoController = TextEditingController();
  final _telefonoController = TextEditingController();
  String estado = 'Activo';
  final estados = ['Activo', 'Inactivo', 'Moroso'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: CeasColors.primaryBlue),
        title: const Text('Registrar/Editar Socio',
            style: TextStyle(
                color: CeasColors.primaryBlue, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            margin: const EdgeInsets.all(32),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Datos personales',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: CeasColors.primaryBlue)),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _nombreController,
                      decoration: const InputDecoration(
                          labelText: 'Nombre completo',
                          border: OutlineInputBorder()),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Ingrese el nombre' : null,
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _ciController,
                      decoration: const InputDecoration(
                          labelText: 'CI', border: OutlineInputBorder()),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Ingrese el CI' : null,
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _correoController,
                      decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          border: OutlineInputBorder()),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Ingrese el correo' : null,
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _telefonoController,
                      decoration: const InputDecoration(
                          labelText: 'Teléfono', border: OutlineInputBorder()),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Ingrese el teléfono' : null,
                    ),
                    const SizedBox(height: 18),
                    DropdownButtonFormField<String>(
                      value: estado,
                      items: estados
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) => setState(() => estado = v ?? 'Activo'),
                      decoration: const InputDecoration(
                          labelText: 'Estado', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.of(context).pop(true);
                          }
                        },
                        icon: const Icon(Icons.save),
                        label: const Text('Guardar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CeasColors.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
