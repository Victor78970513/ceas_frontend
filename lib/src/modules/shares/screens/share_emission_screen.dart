import 'package:flutter/material.dart';
import '../../../core/theme/ceas_colors.dart';

class ShareEmissionScreen extends StatefulWidget {
  const ShareEmissionScreen({Key? key}) : super(key: key);

  @override
  State<ShareEmissionScreen> createState() => _ShareEmissionScreenState();
}

class _ShareEmissionScreenState extends State<ShareEmissionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers para los campos
  final _idSocioController = TextEditingController();
  final _nombreSocioController = TextEditingController();
  final _valorNominalController = TextEditingController();
  final _valorComercialController = TextEditingController();
  final _numeroCertificadoController = TextEditingController();
  final _observacionesController = TextEditingController();
  final _cuotaInicialController = TextEditingController();
  final _numeroCuotasController = TextEditingController();
  final _valorCuotaController = TextEditingController();

  // Variables de estado
  String _tipoAccion = 'Ordinaria';
  String _estado = 'Disponible';
  String _metodoPago = 'Efectivo';
  String _modalidadPago = 'Contado';
  DateTime _fechaEmision = DateTime.now();
  DateTime? _fechaPrimerPago;
  bool _isLoading = false;
  bool _mostrarCamposCuotas = false;

  // Opciones para dropdowns
  final List<String> _tiposAccion = [
    'Ordinaria',
    'Preferencial',
    'Clase A',
    'Clase B',
    'Especial'
  ];

  final List<String> _estados = [
    'Disponible',
    'Reservada',
    'Vendida',
    'Cancelada'
  ];

  final List<String> _metodosPago = [
    'Efectivo',
    'Transferencia Bancaria',
    'Cheque',
    'Tarjeta de Crédito',
    'Tarjeta de Débito',
    'Depósito Bancario'
  ];

  final List<String> _modalidadesPago = [
    'Contado',
    'Cuotas',
    'Pago Diferido',
    'Pago Anticipado'
  ];

  // Lista de socios simulada (en producción vendría de un provider)
  final List<Map<String, dynamic>> _socios = [
    {'id': 'SOC001', 'nombre': 'Juan Pérez', 'ci': '1234567'},
    {'id': 'SOC002', 'nombre': 'María López', 'ci': '2345678'},
    {'id': 'SOC003', 'nombre': 'Carlos Gómez', 'ci': '3456789'},
    {'id': 'SOC004', 'nombre': 'Ana Torres', 'ci': '4567890'},
    {'id': 'SOC005', 'nombre': 'Luis Rodríguez', 'ci': '5678901'},
  ];

  @override
  void initState() {
    super.initState();
    _valorNominalController.text = '1000.00';
    _valorComercialController.text = '1200.00';
    _cuotaInicialController.text = '1200.00';
    _numeroCuotasController.text = '1';
    _valorCuotaController.text = '1200.00';
    _actualizarCamposCuotas();
  }

  @override
  void dispose() {
    _idSocioController.dispose();
    _nombreSocioController.dispose();
    _valorNominalController.dispose();
    _valorComercialController.dispose();
    _numeroCertificadoController.dispose();
    _observacionesController.dispose();
    _cuotaInicialController.dispose();
    _numeroCuotasController.dispose();
    _valorCuotaController.dispose();
    super.dispose();
  }

  void _actualizarCamposCuotas() {
    setState(() {
      _mostrarCamposCuotas = _modalidadPago == 'Cuotas';
      if (_mostrarCamposCuotas) {
        _estado = 'Reservada';
      } else {
        _estado = 'Disponible';
      }
    });
  }

  void _calcularCuotas() {
    final valorComercial =
        double.tryParse(_valorComercialController.text) ?? 0.0;
    final numeroCuotas = int.tryParse(_numeroCuotasController.text) ?? 1;

    if (valorComercial > 0 && numeroCuotas > 0) {
      final valorCuota = valorComercial / numeroCuotas;
      _valorCuotaController.text = valorCuota.toStringAsFixed(2);
    }
  }

  void _searchSocio() {
    showDialog(
      context: context,
      builder: (context) => _buildSocioSearchDialog(),
    );
  }

  Widget _buildSocioSearchDialog() {
    return AlertDialog(
      title: const Text('Buscar Socio'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar por nombre o CI',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Aquí iría la lógica de búsqueda en tiempo real
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _socios.length,
                itemBuilder: (context, index) {
                  final socio = _socios[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: CeasColors.primaryBlue.withOpacity(0.1),
                      child: Text(
                        socio['nombre'][0],
                        style: const TextStyle(
                          color: CeasColors.primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(socio['nombre']),
                    subtitle: Text('CI: ${socio['ci']}'),
                    onTap: () {
                      _idSocioController.text = socio['id'];
                      _nombreSocioController.text = socio['nombre'];
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
      ],
    );
  }

  Future<void> _saveAccion() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simular guardado (aquí iría la lógica real con el provider)
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Acción emitida correctamente'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: CeasColors.primaryBlue),
        title: const Text(
          'Emitir Nueva Acción',
          style: TextStyle(
              color: CeasColors.primaryBlue, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con información
              _buildFormHeader(),
              const SizedBox(height: 32),

              // Información del socio
              _buildSectionHeader('Información del Socio', Icons.person),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _idSocioController,
                      label: 'ID del Socio',
                      icon: Icons.badge_outlined,
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Seleccione un socio';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _nombreSocioController,
                      label: 'Nombre del Socio',
                      icon: Icons.person_outline,
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Seleccione un socio';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _searchSocio,
                  icon: const Icon(Icons.search),
                  label: const Text('Buscar Socio'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: CeasColors.primaryBlue,
                    side: BorderSide(color: CeasColors.primaryBlue),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Información de la acción
              _buildSectionHeader('Información de la Acción', Icons.assignment),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      value: _tipoAccion,
                      items: _tiposAccion,
                      label: 'Tipo de Acción',
                      icon: Icons.category_outlined,
                      onChanged: (value) {
                        setState(() {
                          _tipoAccion = value ?? 'Ordinaria';
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdown(
                      value: _estado,
                      items: _estados,
                      label: 'Estado',
                      icon: Icons.check_circle_outline,
                      onChanged: (value) {
                        setState(() {
                          _estado = value ?? 'Disponible';
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _valorNominalController,
                      label: 'Valor Nominal (Bs.)',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Ingrese el valor nominal';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Ingrese un valor válido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _valorComercialController,
                      label: 'Valor Comercial (Bs.)',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Ingrese el valor comercial';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Ingrese un valor válido';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _numeroCertificadoController,
                      label: 'Número de Certificado',
                      icon: Icons.description_outlined,
                      validator: (value) => null, // Opcional
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: TextEditingController(
                          text:
                              '${_fechaEmision.day.toString().padLeft(2, '0')}/${_fechaEmision.month.toString().padLeft(2, '0')}/${_fechaEmision.year}'),
                      label: 'Fecha de Emisión',
                      icon: Icons.calendar_today_outlined,
                      readOnly: true,
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _fechaEmision,
                          firstDate: DateTime(2020),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                          locale: const Locale('es', 'ES'),
                        );

                        if (picked != null && picked != _fechaEmision) {
                          setState(() {
                            _fechaEmision = picked;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Información de Pago
              _buildSectionHeader('Información de Pago', Icons.payment),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      value: _metodoPago,
                      items: _metodosPago,
                      label: 'Método de Pago',
                      icon: Icons.payment,
                      onChanged: (value) {
                        setState(() {
                          _metodoPago = value ?? 'Efectivo';
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdown(
                      value: _modalidadPago,
                      items: _modalidadesPago,
                      label: 'Modalidad de Pago',
                      icon: Icons.schedule,
                      onChanged: (value) {
                        setState(() {
                          _modalidadPago = value ?? 'Contado';
                          _actualizarCamposCuotas();
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Campos de cuotas (solo si es modalidad de cuotas)
              if (_mostrarCamposCuotas) ...[
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _cuotaInicialController,
                        label: 'Cuota Inicial (Bs.)',
                        icon: Icons.account_balance_wallet,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ingrese la cuota inicial';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Ingrese un valor válido';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _numeroCuotasController,
                        label: 'Número de Cuotas',
                        icon: Icons.format_list_numbered,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ingrese el número de cuotas';
                          }
                          if (int.tryParse(value) == null ||
                              int.parse(value) < 1) {
                            return 'Ingrese un número válido';
                          }
                          return null;
                        },
                        onChanged: (value) => _calcularCuotas(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _valorCuotaController,
                        label: 'Valor por Cuota (Bs.)',
                        icon: Icons.calculate,
                        keyboardType: TextInputType.number,
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Calcule el valor de la cuota';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: TextEditingController(
                          text: _fechaPrimerPago != null
                              ? '${_fechaPrimerPago!.day.toString().padLeft(2, '0')}/${_fechaPrimerPago!.month.toString().padLeft(2, '0')}/${_fechaPrimerPago!.year}'
                              : '',
                        ),
                        label: 'Fecha Primer Pago',
                        icon: Icons.event,
                        readOnly: true,
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _fechaPrimerPago ??
                                DateTime.now().add(const Duration(days: 30)),
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)),
                            locale: const Locale('es', 'ES'),
                          );

                          if (picked != null) {
                            setState(() {
                              _fechaPrimerPago = picked;
                            });
                          }
                        },
                        validator: (value) {
                          if (_mostrarCamposCuotas &&
                              (value == null || value.trim().isEmpty)) {
                            return 'Seleccione fecha de primer pago';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // Observaciones
              _buildSectionHeader('Observaciones', Icons.note),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _observacionesController,
                label: 'Observaciones (opcional)',
                icon: Icons.note_outlined,
                maxLines: 3,
                validator: (value) => null, // Opcional
              ),
              const SizedBox(height: 40),

              // Botones de acción
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CeasColors.primaryBlue,
            CeasColors.primaryBlue.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: CeasColors.primaryBlue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.add_business,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Emitir Nueva Acción',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Complete todos los campos para emitir una nueva acción del club',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: CeasColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: CeasColors.primaryBlue,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: CeasColors.primaryBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
    int? maxLines,
    String? Function(String?)? validator,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: maxLines ?? 1,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: CeasColors.primaryBlue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: CeasColors.primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required String label,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: CeasColors.primaryBlue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: CeasColors.primaryBlue, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            icon: const Icon(Icons.cancel),
            label: const Text('Cancelar'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey.shade700,
              side: BorderSide(color: Colors.grey.shade400),
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _saveAccion,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.add_business),
            label: Text(_isLoading ? 'Emitiendo...' : 'Emitir Acción'),
            style: ElevatedButton.styleFrom(
              backgroundColor: CeasColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ),
      ],
    );
  }
}
