// lib/features/aves/providers/aves_provider.dart

import 'package:flutter/material.dart';
import 'package:abufarm/core/database/database_helper.dart';
import 'package:abufarm/features/aves/models/lote.dart';

class AvesProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<Lote> _lotes = [];
  List<Lote> get lotes => _lotes;

  Future<void> loadLotes() async {
    final db = await _dbHelper.database;
    final maps = await db.query('lotes');
    
    _lotes = maps.map((map) => Lote.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addLote(Lote lote) async {
    final db = await _dbHelper.database;
    final id = await db.insert('lotes', lote.toMap());
    
    _lotes.add(Lote(
      id: id,
      tipo: lote.tipo,
      cantidadInicial: lote.cantidadInicial,
      fechaCreacion: lote.fechaCreacion,
      proveedor: lote.proveedor,
      alimentoTipo: lote.alimentoTipo,
      observaciones: lote.observaciones,
      edadInicial: lote.edadInicial,
    ));
    notifyListeners();
  }

  Future<void> deleteLote(int id) async {
    final db = await _dbHelper.database;
    await db.delete('lotes', where: 'id = ?', whereArgs: [id]);
    
    _lotes.removeWhere((lote) => lote.id == id);
    notifyListeners();
  }

  Future<void> actualizarLote(
    int id, {
    required int cantidad,
    required String tipo,
    String? proveedor,
    String? alimentoTipo,
    String? observaciones,
  }) async {
    final db = await _dbHelper.database;
    await db.update(
      'lotes',
      {
        'cantidad_inicial': cantidad,
        'tipo': tipo,
        'proveedor': proveedor,
        'alimento_tipo': alimentoTipo,
        'observaciones': observaciones,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    await loadLotes(); // Refrescar datos
  }

  Lote getLoteById(int id) {
    return _lotes.firstWhere((lote) => lote.id == id);
  }
}