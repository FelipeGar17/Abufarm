// lib/features/huevos/providers/huevos_provider.dart
import 'package:abufarm/features/aves/providers/aves_provider.dart';
import 'package:flutter/material.dart';
import 'package:abufarm/core/database/database_helper.dart';
import 'package:abufarm/features/huevos/models/registro_huevos.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HuevosProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<RegistroHuevos> _registros = [];
  int _huevosHoy = 0;

  // Getters
  int get huevosHoy => _huevosHoy;
  List<RegistroHuevos> get registros => _registros;

  // Cargar registros del día actual
  Future<void> cargarHuevosHoy() async {
    final hoy = DateTime.now().toIso8601String().substring(0, 10);
    final db = await _dbHelper.database;
    final maps = await db.query(
      'registro_huevos',
      where: 'fecha = ?',
      whereArgs: [hoy],
    );

    _huevosHoy = maps.fold(0, (sum, map) => sum + (map['cantidad'] as int));
    notifyListeners();
  }
Future<List<Map<String, dynamic>>> obtenerResumenSemanal() async {
  final db = await _dbHelper.database;
  final hoy = DateTime.now();
  final inicioSemana = hoy.subtract(Duration(days: hoy.weekday - 1));

  final maps = await db.rawQuery('''
    SELECT 
      strftime('%w', fecha) as dia_semana,
      SUM(cantidad) as total
    FROM registro_huevos
    WHERE fecha BETWEEN ? AND ?
    GROUP BY dia_semana
  ''', [inicioSemana.toIso8601String().substring(0, 10), hoy.toIso8601String().substring(0, 10)]);

  return List.generate(7, (index) {
    final dia = maps.firstWhere(
      (map) => map['dia_semana'] == '$index',
      orElse: () => {'total': 0},
    );
    return {
      'dia': index,
      'huevos': dia['total'] ?? 0,
    };
  });
}
  // Agregar huevos al registro diario
  Future<void> agregarHuevos(int cantidad, {String? observaciones}) async {
    final db = await _dbHelper.database;
    await db.insert('registro_huevos', RegistroHuevos(
      fecha: DateTime.now(),
      cantidad: cantidad,
      observaciones: observaciones,
    ).toMap());

    _huevosHoy += cantidad;
    notifyListeners();
  }

  // Obtener total de gallinas ponedoras (desde AvesProvider)
  int getTotalGallinas(BuildContext context) {
    final avesProvider = Provider.of<AvesProvider>(context, listen: false);
    return avesProvider.lotes
        .where((lote) => lote.tipo == 'ponedoras')
        .fold(0, (sum, lote) => sum + lote.cantidadInicial);
  }

  // Verificar cambio de día al iniciar la app
  Future<void> checkearCambioDia() async {
    final prefs = await SharedPreferences.getInstance();
    final ultimaFecha = prefs.getString('ultima_fecha_huevos');
    final hoy = DateTime.now().toIso8601String().substring(0, 10);

    if (ultimaFecha != hoy) {
      _huevosHoy = 0;
      await prefs.setString('ultima_fecha_huevos', hoy);
      notifyListeners();
    }
  }
  // Añade este método al provider
Future<Map<String, int>> obtenerResumenes() async {
  final semana = await getHuevosSemana();
  final mes = await getHuevosMes();
  final total = await getHuevosTotal();
  final ayer = await getHuevosAyer();

  return {
    'semana': semana,
    'mes': mes,
    'total': total,
    'ayer': ayer,
  };
}

Future<void> agregarNota(String texto) async {
  final db = await _dbHelper.database;
  await db.insert('notas', {
    'texto': texto,
    'fecha': DateTime.now().toIso8601String(),
  });
  notifyListeners();
}

Future<List<Map<String, dynamic>>> obtenerNotas() async {
  final db = await _dbHelper.database;
  return await db.query('notas', orderBy: 'fecha DESC');
}

Future<void> eliminarNota(int id) async {
  final db = await _dbHelper.database;
  await db.delete('notas', where: 'id = ?', whereArgs: [id]);
  notifyListeners();
}

// Obtener huevos de ayer
Future<int> getHuevosAyer() async {
  final db = await _dbHelper.database;
  final ayer = DateTime.now().subtract(const Duration(days: 1));
  final ayerStr = ayer.toIso8601String().substring(0, 10);

  final maps = await db.query(
    'registro_huevos',
    where: 'fecha = ?',
    whereArgs: [ayerStr],
  );

  return maps.fold<int>(0, (sum, map) => sum + (map['cantidad'] as int));
}

// Obtener huevos de esta semana (lunes a hoy)
Future<int> getHuevosSemana() async {
  final db = await _dbHelper.database;
  final ahora = DateTime.now();
  final inicioSemana = ahora.subtract(Duration(days: ahora.weekday - 1));
  final inicioSemanaStr = inicioSemana.toIso8601String().substring(0, 10);

  final maps = await db.query(
    'registro_huevos',
    where: 'fecha >= ? AND fecha <= ?',
    whereArgs: [inicioSemanaStr, ahora.toIso8601String().substring(0, 10)],
  );

  return maps.fold<int>(0, (sum, map) => sum + (map['cantidad'] as int));
}

// Obtener total de huevos registrados
Future<int> getHuevosTotal() async {
  final db = await _dbHelper.database;
  final maps = await db.query('registro_huevos');
  return maps.fold<int>(0, (sum, map) => sum + (map['cantidad'] as int));
}

// Obtener huevos del mes actual
Future<int> getHuevosMes() async {
  final db = await _dbHelper.database;
  final ahora = DateTime.now();
  final inicioMes = DateTime(ahora.year, ahora.month, 1);
  final inicioMesStr = inicioMes.toIso8601String().substring(0, 10);
  final finMesStr = ahora.toIso8601String().substring(0, 10);

  final maps = await db.query(
    'registro_huevos',
    where: 'fecha >= ? AND fecha <= ?',
    whereArgs: [inicioMesStr, finMesStr],
  );

  return maps.fold<int>(0, (sum, map) => sum + (map['cantidad'] as int));
}
}