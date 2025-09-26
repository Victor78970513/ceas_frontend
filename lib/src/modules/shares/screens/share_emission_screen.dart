import 'package:flutter/material.dart';
import '../../../core/theme/ceas_colors.dart';
import '../services/qr_payment_service.dart';
import '../widgets/qr_payment_dialog.dart';
import '../../members/services/members_service.dart';
import '../../members/models/socio.dart';

class ShareEmissionScreen extends StatefulWidget {
  final bool isBottomSheet;

  const ShareEmissionScreen({Key? key, this.isBottomSheet = false})
      : super(key: key);

  @override
  State<ShareEmissionScreen> createState() => _ShareEmissionScreenState();
}

class _ShareEmissionScreenState extends State<ShareEmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _membersService = MembersService();

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

  // Variables para manejo de socios
  List<Socio> _socios = [];
  List<Socio> _sociosFiltrados = [];
  Socio? _socioSeleccionado;
  bool _cargandoSocios = false;
  final _busquedaSocioController = TextEditingController();
  bool _mostrarSugerencias = false;

  // Modos de emisión predefinidos
  String _modoEmision = 'Contado';
  final List<Map<String, dynamic>> _modosEmision = [
    {
      'nombre': 'Contado',
      'descripcion': 'Pago completo de una vez',
      'valorTotal': 10000.0,
      'cuotaInicial': 10000.0,
      'numeroCuotas': 1,
      'valorCuota': 10000.0,
      'icon': Icons.payment,
      'color': Colors.green,
    },
    {
      'nombre': '2 Cuotas',
      'descripcion': '2 pagos de Bs. 5,000',
      'valorTotal': 10000.0,
      'cuotaInicial': 5000.0,
      'numeroCuotas': 2,
      'valorCuota': 5000.0,
      'icon': Icons.schedule,
      'color': Colors.blue,
    },
    {
      'nombre': '5 Cuotas',
      'descripcion': '5 pagos de Bs. 2,000',
      'valorTotal': 10000.0,
      'cuotaInicial': 2000.0,
      'numeroCuotas': 5,
      'valorCuota': 2000.0,
      'icon': Icons.credit_card,
      'color': Colors.orange,
    },
    {
      'nombre': '10 Cuotas',
      'descripcion': '10 pagos de Bs. 1,000',
      'valorTotal': 10000.0,
      'cuotaInicial': 1000.0,
      'numeroCuotas': 10,
      'valorCuota': 1000.0,
      'icon': Icons.account_balance_wallet,
      'color': Colors.purple,
    },
  ];

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


  @override
  void initState() {
    super.initState();
    _valorNominalController.text = '1000.00';
    _actualizarModoEmision(); // Usar el modo de emisión por defecto
    _cargarSocios();
    _busquedaSocioController.addListener(_filtrarSocios);
  }

  @override
  void dispose() {
    _busquedaSocioController.dispose();
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

  void _filtrarSocios() {
    final query = _busquedaSocioController.text.toLowerCase().trim();
    
    if (query.isEmpty) {
      setState(() {
        _sociosFiltrados = [];
        _mostrarSugerencias = false;
      });
      return;
    }

    setState(() {
      _sociosFiltrados = _socios.where((socio) {
        final nombre = socio.nombreCompleto.toLowerCase();
        final ci = socio.ciNit.toLowerCase();
        return nombre.contains(query) || ci.contains(query);
      }).toList();
      _mostrarSugerencias = _sociosFiltrados.isNotEmpty;
    });
  }

  Future<void> _cargarSocios() async {
    setState(() {
      _cargandoSocios = true;
    });

    try {
      final socios = await _membersService.getSocios();
      setState(() {
        _socios = socios;
        _cargandoSocios = false;
      });
    } catch (e) {
      setState(() {
        _cargandoSocios = false;
      });
      print('Error cargando socios: $e');
    }
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

  void _actualizarModoEmision() {
    final modoSeleccionado = _modosEmision.firstWhere(
      (modo) => modo['nombre'] == _modoEmision,
    );

    setState(() {
      _valorComercialController.text =
          modoSeleccionado['valorTotal'].toString();
      _cuotaInicialController.text =
          modoSeleccionado['cuotaInicial'].toString();
      _numeroCuotasController.text =
          modoSeleccionado['numeroCuotas'].toString();
      _valorCuotaController.text = modoSeleccionado['valorCuota'].toString();

      // Actualizar modalidad de pago
      if (modoSeleccionado['numeroCuotas'] > 1) {
        _modalidadPago = 'Cuotas';
        _mostrarCamposCuotas = true;
        _estado = 'Reservada';
      } else {
        _modalidadPago = 'Contado';
        _mostrarCamposCuotas = false;
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



  Future<void> _saveAccion() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_socioSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor seleccione un socio'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Obtener datos del formulario
      final idSocio = _socioSeleccionado!.idSocio;
      final totalPago = 5000.0; // Valor fijo por ahora
      final metodoPago = _metodoPago == 'Efectivo' ? 'efectivo' : 'transferencia_bancaria';

      print('🚀 Generando QR de pago...');
      print('📋 Datos: ID Socio: $idSocio, Total: $totalPago, Método: $metodoPago');

      // Llamar al servicio para generar QR
      final qrResponse = await QrPaymentService.generarQrPago(
        idClub: 1,
        idSocio: idSocio,
        modalidadPago: 1,
        estadoAccion: 1,
        tipoAccion: 'compra',
        totalPago: totalPago,
        metodoPago: metodoPago,
      );

      if (mounted) {
        // Cerrar el bottom sheet primero
        Navigator.of(context).pop();
        
        // Mostrar el diálogo con el QR
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => QrPaymentDialog(qrResponse: qrResponse),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al generar QR de pago: $e'),
            backgroundColor: Colors.red,
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

  Widget _buildSocioDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: TextFormField(
            controller: _busquedaSocioController,
            decoration: InputDecoration(
              labelText: 'Buscar Socio',
              hintText: 'Escriba el nombre o CI del socio',
              prefixIcon: const Icon(Icons.search, color: CeasColors.primaryBlue),
              suffixIcon: _socioSeleccionado != null
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _socioSeleccionado = null;
                          _busquedaSocioController.clear();
                          _mostrarSugerencias = false;
                        });
                      },
                    )
                  : _cargandoSocios
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            onTap: () {
              if (_busquedaSocioController.text.isNotEmpty) {
                setState(() {
                  _mostrarSugerencias = true;
                });
              }
            },
            onChanged: (value) {
              _filtrarSocios();
            },
            validator: (value) {
              if (_socioSeleccionado == null) {
                return 'Por favor seleccione un socio';
              }
              return null;
            },
          ),
        ),
        
        // Mostrar socio seleccionado
        if (_socioSeleccionado != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: CeasColors.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: CeasColors.primaryBlue.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  color: CeasColors.primaryBlue,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _socioSeleccionado!.nombreCompleto,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'CI: ${_socioSeleccionado!.ciNit} | ID: ${_socioSeleccionado!.idSocio}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        
        // Mostrar sugerencias
        if (_mostrarSugerencias && _sociosFiltrados.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _sociosFiltrados.length,
              itemBuilder: (context, index) {
                final socio = _sociosFiltrados[index];
                return InkWell(
                  onTap: () {
                    setState(() {
                      _socioSeleccionado = socio;
                      _busquedaSocioController.text = socio.nombreCompleto;
                      _mostrarSugerencias = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: index < _sociosFiltrados.length - 1
                          ? Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade200,
                                width: 1,
                              ),
                            )
                          : null,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: CeasColors.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.person_outline,
                            color: CeasColors.primaryBlue,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                socio.nombreCompleto,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'CI: ${socio.ciNit} | ID: ${socio.idSocio}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  void _mostrarQRPago() {
    final modoSeleccionado = _modosEmision.firstWhere(
      (modo) => modo['nombre'] == _modoEmision,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.qr_code,
              color: modoSeleccionado['color'],
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text('QR de Pago Bancario'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Acción emitida exitosamente',
              style: TextStyle(
                color: Colors.green.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  // QR simulado (placeholder)
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code,
                          size: 80,
                          color: modoSeleccionado['color'],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'QR Bancario',
                          style: TextStyle(
                            color: modoSeleccionado['color'],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Simulado',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Información del pago
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: modoSeleccionado['color'].withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: modoSeleccionado['color'].withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Detalles del Pago',
                          style: TextStyle(
                            color: modoSeleccionado['color'],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Modo de Emisión:'),
                            Text(
                              modoSeleccionado['nombre'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Valor Total:'),
                            Text(
                              'Bs. ${modoSeleccionado['valorTotal'].toStringAsFixed(0)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        if (modoSeleccionado['numeroCuotas'] > 1) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Número de Cuotas:'),
                              Text(
                                '${modoSeleccionado['numeroCuotas']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Valor por Cuota:'),
                              Text(
                                'Bs. ${modoSeleccionado['valorCuota'].toStringAsFixed(0)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Cuota Inicial:'),
                            Text(
                              'Bs. ${modoSeleccionado['cuotaInicial'].toStringAsFixed(0)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Escanea este QR con tu app bancaria para realizar el pago',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Cerrar también el bottomsheet
            },
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    VoidCallback? onTap,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      onTap: onTap,
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


  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: CeasColors.primaryBlue.withValues(alpha: 0.1),
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

  Widget _buildModosEmision() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Modo de Emisión', Icons.payment),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: _modosEmision.length,
          itemBuilder: (context, index) {
            final modo = _modosEmision[index];
            final isSelected = _modoEmision == modo['nombre'];

            return GestureDetector(
              onTap: () {
                setState(() {
                  _modoEmision = modo['nombre'];
                });
                _actualizarModoEmision();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? modo['color'].withValues(alpha: 0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? modo['color'] : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: modo['color'].withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          modo['icon'],
                          color: modo['color'],
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        modo['nombre'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? modo['color'] : Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        modo['descripcion'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Bs. ${modo['valorTotal'].toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: modo['color'],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
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

  @override
  Widget build(BuildContext context) {
    final formContent = Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Información del socio
          _buildSectionHeader('Información del Socio', Icons.person),
          const SizedBox(height: 16),

          // Dropdown para seleccionar socio
          _buildSocioDropdown(),
          const SizedBox(height: 16),

          const SizedBox(height: 32),


          // Modos de emisión
          _buildModosEmision(),
          const SizedBox(height: 32),


          // Información de pagos
          _buildSectionHeader('Información de Pagos', Icons.payment),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  value: _metodoPago,
                  items: const ['Efectivo', 'Otro método'],
                  label: 'Método de Pago',
                  icon: Icons.payment_outlined,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _metodoPago = value;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(), // Espaciador para mantener el layout
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Botones de acción
          _buildActionButtons(),
        ],
      ),
    );

    // Si es bottomsheet, solo retornar el contenido del formulario
    if (widget.isBottomSheet) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: formContent,
      );
    }

    // Si es pantalla completa, retornar el Scaffold completo
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
        child: formContent,
      ),
    );
  }
}
