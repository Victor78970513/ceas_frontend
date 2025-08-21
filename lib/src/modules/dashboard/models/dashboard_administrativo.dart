import 'package:flutter/material.dart';

class DashboardAdministrativo {
  final String periodo;
  final MetricasFinancieras metricasFinancieras;
  final MetricasAdministrativas metricasAdministrativas;
  final List<TopClub> topClubes;
  final List<TopSocio> topSocios;
  final List<DistribucionIngreso> distribucionIngresos;
  final List<DistribucionEgreso> distribucionEgresos;
  final List<KpiPrincipal> kpisPrincipales;
  final Map<String, TendenciaMensual> tendenciasMensuales;
  final List<String> alertasCriticas;

  DashboardAdministrativo({
    required this.periodo,
    required this.metricasFinancieras,
    required this.metricasAdministrativas,
    required this.topClubes,
    required this.topSocios,
    required this.distribucionIngresos,
    required this.distribucionEgresos,
    required this.kpisPrincipales,
    required this.tendenciasMensuales,
    required this.alertasCriticas,
  });

  factory DashboardAdministrativo.fromJson(Map<String, dynamic> json) {
    return DashboardAdministrativo(
      periodo: json['periodo'],
      metricasFinancieras:
          MetricasFinancieras.fromJson(json['metricas_financieras']),
      metricasAdministrativas:
          MetricasAdministrativas.fromJson(json['metricas_administrativas']),
      topClubes:
          (json['top_clubes'] as List).map((e) => TopClub.fromJson(e)).toList(),
      topSocios: (json['top_socios'] as List)
          .map((e) => TopSocio.fromJson(e))
          .toList(),
      distribucionIngresos: (json['distribucion_ingresos'] as List)
          .map((e) => DistribucionIngreso.fromJson(e))
          .toList(),
      distribucionEgresos: (json['distribucion_egresos'] as List)
          .map((e) => DistribucionEgreso.fromJson(e))
          .toList(),
      kpisPrincipales: (json['kpis_principales'] as List)
          .map((e) => KpiPrincipal.fromJson(e))
          .toList(),
      tendenciasMensuales: Map.fromEntries(
        (json['tendencias_mensuales'] as Map<String, dynamic>).entries.map(
              (e) => MapEntry(e.key, TendenciaMensual.fromJson(e.value)),
            ),
      ),
      alertasCriticas: List<String>.from(json['alertas_criticas']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'periodo': periodo,
      'metricas_financieras': metricasFinancieras.toJson(),
      'metricas_administrativas': metricasAdministrativas.toJson(),
      'top_clubes': topClubes.map((e) => e.toJson()).toList(),
      'top_socios': topSocios.map((e) => e.toJson()).toList(),
      'distribucion_ingresos':
          distribucionIngresos.map((e) => e.toJson()).toList(),
      'distribucion_egresos':
          distribucionEgresos.map((e) => e.toJson()).toList(),
      'kpis_principales': kpisPrincipales.map((e) => e.toJson()).toList(),
      'tendencias_mensuales': tendenciasMensuales
          .map((key, value) => MapEntry(key, value.toJson())),
      'alertas_criticas': alertasCriticas,
    };
  }
}

class MetricasFinancieras {
  final String ingresosTotales;
  final String egresosTotales;
  final String balanceNeto;
  final double margenRentabilidad;
  final String flujoCaja;
  final String proyeccionMensual;

  MetricasFinancieras({
    required this.ingresosTotales,
    required this.egresosTotales,
    required this.balanceNeto,
    required this.margenRentabilidad,
    required this.flujoCaja,
    required this.proyeccionMensual,
  });

  factory MetricasFinancieras.fromJson(Map<String, dynamic> json) {
    return MetricasFinancieras(
      ingresosTotales: json['ingresos_totales'],
      egresosTotales: json['egresos_totales'],
      balanceNeto: json['balance_neto'],
      margenRentabilidad: json['margen_rentabilidad'].toDouble(),
      flujoCaja: json['flujo_caja'],
      proyeccionMensual: json['proyeccion_mensual'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ingresos_totales': ingresosTotales,
      'egresos_totales': egresosTotales,
      'balance_neto': balanceNeto,
      'margen_rentabilidad': margenRentabilidad,
      'flujo_caja': flujoCaja,
      'proyeccion_mensual': proyeccionMensual,
    };
  }

  // Getters para formateo
  String get ingresosFormatted => 'Bs. ${ingresosTotales}';
  String get egresosFormatted => 'Bs. ${egresosTotales}';
  String get balanceFormatted => 'Bs. ${balanceNeto}';
  String get flujoCajaFormatted => 'Bs. ${flujoCaja}';
  String get proyeccionFormatted => 'Bs. ${proyeccionMensual}';
  String get margenFormatted => '${margenRentabilidad.toStringAsFixed(1)}%';

  Color get balanceColor =>
      double.parse(balanceNeto) >= 0 ? Colors.green : Colors.red;
  Color get margenColor => margenRentabilidad >= 5
      ? Colors.green
      : margenRentabilidad >= 0
          ? Colors.orange
          : Colors.red;
}

class MetricasAdministrativas {
  final int totalSocios;
  final int sociosActivos;
  final int sociosInactivos;
  final double tasaRetencion;
  final double crecimientoMensual;
  final double eficienciaOperativa;

  MetricasAdministrativas({
    required this.totalSocios,
    required this.sociosActivos,
    required this.sociosInactivos,
    required this.tasaRetencion,
    required this.crecimientoMensual,
    required this.eficienciaOperativa,
  });

  factory MetricasAdministrativas.fromJson(Map<String, dynamic> json) {
    return MetricasAdministrativas(
      totalSocios: json['total_socios'],
      sociosActivos: json['socios_activos'],
      sociosInactivos: json['socios_inactivos'],
      tasaRetencion: json['tasa_retencion'].toDouble(),
      crecimientoMensual: json['crecimiento_mensual'].toDouble(),
      eficienciaOperativa: json['eficiencia_operativa'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_socios': totalSocios,
      'socios_activos': sociosActivos,
      'socios_inactivos': sociosInactivos,
      'tasa_retencion': tasaRetencion,
      'crecimiento_mensual': crecimientoMensual,
      'eficiencia_operativa': eficienciaOperativa,
    };
  }

  // Getters para formateo
  String get tasaRetencionFormatted => '${tasaRetencion.toStringAsFixed(1)}%';
  String get crecimientoFormatted =>
      '${crecimientoMensual.toStringAsFixed(1)}%';
  String get eficienciaFormatted =>
      '${eficienciaOperativa.toStringAsFixed(1)}%';

  Color get tasaRetencionColor => tasaRetencion >= 80
      ? Colors.green
      : tasaRetencion >= 60
          ? Colors.orange
          : Colors.red;
  Color get crecimientoColor =>
      crecimientoMensual >= 0 ? Colors.green : Colors.red;
  Color get eficienciaColor => eficienciaOperativa >= 80
      ? Colors.green
      : eficienciaOperativa >= 60
          ? Colors.orange
          : Colors.red;
}

class TopClub {
  final int idClub;
  final String nombreClub;
  final String ingresos;
  final String egresos;
  final String balance;
  final double rentabilidad;
  final int sociosActivos;
  final int accionesVendidas;

  TopClub({
    required this.idClub,
    required this.nombreClub,
    required this.ingresos,
    required this.egresos,
    required this.balance,
    required this.rentabilidad,
    required this.sociosActivos,
    required this.accionesVendidas,
  });

  factory TopClub.fromJson(Map<String, dynamic> json) {
    return TopClub(
      idClub: json['id_club'],
      nombreClub: json['nombre_club'],
      ingresos: json['ingresos'],
      egresos: json['egresos'],
      balance: json['balance'],
      rentabilidad: json['rentabilidad'].toDouble(),
      sociosActivos: json['socios_activos'],
      accionesVendidas: json['acciones_vendidas'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_club': idClub,
      'nombre_club': nombreClub,
      'ingresos': ingresos,
      'egresos': egresos,
      'balance': balance,
      'rentabilidad': rentabilidad,
      'socios_activos': sociosActivos,
      'acciones_vendidas': accionesVendidas,
    };
  }

  // Getters para formateo
  String get ingresosFormatted => 'Bs. ${ingresos}';
  String get egresosFormatted => 'Bs. ${egresos}';
  String get balanceFormatted => 'Bs. ${balance}';
  String get rentabilidadFormatted => '${rentabilidad.toStringAsFixed(1)}%';

  Color get balanceColor =>
      double.parse(balance) >= 0 ? Colors.green : Colors.red;
  Color get rentabilidadColor => rentabilidad >= 10
      ? Colors.green
      : rentabilidad >= 0
          ? Colors.orange
          : Colors.red;
}

class TopSocio {
  final int idSocio;
  final String nombreCompleto;
  final String clubPrincipal;
  final int accionesCompradas;
  final String totalInvertido;
  final String estadoPagos;
  final int antiguedadMeses;

  TopSocio({
    required this.idSocio,
    required this.nombreCompleto,
    required this.clubPrincipal,
    required this.accionesCompradas,
    required this.totalInvertido,
    required this.estadoPagos,
    required this.antiguedadMeses,
  });

  factory TopSocio.fromJson(Map<String, dynamic> json) {
    return TopSocio(
      idSocio: json['id_socio'],
      nombreCompleto: json['nombre_completo'],
      clubPrincipal: json['club_principal'],
      accionesCompradas: json['acciones_compradas'],
      totalInvertido: json['total_invertido'],
      estadoPagos: json['estado_pagos'],
      antiguedadMeses: json['antiguedad_meses'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_socio': idSocio,
      'nombre_completo': nombreCompleto,
      'club_principal': clubPrincipal,
      'acciones_compradas': accionesCompradas,
      'total_invertido': totalInvertido,
      'estado_pagos': estadoPagos,
      'antiguedad_meses': antiguedadMeses,
    };
  }

  // Getters para formateo
  String get totalInvertidoFormatted => 'Bs. ${totalInvertido}';
  String get antiguedadFormatted => '$antiguedadMeses meses';

  Color get estadoPagosColor {
    switch (estadoPagos) {
      case 'COMPLETAMENTE_PAGADO':
        return Colors.green;
      case 'PAGOS_PENDIENTES':
        return Colors.orange;
      case 'SIN_PAGOS':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String get estadoPagosDisplay {
    switch (estadoPagos) {
      case 'COMPLETAMENTE_PAGADO':
        return 'Pagado';
      case 'PAGOS_PENDIENTES':
        return 'Pendiente';
      case 'SIN_PAGOS':
        return 'Sin pagos';
      default:
        return estadoPagos;
    }
  }
}

class DistribucionIngreso {
  final String categoria;
  final String monto;
  final double porcentaje;
  final String tendencia;

  DistribucionIngreso({
    required this.categoria,
    required this.monto,
    required this.porcentaje,
    required this.tendencia,
  });

  factory DistribucionIngreso.fromJson(Map<String, dynamic> json) {
    return DistribucionIngreso(
      categoria: json['categoria'],
      monto: json['monto'],
      porcentaje: json['porcentaje'].toDouble(),
      tendencia: json['tendencia'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoria': categoria,
      'monto': monto,
      'porcentaje': porcentaje,
      'tendencia': tendencia,
    };
  }

  // Getters para formateo
  String get montoFormatted => 'Bs. ${monto}';
  String get porcentajeFormatted => '${porcentaje.toStringAsFixed(1)}%';

  Color get tendenciaColor {
    switch (tendencia.toLowerCase()) {
      case 'creciente':
        return Colors.green;
      case 'decreciente':
        return Colors.red;
      case 'estable':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData get tendenciaIcon {
    switch (tendencia.toLowerCase()) {
      case 'creciente':
        return Icons.trending_up;
      case 'decreciente':
        return Icons.trending_down;
      case 'estable':
        return Icons.trending_flat;
      default:
        return Icons.help_outline;
    }
  }
}

class DistribucionEgreso {
  final String categoria;
  final String monto;
  final double porcentaje;
  final String tendencia;

  DistribucionEgreso({
    required this.categoria,
    required this.monto,
    required this.porcentaje,
    required this.tendencia,
  });

  factory DistribucionEgreso.fromJson(Map<String, dynamic> json) {
    return DistribucionEgreso(
      categoria: json['categoria'],
      monto: json['monto'],
      porcentaje: json['porcentaje'].toDouble(),
      tendencia: json['tendencia'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoria': categoria,
      'monto': monto,
      'porcentaje': porcentaje,
      'tendencia': tendencia,
    };
  }

  // Getters para formateo
  String get montoFormatted => 'Bs. ${monto}';
  String get porcentajeFormatted => '${porcentaje.toStringAsFixed(1)}%';

  Color get tendenciaColor {
    switch (tendencia.toLowerCase()) {
      case 'creciente':
        return Colors.red;
      case 'decreciente':
        return Colors.green;
      case 'estable':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData get tendenciaIcon {
    switch (tendencia.toLowerCase()) {
      case 'creciente':
        return Icons.trending_up;
      case 'decreciente':
        return Icons.trending_down;
      case 'estable':
        return Icons.trending_flat;
      default:
        return Icons.help_outline;
    }
  }
}

class KpiPrincipal {
  final String nombre;
  final double valorActual;
  final double valorAnterior;
  final double cambioPorcentual;
  final double meta;
  final String estado;

  KpiPrincipal({
    required this.nombre,
    required this.valorActual,
    required this.valorAnterior,
    required this.cambioPorcentual,
    required this.meta,
    required this.estado,
  });

  factory KpiPrincipal.fromJson(Map<String, dynamic> json) {
    return KpiPrincipal(
      nombre: json['nombre'],
      valorActual: json['valor_actual'].toDouble(),
      valorAnterior: json['valor_anterior'].toDouble(),
      cambioPorcentual: json['cambio_porcentual'].toDouble(),
      meta: json['meta'].toDouble(),
      estado: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'valor_actual': valorActual,
      'valor_anterior': valorAnterior,
      'cambio_porcentual': cambioPorcentual,
      'meta': meta,
      'estado': estado,
    };
  }

  // Getters para formateo
  String get valorActualFormatted => valorActual.toStringAsFixed(1);
  String get cambioFormatted =>
      '${cambioPorcentual >= 0 ? '+' : ''}${cambioPorcentual.toStringAsFixed(1)}%';
  String get metaFormatted => meta.toStringAsFixed(1);

  Color get estadoColor {
    switch (estado.toLowerCase()) {
      case 'excelente':
        return Colors.green;
      case 'bueno':
        return Colors.blue;
      case 'regular':
        return Colors.orange;
      case 'malo':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color get cambioColor => cambioPorcentual >= 0 ? Colors.green : Colors.red;
  IconData get cambioIcon =>
      cambioPorcentual >= 0 ? Icons.trending_up : Icons.trending_down;
}

class TendenciaMensual {
  final String periodo;
  final double valor;
  final double cambioAnterior;
  final double proyeccion;

  TendenciaMensual({
    required this.periodo,
    required this.valor,
    required this.cambioAnterior,
    required this.proyeccion,
  });

  factory TendenciaMensual.fromJson(Map<String, dynamic> json) {
    return TendenciaMensual(
      periodo: json['periodo'],
      valor: json['valor'].toDouble(),
      cambioAnterior: json['cambio_anterior'].toDouble(),
      proyeccion: json['proyeccion'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'periodo': periodo,
      'valor': valor,
      'cambio_anterior': cambioAnterior,
      'proyeccion': proyeccion,
    };
  }

  // Getters para formateo
  String get valorFormatted => 'Bs. ${valor.toStringAsFixed(0)}';
  String get cambioFormatted => 'Bs. ${cambioAnterior.toStringAsFixed(0)}';
  String get proyeccionFormatted => 'Bs. ${proyeccion.toStringAsFixed(0)}';

  double get variacionPorcentual =>
      ((valor - cambioAnterior) / cambioAnterior) * 100;
  String get variacionFormatted =>
      '${variacionPorcentual >= 0 ? '+' : ''}${variacionPorcentual.toStringAsFixed(1)}%';
  Color get variacionColor =>
      variacionPorcentual >= 0 ? Colors.green : Colors.red;
}

