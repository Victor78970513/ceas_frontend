import 'package:flutter/material.dart';
import '../../../core/theme/ceas_colors.dart';
import 'member_detail_screen.dart';
import 'member_form_screen.dart';

class MembersListScreen extends StatefulWidget {
  const MembersListScreen({Key? key}) : super(key: key);

  @override
  State<MembersListScreen> createState() => _MembersListScreenState();
}

class _MembersListScreenState extends State<MembersListScreen> {
  String search = '';
  String estado = 'Todos';
  String tipoMembresia = 'Todos';
  final estados = ['Todos', 'Activo', 'Inactivo', 'Moroso'];
  final tiposMembresia = ['Todos', 'Básica', 'Premium', 'VIP', 'Familiar'];
  int currentPage = 1;
  int itemsPerPage = 10;

  final socios = [
    {
      'club': 'CEAS Principal',
      'nombres': 'Juan Carlos',
      'apellidos': 'Pérez López',
      'ci': '1234567',
      'telefono': '76543210',
      'correo': 'juan.perez@email.com',
      'direccion': 'Av. Principal #123, La Paz',
      'estado': 'Activo',
      'fechaRegistro': '15/01/2024',
      'fechaNacimiento': '25/03/1985',
      'tipoMembresia': 'Premium'
    },
    {
      'club': 'CEAS Principal',
      'nombres': 'María Elena',
      'apellidos': 'López Torres',
      'ci': '2345678',
      'telefono': '76543211',
      'correo': 'maria.lopez@email.com',
      'direccion': 'Calle Comercio #456, La Paz',
      'estado': 'Moroso',
      'fechaRegistro': '22/03/2024',
      'fechaNacimiento': '12/07/1990',
      'tipoMembresia': 'Básica'
    },
    {
      'club': 'CEAS Principal',
      'nombres': 'Carlos Alberto',
      'apellidos': 'Gómez Silva',
      'ci': '3456789',
      'telefono': '76543212',
      'correo': 'carlos.gomez@email.com',
      'direccion': 'Zona Sur #789, La Paz',
      'estado': 'Inactivo',
      'fechaRegistro': '08/02/2024',
      'fechaNacimiento': '03/11/1982',
      'tipoMembresia': 'VIP'
    },
    {
      'club': 'CEAS Principal',
      'nombres': 'Ana Patricia',
      'apellidos': 'Torres Vargas',
      'ci': '4567890',
      'telefono': '76543213',
      'correo': 'ana.torres@email.com',
      'direccion': 'Miraflores #321, La Paz',
      'estado': 'Activo',
      'fechaRegistro': '12/04/2024',
      'fechaNacimiento': '18/09/1988',
      'tipoMembresia': 'Familiar'
    },
    {
      'club': 'CEAS Principal',
      'nombres': 'Luis Fernando',
      'apellidos': 'Fernández Ruiz',
      'ci': '5678901',
      'telefono': '76543214',
      'correo': 'luis.fernandez@email.com',
      'direccion': 'San Miguel #654, La Paz',
      'estado': 'Activo',
      'fechaRegistro': '05/05/2024',
      'fechaNacimiento': '30/12/1992',
      'tipoMembresia': 'Premium'
    },
    {
      'club': 'CEAS Principal',
      'nombres': 'Carmen Rosa',
      'apellidos': 'Silva Mendoza',
      'ci': '6789012',
      'telefono': '76543215',
      'correo': 'carmen.silva@email.com',
      'direccion': 'Obrajes #987, La Paz',
      'estado': 'Activo',
      'fechaRegistro': '18/06/2024',
      'fechaNacimiento': '14/05/1987',
      'tipoMembresia': 'Básica'
    },
    {
      'club': 'CEAS Principal',
      'nombres': 'Roberto José',
      'apellidos': 'Vargas Herrera',
      'ci': '7890123',
      'telefono': '76543216',
      'correo': 'roberto.vargas@email.com',
      'direccion': 'Calacoto #147, La Paz',
      'estado': 'Moroso',
      'fechaRegistro': '25/07/2024',
      'fechaNacimiento': '22/08/1980',
      'tipoMembresia': 'Premium'
    },
    {
      'club': 'CEAS Principal',
      'nombres': 'Patricia Alejandra',
      'apellidos': 'Ruiz Morales',
      'ci': '8901234',
      'telefono': '76543217',
      'correo': 'patricia.ruiz@email.com',
      'direccion': 'Achumani #258, La Paz',
      'estado': 'Activo',
      'fechaRegistro': '30/08/2024',
      'fechaNacimiento': '09/01/1995',
      'tipoMembresia': 'VIP'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = socios.where((s) {
      final matchesEstado = estado == 'Todos' || s['estado'] == estado;
      final matchesMembresia =
          tipoMembresia == 'Todos' || s['tipoMembresia'] == tipoMembresia;
      final matchesSearch = search.isEmpty ||
          (s['nombres'] as String)
              .toLowerCase()
              .contains(search.toLowerCase()) ||
          (s['ci'] as String).contains(search) ||
          (s['correo'] as String).toLowerCase().contains(search.toLowerCase());
      return matchesEstado && matchesMembresia && matchesSearch;
    }).toList();

    final totalSocios = socios.length;
    final sociosActivos = socios.where((s) => s['estado'] == 'Activo').length;
    final sociosMorosos = socios.where((s) => s['estado'] == 'Moroso').length;
    final sociosInactivos =
        socios.where((s) => s['estado'] == 'Inactivo').length;

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
                      Icons.people_alt_rounded,
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
                          'Gestión de Socios',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Administra y controla todos los socios del CEAS',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const MemberFormScreen(),
                        ),
                      );
                      if (result == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Socio registrado/actualizado (ficticio)')),
                        );
                      }
                    },
                    icon: const Icon(Icons.person_add_rounded),
                    label: const Text('Nuevo Socio'),
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

            // Estadísticas mejoradas
            Row(
              children: [
                _buildStatCard(
                    'Total Socios',
                    totalSocios.toString(),
                    Icons.people_rounded,
                    CeasColors.kpiBlue,
                    'Socios registrados'),
                const SizedBox(width: 16),
                _buildStatCard(
                    'Activos',
                    sociosActivos.toString(),
                    Icons.check_circle_rounded,
                    CeasColors.kpiGreen,
                    'En buen estado'),
                const SizedBox(width: 16),
                _buildStatCard(
                    'Morosos',
                    sociosMorosos.toString(),
                    Icons.warning_rounded,
                    CeasColors.kpiOrange,
                    'Pagos pendientes'),
                const SizedBox(width: 16),
                _buildStatCard(
                    'Inactivos',
                    sociosInactivos.toString(),
                    Icons.block_rounded,
                    CeasColors.kpiPurple,
                    'Suspensión temporal'),
              ],
            ),
            const SizedBox(height: 24),

            // Filtros y búsqueda mejorados
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
                                hintText: 'Buscar por nombre, CI o correo...',
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
                            value: estado,
                            items: estados
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (v) =>
                                setState(() => estado = v ?? 'Todos'),
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
                            value: tipoMembresia,
                            items: tiposMembresia
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (v) =>
                                setState(() => tipoMembresia = v ?? 'Todos'),
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

            // Acciones rápidas mejoradas
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
                            Icons.flash_on_rounded,
                            color: CeasColors.primaryBlue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Acciones Rápidas',
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
                        _buildQuickAction('Exportar Lista',
                            Icons.download_rounded, Colors.blue),
                        const SizedBox(width: 16),
                        _buildQuickAction('Enviar Recordatorios',
                            Icons.email_rounded, Colors.orange),
                        const SizedBox(width: 16),
                        _buildQuickAction('Generar Reporte',
                            Icons.assessment_rounded, Colors.green),
                        const SizedBox(width: 16),
                        _buildQuickAction('Sincronizar Datos',
                            Icons.sync_rounded, Colors.purple),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tabla profesional ERP
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
                          'Lista de Socios',
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
                            '${filtered.length} socios encontrados',
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
                              Expanded(
                                  flex: 3, child: _buildHeaderCell('Socio')),
                              Expanded(flex: 1, child: _buildHeaderCell('CI')),
                              Expanded(
                                  flex: 1, child: _buildHeaderCell('Teléfono')),
                              Expanded(
                                  flex: 2, child: _buildHeaderCell('Correo')),
                              Flexible(
                                  flex: 1,
                                  child: Center(
                                      child: _buildHeaderCell('Estado'))),
                              Flexible(
                                  flex: 1,
                                  child: Center(
                                      child: _buildHeaderCell('Membresía'))),
                              Expanded(
                                  flex: 1,
                                  child: _buildHeaderCell('Fecha Registro')),
                              Expanded(
                                  flex: 1, child: _buildHeaderCell('Acciones')),
                            ],
                          ),
                        ),
                        // Filas de la tabla
                        ...filtered.asMap().entries.map((entry) {
                          final index = entry.key;
                          final s = entry.value;
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
                                  Expanded(flex: 3, child: _buildSocioCell(s)),
                                  Expanded(
                                      flex: 1,
                                      child: _buildCell(s['ci'] as String)),
                                  Expanded(
                                      flex: 1,
                                      child:
                                          _buildCell(s['telefono'] as String)),
                                  Expanded(
                                      flex: 2,
                                      child: _buildCorreoCell(
                                          s['correo'] as String)),
                                  Flexible(
                                      flex: 1,
                                      child: Center(
                                          child: _buildEstadoCell(
                                              s['estado'] as String))),
                                  Flexible(
                                      flex: 1,
                                      child: Center(
                                          child: _buildMembresiaCell(
                                              s['tipoMembresia'] as String))),
                                  Expanded(
                                      flex: 1,
                                      child: _buildCell(
                                          s['fechaRegistro'] as String)),
                                  Expanded(
                                      flex: 1, child: _buildOpcionesCell(s)),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Paginación mejorada
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Página $currentPage de ${(filtered.length / itemsPerPage).ceil()}',
                          style: const TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w500),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_left_rounded),
                              onPressed: currentPage > 1
                                  ? () => setState(() => currentPage--)
                                  : null,
                            ),
                            ...List.generate(
                              (filtered.length / itemsPerPage).ceil(),
                              (index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: TextButton(
                                  onPressed: () =>
                                      setState(() => currentPage = index + 1),
                                  child: Text('${index + 1}'),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_right_rounded),
                              onPressed: currentPage <
                                      (filtered.length / itemsPerPage).ceil()
                                  ? () => setState(() => currentPage++)
                                  : null,
                            ),
                          ],
                        ),
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

  Widget _buildQuickAction(String title, IconData icon, Color color) {
    return Expanded(
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title (ficticio)')),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _estadoBadge(String estado) {
    Color color;
    switch (estado) {
      case 'Activo':
        color = Colors.green;
        break;
      case 'Inactivo':
        color = Colors.grey;
        break;
      case 'Moroso':
        color = Colors.red;
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

  Widget _membresiaBadge(String membresia) {
    Color color;
    switch (membresia) {
      case 'VIP':
        color = Colors.purple;
        break;
      case 'Premium':
        color = Colors.blue;
        break;
      case 'Familiar':
        color = Colors.orange;
        break;
      case 'Básica':
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
        child: Text(membresia,
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 11)),
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

  Widget _buildSocioCell(Map<String, dynamic> socio) {
    final nombreCompleto = '${socio['nombres']} ${socio['apellidos']}';
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: CeasColors.primaryBlue.withOpacity(0.1),
          child: Text(
            (socio['nombres'] as String).substring(0, 1).toUpperCase(),
            style: const TextStyle(
              color: CeasColors.primaryBlue,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nombreCompleto,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                socio['club'] as String,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCorreoCell(String correo) {
    return Text(
      correo,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
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

  Widget _buildMembresiaCell(String membresia) {
    return _membresiaBadge(membresia);
  }

  Widget _buildEstadoCell(String estado) {
    return _estadoBadge(estado);
  }

  Widget _buildOpcionesCell(Map<String, dynamic> socio) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.grey),
      onSelected: (value) {
        switch (value) {
          case 'ver':
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const MemberDetailScreen(),
              ),
            );
            break;
          case 'editar':
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const MemberFormScreen(),
              ),
            );
            break;
          case 'desactivar':
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Desactivar socio'),
                content: const Text(
                    '¿Estás seguro de que deseas desactivar este socio?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Socio desactivado (ficticio)')),
                      );
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Desactivar'),
                  ),
                ],
              ),
            );
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'ver',
          child: Row(
            children: [
              Icon(Icons.visibility, color: CeasColors.primaryBlue),
              SizedBox(width: 8),
              Text('Ver detalle'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'editar',
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.orange),
              SizedBox(width: 8),
              Text('Editar'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'desactivar',
          child: Row(
            children: [
              Icon(Icons.block, color: Colors.red),
              SizedBox(width: 8),
              Text('Desactivar'),
            ],
          ),
        ),
      ],
    );
  }
}
