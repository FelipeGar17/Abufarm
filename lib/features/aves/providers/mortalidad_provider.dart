// lib/features/aves/providers/mortalidad_provider.dart
import 'package:flutter/material.dart';
import 'package:abufarm/core/database/database_helper.dart';
import 'package:abufarm/features/aves/models/mortalidad.dart';

class MortalidadProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> registrarMortalidad(RegistroMortalidad registro) async {
    final db = await _dbHelper.database;
    
    // 1. Registrar la mortalidad
    await db.insert('mortalidad', registro.toMap());
    
    // 2. Actualizar el lote (reducir cantidad)
    await db.rawUpdate('''
      UPDATE lotes 
      SET cantidad_inicial = cantidad_inicial - ? 
      WHERE id = ?
    ''', [registro.cantidad, registro.loteId]);
    
    notifyListeners();
  }

  Future<List<RegistroMortalidad>> getMortalidadMes() async {
    final db = await _dbHelper.database;
    final hoy = DateTime.now();
    final primerDiaMes = DateTime(hoy.year, hoy.month, 1);

    final resultados = await db.query(
      'mortalidad',
      where: 'fecha BETWEEN ? AND ?',
      whereArgs: [
        primerDiaMes.toIso8601String(),
        hoy.toIso8601String(),
      ],
      orderBy: 'fecha DESC',
    );

    return resultados.map((map) => RegistroMortalidad.fromMap(map)).toList();
  }

  Future<int> getTotalMortalidadMes() async {
    final db = await _dbHelper.database;
    final hoy = DateTime.now();
    final primerDiaMes = DateTime(hoy.year, hoy.month, 1);

    final resultado = await db.rawQuery('''
      SELECT SUM(cantidad) as total 
      FROM mortalidad 
      WHERE fecha BETWEEN ? AND ?
    ''', [
      primerDiaMes.toIso8601String(),
      hoy.toIso8601String(),
    ]);

    return resultado.first['total'] as int? ?? 0;
  }
}