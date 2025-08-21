class FinanzasResumen {
  final String periodo;
  final MetricasGenerales metricasGenerales;
  final Map<String, DistribucionClub> distribucionPorClub;
  final TopCategorias topCategorias;

  FinanzasResumen({
    required this.periodo,
    required this.metricasGenerales,
    required this.distribucionPorClub,
    required this.topCategorias,
  });

  factory FinanzasResumen.fromJson(Map<String, dynamic> json) {
    return FinanzasResumen(
      periodo: json['periodo'],
      metricasGenerales: MetricasGenerales.fromJson(json['metricas_generales']),
      distribucionPorClub:
          (json['distribucion_por_club'] as Map<String, dynamic>)
              .map((key, value) => MapEntry(
                    key,
                    DistribucionClub.fromJson(value),
                  )),
      topCategorias: TopCategorias.fromJson(json['top_categorias']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'periodo': periodo,
      'metricas_generales': metricasGenerales.toJson(),
      'distribucion_por_club': distribucionPorClub
          .map((key, value) => MapEntry(key, value.toJson())),
      'top_categorias': topCategorias.toJson(),
    };
  }

  // Getters útiles para la UI
  double get balance => metricasGenerales.balance;
  double get ingresos => metricasGenerales.ingresos;
  double get egresos => metricasGenerales.egresos;
  int get movimientos => metricasGenerales.movimientos;

  // Formato del período para la UI
  String get periodoDisplay {
    final meses = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];

    final partes = periodo.split('-');
    if (partes.length == 2) {
      final mes = int.tryParse(partes[1]);
      if (mes != null && mes >= 1 && mes <= 12) {
        return '${meses[mes - 1]} ${partes[0]}';
      }
    }
    return periodo;
  }
}

class MetricasGenerales {
  final double ingresos;
  final double egresos;
  final double balance;
  final int movimientos;

  MetricasGenerales({
    required this.ingresos,
    required this.egresos,
    required this.balance,
    required this.movimientos,
  });

  factory MetricasGenerales.fromJson(Map<String, dynamic> json) {
    return MetricasGenerales(
      ingresos: double.parse(json['ingresos']),
      egresos: double.parse(json['egresos']),
      balance: double.parse(json['balance']),
      movimientos: json['movimientos'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ingresos': ingresos.toString(),
      'egresos': egresos.toString(),
      'balance': balance.toString(),
      'movimientos': movimientos,
    };
  }
}

class DistribucionClub {
  final double ingresos;
  final double egresos;
  final double balance;

  DistribucionClub({
    required this.ingresos,
    required this.egresos,
    required this.balance,
  });

  factory DistribucionClub.fromJson(Map<String, dynamic> json) {
    return DistribucionClub(
      ingresos: double.parse(json['ingresos']),
      egresos: double.parse(json['egresos']),
      balance: double.parse(json['balance']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ingresos': ingresos.toString(),
      'egresos': egresos.toString(),
      'balance': balance.toString(),
    };
  }
}

class TopCategorias {
  final List<CategoriaResumen> ingresos;
  final List<CategoriaResumen> egresos;

  TopCategorias({
    required this.ingresos,
    required this.egresos,
  });

  factory TopCategorias.fromJson(Map<String, dynamic> json) {
    return TopCategorias(
      ingresos: (json['ingresos'] as List)
          .map((e) => CategoriaResumen.fromJson(e))
          .toList(),
      egresos: (json['egresos'] as List)
          .map((e) => CategoriaResumen.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ingresos': ingresos.map((e) => e.toJson()).toList(),
      'egresos': egresos.map((e) => e.toJson()).toList(),
    };
  }
}

class CategoriaResumen {
  final String categoria;
  final double monto;

  CategoriaResumen({
    required this.categoria,
    required this.monto,
  });

  factory CategoriaResumen.fromJson(Map<String, dynamic> json) {
    return CategoriaResumen(
      categoria: json['categoria'],
      monto: double.parse(json['monto']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoria': categoria,
      'monto': monto.toString(),
    };
  }
}

