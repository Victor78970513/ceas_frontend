class Compra {
  final int idCompra;
  final int idProveedor;
  final DateTime fechaDeCompra;
  final double montoTotal;
  final String estado;
  final DateTime? fechaDeEntrega;
  final int cantidadItems;
  final String categoria;
  final String proveedor;

  Compra({
    required this.idCompra,
    required this.idProveedor,
    required this.fechaDeCompra,
    required this.montoTotal,
    required this.estado,
    this.fechaDeEntrega,
    required this.cantidadItems,
    required this.categoria,
    required this.proveedor,
  });

  factory Compra.fromJson(Map<String, dynamic> json) {
    return Compra(
      idCompra: json['id_compra'],
      idProveedor: json['id_proveedor'],
      fechaDeCompra: DateTime.parse(json['fecha_de_compra']),
      montoTotal: json['monto_total'].toDouble(),
      estado: json['estado'],
      fechaDeEntrega: json['fecha_de_entrega'] != null
          ? DateTime.parse(json['fecha_de_entrega'])
          : null,
      cantidadItems: json['cantidad_items'],
      categoria: json['categoria'],
      proveedor: json['proveedor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_compra': idCompra,
      'id_proveedor': idProveedor,
      'fecha_de_compra': fechaDeCompra.toIso8601String(),
      'monto_total': montoTotal,
      'estado': estado,
      'fecha_de_entrega': fechaDeEntrega?.toIso8601String(),
      'cantidad_items': cantidadItems,
      'categoria': categoria,
      'proveedor': proveedor,
    };
  }

  // Getters útiles para la UI
  String get id => 'COMP${idCompra.toString().padLeft(3, '0')}';
  String get fecha => _formatDate(fechaDeCompra);
  String get fechaEntrega =>
      fechaDeEntrega != null ? _formatDate(fechaDeEntrega!) : 'N/A';
  String get items => cantidadItems.toString();
  String get montoTotalFormatted => 'Bs. ${montoTotal.toStringAsFixed(0)}';

  // Para compatibilidad con el código existente
  String get metodoPago => 'N/A'; // No viene en el endpoint

  // Formateo de fechas
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

