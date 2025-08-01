import 'package:flutter/material.dart';
import '../../../core/theme/ceas_colors.dart';
import '../../../core/widgets/ceas_header.dart';

class StaffListScreen extends StatefulWidget {
  const StaffListScreen({Key? key}) : super(key: key);

  @override
  State<StaffListScreen> createState() => _StaffListScreenState();
}

class _StaffListScreenState extends State<StaffListScreen> {
  String search = '';
  String cargo = 'Todos';
  String estado = 'Todos';

  final List<Map<String, dynamic>> empleados = [
    {
      'id': 'EMP001',
      'nombre': 'Carlos Gómez',
      'cargo': 'Encargado de Ventas',
      'email': 'carlos.gomez@ceas.com',
      'telefono': '76543210',
      'fechaIngreso': '15/03/2022',
      'estado': 'Activo',
      'salario': 4500.0,
      'departamento': 'Ventas',
    },
    {
      'id': 'EMP002',
      'nombre': 'Ana Torres',
      'cargo': 'Contadora',
      'email': 'ana.torres@ceas.com',
      'telefono': '76543211',
      'fechaIngreso': '22/01/2021',
      'estado': 'Activo',
      'salario': 5200.0,
      'departamento': 'Finanzas',
    },
    {
      'id': 'EMP003',
      'nombre': 'Luis Mendoza',
      'cargo': 'Instructor de Equitación',
      'email': 'luis.mendoza@ceas.com',
      'telefono': '76543212',
      'fechaIngreso': '10/06/2023',
      'estado': 'Activo',
      'salario': 3800.0,
      'departamento': 'Deportes',
    },
  ];

  final List<Map<String, dynamic>> asistencia = [
    {
      'empleado': 'Carlos Gómez',
      'fecha': '15/12/2024',
      'entrada': '08:00',
      'salida': '17:00',
      'estado': 'Presente',
      'horas': 9,
    },
    {
      'empleado': 'Ana Torres',
      'fecha': '15/12/2024',
      'entrada': '08:15',
      'salida': '17:30',
      'estado': 'Retraso',
      'horas': 9.25,
    },
  ];

  List<Map<String, dynamic>> get filteredEmpleados {
    return empleados.where((empleado) {
      final matchesSearch =
          empleado['nombre'].toLowerCase().contains(search.toLowerCase()) ||
              empleado['id'].toLowerCase().contains(search.toLowerCase());
      final matchesCargo = cargo == 'Todos' || empleado['cargo'] == cargo;
      final matchesEstado = estado == 'Todos' || empleado['estado'] == estado;
      return matchesSearch && matchesCargo && matchesEstado;
    }).toList();
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
                          'Recursos Humanos',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Gestión de empleados y control de asistencia',
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

            _buildStatsRow(),
            const SizedBox(height: 24),
            _buildEmpleadosSection(),
            const SizedBox(height: 24),
            _buildAsistenciaSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatCard('Total Empleados', '${empleados.length}', Icons.people,
            CeasColors.primaryBlue),
        const SizedBox(width: 16),
        _buildStatCard(
            'Activos',
            '${empleados.where((e) => e['estado'] == 'Activo').length}',
            Icons.check_circle,
            Colors.green),
        const SizedBox(width: 16),
        _buildStatCard(
            'Presentes Hoy',
            '${asistencia.where((a) => a['estado'] == 'Presente').length}',
            Icons.today,
            Colors.orange),
        const SizedBox(width: 16),
        _buildStatCard(
            'Retrasos Hoy',
            '${asistencia.where((a) => a['estado'] == 'Retraso').length}',
            Icons.schedule,
            Colors.red),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
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
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpleadosSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Icons.people_alt_rounded,
                        color: CeasColors.primaryBlue,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Empleados',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: CeasColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddEmployeeDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Nuevo Empleado'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CeasColors.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildFilters(),
            const SizedBox(height: 20),
            _buildEmpleadosTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (value) => setState(() => search = value),
            decoration: InputDecoration(
              hintText: 'Buscar por nombre o ID...',
              prefixIcon: const Icon(Icons.search),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 16),
        _buildFilterDropdown(
            'Cargo',
            cargo,
            [
              'Todos',
              'Encargado de Ventas',
              'Contadora',
              'Instructor de Equitación'
            ],
            (value) => setState(() => cargo = value!)),
        const SizedBox(width: 16),
        _buildFilterDropdown('Estado', estado, ['Todos', 'Activo', 'Inactivo'],
            (value) => setState(() => estado = value!)),
      ],
    );
  }

  Widget _buildEmpleadosTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                Expanded(flex: 3, child: _buildHeaderCell('Empleado')),
                Expanded(flex: 2, child: _buildHeaderCell('Cargo')),
                Expanded(flex: 2, child: _buildHeaderCell('Departamento')),
                Expanded(flex: 1, child: _buildHeaderCell('F. Ingreso')),
                Expanded(flex: 1, child: _buildHeaderCell('Salario')),
                Expanded(
                    flex: 1, child: Center(child: _buildHeaderCell('Estado'))),
                Expanded(flex: 1, child: _buildHeaderCell('Acciones')),
              ],
            ),
          ),
          ...filteredEmpleados.asMap().entries.map((entry) {
            final index = entry.key;
            final empleado = entry.value;
            return Container(
              decoration: BoxDecoration(
                color: index.isEven ? Colors.grey[50] : Colors.white,
                border: Border(
                    bottom: BorderSide(color: Colors.grey[100]!, width: 0.5)),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Expanded(flex: 1, child: _buildCell(empleado['id'])),
                    Expanded(flex: 3, child: _buildEmpleadoCell(empleado)),
                    Expanded(flex: 2, child: _buildCell(empleado['cargo'])),
                    Expanded(
                        flex: 2, child: _buildCell(empleado['departamento'])),
                    Expanded(
                        flex: 1, child: _buildCell(empleado['fechaIngreso'])),
                    Expanded(
                        flex: 1, child: _buildMoneyCell(empleado['salario'])),
                    Expanded(
                        flex: 1,
                        child: Center(
                            child: _buildEstadoCell(empleado['estado']))),
                    Expanded(flex: 1, child: _buildOpcionesCell(empleado)),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildAsistenciaSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.schedule_rounded,
                        color: Colors.orange,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Control de Asistencia',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAttendanceDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Registrar Asistencia'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildAsistenciaTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildAsistenciaTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(flex: 3, child: _buildHeaderCell('Empleado')),
                Expanded(flex: 1, child: _buildHeaderCell('Fecha')),
                Expanded(flex: 1, child: _buildHeaderCell('Entrada')),
                Expanded(flex: 1, child: _buildHeaderCell('Salida')),
                Expanded(flex: 1, child: _buildHeaderCell('Horas')),
                Expanded(
                    flex: 1, child: Center(child: _buildHeaderCell('Estado'))),
                Expanded(flex: 1, child: _buildHeaderCell('Acciones')),
              ],
            ),
          ),
          ...asistencia.asMap().entries.map((entry) {
            final index = entry.key;
            final registro = entry.value;
            return Container(
              decoration: BoxDecoration(
                color: index.isEven ? Colors.grey[50] : Colors.white,
                border: Border(
                    bottom: BorderSide(color: Colors.grey[100]!, width: 0.5)),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Expanded(flex: 3, child: _buildCell(registro['empleado'])),
                    Expanded(flex: 1, child: _buildCell(registro['fecha'])),
                    Expanded(flex: 1, child: _buildCell(registro['entrada'])),
                    Expanded(flex: 1, child: _buildCell(registro['salida'])),
                    Expanded(
                        flex: 1, child: _buildCell('${registro['horas']}h')),
                    Expanded(
                        flex: 1,
                        child: Center(
                            child: _buildAsistenciaEstadoCell(
                                registro['estado']))),
                    Expanded(
                        flex: 1, child: _buildAsistenciaOpcionesCell(registro)),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: CeasColors.primaryBlue,
        fontSize: 14,
      ),
    );
  }

  Widget _buildCell(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget _buildEmpleadoCell(Map<String, dynamic> empleado) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: CeasColors.primaryBlue.withOpacity(0.1),
          child: Text(
            empleado['nombre'].split(' ').map((n) => n[0]).join(''),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: CeasColors.primaryBlue,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                empleado['nombre'],
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                empleado['email'],
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMoneyCell(dynamic amount) {
    return Text(
      'Bs. ${amount.toStringAsFixed(0)}',
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.green,
      ),
    );
  }

  Widget _buildEstadoCell(String estado) {
    Color color = estado == 'Activo' ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        estado,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildAsistenciaEstadoCell(String estado) {
    Color color;
    IconData icon;
    switch (estado) {
      case 'Presente':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'Retraso':
        color = Colors.orange;
        icon = Icons.schedule;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            estado,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpcionesCell(Map<String, dynamic> empleado) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value) {
          case 'editar':
            _showEditEmployeeDialog(empleado);
            break;
          case 'asistencia':
            _showAttendanceHistoryDialog(empleado);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'editar',
          child: Row(
            children: [
              Icon(Icons.edit, size: 16),
              SizedBox(width: 8),
              Text('Editar'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'asistencia',
          child: Row(
            children: [
              Icon(Icons.history, size: 16),
              SizedBox(width: 8),
              Text('Ver Asistencia'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAsistenciaOpcionesCell(Map<String, dynamic> registro) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value) {
          case 'editar':
            _showEditAttendanceDialog(registro);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'editar',
          child: Row(
            children: [
              Icon(Icons.edit, size: 16),
              SizedBox(width: 8),
              Text('Editar'),
            ],
          ),
        ),
      ],
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

  void _showAddEmployeeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo Empleado'),
        content: const Text('Funcionalidad de agregar empleado (ficticia)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Empleado agregado exitosamente')),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showEditEmployeeDialog(Map<String, dynamic> empleado) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar ${empleado['nombre']}'),
        content: const Text('Funcionalidad de editar empleado (ficticia)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Empleado actualizado exitosamente')),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showAttendanceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registrar Asistencia'),
        content: const Text('Funcionalidad de registrar asistencia (ficticia)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Asistencia registrada exitosamente')),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showAttendanceHistoryDialog(Map<String, dynamic> empleado) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Historial de Asistencia - ${empleado['nombre']}'),
        content:
            const Text('Funcionalidad de historial de asistencia (ficticia)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showEditAttendanceDialog(Map<String, dynamic> registro) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Asistencia'),
        content: const Text('Funcionalidad de editar asistencia (ficticia)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Asistencia actualizada exitosamente')),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
