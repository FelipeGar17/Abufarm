# 🐔 AbuFarm - Sistema de Gestión de Granja Avícola

<div align="center">
  <img src="assets\image\Logoapk.png" alt="Dashboard" width="200"/>
</div>

Sistema completo de gestión para granjas avícolas desarrollado en Flutter. Permite administrar lotes de aves, registrar producción de huevos, controlar mortalidad y gestionar transacciones financieras.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-07405E?style=for-the-badge&logo=sqlite&logoColor=white)

## 📱 Características Principales

### Gestión de Lotes de Aves
- ✅ Crear, editar y eliminar lotes
- 📊 Clasificación automática (pollitos, ponedoras, engorde)
- 📅 Seguimiento de edad y fecha de adquisición
- 🔄 Reclasificación de lotes
- 🗑️ Eliminación automática de lotes con 0 aves

### Registro de Producción
- 🥚 Registro diario de huevos
- 📈 Estadísticas de producción
- 💹 Visualización de tendencias

### Control de Mortalidad
- 📝 Registro de bajas con causa y observaciones
- 📊 Estadísticas mensuales
- 🚨 Alertas de mortalidad elevada

### Gestión Financiera
- 💰 Registro de ingresos y gastos
- 📊 Balance mensual automático
- 📈 Visualización de ganancias/pérdidas

### Dashboard Integral
- 📊 Resumen de todos los indicadores
- 🔄 Actualización en tiempo real
- 📱 Navegación intuitiva

## 📸 Capturas de Pantalla

<div align="center">
  <table>
    <tr>
      <td><img src="assets\screenshots\dashboard.jpg" alt="Dashboard" width="300"/></td>
      <td><img src="assets\screenshots\huevos.jpg" alt="Gestión de Lotes" width="300"/></td>
    </tr>
    <tr>
      <td><img src="assets\screenshots\lotes.jpg" alt="Registro de Huevos" width="300"/></td>
      <td><img src="assets\screenshots\transacciones.jpg" alt="Transacciones" width="300"/></td>
    </tr>
  </table>
</div>

## 🚀 Instalación

### Requisitos Previos
- Flutter SDK (>=3.7.2)
- Android Studio o VS Code
- Git

### Pasos de Instalación

1. **Clonar el repositorio**
```bash
git clone https://github.com/TU_USUARIO/abufarm.git
cd abufarm
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Generar iconos y splash screen**
```bash
flutter pub run flutter_launcher_icons:main
flutter pub run flutter_native_splash:create
```

4. **Ejecutar la aplicación**
```bash
flutter run
```

5. **Generar APK**
```bash
flutter build apk
```

## 📦 Dependencias Principales

```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.0.0          # Base de datos local
  provider: ^6.1.5          # Gestión de estado
  intl: ^0.17.0            # Internacionalización
  fl_chart: ^1.0.0         # Gráficos
  flutter_easyloading: ^3.0.5  # Indicadores de carga
```

## 🏗️ Arquitectura del Proyecto

```
lib/
├── app/
│   └── routes/           # Rutas de navegación
├── core/
│   ├── constants/        # Constantes y colores
│   ├── database/         # SQLite helpers
│   └── widgets/          # Widgets reutilizables
├── features/
│   ├── aves/            # Gestión de lotes
│   ├── dashboard/       # Pantalla principal
│   ├── huevos/          # Producción de huevos
│   ├── transacciones/   # Finanzas
│   └── ventas/          # Ventas
└── main.dart
```

## 🎨 Capturas de Pantalla

*(Agrega aquí capturas de tu app)*

## 📝 Uso

### Crear un Nuevo Lote
1. Navegar a "Lotes" desde el dashboard
2. Presionar el botón "+"
3. Completar información del lote
4. Guardar

### Registrar Producción Diaria
1. Ir a "Huevos" desde el menú inferior
2. Presionar "+" para agregar huevos
3. Ingresar cantidad del día

### Registrar Mortalidad
1. Acceder a "Mortalidad" desde el dashboard
2. Seleccionar lote afectado
3. Ingresar cantidad, causa y observaciones

## 🔄 Actualizaciones Recientes

- ✅ Campo de edad inicial para lotes
- ✅ Cálculo automático de edad actual
- ✅ Eliminación automática de lotes vacíos
- ✅ Opción de eliminar lotes manualmente
- ✅ Mejoras en UI/UX

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request


## 🙏 Agradecimientos

- Diseñado para gestión eficiente de granjas avícolas
- Desarrollado con Flutter y ❤️

---

⭐ Si te gusta este proyecto, dale una estrella en GitHub!