// lib/app/routes/route_generator.dart

import 'package:abufarm/features/aves/screens/edit_lote_screen.dart';
import 'package:abufarm/features/aves/screens/list_lotes_screen.dart';
import 'package:abufarm/features/aves/screens/registrar_mortalidad_screen.dart';
import 'package:abufarm/features/transacciones/screens/agregar_transaccion.dart';
import 'package:abufarm/features/transacciones/screens/historial_screen.dart';
import 'package:flutter/material.dart';
import 'package:abufarm/app/routes/app_routes.dart';
import 'package:abufarm/features/dashboard/screens/dashboard_screen.dart';
import 'package:abufarm/features/aves/screens/add_lote_screen.dart';
import 'package:abufarm/features/huevos/screens/huevos_screen.dart';
import 'package:abufarm/features/transacciones/screens/transacciones_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.dashboard:
        return _fadeRoute(const DashboardScreen(), settings);
      case AppRoutes.addLote:
        return _fadeRoute(const AddLoteScreen(), settings);
      case AppRoutes.listLotes:
        return _fadeRoute(const ListLotesScreen(), settings);
      case AppRoutes.editLote:
        final loteId = settings.arguments as int;
        return _fadeRoute(EditLoteScreen(loteId: loteId), settings);
      case AppRoutes.registroHuevos:
        return _fadeRoute(const HuevosScreen(), settings);
      case AppRoutes.agregarIngreso:
        return _fadeRoute(
          const AgregarTransaccionScreen(esIngreso: true),
          settings,
        );
      case AppRoutes.agregarGasto:
        return _fadeRoute(
          const AgregarTransaccionScreen(esIngreso: false),
          settings,
        );
      case AppRoutes.ventas:
        return _fadeRoute(const TransaccionesScreen(), settings);
      case AppRoutes.historialTransacciones:
        return MaterialPageRoute(builder: (_) => const HistorialScreen());
      case AppRoutes.registrarMortalidad:
        return MaterialPageRoute(
          builder: (_) => const RegistrarMortalidadScreen(),
        );
      // Agrega aquí más rutas según las vayas creando
      default:
        return _errorRoute();
    }
  }

  static PageRoute _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('Página no encontrada')),
        );
      },
    );
  }
}
