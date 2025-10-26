import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html;
import '../../../core/theme/ceas_colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/accion.dart';
import '../providers/accion_provider.dart';
import '../services/accion_service.dart';
import 'share_emission_screen.dart';
import 'share_certificate_screen.dart';
import '../widgets/certificate_download_dialog.dart';

class SharesListScreen extends StatefulWidget {
  const SharesListScreen({Key? key}) : super(key: key);

  @override
  State<SharesListScreen> createState() => _SharesListScreenState();
}

class _SharesListScreenState extends State<SharesListScreen> {
  String search = '';
  String filtroTipo = 'Todos';
  String filtroEstado = 'Todos';

  // Variables de paginación
  int currentPage = 1;
  int itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    // Cargar acciones al inicializar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated) {
        Provider.of<AccionProvider>(context, listen: false).loadAcciones(
          token: authProvider.user!.accessToken,
          idClub: authProvider.user!.idClub,
        );
      }
    });
  }

  List<Accion> _getFilteredAcciones(AccionProvider accionProvider) {
    return accionProvider.acciones.where((accion) {
      final matchesSearch = search.isEmpty ||
          accion.tipoAccion.toLowerCase().contains(search.toLowerCase()) ||
          accion.estadoAccionInfo.nombre
              .toLowerCase()
              .contains(search.toLowerCase()) ||
          accion.estadoPagos.estadoPago
              .toLowerCase()
              .contains(search.toLowerCase());

      final matchesTipo =
          filtroTipo == 'Todos' || accion.tipoAccion == filtroTipo;
      final matchesEstado = filtroEstado == 'Todos' ||
          accion.estadoAccionInfo.nombre == filtroEstado;

      return matchesSearch && matchesTipo && matchesEstado;
    }).toList();
  }

  List<Accion> _getPaginatedAcciones(List<Accion> filteredAcciones) {
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    return filteredAcciones.sublist(
      startIndex,
      endIndex > filteredAcciones.length ? filteredAcciones.length : endIndex,
    );
  }

  int _getTotalPages(int totalAcciones) =>
      (totalAcciones / itemsPerPage).ceil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header principal
            _buildHeader(),
            const SizedBox(height: 32),

            // Estadísticas
            _buildStatsRow(),
            const SizedBox(height: 32),

            // Filtros y búsqueda
            _buildFiltersRow(),
            const SizedBox(height: 24),

            // Lista de acciones
            Consumer<AccionProvider>(
              builder: (context, accionProvider, child) {
                final filteredAcciones = _getFilteredAcciones(accionProvider);
                final totalPages = _getTotalPages(filteredAcciones.length);

                return Column(
                  children: [
                    _buildAccionesTable(filteredAcciones),
                    const SizedBox(height: 24),
                    // Paginación
                    if (totalPages > 1) _buildPagination(totalPages),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
              Icons.assignment,
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
                  'Gestión de Acciones',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Administra todas las acciones del club deportivo',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => _descargarReporteAcciones(),
                icon: const Icon(Icons.assessment),
                label: const Text('Generar Reporte'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  textStyle:
                      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () {
                  print('DEBUG: Botón Emitir Acción presionado');
                  _showEmitAccionDialog();
                },
                icon: const Icon(Icons.add_business),
                label: const Text('Emitir Acción'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: CeasColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  textStyle:
                      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Consumer<AccionProvider>(
      builder: (context, accionProvider, child) {
        final totalAcciones = accionProvider.acciones.length;
        final estadisticas = accionProvider.getEstadisticas();
        final accionesCompletamentePagadas =
            estadisticas['completamente_pagadas'] ?? 0;
        final accionesParcialmentePagadas =
            estadisticas['parcialmente_pagadas'] ?? 0;
        final accionesPendientes = estadisticas['pendientes'] ?? 0;
        final valorTotal = accionProvider.acciones
            .fold<double>(0, (sum, a) => sum + a.estadoPagos.precioRenovacion);

        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Acciones',
                totalAcciones.toString(),
                Icons.assignment,
                CeasColors.primaryBlue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Completamente Pagadas',
                accionesCompletamentePagadas.toString(),
                Icons.check_circle,
                Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Parcialmente Pagadas',
                accionesParcialmentePagadas.toString(),
                Icons.pending,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Valor Total',
                'Bs. ${valorTotal.toStringAsFixed(0)}',
                Icons.attach_money,
                Colors.purple,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersRow() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Buscar acciones...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) {
              setState(() {
                search = value;
                currentPage = 1;
              });
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: filtroTipo,
            decoration: InputDecoration(
              labelText: 'Tipo',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            items: ['Todos', 'Ordinaria', 'Preferencial', 'Clase A', 'Especial']
                .map((tipo) => DropdownMenuItem(value: tipo, child: Text(tipo)))
                .toList(),
            onChanged: (value) {
              setState(() {
                filtroTipo = value ?? 'Todos';
                currentPage = 1;
              });
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: filtroEstado,
            decoration: InputDecoration(
              labelText: 'Estado',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            items: ['Todos', 'estado1', 'estado2', 'estado3']
                .map((estado) =>
                    DropdownMenuItem(value: estado, child: Text(estado)))
                .toList(),
            onChanged: (value) {
              setState(() {
                filtroEstado = value ?? 'Todos';
                currentPage = 1;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAccionesTable(List<Accion> filteredAcciones) {
    if (filteredAcciones.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No se encontraron acciones',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Intenta ajustar los filtros de búsqueda',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Socio ID')),
            DataColumn(label: Text('Tipo')),
            DataColumn(label: Text('Precio Renovación')),
            DataColumn(label: Text('Estado Acción')),
            DataColumn(label: Text('Estado Pago')),
            DataColumn(label: Text('Modalidad Pago')),
            DataColumn(label: Text('Acciones')),
          ],
          rows: _getPaginatedAcciones(filteredAcciones).map((accion) {
            return DataRow(
              cells: [
                DataCell(Text(accion.idAccion.toString())),
                DataCell(Text(accion.idSocio.toString())),
                DataCell(Text(accion.tipoAccion)),
                DataCell(Text(
                    'Bs. ${accion.estadoPagos.precioRenovacion.toStringAsFixed(0)}')),
                DataCell(
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          _getEstadoAccionColor(accion.estadoAccionInfo.nombre)
                              .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      accion.estadoAccionInfo.nombre,
                      style: TextStyle(
                        color: _getEstadoAccionColor(
                            accion.estadoAccionInfo.nombre),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getEstadoPagoColor(accion.estadoPagos.estadoPago)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      accion.estadoPagos.estadoPago,
                      style: TextStyle(
                        color:
                            _getEstadoPagoColor(accion.estadoPagos.estadoPago),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                DataCell(Text(accion.modalidadPagoInfo.descripcion)),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Botón de descarga de certificado
                      if (accion.certificadoPdf != null && accion.certificadoPdf!.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.picture_as_pdf, size: 18),
                          onPressed: () => _showCertificadoDialog(context, accion),
                          tooltip: 'Descargar Certificado',
                          color: Colors.red,
                        ),
                      IconButton(
                        icon: const Icon(Icons.visibility, size: 18),
                        onPressed: () => _viewAccion(accion),
                        tooltip: 'Ver detalles',
                      ),
                      if (accion.estadoPagos.estadoPago !=
                          'COMPLETAMENTE_PAGADA')
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18),
                          onPressed: () => _editAccion(accion),
                          tooltip: 'Editar',
                        ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPagination(int totalPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed:
              currentPage > 1 ? () => setState(() => currentPage--) : null,
        ),
        ...List.generate(
          totalPages,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextButton(
              onPressed: () => setState(() => currentPage = index + 1),
              style: TextButton.styleFrom(
                backgroundColor: currentPage == index + 1
                    ? CeasColors.primaryBlue
                    : Colors.transparent,
                foregroundColor: currentPage == index + 1
                    ? Colors.white
                    : CeasColors.primaryBlue,
              ),
              child: Text('${index + 1}'),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: currentPage < totalPages
              ? () => setState(() => currentPage++)
              : null,
        ),
      ],
    );
  }

  Color _getEstadoColor(String estado) {
    switch (estado) {
      case 'Disponible':
        return Colors.green;
      case 'Vendida':
        return Colors.orange;
      case 'Reservada':
        return Colors.blue;
      case 'Cancelada':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getEstadoAccionColor(String estado) {
    switch (estado) {
      case 'estado1':
        return Colors.green;
      case 'estado2':
        return Colors.orange;
      case 'estado3':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color _getEstadoPagoColor(String estado) {
    switch (estado) {
      case 'COMPLETAMENTE_PAGADA':
        return Colors.green;
      case 'PARCIALMENTE_PAGADA':
        return Colors.orange;
      case 'PENDIENTE':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showEmitAccionDialog() {
    print('DEBUG: Función _showEmitAccionDialog ejecutada');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Abriendo pantalla de emisión...'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 1),
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ShareEmissionScreen(),
      ),
    ).then((result) {
      if (result == true) {
        // Si se emitió una acción, refrescar la lista
        setState(() {
          // Aquí podrías refrescar los datos
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Acción emitida exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  void _viewAccion(Accion accion) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ShareCertificateScreen(),
      ),
    );
  }

  void _editAccion(Accion accion) {
    // Aquí iría la lógica para editar la acción
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editando acción ${accion.idAccion}'),
        backgroundColor: CeasColors.primaryBlue,
      ),
    );
  }

  void _showCertificadoDialog(BuildContext context, Accion accion) {
    // Verificar si hay un certificado disponible para descargar
    if (accion.certificadoPdf != null && accion.certificadoPdf!.isNotEmpty) {
      // Mostrar diálogo de descarga
      showDialog(
        context: context,
        builder: (context) => CertificateDownloadDialog(
          fileName: accion.certificadoPdf!,
          accionId: accion.idAccion.toString(),
        ),
      );
    } else {
      // Mostrar mensaje de que no hay certificado disponible
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.info, color: Colors.white),
              const SizedBox(width: 8),
              Text('No hay certificado disponible para la acción ${accion.idAccion}'),
            ],
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// Descarga el reporte de acciones en formato PDF
  Future<void> _descargarReporteAcciones() async {
    try {
      // Mostrar diálogo de carga
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Generando reporte PDF...'),
            ],
          ),
        ),
      );

      // Obtener token de autenticación
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (!authProvider.isAuthenticated) {
        throw Exception('No autenticado');
      }

      final accionService = AccionService();
      final pdfBytes = await accionService.downloadReporteAcciones(
        token: authProvider.user!.accessToken,
      );

      // Cerrar diálogo de carga
      if (mounted) Navigator.of(context).pop();

      if (pdfBytes.isEmpty) {
        throw Exception('El archivo PDF está vacío');
      }

      // Crear URL del blob para descarga en web
      final blob = html.Blob([pdfBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      
      // Crear un elemento de enlace temporal
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'reporte_acciones_${DateTime.now().millisecondsSinceEpoch}.pdf')
        ..click();
      
      // Limpiar la URL del blob
      html.Url.revokeObjectUrl(url);

      if (mounted) {
        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Reporte descargado exitosamente',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Cerrar diálogo de carga si está abierto
      if (mounted) Navigator.of(context).pop();

      print('❌ Error descargando reporte: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Error al descargar reporte: $e',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }
}
