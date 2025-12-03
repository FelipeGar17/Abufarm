// lib/core/constants/app_theme.dart

import 'package:flutter/material.dart';
import 'colors.dart'; // Archivo que crearemos después

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.verdePasto,
      colorScheme: ColorScheme.light(
        primary: AppColors.verdePasto,
        secondary: AppColors.naranjaYema,
        error: AppColors.rojoCresta,
      ),
      scaffoldBackgroundColor: AppColors.blancoHueso,
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.verdePasto,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25)),
        buttonColor: AppColors.naranjaYema,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.naranjaYema,
          foregroundColor: AppColors.verdeOscuro,
          minimumSize: Size(120, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25)),
          textStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.verdeOscuro,
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.verdeOscuro,
        ),
        bodyLarge: TextStyle(
          fontSize: 20,
          color: AppColors.verdeOscuro,
        ),
        bodyMedium: TextStyle(
          fontSize: 18,
          color: AppColors.verdeOscuro,
        ),
        labelLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grisPluma),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grisPluma),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.verdePasto, width: 2),
        ),
        labelStyle: TextStyle(
          color: AppColors.cafeTierra,
          fontSize: 18,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
    );
  }
}