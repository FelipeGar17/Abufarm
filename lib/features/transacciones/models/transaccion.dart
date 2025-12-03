import 'package:intl/intl.dart';

class Transaccion {
  final int? id;
  final String tipo; // 'ingreso' o 'gasto'
  final double monto;
  final String concepto;
  final String? descripcion;
  final DateTime fecha;
  final String categoria;

  Transaccion({
    this.id,
    required this.tipo,
    required this.monto,
    required this.concepto,
    this.descripcion,
    required this.fecha,
    required this.categoria,
  });

  Map<String, dynamic> toMap({bool incluirTipo = false}) {
    final map = {
      'id': id,
      'monto': monto,
      'concepto': concepto,
      'descripcion': descripcion,
      'fecha': fecha.toIso8601String(),
      'categoria': categoria,
    };
    if (incluirTipo) {
      map['tipo'] = tipo;
    }
    return map;
  }

  factory Transaccion.fromMap(Map<String, dynamic> map) {
    return Transaccion(
      id: map['id'] as int?,
      tipo: map['tipo'] as String,
      monto: map['monto'] is int ? (map['monto'] as int).toDouble() : map['monto'] as double,
      concepto: map['concepto'] as String,
      descripcion: map['descripcion'] as String?,
      fecha: DateTime.parse(map['fecha'] as String),
      categoria: map['categoria'] as String,
    );
  }
    String get fechaFormateada => DateFormat('dd/MM/yyyy').format(fecha);

  }