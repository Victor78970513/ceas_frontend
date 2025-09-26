import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/ceas_colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/socio_accion.dart';
import '../services/socio_acciones_service.dart';
import '../widgets/certificate_download_dialog.dart';

class SocioAccionesScreen extends StatefulWidget {
  const SocioAccionesScreen({Key? key}) : super(key: key);

  @override
  State<SocioAccionesScreen> createState() => _SocioAccionesScreenState();
}

class _SocioAccionesScreenState extends State<SocioAccionesScreen> {
  List<SocioAccion> _acciones = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAcciones();
  }

  Future<void> _loadAcciones() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated && authProvider.user != null) {
        final acciones = await SocioAccionesService.getAccionesSocio(
          authProvider.user!.idUsuario,
          authProvider.user!.accessToken,
        );
        
        setState(() {
          _acciones = acciones;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Usuario no autenticado';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Mis Acciones',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.grey.shade200,
        scrolledUnderElevation: 2,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: CeasColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: CeasColors.primaryBlue.withOpacity(0.2),
                  ),
                ),
                child: Icon(
                  Icons.refresh_rounded,
                  color: CeasColors.primaryBlue,
                  size: 20,
                ),
              ),
              onPressed: _loadAcciones,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.grey.shade200,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade600),
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Cargando tus acciones...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: Colors.grey.shade100,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: Colors.red.shade400,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Error al cargar acciones',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        CeasColors.primaryBlue,
                        CeasColors.primaryBlue.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                child: ElevatedButton(
                  onPressed: _loadAcciones,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Reintentar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_acciones.isEmpty) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: Colors.grey.shade100,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.assignment_outlined,
                  size: 48,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'No tienes acciones registradas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Las acciones que adquieras aparecerán aquí',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Header con información resumida
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
            ],
            border: Border.all(
              color: Colors.grey.shade100,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: CeasColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: CeasColors.primaryBlue.withOpacity(0.2),
                      ),
                    ),
                    child: Icon(
                      Icons.analytics_rounded,
                      color: CeasColors.primaryBlue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Resumen de Acciones',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Información general de tu portafolio',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      'Total Acciones',
                      '${_acciones.fold(0, (sum, accion) => sum + accion.cantidadAcciones)}',
                      Icons.assignment_rounded,
                      Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      'Inversión Total',
                      'Bs. ${_acciones.fold(0.0, (sum, accion) => sum + accion.totalPago).toStringAsFixed(0)}',
                      Icons.attach_money_rounded,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      'Estado',
                      _acciones.every((accion) => accion.estadoAccion == 2)
                          ? 'Aprobadas'
                          : 'Mixtas',
                      Icons.check_circle_rounded,
                      _acciones.every((accion) => accion.estadoAccion == 2)
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Lista de acciones
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _acciones.length,
            itemBuilder: (context, index) {
              final accion = _acciones[index];
              return _buildAccionCard(accion);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAccionCard(SocioAccion accion) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade100,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: CeasColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: CeasColors.primaryBlue.withOpacity(0.2),
                    ),
                  ),
                  child: Icon(
                    Icons.assignment_rounded,
                    color: CeasColors.primaryBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Acción #${accion.idAccion}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        'Comprada el ${accion.fechaCreacion.day}/${accion.fechaCreacion.month}/${accion.fechaCreacion.year}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: accion.estadoAccion == 2
                          ? [
                              Colors.green.withOpacity(0.1),
                              Colors.green.withOpacity(0.05),
                            ]
                          : [
                              Colors.orange.withOpacity(0.1),
                              Colors.orange.withOpacity(0.05),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: accion.estadoAccion == 2
                          ? Colors.green.withOpacity(0.3)
                          : Colors.orange.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        accion.estadoAccion == 2
                            ? Icons.check_circle_rounded
                            : Icons.pending_rounded,
                        size: 12,
                        color: accion.estadoAccion == 2
                            ? Colors.green
                            : Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        accion.estadoNombre,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: accion.estadoAccion == 2
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Información de la acción
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'Cantidad',
                    '${accion.cantidadAcciones}',
                    Icons.assignment,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    'Precio Unitario',
                    'Bs. ${accion.precioUnitario.toStringAsFixed(0)}',
                    Icons.monetization_on,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'Total Pagado',
                    'Bs. ${accion.totalPago.toStringAsFixed(0)}',
                    Icons.payment,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    'Método',
                    accion.metodoPago,
                    Icons.credit_card,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            _buildInfoItem(
              'Fecha de Compra',
              '${accion.fechaCreacion.day}/${accion.fechaCreacion.month}/${accion.fechaCreacion.year}',
              Icons.calendar_today,
            ),
            
            // Botón de certificado si está disponible
            if (accion.certificadoPdf != null) ...[
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      CeasColors.primaryBlue,
                      CeasColors.primaryBlue.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: CeasColors.primaryBlue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showCertificadoDialog(accion.certificadoPdf!),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.picture_as_pdf_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Descargar Certificado',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCertificadoDialog(String fileName) {
    // Extraer el ID de la acción del nombre del archivo
    // El formato esperado es: certificado_accion_{id_accion}_{id_socio}_{timestamp}.pdf
    final parts = fileName.split('_');
    String accionId = '';
    if (parts.length >= 3) {
      accionId = parts[2]; // El tercer elemento debería ser el ID de la acción
    }
    
    showDialog(
      context: context,
      builder: (context) => CertificateDownloadDialog(
        fileName: fileName,
        accionId: accionId,
      ),
    );
  }
}
