// lib/app/app.dart

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:abufarm/app/routes/app_routes.dart';
import 'package:abufarm/app/routes/route_generator.dart';
import 'package:abufarm/features/dashboard/screens/dashboard_screen.dart';

class GranjaApp extends StatelessWidget {
  const GranjaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        // Limita el textScaleFactor a 1.2 como máximo
        final cappedTextScale = mediaQuery.textScaleFactor.clamp(1.0, 1.2);

        return MediaQuery(
          data: mediaQuery.copyWith(textScaleFactor: cappedTextScale),
          child: MaterialApp(
            title: 'AbuFarm',
            theme: ThemeData(
              primarySwatch: Colors.green,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
            ),
            home: const DashboardScreen(),
            onGenerateRoute: RouteGenerator.generateRoute,
          ),
        );
      },
    );
  }
}