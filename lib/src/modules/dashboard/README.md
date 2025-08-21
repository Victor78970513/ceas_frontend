# Dashboard Administrativo - CEAS

## Descripción

El Dashboard Administrativo es una pantalla completa de Business Intelligence que muestra métricas financieras, administrativas y operativas en tiempo real desde el backend.

## Características

### 🎯 **Métricas Principales**
- **Financieras**: Ingresos, Egresos, Balance Neto, Margen de Rentabilidad
- **Administrativas**: Total Socios, Socios Activos, Tasa de Retención, Eficiencia Operativa

### 📊 **KPIs Principales**
- Tasa de Conversión de Socios
- Rentabilidad por Club
- Eficiencia Operativa
- Comparación con metas y períodos anteriores

### 📈 **Distribuciones**
- **Ingresos**: Por categoría (Donaciones, Cuotas, Otros)
- **Egresos**: Por categoría (Compras, Servicios)
- Tendencias y porcentajes de cada categoría

### 🏆 **Top Rankings**
- **Clubes**: Por rentabilidad, ingresos y socios activos
- **Socios**: Por inversión, estado de pagos y antigüedad

### ⚠️ **Alertas Críticas**
- Socios inactivos
- Pagos pendientes
- Notificaciones importantes del sistema

### 📅 **Tendencias Mensuales**
- Proyecciones financieras
- Comparación con períodos anteriores
- Variaciones porcentuales

## Arquitectura

### 📁 **Estructura de Archivos**
```
lib/src/modules/dashboard/
├── models/
│   └── dashboard_administrativo.dart      # Modelos de datos
├── services/
│   └── dashboard_service.dart             # Llamadas al backend
├── providers/
│   └── dashboard_provider.dart            # Estado y lógica de negocio
└── screens/
    └── dashboard_administrativo_screen.dart # UI principal
```

### 🔄 **Flujo de Datos**
1. **DashboardService** → Llama al endpoint `GET /bi/administrativo/dashboard`
2. **DashboardProvider** → Maneja el estado y notifica cambios
3. **DashboardAdministrativoScreen** → Renderiza la UI con datos del provider

## Uso

### 🔌 **Registro del Provider**
```dart
// En main.dart
ChangeNotifierProvider(create: (_) => DashboardProvider()),
```

### 📱 **Navegación**
```dart
// Navegar al dashboard
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => const DashboardAdministrativoScreen(),
  ),
);
```

### 🔄 **Carga de Datos**
```dart
// Cargar datos manualmente
final dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
await dashboardProvider.loadDashboard(token);

// Refrescar datos
await dashboardProvider.refresh(token);
```

## Endpoint del Backend

### 🌐 **URL**
```
GET http://localhost:8000/bi/administrativo/dashboard
```

### 🔐 **Headers**
```
Authorization: Bearer {token}
Content-Type: application/json
```

### 📊 **Respuesta**
```json
{
  "periodo": "2025-08",
  "metricas_financieras": { ... },
  "metricas_administrativas": { ... },
  "top_clubes": [ ... ],
  "top_socios": [ ... ],
  "distribucion_ingresos": [ ... ],
  "distribucion_egresos": [ ... ],
  "kpis_principales": [ ... ],
  "tendencias_mensuales": { ... },
  "alertas_criticas": [ ... ]
}
```

## Características de UI/UX

### 🎨 **Diseño Visual**
- **Header**: SliverAppBar con gradiente azul y elementos decorativos
- **Cards**: Sombras suaves, bordes redondeados, colores semánticos
- **Responsive**: Adaptable a diferentes tamaños de pantalla
- **Colores**: Sistema de colores coherente con el tema CEAS

### 📱 **Interactividad**
- **Pull to Refresh**: Actualización manual de datos
- **Estados Visuales**: Loading, error, datos cargados
- **Hover Effects**: Feedback visual en elementos interactivos
- **Navegación Fluida**: Transiciones suaves entre secciones

### 🔍 **Accesibilidad**
- **Iconos Semánticos**: Cada métrica tiene su icono representativo
- **Colores Significativos**: Verde para positivo, rojo para negativo
- **Texto Descriptivo**: Labels claros y explicativos
- **Contraste Adecuado**: Legibilidad optimizada

## Personalización

### 🎯 **Modificar Métricas**
```dart
// En dashboard_administrativo_screen.dart
Widget _buildMetricasPrincipales(DashboardProvider provider) {
  // Personalizar qué métricas mostrar
  // Cambiar colores, iconos o layout
}
```

### 🎨 **Cambiar Colores**
```dart
// En ceas_colors.dart
class CeasColors {
  static const Color primaryBlue = Color(0xFF1E40AF);
  static const Color successGreen = Color(0xFF059669);
  static const Color warningOrange = Color(0xFFD97706);
  static const Color dangerRed = Color(0xFFDC2626);
}
```

### 📊 **Agregar Nuevas Secciones**
```dart
// Agregar nueva sección en el build method
Widget _buildNuevaSeccion(DashboardProvider provider) {
  return Container(
    // Implementar nueva funcionalidad
  );
}
```

## Mantenimiento

### 🐛 **Debugging**
- Logs detallados en consola para cada operación
- Estados de carga y error claramente visibles
- Manejo de excepciones robusto

### 📈 **Performance**
- Lazy loading de datos
- Caching en el provider
- Actualización eficiente de UI

### 🔒 **Seguridad**
- Validación de token en cada llamada
- Manejo seguro de errores HTTP
- Timeout en llamadas al backend

## Contribución

### 📝 **Convenciones de Código**
- Nombres descriptivos para métodos y variables
- Comentarios en español para consistencia
- Separación clara de responsabilidades
- Uso de const donde sea posible

### 🧪 **Testing**
- Verificar que todos los modelos se parseen correctamente
- Probar estados de carga y error
- Validar responsive design en diferentes pantallas
- Comprobar integración con el backend

---

**Desarrollado con ❤️ para CEAS**

