import 'package:flutter/material.dart';
import '../../../core/theme/ceas_colors.dart';

class SharesScreen extends StatefulWidget {
  const SharesScreen({Key? key}) : super(key: key);

  @override
  State<SharesScreen> createState() => _SharesScreenState();
}

class _SharesScreenState extends State<SharesScreen> {
  String search = '';
  String estadoAccion = 'Todos';
  String tipoAccion = 'Todos';
  final estadosAccion = ['Todos', 'Activa', 'Pagada', 'Vencida', 'Cancelada'];
  final tiposAccion = ['Todos', 'Ordinaria', 'Preferencial', 'Especial'];

  final acciones = [
    {
      'id': 'ACC-001',
      'socioTitular': 'Juan Carlos Pérez López',
      'tipoAccion': 'Ordinaria',
      'estadoAccion': 'Activa',
      'modalidadPago': 'Mensual',
      'valorAccion': 1000.0,
      'saldoPendiente': 800.0,
      'fechaEmision': '15/01/2024',
      'certificadoPdf': 'certificado_001.pdf',
      'certificadoCifrado': 'certificado_001_cifrado.txt',
      'pagosRealizados': 2,
      'totalPagos': 5,
    },
    {
      'id': 'ACC-002',
      'socioTitular': 'María Elena López Torres',
      'tipoAccion': 'Preferencial',
      'estadoAccion': 'Pagada',
      'modalidadPago': 'Anual',
      'valorAccion': 2000.0,
      'saldoPendiente': 0.0,
      'fechaEmision': '22/03/2024',
      'certificadoPdf': 'certificado_002.pdf',
      'certificadoCifrado': 'certificado_002_cifrado.txt',
      'pagosRealizados': 1,
      'totalPagos': 1,
    },
    {
      'id': 'ACC-003',
      'socioTitular': 'Carlos Alberto Gómez Silva',
      'tipoAccion': 'Ordinaria',
      'estadoAccion': 'Vencida',
      'modalidadPago': 'Mensual',
      'valorAccion': 1500.0,
      'saldoPendiente': 1500.0,
      'fechaEmision': '08/02/2024',
      'certificadoPdf': 'certificado_003.pdf',
      'certificadoCifrado': 'certificado_003_cifrado.txt',
      'pagosRealizados': 0,
      'totalPagos': 6,
    },
    {
      'id': 'ACC-004',
      'socioTitular': 'Ana Patricia Torres Vargas',
      'tipoAccion': 'Especial',
      'estadoAccion': 'Activa',
      'modalidadPago': 'Trimestral',
      'valorAccion': 3000.0,
      'saldoPendiente': 2000.0,
      'fechaEmision': '12/04/2024',
      'certificadoPdf': 'certificado_004.pdf',
      'certificadoCifrado': 'certificado_004_cifrado.txt',
      'pagosRealizados': 1,
      'totalPagos': 4,
    },
    {
      'id': 'ACC-005',
      'socioTitular': 'Luis Fernando Fernández Ruiz',
      'tipoAccion': 'Ordinaria',
      'estadoAccion': 'Activa',
      'modalidadPago': 'Mensual',
      'valorAccion': 1200.0,
      'saldoPendiente': 600.0,
      'fechaEmision': '05/05/2024',
      'certificadoPdf': 'certificado_005.pdf',
      'certificadoCifrado': 'certificado_005_cifrado.txt',
      'pagosRealizados': 3,
      'totalPagos': 6,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = acciones.where((a) {
      final matchesEstado =
          estadoAccion == 'Todos' || a['estadoAccion'] == estadoAccion;
      final matchesTipo =
          tipoAccion == 'Todos' || a['tipoAccion'] == tipoAccion;
      final matchesSearch = search.isEmpty ||
          (a['socioTitular'] as String)
              .toLowerCase()
              .contains(search.toLowerCase()) ||
          (a['id'] as String).toLowerCase().contains(search.toLowerCase());
      return matchesEstado && matchesTipo && matchesSearch;
    }).toList();

    final totalAcciones = acciones.length;
    final accionesActivas =
        acciones.where((a) => a['estadoAccion'] == 'Activa').length;
    final accionesPagadas =
        acciones.where((a) => a['estadoAccion'] == 'Pagada').length;
    final accionesVencidas =
        acciones.where((a) => a['estadoAccion'] == 'Vencida').length;

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
                    'Activas',
                    accionesActivas.toString(),
                    Icons.check_circle_rounded,
                    CeasColors.kpiGreen,
                    'En proceso'),
                const SizedBox(width: 16),
                _buildStatCard('Pagadas', accionesPagadas.toString(),
                    Icons.payment_rounded, CeasColors.kpiOrange, 'Completadas'),
                const SizedBox(width: 16),
                _buildStatCard('Vencidas', accionesVencidas.toString(),
                    Icons.warning_rounded, CeasColors.kpiPurple, 'Pendientes'),
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
                                hintText: 'Buscar por socio o ID de acción...',
                                hintStyle: TextStyle(color: Colors.grey[500]),
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
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (v) =>
                                setState(() => estadoAccion = v ?? 'Todos'),
                            underline: Container(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: CeasColors.primaryBlue),
                            icon: const Icon(Icons.keyboard_arrow_down_rounded),
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
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (v) =>
                                setState(() => tipoAccion = v ?? 'Todos'),
                            underline: Container(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: CeasColors.primaryBlue),
                            icon: const Icon(Icons.keyboard_arrow_down_rounded),
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
                            '${filtered.length} acciones encontradas',
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
                              Expanded(flex: 1, child: _buildHeaderCell('ID')),
                              Expanded(
                                  flex: 2,
                                  child: _buildHeaderCell('Socio Titular')),
                              Expanded(
                                  flex: 1, child: _buildHeaderCell('Tipo')),
                              Flexible(
                                  flex: 1,
                                  child: Center(
                                      child: _buildHeaderCell('Estado'))),
                              Expanded(
                                  flex: 1,
                                  child: _buildHeaderCell('Modalidad')),
                              Expanded(
                                  flex: 1, child: _buildHeaderCell('Valor')),
                              Expanded(
                                  flex: 1, child: _buildHeaderCell('Saldo')),
                              Expanded(
                                  flex: 1, child: _buildHeaderCell('Progreso')),
                              Expanded(
                                  flex: 1, child: _buildHeaderCell('Acciones')),
                            ],
                          ),
                        ),
                        // Filas de la tabla
                        ...filtered.asMap().entries.map((entry) {
                          final index = entry.key;
                          final a = entry.value;
                          return Container(
                            decoration: BoxDecoration(
                              color:
                                  index.isEven ? Colors.grey[50] : Colors.white,
                              border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey[100]!, width: 0.5),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: _buildCell(a['id'] as String)),
                                  Expanded(
                                      flex: 2,
                                      child: _buildCell(
                                          a['socioTitular'] as String)),
                                  Expanded(
                                      flex: 1,
                                      child: _buildTipoAccionCell(
                                          a['tipoAccion'] as String)),
                                  Flexible(
                                      flex: 1,
                                      child: Center(
                                          child: _buildEstadoAccionCell(
                                              a['estadoAccion'] as String))),
                                  Expanded(
                                      flex: 1,
                                      child: _buildCell(
                                          a['modalidadPago'] as String)),
                                  Expanded(
                                      flex: 1,
                                      child: _buildMoneyCell(
                                          a['valorAccion'] as double)),
                                  Expanded(
                                      flex: 1,
                                      child: _buildMoneyCell(
                                          a['saldoPendiente'] as double)),
                                  Expanded(
                                      flex: 1,
                                      child: _buildProgressCell(
                                          a['pagosRealizados'] as int,
                                          a['totalPagos'] as int)),
                                  Expanded(
                                      flex: 1, child: _buildAccionesCell(a)),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
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

  Widget _buildHeaderCell(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 13,
        color: CeasColors.primaryBlue,
      ),
      overflow: TextOverflow.ellipsis,
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

  Widget _buildAccionesCell(Map<String, dynamic> accion) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.grey),
      onSelected: (value) {
        switch (value) {
          case 'certificado':
            _showCertificadoDialog(context, accion);
            break;
          case 'estado':
            _showCambiarEstadoDialog(context, accion);
            break;
          case 'pago':
            _showRegistroPagoDialog(context, accion);
            break;
          case 'detalle':
            _showDetalleAccionDialog(context, accion);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'certificado',
          child: Row(
            children: [
              Icon(Icons.picture_as_pdf, color: Colors.red),
              SizedBox(width: 8),
              Text('Emitir Certificado'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'estado',
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.orange),
              SizedBox(width: 8),
              Text('Cambiar Estado'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'pago',
          child: Row(
            children: [
              Icon(Icons.payment, color: Colors.green),
              SizedBox(width: 8),
              Text('Registrar Pago'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'detalle',
          child: Row(
            children: [
              Icon(Icons.visibility, color: CeasColors.primaryBlue),
              SizedBox(width: 8),
              Text('Ver Detalle'),
            ],
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
        child: Text(tipo,
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 11)),
      ),
    );
  }

  Widget _estadoAccionBadge(String estado) {
    Color color;
    switch (estado) {
      case 'Activa':
        color = Colors.green;
        break;
      case 'Pagada':
        color = Colors.blue;
        break;
      case 'Vencida':
        color = Colors.red;
        break;
      case 'Cancelada':
        color = Colors.grey;
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emitir Nueva Acción'),
        content: const Text('Funcionalidad de emisión de acciones (ficticia)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Acción emitida (ficticio)')),
              );
            },
            child: const Text('Emitir'),
          ),
        ],
      ),
    );
  }

  void _showCertificadoDialog(
      BuildContext context, Map<String, dynamic> accion) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emitir Certificado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Acción: ${accion['id']}'),
            Text('Socio: ${accion['socioTitular']}'),
            const SizedBox(height: 16),
            const Text('Seleccione el tipo de certificado:'),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: const Text('Certificado PDF'),
              subtitle: Text('${accion['certificadoPdf']}'),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Certificado PDF generado (ficticio)')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.security, color: Colors.blue),
              title: const Text('Certificado Cifrado'),
              subtitle: Text('${accion['certificadoCifrado']}'),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Certificado cifrado generado (ficticio)')),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showCambiarEstadoDialog(
      BuildContext context, Map<String, dynamic> accion) {
    String nuevoEstado = accion['estadoAccion'];
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Cambiar Estado de Acción'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Acción: ${accion['id']}'),
              Text('Estado actual: ${accion['estadoAccion']}'),
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

  void _showRegistroPagoDialog(
      BuildContext context, Map<String, dynamic> accion) {
    final montoController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registrar Pago'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Acción: ${accion['id']}'),
            Text('Saldo pendiente: Bs. ${accion['saldoPendiente']}'),
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

  void _showDetalleAccionDialog(
      BuildContext context, Map<String, dynamic> accion) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalle de Acción'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('ID', accion['id']),
            _buildDetailRow('Socio Titular', accion['socioTitular']),
            _buildDetailRow('Tipo', accion['tipoAccion']),
            _buildDetailRow('Estado', accion['estadoAccion']),
            _buildDetailRow('Modalidad de Pago', accion['modalidadPago']),
            _buildDetailRow('Valor', 'Bs. ${accion['valorAccion']}'),
            _buildDetailRow(
                'Saldo Pendiente', 'Bs. ${accion['saldoPendiente']}'),
            _buildDetailRow('Fecha Emisión', accion['fechaEmision']),
            _buildDetailRow('Certificado PDF', accion['certificadoPdf']),
            _buildDetailRow(
                'Certificado Cifrado', accion['certificadoCifrado']),
            _buildDetailRow('Pagos',
                '${accion['pagosRealizados']}/${accion['totalPagos']}'),
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
