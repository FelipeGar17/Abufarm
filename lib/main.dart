// lib/main.dart

import 'package:abufarm/features/aves/providers/mortalidad_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:abufarm/features/aves/providers/aves_provider.dart';
import 'package:abufarm/features/huevos/providers/huevos_provider.dart';
import 'package:abufarm/features/transacciones/providers/transacciones_provider.dart';
import 'package:abufarm/app/routes/route_generator.dart';
import 'package:abufarm/features/dashboard/screens/dashboard_screen.dart';
import 'package:abufarm/core/constants/app_theme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AvesProvider()..loadLotes()),
        ChangeNotifierProvider(create: (_) => HuevosProvider()),
        ChangeNotifierProvider(create: (_) => TransaccionesProvider()),
        ChangeNotifierProvider(create: (_) => MortalidadProvider()),
      ],
      child: const GranjaApp(),
    ),
  );
}

class GranjaApp extends StatelessWidget {
  const GranjaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AbuFarm',
      theme: AppTheme.lightTheme, // Usamos nuestro tema personalizado
      home: const DashboardScreen(),
      onGenerateRoute: RouteGenerator.generateRoute,
      builder: EasyLoading.init(), // <-- ¡Agrega esto!
    );
  }
}
