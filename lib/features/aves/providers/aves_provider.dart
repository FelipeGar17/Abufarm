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

  Future<void> eliminarLote(int id) async {
    final db = await _dbHelper.database;
    
    // Eliminar de la base de datos
    await db.delete('lotes', where: 'id = ?', whereArgs: [id]);
    
    // Eliminar de la lista en memoria
    _lotes.removeWhere((lote) => lote.id == id);
    
    notifyListeners();
  }

  // Método para verificar y eliminar automáticamente lotes con 0 aves
  Future<void> verificarYEliminarLotesVacios() async {
    final lotesVacios = _lotes.where((lote) => lote.cantidadInicial == 0).toList();
    
    for (var lote in lotesVacios) {
      if (lote.id != null) {
        await eliminarLote(lote.id!);
      }
    }
  }

  Future<void> actualizarLote(
    int id, {
    required int cantidad,
    required String tipo,
    String? proveedor,
    String? alimentoTipo,
    String? observaciones,
    int? edadInicial,
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
        'edad_inicial': edadInicial,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    
    await loadLotes(); // Refrescar datos
    
    // Si la cantidad es 0, eliminar el lote automáticamente
    if (cantidad == 0) {
      await eliminarLote(id);
      // Mostrar notificación (opcional, puedes hacerlo en el UI)
    }
  }

  Lote getLoteById(int id) {
    return _lotes.firstWhere((lote) => lote.id == id);
  }
}