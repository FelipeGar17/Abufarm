// lib/core/widgets/custom_bottom_nav.dart

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/colors.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) async {
        if (index != currentIndex) {
          EasyLoading.show(status: 'Cargando...');
          await Future.delayed(const Duration(milliseconds: 300));
          // Limpia el stack y navega a la nueva ruta
          final routes = [
            '/',         
            '/produccion/huevos',
            '/aves/lotes',
            '/finanzas/ventas',   
          ];
          Navigator.pushNamedAndRemoveUntil(
            context,
            routes[index],
            (route) => false,
          );
          // El loader se debe ocultar en la pantalla destino
        }
      },
      backgroundColor: AppColors.verdePasto,
      selectedItemColor: AppColors.amarilloPollito,
      unselectedItemColor: Colors.white.withOpacity(0.7),
      selectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(fontSize: 13),
      selectedIconTheme: IconThemeData(
        size: 30,
        color: AppColors.amarilloPollito,
      ),
      unselectedIconTheme: const IconThemeData(size: 28, color: Colors.white70),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 10,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 30),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.egg, size: 30),
          label: 'Huevos',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.feather ,
            size: 30,
          ), // o FontAwesomeIcons.feather, FontAwesomeIcons.dove, FontAwesomeIcons.kiwiBird
          label: 'Aves',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.attach_money, size: 30),
          label: 'transacciones',
        ),
      ],
    );
  }
}
