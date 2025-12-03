// lib/features/transacciones/providers/transacciones_provider.dart
import 'package:flutter/material.dart';
import 'package:abufarm/core/database/database_helper.dart';
import 'package:abufarm/features/transacciones/models/transaccion.dart';

class TransaccionesProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  double totalIngresos = 0.0;
  double totalGastos = 0.0;

  double get balance => totalIngresos - totalGastos;

  Future<void> agregarTransaccion(Transaccion transaccion) async {
    final db = await _dbHelper.database;
    await db.insert(
      transaccion.tipo == 'ingreso' ? 'ingresos' : 'gastos',
      transaccion.toMap(),
    );
    notifyListeners();
  }

  Future<List<Transaccion>> getUltimasTransacciones({int limit = 3}) async {
    final db = await _dbHelper.database;
    
    final ingresos = await db.query('ingresos', 
      orderBy: 'fecha DESC', 
      limit: limit,
    );
    
    final gastos = await db.query('gastos', 
      orderBy: 'fecha DESC', 
      limit: limit,
    );

    final todas = [
      ...ingresos.map((i) => Transaccion.fromMap({...i, 'tipo': 'ingreso'})),
      ...gastos.map((g) => Transaccion.fromMap({...g, 'tipo': 'gasto'})),
    ];

    todas.sort((a, b) => b.fecha.compareTo(a.fecha));
    return todas.take(limit).toList();
  }

  Future<double> getTotalMes(String tipo) async {
    final db = await _dbHelper.database;
    final hoy = DateTime.now();
    final primerDiaMes = DateTime(hoy.year, hoy.month, 1);
    
    final result = await db.rawQuery('''
      SELECT SUM(monto) as total 
      FROM ${tipo == 'ingreso' ? 'ingresos' : 'gastos'}
      WHERE fecha BETWEEN ? AND ?
    ''', [
      primerDiaMes.toIso8601String(),
      hoy.toIso8601String(),
    ]);

    return result.first['total'] as double? ?? 0.0;
  }
  // Añade este método a tu transacciones_provider.dart
Future<List<Transaccion>> getTransaccionesPorFecha(DateTime desde, DateTime hasta) async {
  final db = await _dbHelper.database;
  
  final ingresos = await db.query(
    'ingresos',
    where: 'fecha BETWEEN ? AND ?',
    whereArgs: [
      desde.toIso8601String(),
      hasta.toIso8601String(),
    ],
    orderBy: 'fecha DESC',
  );
  
  final gastos = await db.query(
    'gastos',
    where: 'fecha BETWEEN ? AND ?',
    whereArgs: [
      desde.toIso8601String(),
      hasta.toIso8601String(),
    ],
    orderBy: 'fecha DESC',
  );

  final todas = [
    ...ingresos.map((i) => Transaccion.fromMap({...i, 'tipo': 'ingreso'})),
    ...gastos.map((g) => Transaccion.fromMap({...g, 'tipo': 'gasto'})),
  ];

  todas.sort((a, b) => b.fecha.compareTo(a.fecha));
  return todas;
}

// Total de ingresos del mes actual
Future<double> calcularTotalIngresos() async {
  final db = await _dbHelper.database;
  final hoy = DateTime.now();
  final primerDiaMes = DateTime(hoy.year, hoy.month, 1);

  final result = await db.rawQuery('''
    SELECT SUM(monto) as total 
    FROM ingresos
    WHERE fecha BETWEEN ? AND ?
  ''', [
    primerDiaMes.toIso8601String(),
    hoy.toIso8601String(),
  ]);

  return result.first['total'] as double? ?? 0.0;
}

// Total de gastos del mes actual
Future<double> calcularTotalGastos() async {
  final db = await _dbHelper.database;
  final hoy = DateTime.now();
  final primerDiaMes = DateTime(hoy.year, hoy.month, 1);

  final result = await db.rawQuery('''
    SELECT SUM(monto) as total 
    FROM gastos
    WHERE fecha BETWEEN ? AND ?
  ''', [
    primerDiaMes.toIso8601String(),
    hoy.toIso8601String(),
  ]);

  return result.first['total'] as double? ?? 0.0;
}
}