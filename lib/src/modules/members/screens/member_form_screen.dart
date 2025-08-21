import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/ceas_colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/socio.dart';
import '../providers/socio_provider.dart';

class MemberFormScreen extends StatefulWidget {
  final Socio? socio; // Si es null, es crear; si tiene valor, es editar
  final bool isBottomSheet; // Si es true, se muestra como bottom sheet

  const MemberFormScreen({
    Key? key,
    this.socio,
    this.isBottomSheet = false,
  }) : super(key: key);

  @override
  State<MemberFormScreen> createState() => _MemberFormScreenState();
}

class _MemberFormScreenState extends State<MemberFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers para los campos
  final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _ciNitController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _correoController = TextEditingController();
  final _direccionController = TextEditingController();
  final _fechaNacimientoController = TextEditingController();

  // Variables de estado
  String _estado = 'Activo';
  String _tipoMembresia = 'Individual';
  DateTime? _fechaNacimiento;
  bool _isLoading = false;

  // Opciones para dropdowns
  final List<String> _estados = ['Activo', 'Inactivo', 'Moroso'];
  List<String> _tiposMembresia = [
    'Individual',
    'Familiar',
    'Corporativa',
    'VIP',
    'Estudiante',
    'Accionista'
  ];

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.socio != null) {
      // Modo edición - cargar datos existentes
      _nombresController.text = widget.socio!.nombres;
      _apellidosController.text = widget.socio!.apellidos;
      _ciNitController.text = widget.socio!.ciNit;
      _telefonoController.text = widget.socio!.telefono;
      _correoController.text = widget.socio!.correoElectronico;
      _direccionController.text = widget.socio!.direccion;

      // Manejar estado de manera robusta
      if (_estados.contains(widget.socio!.estadoTexto)) {
        _estado = widget.socio!.estadoTexto;
      } else {
        // Si el estado no está en la lista, usar el primero disponible
        _estado = _estados.first;
      }

      // Manejar tipo de membresía de manera robusta
      if (_tiposMembresia.contains(widget.socio!.tipoMembresia)) {
        _tipoMembresia = widget.socio!.tipoMembresia;
      } else {
        // Si el tipo no está en la lista, agregarlo temporalmente
        if (widget.socio!.tipoMembresia.isNotEmpty) {
          _tiposMembresia.add(widget.socio!.tipoMembresia);
          _tipoMembresia = widget.socio!.tipoMembresia;
        } else {
          _tipoMembresia = _tiposMembresia.first;
        }
      }

      if (widget.socio!.fechaNacimiento != null) {
        try {
          _fechaNacimiento = DateTime.parse(widget.socio!.fechaNacimiento!);
          _fechaNacimientoController.text = _formatDate(_fechaNacimiento!);
        } catch (e) {
          // Ignorar error de parsing de fecha
        }
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _selectDate(BuildContext context) async {
    try {
      // Asegurarse de que el contexto sea válido
      if (!mounted) return;

      // Usar un enfoque más directo para evitar problemas de localización
      final DateTime? picked = await showDialog<DateTime>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Seleccionar Fecha de Nacimiento'),
            content: SizedBox(
              width: 300,
              height: 400,
              child: CalendarDatePicker(
                initialDate: _fechaNacimiento ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                onDateChanged: (DateTime value) {
                  Navigator.of(context).pop(value);
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context)
                    .pop(_fechaNacimiento ?? DateTime.now()),
                child: const Text('Confirmar'),
              ),
            ],
          );
        },
      );

      // Verificar que el widget siga montado antes de actualizar el estado
      if (mounted && picked != null && picked != _fechaNacimiento) {
        setState(() {
          _fechaNacimiento = picked;
          _fechaNacimientoController.text = _formatDate(picked);
        });
      }
    } catch (e) {
      // En caso de error, mostrar un mensaje pero no crashear
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al seleccionar fecha: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _saveSocio() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Obtener el token del AuthProvider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (!authProvider.isAuthenticated) {
        throw Exception('No hay sesión activa');
      }

      final token = authProvider.user!.accessToken;
      final idClub = authProvider.user!.idClub;

      if (widget.socio != null) {
        // Modo edición - actualizar socio existente
        final socioProvider =
            Provider.of<SocioProvider>(context, listen: false);
        final success = await socioProvider.updateSocio(
          token: token,
          idSocio: widget.socio!.idSocio,
          idClub: idClub,
          nombres: _nombresController.text.trim(),
          apellidos: _apellidosController.text.trim(),
          ciNit: _ciNitController.text.trim(),
          telefono: _telefonoController.text.trim(),
          correoElectronico: _correoController.text.trim(),
          direccion: _direccionController.text.trim(),
          estado: _getEstadoValue(_estado),
          fechaNacimiento: _fechaNacimiento != null
              ? _formatDateForBackend(_fechaNacimiento!)
              : '',
          tipoMembresia: _tipoMembresia,
        );

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Socio actualizado correctamente'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          throw Exception('Error al actualizar el socio');
        }
      } else {
        // Modo creación - crear nuevo socio
        final socioProvider =
            Provider.of<SocioProvider>(context, listen: false);
        final success = await socioProvider.createSocio(
          token: token,
          idClub: idClub,
          nombres: _nombresController.text.trim(),
          apellidos: _apellidosController.text.trim(),
          ciNit: _ciNitController.text.trim(),
          telefono: _telefonoController.text.trim(),
          correoElectronico: _correoController.text.trim(),
          direccion: _direccionController.text.trim(),
          estado: _getEstadoValue(_estado),
          fechaNacimiento: _fechaNacimiento != null
              ? _formatDateForBackend(_fechaNacimiento!)
              : '',
          tipoMembresia: _tipoMembresia,
        );

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Socio creado correctamente'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          throw Exception('Error al crear el socio');
        }
      }

      // Si es bottom sheet, cerrarlo; si no, navegar de vuelta
      if (mounted) {
        if (widget.isBottomSheet) {
          Navigator.of(context).pop(true);
        } else {
          Navigator.of(context).pop(true);
        }
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
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    _ciNitController.dispose();
    _telefonoController.dispose();
    _correoController.dispose();
    _direccionController.dispose();
    _fechaNacimientoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.socio != null;

    // Si es bottom sheet, no usar Scaffold
    if (widget.isBottomSheet) {
      return _buildFormContent(isEditing);
    }

    // Si es pantalla completa, usar Scaffold normal
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: CeasColors.primaryBlue),
        title: Text(
          isEditing ? 'Editar Socio' : 'Crear Nuevo Socio',
          style: const TextStyle(
              color: CeasColors.primaryBlue, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteConfirmation(),
            ),
        ],
      ),
      body: _buildFormContent(isEditing),
    );
  }

  Widget _buildFormContent(bool isEditing) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(widget.isBottomSheet ? 16.0 : 24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con información (solo si no es bottom sheet)
            if (!widget.isBottomSheet) ...[
              _buildFormHeader(isEditing),
              const SizedBox(height: 32),
            ],

            // Datos personales
            _buildSectionHeader('Datos Personales', Icons.person),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _nombresController,
                    label: 'Nombres',
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingrese los nombres';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _apellidosController,
                    label: 'Apellidos',
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingrese los apellidos';
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
                    controller: _ciNitController,
                    label: 'CI/NIT',
                    icon: Icons.badge_outlined,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingrese el CI/NIT';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _fechaNacimientoController,
                    label: 'Fecha de Nacimiento',
                    icon: Icons.calendar_today_outlined,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    validator: (value) => null, // Opcional
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Información de contacto
            _buildSectionHeader('Información de Contacto', Icons.contact_phone),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _correoController,
              label: 'Correo Electrónico',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingrese el correo electrónico';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Ingrese un correo válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _telefonoController,
                    label: 'Teléfono',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingrese el teléfono';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _direccionController,
                    label: 'Dirección',
                    icon: Icons.location_on_outlined,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingrese la dirección';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Información de membresía
            _buildSectionHeader(
                'Información de Membresía', Icons.card_membership),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    value: _estado,
                    items: _estados,
                    label: 'Estado',
                    icon: Icons.check_circle_outline,
                    onChanged: (value) {
                      setState(() {
                        _estado = value ?? 'Activo';
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDropdown(
                    value: _tipoMembresia,
                    items: _tiposMembresia,
                    label: 'Tipo de Membresía',
                    icon: Icons.category_outlined,
                    onChanged: (value) {
                      setState(() {
                        _tipoMembresia = value ?? 'Individual';
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Botones de acción
            _buildActionButtons(isEditing),

            // Espacio extra para bottom sheet
            if (widget.isBottomSheet) const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFormHeader(bool isEditing) {
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
            child: Icon(
              isEditing ? Icons.edit : Icons.person_add,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Editar Socio' : 'Crear Nuevo Socio',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isEditing
                      ? 'Modifica la información del socio seleccionado'
                      : 'Completa todos los campos para registrar un nuevo socio',
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
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
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

  Widget _buildActionButtons(bool isEditing) {
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
            onPressed: _isLoading ? null : _saveSocio,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Icon(
                    isEditing ? Icons.save : Icons.add,
                    color: Colors.white,
                  ),
            label: Text(_isLoading
                ? 'Guardando...'
                : (isEditing ? 'Actualizar' : 'Crear Socio')),
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

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text(
          '¿Estás seguro de que quieres eliminar al socio ${widget.socio!.nombreCompleto}? '
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Aquí iría la lógica de eliminación
              Navigator.of(context).pop(true);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  // Método auxiliar para convertir estado de texto a valor numérico
  int _getEstadoValue(String estadoTexto) {
    switch (estadoTexto) {
      case 'Activo':
        return 1;
      case 'Inactivo':
        return 0;
      case 'Moroso':
        return 2;
      default:
        return 1; // Por defecto activo
    }
  }

  // Método auxiliar para formatear fecha para el backend (YYYY-MM-DD)
  String _formatDateForBackend(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
