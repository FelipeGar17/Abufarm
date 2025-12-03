// lib/features/huevos/models/registro_huevos.dart
class RegistroHuevos {
  final int? id;
  final DateTime fecha;
  final int cantidad;
  final String? observaciones;

  RegistroHuevos({
    this.id,
    required this.fecha,
    required this.cantidad,
    this.observaciones,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fecha': fecha.toIso8601String().substring(0, 10), // Solo fecha
      'cantidad': cantidad,
      'observaciones': observaciones,
    };
  }

  factory RegistroHuevos.fromMap(Map<String, dynamic> map) {
    return RegistroHuevos(
      id: map['id'],
      fecha: DateTime.parse(map['fecha']),
      cantidad: map['cantidad'],
      observaciones: map['observaciones'],
    );
  }
}