import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/ceas_colors.dart';
import '../providers/members_provider.dart';
import '../models/socio.dart';
import 'member_detail_screen.dart';
import 'member_form_screen.dart';

class MembersListScreen extends StatefulWidget {
  const MembersListScreen({Key? key}) : super(key: key);

  @override
  State<MembersListScreen> createState() => _MembersListScreenState();
}

class _MembersListScreenState extends State<MembersListScreen> {
  int currentPage = 1;
  int itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    // Cargar socios al inicializar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MembersProvider>(context, listen: false).loadSocios();
    });
  }

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
                      Icons.groups_rounded,
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
                          'Administración y control de miembros del club',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showCreateMemberDialog(context),
                    icon: const Icon(Icons.person_add),
                    label: const Text('Crear Socio'),
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
            Consumer<MembersProvider>(
              builder: (context, membersProvider, child) {
                final totalSocios = membersProvider.socios.length;
                final sociosActivos =
                    membersProvider.socios.where((s) => s.estaActivo).length;
                final sociosInactivos = totalSocios - sociosActivos;

                return Row(
                  children: [
                    _buildStatCard('Total Socios', totalSocios.toString(),
                        Icons.groups, CeasColors.kpiBlue, 'Socios registrados'),
                    const SizedBox(width: 16),
                    _buildStatCard(
                        'Socios Activos',
                        sociosActivos.toString(),
                        Icons.check_circle,
                        CeasColors.kpiGreen,
                        'En buen estado'),
                    const SizedBox(width: 16),
                    _buildStatCard(
                        'Socios Inactivos',
                        sociosInactivos.toString(),
                        Icons.cancel,
                        Colors.red,
                        'Pendientes'),
                    const SizedBox(width: 16),
                    _buildStatCard('Nuevos este mes', '0', Icons.person_add,
                        CeasColors.kpiOrange, 'Registros recientes'),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // Acciones rápidas
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

            // Contenido principal
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey[200]!, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Lista de Socios',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: CeasColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildFilters(),
                    const SizedBox(height: 20),
                    _buildMembersTable(),
                  ],
                ),
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
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
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
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
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

  Widget _buildFilters() {
    return Consumer<MembersProvider>(
      builder: (context, membersProvider, child) {
        return Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                onChanged: membersProvider.updateSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre, CI o email...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 16),
            _buildFilterDropdown(
              'Estado',
              membersProvider.filterEstado,
              ['Todos', 'Activo', 'Inactivo'],
              membersProvider.updateFilterEstado,
            ),
            const SizedBox(width: 16),
            _buildFilterDropdown(
              'Tipo Membresía',
              membersProvider.filterTipoMembresia,
              ['Todos', 'Accionista', 'Básica', 'Premium', 'VIP'],
              membersProvider.updateFilterTipoMembresia,
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterDropdown(String label, String value, List<String> items,
      Function(String) onChanged) {
    return Container(
      width: 200,
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: (value) => onChanged(value!),
      ),
    );
  }

  Widget _buildMembersTable() {
    return Consumer<MembersProvider>(
      builder: (context, membersProvider, child) {
        if (membersProvider.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (membersProvider.error != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar socios',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[400]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    membersProvider.error!,
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => membersProvider.loadSocios(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }

        final filteredSocios = membersProvider.filteredSocios;
        final startIndex = (currentPage - 1) * itemsPerPage;
        final endIndex =
            (startIndex + itemsPerPage).clamp(0, filteredSocios.length);
        final paginatedSocios = filteredSocios.sublist(startIndex, endIndex);
        final totalPages = (filteredSocios.length / itemsPerPage).ceil();

        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: CeasColors.primaryBlue.withOpacity(0.05),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: _buildHeaderCell('Socio', TextAlign.center)),
                        Expanded(
                            flex: 1,
                            child:
                                _buildHeaderCell('CI/NIT', TextAlign.center)),
                        Expanded(
                            flex: 1,
                            child:
                                _buildHeaderCell('Teléfono', TextAlign.center)),
                        Expanded(
                            flex: 2,
                            child: _buildHeaderCell('Email', TextAlign.start)),
                        Expanded(
                            flex: 1,
                            child:
                                _buildHeaderCell('Estado', TextAlign.center)),
                        Expanded(
                            flex: 1,
                            child: _buildHeaderCell(
                                'Membresía', TextAlign.center)),
                        Expanded(
                            flex: 1,
                            child: _buildHeaderCell(
                                'Fecha Registro', TextAlign.center)),
                        Expanded(
                            flex: 1,
                            child:
                                _buildHeaderCell('Acciones', TextAlign.center)),
                      ],
                    ),
                  ),
                  ...paginatedSocios.asMap().entries.map((entry) {
                    final index = entry.key;
                    final socio = entry.value;
                    return Container(
                      decoration: BoxDecoration(
                        color: index.isEven ? Colors.grey[50] : Colors.white,
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey[100]!, width: 0.5)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(flex: 2, child: _buildSocioCell(socio)),
                            Expanded(
                                flex: 1,
                                child:
                                    _buildCell(socio.ciNit, TextAlign.center)),
                            Expanded(
                                flex: 1,
                                child: _buildCell(
                                    socio.telefono, TextAlign.center)),
                            Expanded(
                                flex: 2,
                                child: _buildCell(socio.correoElectronico)),
                            Expanded(
                                flex: 1,
                                child: _buildEstadoCell(socio.estadoTexto)),
                            Expanded(
                                flex: 1,
                                child:
                                    _buildMembresiaCell(socio.tipoMembresia)),
                            Expanded(
                                flex: 1,
                                child: _buildCell(
                                    _formatDate(socio.fechaDeRegistro),
                                    TextAlign.center)),
                            Expanded(
                                flex: 1, child: _buildActionButtons(socio)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildPagination(
                currentPage,
                totalPages,
                (page) => setState(() => currentPage = page),
                filteredSocios.length,
                startIndex,
                endIndex),
          ],
        );
      },
    );
  }

  String _formatDate(String dateString) {
    try {
      // Parsear la fecha del backend y formatearla
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  Widget _buildHeaderCell(String text,
      [TextAlign textAlign = TextAlign.center]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        // color: Colors.red,
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: CeasColors.primaryBlue,
            fontSize: 14,
          ),
          textAlign: textAlign,
        ),
      ),
    );
  }

  Widget _buildCell(String text, [TextAlign textAlign = TextAlign.start]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        // color: Colors.red,
        child: Text(
          text,
          style: const TextStyle(fontSize: 14),
          textAlign: textAlign,
        ),
      ),
    );
  }

  Widget _buildSocioCell(Socio socio) {
    return Container(
      // color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: CeasColors.primaryBlue.withOpacity(0.1),
            child: Text(
              socio.nombres.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                color: CeasColors.primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                socio.nombreCompleto,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                'CEAS Principal',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEstadoCell(String estado) {
    Color color = estado == 'Activo' ? Colors.green : Colors.grey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        estado,
        style:
            TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMembresiaCell(String tipoMembresia) {
    Color backgroundColor;
    Color borderColor;
    Color textColor;

    switch (tipoMembresia.toLowerCase()) {
      case 'accionista':
        backgroundColor = Colors.purple[100]!;
        borderColor = Colors.purple[600]!;
        textColor = Colors.purple[700]!;
        break;
      case 'básica':
        backgroundColor = Colors.blue[100]!;
        borderColor = Colors.blue[600]!;
        textColor = Colors.blue[700]!;
        break;
      case 'premium':
        backgroundColor = Colors.orange[100]!;
        borderColor = Colors.orange[600]!;
        textColor = Colors.orange[700]!;
        break;
      case 'vip':
        backgroundColor = Colors.amber[100]!;
        borderColor = Colors.amber[600]!;
        textColor = Colors.amber[700]!;
        break;
      default:
        backgroundColor = Colors.grey[100]!;
        borderColor = Colors.grey[600]!;
        textColor = Colors.grey[700]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Text(
        tipoMembresia,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildActionButtons(Socio socio) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.grey),
      onSelected: (value) {
        switch (value) {
          case 'view':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const MemberDetailScreen(),
              ),
            );
            break;
          case 'edit':
            _showEditMemberDialog(context, socio);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'view',
          child: Row(
            children: [
              Icon(Icons.visibility, color: CeasColors.primaryBlue, size: 18),
              SizedBox(width: 8),
              Text('Ver detalle'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.orange, size: 18),
              SizedBox(width: 8),
              Text('Editar'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPagination(
      int currentPage,
      int totalPages,
      Function(int) onPageChange,
      int totalItems,
      int startIndex,
      int endIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Mostrando ${startIndex + 1}-$endIndex de $totalItems registros',
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left_rounded),
              onPressed:
                  currentPage > 1 ? () => onPageChange(currentPage - 1) : null,
            ),
            ...List.generate(
              totalPages,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: TextButton(
                  onPressed: () => onPageChange(index + 1),
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
              icon: const Icon(Icons.chevron_right_rounded),
              onPressed: currentPage < totalPages
                  ? () => onPageChange(currentPage + 1)
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  void _showCreateMemberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Crear Nuevo Socio'),
        content: const Text('Funcionalidad de crear socio (ficticia)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Socio creado exitosamente')),
              );
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  void _showEditMemberDialog(BuildContext context, Socio socio) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar Socio - ${socio.nombreCompleto}'),
        content: const Text('Funcionalidad de editar socio (ficticia)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Socio actualizado exitosamente')),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteMemberDialog(BuildContext context, Socio socio) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Socio - ${socio.nombreCompleto}'),
        content: const Text('¿Está seguro de que desea eliminar este socio?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Socio eliminado exitosamente')),
              );
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
