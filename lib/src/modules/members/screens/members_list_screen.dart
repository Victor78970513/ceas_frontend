import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html;
import '../../../core/theme/ceas_colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/socio_provider.dart';
import '../models/socio.dart';
import '../services/members_service.dart';
import 'member_form_screen.dart';

class MembersListScreen extends StatefulWidget {
  const MembersListScreen({Key? key}) : super(key: key);

  @override
  State<MembersListScreen> createState() => _MembersListScreenState();
}

class _MembersListScreenState extends State<MembersListScreen> {
  int currentPage = 1;
  int itemsPerPage = 12; // Cambiado a 12 para que sea múltiplo de 3 (grid de 3 columnas)

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
          final isMobile = constraints.maxWidth < 1024; // Breakpoint consistente

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

        if (isMobile) {
          // Móvil: usar Wrap
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildStatCard(
                'Total Socios',
                totalSocios.toString(),
                Icons.people,
                CeasColors.primaryBlue,
                isMobile,
              ),
              _buildStatCard(
                'Socios Activos',
                sociosActivos.toString(),
                Icons.check_circle,
                Colors.green,
                isMobile,
              ),
              _buildStatCard(
                'Socios Inactivos',
                sociosInactivos.toString(),
                Icons.cancel,
                Colors.red,
                isMobile,
              ),
            ],
          );
        } else {
          // Desktop: usar Row con Expanded
          return Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Socios',
                  totalSocios.toString(),
                  Icons.people,
                  CeasColors.primaryBlue,
                  isMobile,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Socios Activos',
                  sociosActivos.toString(),
                  Icons.check_circle,
                  Colors.green,
                  isMobile,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Socios Inactivos',
                  sociosInactivos.toString(),
                  Icons.cancel,
                  Colors.red,
                  isMobile,
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color, bool isMobile) {
    return Container(
      width: isMobile ? double.infinity : null, // null para que Expanded funcione en desktop
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color.withOpacity(0.2),
                        color.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsRow(bool isMobile) {
    if (isMobile) {
      // Móvil: usar Wrap
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          SizedBox(
            width: double.infinity,
            child: _buildQuickAction(
                'Crear Socio', Icons.person_add, CeasColors.primaryBlue),
          ),
          // SizedBox(
          //   width: double.infinity,
          //   child: _buildQuickAction(
          //       'Exportar Datos', Icons.download, Colors.orange),
          // ),
          SizedBox(
            width: double.infinity,
            child: _buildQuickAction(
                'Generar Reporte', Icons.assessment, Colors.purple),
          ),
        ],
      );
    } else {
      // Desktop: usar Row con Expanded
      return Row(
        children: [
          Expanded(
            child: _buildQuickAction(
                'Crear Socio', Icons.person_add, CeasColors.primaryBlue),
          ),
          // const SizedBox(width: 16),
          // Expanded(
          //   child: _buildQuickAction(
          //       'Exportar Datos', Icons.download, Colors.orange),
          // ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildQuickAction(
                'Generar Reporte', Icons.assessment, Colors.purple),
          ),
        ],
      );
    }
  }

  Widget _buildQuickAction(String title, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        if (title == 'Crear Socio') {
          _showCreateMemberDialog(context);
        } else if (title == 'Generar Reporte') {
          _descargarReporteSocios();
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
              // Vista condicional: tabla para desktop, tarjetas para móvil
              if (isMobile)
                _buildMembersCards(paginatedSocios, isMobile)
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

  Widget _buildDesktopMembersTable(List<Socio> socios) {
    return Column(
      children: [
        // Encabezado de la tabla
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
              Expanded(flex: 2, child: _buildHeaderCell('Nombres')),
              const SizedBox(width: 8),
              Expanded(flex: 2, child: _buildHeaderCell('Apellidos')),
              const SizedBox(width: 8),
              Expanded(flex: 2, child: _buildHeaderCell('CI/NIT')),
              const SizedBox(width: 8),
              Expanded(flex: 3, child: _buildHeaderCell('Correo')),
              const SizedBox(width: 8),
              Expanded(flex: 2, child: _buildHeaderCell('Teléfono')),
              const SizedBox(width: 8),
              Expanded(flex: 2, child: _buildHeaderCell('Registro')),
              const SizedBox(width: 8),
              Expanded(flex: 2, child: _buildHeaderCell('Estado', TextAlign.center)),
              const SizedBox(width: 8),
              Expanded(flex: 2, child: _buildHeaderCell('Acciones', TextAlign.center)),
            ],
          ),
        ),
        // Filas de datos
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
                  Expanded(flex: 2, child: _buildCell(_formatDate(socio.fechaDeRegistro))),
                  const SizedBox(width: 8),
                  Expanded(flex: 2, child: _buildEstadoChipForTable(socio.estadoTexto)),
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

  Widget _buildEstadoChipForTable(String estado) {
    Color backgroundColor;
    Color textColor;
    switch (estado.toLowerCase()) {
      case 'activo':
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green[700]!;
        break;
      case 'inactivo':
        backgroundColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red[700]!;
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey[700]!;
    }
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: textColor.withOpacity(0.3), width: 1),
        ),
        child: Text(
          estado,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildActionsCell(Socio socio) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Botón Ver
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
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 1024;
          
          if (isMobile) {
            // Layout móvil - columna
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Información
                Text(
                  'Mostrando ${endIndex - startIndex} de $totalItems socios',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Controles de navegación
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Botón anterior
                    Container(
                      decoration: BoxDecoration(
                        color: currentPage > 1 
                            ? CeasColors.primaryBlue.withOpacity(0.1) 
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: currentPage > 1
                            ? () => setState(() => currentPage--)
                            : null,
                        icon: Icon(
                          Icons.chevron_left,
                          color: currentPage > 1
                              ? CeasColors.primaryBlue
                              : Colors.grey.shade400,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Número de página actual
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            CeasColors.primaryBlue,
                            CeasColors.primaryBlue.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: CeasColors.primaryBlue.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '$currentPage / $totalPages',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Botón siguiente
                    Container(
                      decoration: BoxDecoration(
                        color: currentPage < totalPages 
                            ? CeasColors.primaryBlue.withOpacity(0.1) 
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: currentPage < totalPages
                            ? () => setState(() => currentPage++)
                            : null,
                        icon: Icon(
                          Icons.chevron_right,
                          color: currentPage < totalPages
                              ? CeasColors.primaryBlue
                              : Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Selector de elementos por página
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<int>(
                          value: itemsPerPage,
                          onChanged: (int? newValue) {
                            if (newValue != null) {
                              setState(() {
                                itemsPerPage = newValue;
                                currentPage = 1;
                              });
                            }
                          },
                          items: [9, 12, 18, 24].map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text('$value'),
                            );
                          }).toList(),
                          underline: Container(),
                          icon: Icon(Icons.arrow_drop_down, color: CeasColors.primaryBlue),
                          style: TextStyle(
                            color: CeasColors.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            // Layout desktop - fila
            return Row(
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
                    Container(
                      decoration: BoxDecoration(
                        color: currentPage > 1 
                            ? CeasColors.primaryBlue.withOpacity(0.1) 
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: currentPage > 1
                            ? () => setState(() => currentPage--)
                            : null,
                        icon: Icon(
                          Icons.chevron_left,
                          color: currentPage > 1
                              ? CeasColors.primaryBlue
                              : Colors.grey.shade400,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Número de página actual
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            CeasColors.primaryBlue,
                            CeasColors.primaryBlue.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: CeasColors.primaryBlue.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '$currentPage / $totalPages',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Botón siguiente
                    Container(
                      decoration: BoxDecoration(
                        color: currentPage < totalPages 
                            ? CeasColors.primaryBlue.withOpacity(0.1) 
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: currentPage < totalPages
                            ? () => setState(() => currentPage++)
                            : null,
                        icon: Icon(
                          Icons.chevron_right,
                          color: currentPage < totalPages
                              ? CeasColors.primaryBlue
                              : Colors.grey.shade400,
                        ),
                      ),
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<int>(
                        value: itemsPerPage,
                        onChanged: (int? newValue) {
                          if (newValue != null) {
                            setState(() {
                              itemsPerPage = newValue;
                              currentPage = 1;
                            });
                          }
                        },
                        items: [9, 12, 18, 24].map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text('$value'),
                          );
                        }).toList(),
                        underline: Container(),
                        icon: Icon(Icons.arrow_drop_down, color: CeasColors.primaryBlue),
                        style: TextStyle(
                          color: CeasColors.primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        },
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
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.9,
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
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.8,
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
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.9,
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

  Widget _buildMembersCards(List<Socio> socios, bool isMobile) {
    if (isMobile) {
      // Layout de una columna para móvil
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: socios.length,
        itemBuilder: (context, index) {
          return _buildMemberCard(socios[index], isMobile);
        },
      );
    } else {
      // Layout de grid para desktop
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: socios.length,
        itemBuilder: (context, index) {
          return _buildMemberCard(socios[index], isMobile);
        },
        padding: const EdgeInsets.all(20),
      );
    }
  }

  Widget _buildMemberCard(Socio socio, bool isMobile) {
    final getInitials = (String name) {
      final parts = name.split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return name[0].toUpperCase();
    };

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 0,
        vertical: isMobile ? 8 : 0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200]!.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con gradiente
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  CeasColors.primaryBlue,
                  CeasColors.primaryBlue.withOpacity(0.7),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      getInitials(socio.nombreCompleto),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: CeasColors.primaryBlue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        socio.nombreCompleto,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.credit_card,
                            size: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'CI: ${socio.ciNit}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Estado chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: socio.estadoTexto == 'ACTIVO'
                              ? Colors.green[300]
                              : Colors.red[300],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        socio.estadoTexto,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Información del socio
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(Icons.person_outline, 'Nombres', socio.nombres),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.person_outline, 'Apellidos', socio.apellidos),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.email_outlined, 'Email', socio.correoElectronico),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.phone_outlined, 'Teléfono', socio.telefono),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.calendar_today_outlined, 'Registro', _formatDate(socio.fechaDeRegistro)),
              ],
            ),
          ),
          
          // Botones de acción
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    'Ver',
                    Icons.visibility_rounded,
                    CeasColors.primaryBlue,
                    () => _handleMemberAction('view', socio),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    'Editar',
                    Icons.edit_rounded,
                    Colors.orange,
                    () => _handleMemberAction('edit', socio),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: CeasColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 16,
            color: CeasColors.primaryBlue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Descarga el reporte de socios en formato PDF
  Future<void> _descargarReporteSocios() async {
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

      final membersService = MembersService();
      final pdfBytes = await membersService.downloadReporteSocios();

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
        ..setAttribute('download', 'reporte_socios_${DateTime.now().millisecondsSinceEpoch}.pdf')
        ..click();
      
      // Limpiar la URL del blob
      html.Url.revokeObjectUrl(url);

      if (mounted) {
        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
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

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString; // Retorna la cadena original si no se puede parsear
    }
  }
}
