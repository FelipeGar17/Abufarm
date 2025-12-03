// lib/features/aves/models/mortalidad.dart
import 'package:intl/intl.dart';

class RegistroMortalidad {
  final int? id;
  final int loteId;
  final int cantidad;
  final DateTime fecha;
  final String? causa;
  final String? observaciones;

  RegistroMortalidad({
    this.id,
    required this.loteId,
    required this.cantidad,
    required this.fecha,
    this.causa,
    this.observaciones,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lote_id': loteId,
      'cantidad': cantidad,
      'fecha': fecha.toIso8601String(),
      'causa': causa,
      'observaciones': observaciones,
    };
  }

  factory RegistroMortalidad.fromMap(Map<String, dynamic> map) {
    return RegistroMortalidad(
      id: map['id'] as int?,
      loteId: map['lote_id'] as int,
      cantidad: map['cantidad'] as int,
      fecha: DateTime.parse(map['fecha'] as String),
      causa: map['causa'] as String?,
      observaciones: map['observaciones'] as String?,
    );
  }

  String get fechaFormateada => DateFormat('dd/MM/yyyy').format(fecha);
}