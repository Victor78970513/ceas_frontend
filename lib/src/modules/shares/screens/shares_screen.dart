import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/foundation.dart';

// Importación condicional para web
import 'dart:html' as html;
import '../../../core/theme/ceas_colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/accion.dart';
import '../providers/accion_provider.dart';
import 'share_emission_screen.dart';
import '../widgets/certificate_download_dialog.dart';

class SharesScreen extends StatefulWidget {
  const SharesScreen({Key? key}) : super(key: key);

  @override
  State<SharesScreen> createState() => _SharesScreenState();
}

class _SharesScreenState extends State<SharesScreen> {
  String search = '';
  String estadoAccion = 'Todos';
  String tipoAccion = 'Todos';
  bool _dialogoCargaAbierto = false;
  final estadosAccion = [
    'Todos',
    'Activa',
    'Pendiente',
    'Expirada',
    'Cancelada',
    'Suspendida'
  ];
  final tiposAccion = ['Todos', 'Ordinaria', 'Preferencial', 'Especial'];

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

    // Respaldo de emergencia: cerrar diálogo de carga si se queda abierto por más de 1 minuto
    Timer.periodic(const Duration(seconds: 60), (timer) {
      if (_dialogoCargaAbierto && mounted) {
        print(
            '⚠️ Diálogo de carga abierto por más de 1 minuto, cerrando forzadamente...');
        _cerrarDialogoCargaForzado(context);
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccionProvider>(
      builder: (context, accionProvider, child) {
        // Filtrado se maneja ahora a través de la paginación

        final totalAcciones = accionProvider.acciones.length;
        final estadisticas = accionProvider.getEstadisticas();
        final accionesCompletamentePagadas =
            estadisticas['completamente_pagadas'] ?? 0;
        final accionesParcialmentePagadas =
            estadisticas['parcialmente_pagadas'] ?? 0;
        final accionesPendientes = estadisticas['pendientes'] ?? 0;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header principal
                Container(
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
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.assignment_turned_in_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Gestión de Acciones',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Administra las acciones emitidas y certificados del CEAS',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          _showEmitirAccionDialog(context);
                        },
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Emitir Acción'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: CeasColors.primaryBlue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Estadísticas
                Row(
                  children: [
                    _buildStatCard(
                        'Total Acciones',
                        totalAcciones.toString(),
                        Icons.assignment_rounded,
                        CeasColors.kpiBlue,
                        'Acciones emitidas'),
                    const SizedBox(width: 16),
                    _buildStatCard(
                        'Completamente Pagadas',
                        accionesCompletamentePagadas.toString(),
                        Icons.check_circle_rounded,
                        CeasColors.kpiGreen,
                        '100% pagadas'),
                    const SizedBox(width: 16),
                    _buildStatCard(
                        'Parcialmente Pagadas',
                        accionesParcialmentePagadas.toString(),
                        Icons.payment_rounded,
                        CeasColors.kpiOrange,
                        'Pagos parciales'),
                    const SizedBox(width: 16),
                    _buildStatCard(
                        'Pendientes',
                        accionesPendientes.toString(),
                        Icons.warning_rounded,
                        CeasColors.kpiPurple,
                        'Sin pagos'),
                  ],
                ),
                const SizedBox(height: 24),

                // Filtros y búsqueda
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey[200]!, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: CeasColors.primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.filter_alt_rounded,
                                color: CeasColors.primaryBlue,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Filtros y Búsqueda',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: CeasColors.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[200]!),
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText:
                                        'Buscar por socio o ID de acción...',
                                    hintStyle:
                                        TextStyle(color: Colors.grey[500]),
                                    prefixIcon: const Icon(Icons.search_rounded,
                                        color: Colors.grey),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 16),
                                  ),
                                  onChanged: (v) => setState(() => search = v),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: DropdownButton<String>(
                                value: estadoAccion,
                                items: estadosAccion
                                    .map((e) => DropdownMenuItem(
                                        value: e, child: Text(e)))
                                    .toList(),
                                onChanged: (v) =>
                                    setState(() => estadoAccion = v ?? 'Todos'),
                                underline: Container(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: CeasColors.primaryBlue),
                                icon: const Icon(
                                    Icons.keyboard_arrow_down_rounded),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: DropdownButton<String>(
                                value: tipoAccion,
                                items: tiposAccion
                                    .map((e) => DropdownMenuItem(
                                        value: e, child: Text(e)))
                                    .toList(),
                                onChanged: (v) =>
                                    setState(() => tipoAccion = v ?? 'Todos'),
                                underline: Container(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: CeasColors.primaryBlue),
                                icon: const Icon(
                                    Icons.keyboard_arrow_down_rounded),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Tabla de acciones
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey[200]!, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: CeasColors.primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.table_chart_rounded,
                                color: CeasColors.primaryBlue,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Acciones Emitidas',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: CeasColors.primaryBlue,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: CeasColors.primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${accionProvider.totalItems} acciones encontradas (Página ${accionProvider.currentPage} de ${accionProvider.totalPages})',
                                style: const TextStyle(
                                  color: CeasColors.primaryBlue,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            // Header de la tabla
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              decoration: BoxDecoration(
                                color: CeasColors.primaryBlue.withOpacity(0.05),
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey[200]!, width: 1),
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Expanded(
                                  //     flex: 1, child: _buildHeaderCell('ID')),
                                  Expanded(
                                      flex: 1,
                                      child: _buildHeaderCell('Socio Titular')),
                                  Expanded(
                                      flex: 1,
                                      child: _buildHeaderCell(
                                          'Tipo', TextAlign.center)),
                                  Flexible(
                                      flex: 1,
                                      child: Center(
                                          child: _buildHeaderCell('Estado'))),
                                  Expanded(
                                      flex: 1,
                                      child: _buildHeaderCell('Modalidad')),
                                  Expanded(
                                      flex: 1,
                                      child: _buildHeaderCell('Valor')),
                                  Expanded(
                                      flex: 1,
                                      child: _buildHeaderCell('Saldo')),
                                  Expanded(
                                      flex: 1,
                                      child: _buildHeaderCell('Progreso')),
                                  Expanded(
                                      flex: 2,
                                      child: _buildHeaderCell(
                                          'Acciones', TextAlign.center)),
                                ],
                              ),
                            ),
                            // Filas de la tabla
                            ...(accionProvider.paginatedAcciones.isNotEmpty
                                ? accionProvider.paginatedAcciones
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                    final index = entry.key;
                                    final accion = entry.value;

                                    return Container(
                                      decoration: BoxDecoration(
                                        color: index.isEven
                                            ? Colors.grey[50]
                                            : Colors.white,
                                        border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[100]!,
                                              width: 0.5),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 12),
                                        child: Row(
                                          children: [
                                            // Expanded(
                                            //     flex: 1,
                                            //     child: _buildCell(accion
                                            //         .idAccion
                                            //         .toString())),
                                            Expanded(
                                                flex: 1,
                                                child: _buildCell(
                                                    accion.socioTitularTexto)),
                                            Expanded(
                                                flex: 1,
                                                child: Center(
                                                  child: _buildTipoAccionCell(
                                                    accion.tipoAccion,
                                                  ),
                                                )),
                                            Flexible(
                                                flex: 1,
                                                child: Center(
                                                    child:
                                                        _buildEstadoAccionCell(
                                                  accion
                                                      .estadoAccionInfo.nombre,
                                                ))),
                                            Expanded(
                                                flex: 1,
                                                child: _buildCell('Mensual')),
                                            Expanded(
                                                flex: 1,
                                                child: _buildMoneyCell(accion
                                                    .estadoPagos
                                                    .precioRenovacion)),
                                            Expanded(
                                                flex: 1,
                                                child: _buildMoneyCell(accion
                                                    .estadoPagos
                                                    .saldoPendiente)),
                                            Expanded(
                                                flex: 1,
                                                child: _buildProgressCell(
                                                    accion.estadoPagos
                                                        .pagosRealizados,
                                                    accion.modalidadPagoInfo
                                                        .cantidadCuotas)),
                                            Expanded(
                                                flex: 2,
                                                child:
                                                    _buildAccionesCell(accion)),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList()
                                : []),

                            // Controles de paginación
                            if (accionProvider.totalPages > 1) ...[
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.grey.shade200,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Información de la página
                                    Text(
                                      'Mostrando ${accionProvider.paginatedAcciones.length} de ${accionProvider.totalItems} acciones',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),

                                    // Controles de navegación
                                    Row(
                                      children: [
                                        // Botón anterior
                                        IconButton(
                                          onPressed:
                                              accionProvider.currentPage > 1
                                                  ? () => accionProvider
                                                      .previousPage()
                                                  : null,
                                          icon: const Icon(Icons.chevron_left),
                                          color: accionProvider.currentPage > 1
                                              ? CeasColors.primaryBlue
                                              : Colors.grey.shade400,
                                        ),

                                        // Número de página actual
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: CeasColors.primaryBlue,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '${accionProvider.currentPage}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),

                                        // Separador
                                        Text(
                                          ' de ${accionProvider.totalPages}',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),

                                        // Botón siguiente
                                        IconButton(
                                          onPressed: accionProvider.hasMorePages
                                              ? () => accionProvider.nextPage()
                                              : null,
                                          icon: const Icon(Icons.chevron_right),
                                          color: accionProvider.hasMorePages
                                              ? CeasColors.primaryBlue
                                              : Colors.grey.shade400,
                                        ),
                                      ],
                                    ),

                                    // Selector de elementos por página
                                    Row(
                                      children: [
                                        Text(
                                          'Mostrar: ',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        DropdownButton<int>(
                                          value: accionProvider.itemsPerPage,
                                          onChanged: (int? newValue) {
                                            if (newValue != null) {
                                              accionProvider
                                                  .setItemsPerPage(newValue);
                                            }
                                          },
                                          items: [10, 20, 50, 100]
                                              .map((int value) {
                                            return DropdownMenuItem<int>(
                                              value: value,
                                              child: Text('$value'),
                                            );
                                          }).toList(),
                                          underline: Container(),
                                          style: TextStyle(
                                            color: CeasColors.primaryBlue,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
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
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color, String subtitle) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(value,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: color)),
                  Text(subtitle,
                      style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text, [TextAlign textAlign = TextAlign.left]) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 13,
        color: CeasColors.primaryBlue,
      ),
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }

  Widget _buildCell(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }

  Widget _buildMoneyCell(double amount) {
    return Text(
      'Bs. ${amount.toStringAsFixed(0)}',
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: CeasColors.primaryBlue,
      ),
    );
  }

  Widget _buildTipoAccionCell(String tipo) {
    return _tipoAccionBadge(tipo);
  }

  Widget _buildEstadoAccionCell(String estado) {
    return _estadoAccionBadge(estado);
  }

  Widget _buildProgressCell(int realizados, int total) {
    final porcentaje = total > 0 ? (realizados / total * 100).round() : 0;
    return Column(
      children: [
        Text(
          '$realizados/$total',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: total > 0 ? realizados / total : 0,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            porcentaje >= 100 ? Colors.green : CeasColors.primaryBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildAccionesCell(Accion accion) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Botón Emitir Certificado
        Container(
          margin: const EdgeInsets.only(right: 4),
          child: Tooltip(
            message: 'Emitir Certificado',
            child: InkWell(
              onTap: () => _showCertificadoDialog(context, accion),
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Icon(
                  Icons.picture_as_pdf,
                  color: Colors.red.shade600,
                  size: 16,
                ),
              ),
            ),
          ),
        ),

        // Botón Cambiar Estado
        Container(
          margin: const EdgeInsets.only(right: 4),
          child: Tooltip(
            message: 'Cambiar Estado',
            child: InkWell(
              onTap: () => _showCambiarEstadoDialog(context, accion),
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Icon(
                  Icons.edit,
                  color: Colors.orange.shade600,
                  size: 16,
                ),
              ),
            ),
          ),
        ),

        // Botón Registrar Pago
        Container(
          margin: const EdgeInsets.only(right: 4),
          child: Tooltip(
            message: 'Registrar Pago',
            child: InkWell(
              onTap: () => _showRegistroPagoDialog(context, accion),
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Icon(
                  Icons.payment,
                  color: Colors.green.shade600,
                  size: 16,
                ),
              ),
            ),
          ),
        ),

        // Botón Ver Detalle
        Container(
          margin: const EdgeInsets.only(right: 4),
          child: Tooltip(
            message: 'Ver Detalle',
            child: InkWell(
              onTap: () => _showDetalleAccionDialog(context, accion),
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: CeasColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: CeasColors.primaryBlue.withOpacity(0.3)),
                ),
                child: Icon(
                  Icons.visibility,
                  color: CeasColors.primaryBlue,
                  size: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _tipoAccionBadge(String tipo) {
    Color color;
    switch (tipo) {
      case 'Ordinaria':
        color = Colors.blue;
        break;
      case 'Preferencial':
        color = Colors.purple;
        break;
      case 'Especial':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(tipo,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 11)),
        ),
      ),
    );
  }

  Widget _estadoAccionBadge(String estado) {
    Color color;
    switch (estado) {
      case 'Activa':
        color = Colors.green;
        break;
      case 'Pendiente':
        color = Colors.orange;
        break;
      case 'Expirada':
        color = Colors.red;
        break;
      case 'Cancelada':
        color = Colors.grey;
        break;
      case 'Suspendida':
        color = Colors.purple;
        break;
      default:
        color = Colors.blueGrey;
    }
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(estado,
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 11)),
      ),
    );
  }

  void _showEmitirAccionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 20,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header del bottom sheet
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Handle para arrastrar
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Título y subtítulo
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                CeasColors.primaryBlue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.add_circle_outline,
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
                                'Emitir Nueva Acción',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: CeasColors.primaryBlue,
                                ),
                              ),
                              const Text(
                                'Crea una nueva acción para el CEAS',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Botón de cerrar
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.grey.shade100,
                            foregroundColor: Colors.grey.shade600,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Contenido del formulario
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: const ShareEmissionScreen(isBottomSheet: true),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _cerrarDialogoCarga(BuildContext context) {
    if (_dialogoCargaAbierto && context.mounted) {
      try {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
          _dialogoCargaAbierto = false;
        }
      } catch (e) {
        print('Error al cerrar diálogo: $e');
        _dialogoCargaAbierto = false;
      }
    }
  }

  void _cerrarDialogoCargaForzado(BuildContext context) {
    if (_dialogoCargaAbierto && context.mounted) {
      try {
        // Intentar cerrar múltiples diálogos si es necesario
        int intentos = 0;
        while (Navigator.canPop(context) && intentos < 5) {
          Navigator.of(context).pop();
          intentos++;
        }
        _dialogoCargaAbierto = false;
      } catch (e) {
        print('Error al cerrar diálogo forzado: $e');
        _dialogoCargaAbierto = false;
      }
    }
  }

  Future<String> _guardarPDFTemporal(
      List<int> pdfBytes, String nombreArchivo) async {
    try {
      // Intentar usar path_provider primero
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$nombreArchivo');
      await file.writeAsBytes(pdfBytes);
      return file.path;
    } catch (e) {
      print('Error con path_provider: $e');

      // Fallback: usar directorio de documentos del usuario
      if (kIsWeb) {
        // Para web, usar descarga directa del navegador
        return await _descargarPDFWeb(pdfBytes, nombreArchivo);
      } else {
        try {
          // Intentar usar el directorio de documentos
          final directory = await getApplicationDocumentsDirectory();
          final file = File('${directory.path}/$nombreArchivo');
          await file.writeAsBytes(pdfBytes);
          return file.path;
        } catch (e2) {
          print('Error con getApplicationDocumentsDirectory: $e2');

          // Último fallback: directorio actual
          final currentDir = Directory.current;
          final tempDir = Directory('${currentDir.path}/temp_pdfs');

          // Crear directorio si no existe
          if (!await tempDir.exists()) {
            await tempDir.create(recursive: true);
          }

          final file = File('${tempDir.path}/$nombreArchivo');
          await file.writeAsBytes(pdfBytes);
          return file.path;
        }
      }
    }
  }

  Future<String> _descargarPDFWeb(
      List<int> pdfBytes, String nombreArchivo) async {
    // Para web, crear un blob y descargarlo
    final blob = html.Blob([pdfBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Crear elemento de descarga
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', nombreArchivo)
      ..click();

    // Limpiar URL del blob
    html.Url.revokeObjectUrl(url);

    // Retornar un identificador virtual para web
    return 'web_download_$nombreArchivo';
  }

  Future<void> _abrirPDF(BuildContext context, String filePath) async {
    try {
      if (kIsWeb) {
        // Para web, mostrar mensaje de descarga completada
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ PDF descargado exitosamente'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        // Para móvil/desktop, abrir el archivo
        await OpenFile.open(filePath);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('PDF abierto exitosamente'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('Error al abrir PDF: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al abrir el PDF: $e'),
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
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

  Future<void> _generarCertificadoPDF(
      BuildContext context, Accion accion) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (!authProvider.isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No autenticado')),
        );
        return;
      }

      final token = authProvider.user!.accessToken;

      // Mostrar indicador de carga
      _dialogoCargaAbierto = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Generando certificado PDF...'),
            ],
          ),
        ),
      );

      print(
          'Llamando al endpoint: http://localhost:8000/acciones/${accion.idAccion}/generar-certificado');

      final response = await http.post(
        Uri.parse(
            'http://localhost:8000/acciones/${accion.idAccion}/generar-certificado'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      // Respaldo: asegurar que el diálogo se cierre después de 35 segundos
      Future.delayed(const Duration(seconds: 35), () {
        if (_dialogoCargaAbierto && context.mounted) {
          _cerrarDialogoCargaForzado(context);
        }
      });

      print('Response status: ${response.statusCode}');
      print('Response content-type: ${response.headers['content-type']}');
      print('Response content-length: ${response.headers['content-length']}');
      print('Response body length: ${response.bodyBytes.length}');
      if (response.statusCode != 200) {
        print('Response body: ${response.body}');
      }

      // Cerrar indicador de carga
      _cerrarDialogoCarga(context);

      if (response.statusCode == 200) {
        // El servidor retorna directamente el PDF
        final pdfBytes = response.bodyBytes;

        if (pdfBytes.isEmpty) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error: El PDF recibido está vacío'),
                duration: Duration(seconds: 5),
              ),
            );
          }
          return;
        }

        // Guardar PDF en directorio temporal
        final fileName =
            'certificado_${accion.idAccion}_${DateTime.now().millisecondsSinceEpoch}.pdf';

        try {
          // Guardar PDF
          final filePath = await _guardarPDFTemporal(pdfBytes, fileName);

          if (context.mounted) {
            // Mostrar confirmación y opción de abrir
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Certificado Generado'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'El certificado se ha generado exitosamente.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Archivo: $fileName',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '¿Deseas abrir el PDF ahora?',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _abrirPDF(context, filePath);
                    },
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Abrir PDF'),
                  ),
                ],
              ),
            );
          }
        } catch (e) {
          print('Error al guardar PDF: $e');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al guardar el PDF: $e'),
                duration: const Duration(seconds: 5),
              ),
            );
          }
        }
      } else {
        if (context.mounted) {
          String errorMessage;
          switch (response.statusCode) {
            case 401:
              errorMessage =
                  '🔐 Error de autenticación. Tu sesión ha expirado. Por favor, inicia sesión nuevamente.';
              break;
            case 403:
              errorMessage = '🚫 No tienes permisos para generar certificados.';
              break;
            case 404:
              errorMessage = '❓ La acción no fue encontrada.';
              break;
            case 500:
              errorMessage =
                  '⚠️ Error interno del servidor. Intenta más tarde.';
              break;
            default:
              errorMessage =
                  '❌ Error del servidor: ${response.statusCode}\n${response.body}';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              duration: const Duration(seconds: 8),
              backgroundColor: Colors.red.shade600,
            ),
          );
        }
      }
    } catch (e) {
      print('Error en _generarCertificadoPDF: $e');

      // Cerrar indicador de carga si hay error
      _cerrarDialogoCarga(context);

      if (context.mounted) {
        String errorMessage = 'Error desconocido';
        if (e.toString().contains('TimeoutException')) {
          errorMessage =
              '⏱️ Tiempo de espera agotado (30s). Verifica tu conexión.';
        } else if (e.toString().contains('SocketException')) {
          errorMessage =
              '🌐 Error de conexión. Verifica que el servidor esté funcionando.';
        } else if (e.toString().contains('FormatException')) {
          errorMessage = '📄 Error en el formato de respuesta del servidor.';
        } else {
          errorMessage = '❌ Error: $e';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: const Duration(seconds: 8),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    }
  }

  Future<void> _generarCertificadoCifrado(
      BuildContext context, Accion accion) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (!authProvider.isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No autenticado')),
        );
        return;
      }

      final token = authProvider.user!.accessToken;

      // Mostrar indicador de carga
      _dialogoCargaAbierto = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Generando certificado cifrado...'),
            ],
          ),
        ),
      );

      final response = await http.post(
        Uri.parse(
            'http://localhost:8000/acciones/${accion.idAccion}/generar-certificado'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      // Respaldo: asegurar que el diálogo se cierre después de 35 segundos
      Future.delayed(const Duration(seconds: 35), () {
        if (_dialogoCargaAbierto && context.mounted) {
          _cerrarDialogoCargaForzado(context);
        }
      });

      // Cerrar indicador de carga
      _cerrarDialogoCarga(context);

      if (response.statusCode == 200) {
        // El servidor retorna directamente el PDF
        final pdfBytes = response.bodyBytes;

        if (pdfBytes.isEmpty) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error: El PDF recibido está vacío'),
                duration: Duration(seconds: 5),
              ),
            );
          }
          return;
        }

        // Guardar PDF en directorio temporal
        final fileName =
            'certificado_cifrado_${accion.idAccion}_${DateTime.now().millisecondsSinceEpoch}.pdf';

        try {
          // Guardar PDF
          final filePath = await _guardarPDFTemporal(pdfBytes, fileName);

          if (context.mounted) {
            // Mostrar confirmación y opción de abrir
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Certificado Cifrado Generado'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.security,
                      color: Colors.blue,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'El certificado cifrado se ha generado exitosamente.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Archivo: $fileName',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '¿Deseas abrir el PDF cifrado ahora?',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _abrirPDF(context, filePath);
                    },
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Abrir PDF'),
                  ),
                ],
              ),
            );
          }
        } catch (e) {
          print('Error al guardar PDF cifrado: $e');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al guardar el PDF cifrado: $e'),
                duration: const Duration(seconds: 5),
              ),
            );
          }
        }
      } else {
        if (context.mounted) {
          String errorMessage;
          switch (response.statusCode) {
            case 401:
              errorMessage =
                  '🔐 Error de autenticación. Tu sesión ha expirado. Por favor, inicia sesión nuevamente.';
              break;
            case 403:
              errorMessage = '🚫 No tienes permisos para generar certificados.';
              break;
            case 404:
              errorMessage = '❓ La acción no fue encontrada.';
              break;
            case 500:
              errorMessage =
                  '⚠️ Error interno del servidor. Intenta más tarde.';
              break;
            default:
              errorMessage =
                  '❌ Error del servidor: ${response.statusCode}\n${response.body}';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              duration: const Duration(seconds: 8),
              backgroundColor: Colors.red.shade600,
            ),
          );
        }
      }
    } catch (e) {
      print('Error en _generarCertificadoCifrado: $e');

      // Cerrar indicador de carga si hay error
      _cerrarDialogoCarga(context);

      if (context.mounted) {
        String errorMessage = 'Error desconocido';
        if (e.toString().contains('TimeoutException')) {
          errorMessage =
              '⏱️ Tiempo de espera agotado (30s). Verifica tu conexión.';
        } else if (e.toString().contains('SocketException')) {
          errorMessage =
              '🌐 Error de conexión. Verifica que el servidor esté funcionando.';
        } else if (e.toString().contains('FormatException')) {
          errorMessage = '📄 Error en el formato de respuesta del servidor.';
        } else {
          errorMessage = '❌ Error: $e';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: const Duration(seconds: 8),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    }
  }

  void _showCambiarEstadoDialog(BuildContext context, Accion accion) {
    String nuevoEstado = accion.estadoAccionInfo.nombre;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Cambiar Estado de Acción'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Acción: ${accion.idAccion}'),
              Text('Estado actual: ${accion.estadoAccionInfo.nombre}'),
              const SizedBox(height: 16),
              const Text('Nuevo estado:'),
              ...estadosAccion.where((e) => e != 'Todos').map(
                    (estado) => RadioListTile<String>(
                      title: Text(estado),
                      value: estado,
                      groupValue: nuevoEstado,
                      onChanged: (value) =>
                          setState(() => nuevoEstado = value!),
                    ),
                  ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text('Estado cambiado a $nuevoEstado (ficticio)')),
                );
              },
              child: const Text('Cambiar'),
            ),
          ],
        ),
      ),
    );
  }

  void _showRegistroPagoDialog(BuildContext context, Accion accion) {
    final montoController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registrar Pago'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Acción: ${accion.idAccion}'),
            Text('Saldo pendiente: Bs. ${accion.estadoPagos.saldoPendiente}'),
            const SizedBox(height: 16),
            TextField(
              controller: montoController,
              decoration: const InputDecoration(
                labelText: 'Monto del pago',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pago registrado (ficticio)')),
              );
            },
            child: const Text('Registrar'),
          ),
        ],
      ),
    );
  }

  void _showDetalleAccionDialog(BuildContext context, Accion accion) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalle de Acción'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('ID', accion.idAccion.toString()),
            _buildDetailRow('Socio ID', accion.idSocio.toString()),
            _buildDetailRow('Tipo', accion.tipoAccion),
            _buildDetailRow('Estado Acción', accion.estadoAccionInfo.nombre),
            _buildDetailRow('Modalidad de Pago', 'Mensual'),
            _buildDetailRow('Precio Renovación',
                'Bs. ${accion.estadoPagos.precioRenovacion}'),
            _buildDetailRow(
                'Saldo Pendiente', 'Bs. ${accion.estadoPagos.saldoPendiente}'),
            _buildDetailRow('Fecha Emisión', accion.fechaEmisionCertificado),
            _buildDetailRow(
                'Certificado PDF', accion.certificadoPdf ?? 'No disponible'),
            _buildDetailRow(
                'Certificado Cifrado', accion.certificadoCifrado ? 'Sí' : 'No'),
            _buildDetailRow('Pagos',
                '${accion.estadoPagos.pagosRealizados}/${accion.modalidadPagoInfo.cantidadCuotas}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
