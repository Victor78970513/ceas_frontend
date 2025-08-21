import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/ceas_colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/socio_provider.dart';
import '../models/socio.dart';
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
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated) {
        Provider.of<SocioProvider>(context, listen: false).loadSocios(
          token: authProvider.user!.accessToken,
          idClub: authProvider.user!.idClub,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth <= 768;

          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header principal
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isMobile ? 16 : 24),
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
                  child: isMobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Gestión de Socios',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Administración y control de miembros del club',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Row(
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
                          ],
                        ),
                ),
                const SizedBox(height: 24),

                // Estadísticas
                _buildStatsRow(isMobile),
                const SizedBox(height: 24),

                // Acciones rápidas
                _buildQuickActionsRow(isMobile),
                const SizedBox(height: 24),

                // Filtros
                _buildFiltersSection(isMobile),
                const SizedBox(height: 24),

                // Lista de socios
                _buildMembersTable(isMobile),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsRow(bool isMobile) {
    return Consumer<SocioProvider>(
      builder: (context, socioProvider, child) {
        final totalSocios = socioProvider.socios.length;
        final sociosActivos =
            socioProvider.socios.where((s) => s.estaActivo).length;
        final sociosInactivos = totalSocios - sociosActivos;

        return isMobile
            ? Column(
                children: [
                  _buildStatCard('Total Socios', totalSocios.toString(),
                      Icons.people, CeasColors.primaryBlue),
                  const SizedBox(height: 16),
                  _buildStatCard('Socios Activos', sociosActivos.toString(),
                      Icons.check_circle, Colors.green),
                  const SizedBox(height: 16),
                  _buildStatCard('Socios Inactivos', sociosInactivos.toString(),
                      Icons.cancel, Colors.red),
                ],
              )
            : Row(
                children: [
                  Expanded(
                      child: _buildStatCard(
                          'Total Socios',
                          totalSocios.toString(),
                          Icons.people,
                          CeasColors.primaryBlue)),
                  const SizedBox(width: 16),
                  Expanded(
                      child: _buildStatCard(
                          'Socios Activos',
                          sociosActivos.toString(),
                          Icons.check_circle,
                          Colors.green)),
                  const SizedBox(width: 16),
                  Expanded(
                      child: _buildStatCard(
                          'Socios Inactivos',
                          sociosInactivos.toString(),
                          Icons.cancel,
                          Colors.red)),
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

  Widget _buildQuickActionsRow(bool isMobile) {
    return isMobile
        ? Column(
            children: [
              _buildQuickAction(
                  'Crear Socio', Icons.person_add, CeasColors.primaryBlue),
              const SizedBox(height: 12),
              _buildQuickAction(
                  'Importar Lista', Icons.upload_file, Colors.green),
              const SizedBox(height: 12),
              _buildQuickAction(
                  'Exportar Datos', Icons.download, Colors.orange),
              const SizedBox(height: 12),
              _buildQuickAction(
                  'Generar Reporte', Icons.assessment, Colors.purple),
            ],
          )
        : Row(
            children: [
              Expanded(
                  child: _buildQuickAction(
                      'Crear Socio', Icons.person_add, CeasColors.primaryBlue)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildQuickAction(
                      'Importar Lista', Icons.upload_file, Colors.green)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildQuickAction(
                      'Exportar Datos', Icons.download, Colors.orange)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildQuickAction(
                      'Generar Reporte', Icons.assessment, Colors.purple)),
            ],
          );
  }

  Widget _buildQuickAction(String title, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        if (title == 'Crear Socio') {
          _showCreateMemberDialog(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title (ficticio)')),
          );
        }
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
    );
  }

  Widget _buildFiltersSection(bool isMobile) {
    return Consumer<SocioProvider>(
      builder: (context, socioProvider, child) {
        return Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                        color: CeasColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.filter_alt,
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
                isMobile
                    ? Column(
                        children: [
                          TextField(
                            onChanged: socioProvider.updateSearchQuery,
                            decoration: InputDecoration(
                              hintText: 'Buscar por nombre, CI o email...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildFilterDropdown(
                            'Estado',
                            socioProvider.filterEstado,
                            ['Todos', 'Activo', 'Inactivo'],
                            (value) => socioProvider
                                .updateFilterEstado(value ?? 'Todos'),
                          ),
                          const SizedBox(height: 16),
                          _buildFilterDropdown(
                            'Tipo de Socio',
                            socioProvider.filterTipoMembresia,
                            ['Todos', 'Accionista', 'Básica', 'Premium', 'VIP'],
                            (value) => socioProvider
                                .updateFilterTipoMembresia(value ?? 'Todos'),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              onChanged: socioProvider.updateSearchQuery,
                              decoration: InputDecoration(
                                hintText: 'Buscar por nombre, CI o email...',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          _buildFilterDropdown(
                            'Estado',
                            socioProvider.filterEstado,
                            ['Todos', 'Activo', 'Inactivo'],
                            (value) => socioProvider
                                .updateFilterEstado(value ?? 'Todos'),
                          ),
                          const SizedBox(width: 16),
                          _buildFilterDropdown(
                            'Tipo de Socio',
                            socioProvider.filterTipoMembresia,
                            ['Todos', 'Accionista', 'Básica', 'Premium', 'VIP'],
                            (value) => socioProvider
                                .updateFilterTipoMembresia(value ?? 'Todos'),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterDropdown(String label, String value, List<String> items,
      Function(String?) onChanged) {
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
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildMembersTable(bool isMobile) {
    return Consumer<SocioProvider>(
      builder: (context, socioProvider, child) {
        if (socioProvider.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (socioProvider.error != null) {
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
                      color: Colors.red[400],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    socioProvider.error!,
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final authProvider =
                          Provider.of<AuthProvider>(context, listen: false);
                      if (authProvider.isAuthenticated) {
                        socioProvider.loadSocios(
                          token: authProvider.user!.accessToken,
                          idClub: authProvider.user!.idClub,
                        );
                      }
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }

        final filteredSocios = socioProvider.filteredSocios;
        final startIndex = (currentPage - 1) * itemsPerPage;
        final endIndex =
            (startIndex + itemsPerPage).clamp(0, filteredSocios.length);
        final paginatedSocios = filteredSocios.sublist(startIndex, endIndex);
        final totalPages = (filteredSocios.length / itemsPerPage).ceil();

        return Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: CeasColors.primaryBlue.withOpacity(0.05),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: CeasColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.list_alt,
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
                        '${filteredSocios.length} socios encontrados',
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
              if (isMobile)
                _buildMobileMembersList(paginatedSocios)
              else
                _buildDesktopMembersTable(paginatedSocios),
              const SizedBox(height: 16),
              _buildPagination(
                  totalPages, filteredSocios.length, startIndex, endIndex),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMobileMembersList(List<Socio> socios) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: socios.length,
      itemBuilder: (context, index) {
        final socio = socios[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[200]!,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: CeasColors.primaryBlue.withOpacity(0.1),
                    child: Text(
                      socio.nombres.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: CeasColors.primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'CI: ${socio.ciNit}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'Registro: ${_formatDate(socio.fechaDeRegistro)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildEstadoChip(socio.estadoTexto),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nombres: ${socio.nombres}',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        Text(
                          'Apellidos: ${socio.apellidos}',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        Text(
                          'Email: ${socio.correoElectronico}',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        Text(
                          'Teléfono: ${socio.telefono}',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Botón Ver Detalles
                      Container(
                        decoration: BoxDecoration(
                          color: CeasColors.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: () => _handleMemberAction('view', socio),
                          icon: const Icon(
                            Icons.visibility_rounded,
                            color: CeasColors.primaryBlue,
                            size: 20,
                          ),
                          tooltip: 'Ver Detalles',
                          style: IconButton.styleFrom(
                            padding: const EdgeInsets.all(8),
                            minimumSize: const Size(32, 32),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Botón Editar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: () => _handleMemberAction('edit', socio),
                          icon: const Icon(
                            Icons.edit_rounded,
                            color: Colors.orange,
                            size: 20,
                          ),
                          tooltip: 'Editar',
                          style: IconButton.styleFrom(
                            padding: const EdgeInsets.all(8),
                            minimumSize: const Size(32, 32),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesktopMembersTable(List<Socio> socios) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: CeasColors.primaryBlue.withOpacity(0.05),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Row(
            children: [
              Expanded(flex: 1, child: _buildHeaderCell('ID')),
              const SizedBox(width: 8),
              Expanded(flex: 2, child: _buildHeaderCell('Nombres')),
              const SizedBox(width: 8),
              Expanded(flex: 2, child: _buildHeaderCell('Apellidos')),
              const SizedBox(width: 8),
              Expanded(flex: 2, child: _buildHeaderCell('Carnet de Identidad')),
              const SizedBox(width: 8),
              Expanded(flex: 3, child: _buildHeaderCell('Correo Electrónico')),
              const SizedBox(width: 8),
              Expanded(flex: 2, child: _buildHeaderCell('Teléfono')),
              const SizedBox(width: 8),
              Expanded(flex: 2, child: _buildHeaderCell('Fecha Registro')),
              const SizedBox(width: 8),
              Expanded(
                  flex: 2, child: _buildHeaderCell('Estado', TextAlign.center)),
              const SizedBox(width: 8),
              Expanded(
                  flex: 2,
                  child: _buildHeaderCell('Acciones', TextAlign.center)),
            ],
          ),
        ),
        ...socios.asMap().entries.map((entry) {
          final index = entry.key;
          final socio = entry.value;
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 1),
            decoration: BoxDecoration(
              color: index.isEven ? Colors.grey[50] : Colors.white,
              border: Border(
                  bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      flex: 1, child: _buildCell(socio.idSocio.toString())),
                  const SizedBox(width: 8),
                  Expanded(flex: 2, child: _buildCell(socio.nombres)),
                  const SizedBox(width: 8),
                  Expanded(flex: 2, child: _buildCell(socio.apellidos)),
                  const SizedBox(width: 8),
                  Expanded(flex: 2, child: _buildCell(socio.ciNit)),
                  const SizedBox(width: 8),
                  Expanded(flex: 3, child: _buildCell(socio.correoElectronico)),
                  const SizedBox(width: 8),
                  Expanded(flex: 2, child: _buildCell(socio.telefono)),
                  const SizedBox(width: 8),
                  Expanded(
                      flex: 2,
                      child: _buildCell(_formatDate(socio.fechaDeRegistro))),
                  const SizedBox(width: 8),
                  Expanded(flex: 2, child: _buildEstadoChip(socio.estadoTexto)),
                  const SizedBox(width: 8),
                  Expanded(flex: 2, child: _buildActionsCell(socio)),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildHeaderCell(String text, [TextAlign textAlign = TextAlign.left]) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: CeasColors.primaryBlue,
        fontSize: 13,
        letterSpacing: 0.5,
      ),
      textAlign: textAlign,
    );
  }

  Widget _buildCell(String text, [TextAlign textAlign = TextAlign.left]) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[800],
        fontWeight: FontWeight.w500,
      ),
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }

  Widget _buildEstadoChip(String estado) {
    Color color;
    switch (estado) {
      case 'Activo':
        color = Colors.green;
        break;
      case 'Inactivo':
        color = Colors.grey;
        break;
      default:
        color = Colors.blueGrey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Center(
        child: Text(
          estado,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 11,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  Widget _buildActionsCell(Socio socio) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Botón Ver Detalles
        Container(
          decoration: BoxDecoration(
            color: CeasColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            onPressed: () => _handleMemberAction('view', socio),
            icon: const Icon(
              Icons.visibility_rounded,
              color: CeasColors.primaryBlue,
              size: 20,
            ),
            tooltip: 'Ver Detalles',
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(8),
              minimumSize: const Size(36, 36),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Botón Editar
        Container(
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            onPressed: () => _handleMemberAction('edit', socio),
            icon: const Icon(
              Icons.edit_rounded,
              color: Colors.orange,
              size: 20,
            ),
            tooltip: 'Editar',
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(8),
              minimumSize: const Size(36, 36),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPagination(
      int totalPages, int totalItems, int startIndex, int endIndex) {
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Información de la página
          Text(
            'Mostrando ${endIndex - startIndex} de $totalItems socios',
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
                onPressed: currentPage > 1
                    ? () => setState(() => currentPage--)
                    : null,
                icon: const Icon(Icons.chevron_left),
                color: currentPage > 1
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
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$currentPage',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),

              // Separador
              Text(
                ' de $totalPages',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // Botón siguiente
              IconButton(
                onPressed: currentPage < totalPages
                    ? () => setState(() => currentPage++)
                    : null,
                icon: const Icon(Icons.chevron_right),
                color: currentPage < totalPages
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
                value: itemsPerPage,
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    setState(() {
                      itemsPerPage = newValue;
                      currentPage = 1; // Reset a la primera página
                    });
                  }
                },
                items: [10, 20, 50, 100].map((int value) {
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
    );
  }

  void _handleMemberAction(String action, Socio socio) {
    switch (action) {
      case 'view':
        _showViewMemberBottomSheet(socio);
        break;
      case 'edit':
        _showEditMemberBottomSheet(socio);
        break;
      case 'delete':
        _showDeleteConfirmation(socio);
        break;
    }
  }

  void _showEditMemberBottomSheet(Socio socio) {
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
                            color: CeasColors.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.edit,
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
                                'Editar Socio',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: CeasColors.primaryBlue,
                                ),
                              ),
                              Text(
                                'Modifica la información de ${socio.nombreCompleto}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
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
                child: MemberFormScreen(
                  socio: socio,
                  isBottomSheet: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showViewMemberBottomSheet(Socio socio) {
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
                            color: CeasColors.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.visibility_rounded,
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
                                'Detalles del Socio',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: CeasColors.primaryBlue,
                                ),
                              ),
                              Text(
                                'Información completa de ${socio.nombreCompleto}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
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
              // Contenido de detalles
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailSection('Información Personal', [
                        _buildDetailRow('ID Socio', socio.idSocio.toString()),
                        _buildDetailRow('Nombres', socio.nombres),
                        _buildDetailRow('Apellidos', socio.apellidos),
                        _buildDetailRow('CI/NIT', socio.ciNit),
                        _buildDetailRow('Teléfono', socio.telefono),
                        _buildDetailRow('Email', socio.correoElectronico),
                        _buildDetailRow('Dirección', socio.direccion),
                      ]),
                      const SizedBox(height: 24),
                      _buildDetailSection('Información de Membresía', [
                        _buildDetailRow('Estado', socio.estadoTexto),
                        _buildDetailRow(
                            'Tipo de Membresía', socio.tipoMembresia),
                        _buildDetailRow('Fecha de Registro',
                            _formatDate(socio.fechaDeRegistro)),
                        if (socio.fechaNacimiento != null)
                          _buildDetailRow('Fecha de Nacimiento',
                              _formatDate(socio.fechaNacimiento!)),
                      ]),
                      const SizedBox(height: 24),
                      _buildDetailSection('Información del Club', [
                        _buildDetailRow('ID Club', socio.idClub.toString()),
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: CeasColors.primaryBlue,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Socio socio) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text(
            '¿Está seguro de que desea eliminar al socio ${socio.nombreCompleto}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implementar eliminación real
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

  void _showCreateMemberDialog(BuildContext context) {
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
                            color: CeasColors.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.person_add,
                            color: CeasColors.primaryBlue,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Crear Nuevo Socio',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: CeasColors.primaryBlue,
                                ),
                              ),
                              Text(
                                'Registra un nuevo miembro en el club',
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
                child: MemberFormScreen(
                  socio: null,
                  isBottomSheet: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString; // Retorna la cadena original si no se puede parsear
    }
  }
}
