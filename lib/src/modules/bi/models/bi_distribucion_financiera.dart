class BiDistribucionFinanciera {
  final String periodo;
  final List<BiCategoriaFinanciera> categorias;
  final double totalIngresos;
  final double totalEgresos;
  final double balanceTotal;

  BiDistribucionFinanciera({
    required this.periodo,
    required this.categorias,
    required this.totalIngresos,
    required this.totalEgresos,
    required this.balanceTotal,
  });

  factory BiDistribucionFinanciera.fromJson(Map<String, dynamic> json) {
    return BiDistribucionFinanciera(
      periodo: json['periodo'] ?? '',
      categorias: (json['categorias'] as List<dynamic>?)
              ?.map((item) => BiCategoriaFinanciera.fromJson(item))
              .toList() ??
          [],
      totalIngresos: (json['total_ingresos'] ?? 0.0).toDouble(),
      totalEgresos: (json['total_egresos'] ?? 0.0).toDouble(),
      balanceTotal: (json['balance_total'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'periodo': periodo,
      'categorias': categorias.map((c) => c.toJson()).toList(),
      'total_ingresos': totalIngresos,
      'total_egresos': totalEgresos,
      'balance_total': balanceTotal,
    };
  }
}

class BiCategoriaFinanciera {
  final String nombre;
  final double monto;
  final String tipo; // 'ingreso' o 'egreso'
  final double porcentaje;
  final String color;

  BiCategoriaFinanciera({
    required this.nombre,
    required this.monto,
    required this.tipo,
    required this.porcentaje,
    required this.color,
  });

  factory BiCategoriaFinanciera.fromJson(Map<String, dynamic> json) {
    return BiCategoriaFinanciera(
      nombre: json['nombre'] ?? '',
      monto: (json['monto'] ?? 0.0).toDouble(),
      tipo: json['tipo'] ?? 'ingreso',
      porcentaje: (json['porcentaje'] ?? 0.0).toDouble(),
      color: json['color'] ?? '#2196F3',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'monto': monto,
      'tipo': tipo,
      'porcentaje': porcentaje,
      'color': color,
    };
  }

  // Getters para UI
  String get montoFormatted => 'Bs. ${monto.toStringAsFixed(0)}';
  String get porcentajeFormatted => '${porcentaje.toStringAsFixed(1)}%';

  bool get esIngreso => tipo.toLowerCase() == 'ingreso';
  bool get esEgreso => tipo.toLowerCase() == 'egreso';
}
