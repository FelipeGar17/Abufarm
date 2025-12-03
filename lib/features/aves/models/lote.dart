// lib/features/aves/models/lote.dart

class Lote {
  final int? id;
  final String tipo;
  final int cantidadInicial;
  final DateTime fechaCreacion;
  final String? proveedor;
  final String? alimentoTipo;
  final String? observaciones;
  final int edadInicial;

  Lote({
    this.id,
    required this.tipo,
    required this.cantidadInicial,
    required this.fechaCreacion,
    this.proveedor,
    this.alimentoTipo,
    this.observaciones, 
    this.edadInicial = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipo': tipo,
      'cantidad_inicial': cantidadInicial,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'proveedor': proveedor,
      'alimento_tipo': alimentoTipo,
      'observaciones': observaciones, 
      'edad_inicial': edadInicial,
    };
  }

  factory Lote.fromMap(Map<String, dynamic> map) {
    return Lote(
      id: map['id'],
      tipo: map['tipo'],
      cantidadInicial: map['cantidad_inicial'],
      fechaCreacion: DateTime.parse(map['fecha_creacion']),
      proveedor: map['proveedor'],
      alimentoTipo: map['alimento_tipo'],
      observaciones: map['observaciones'], 
      edadInicial: map['edad_inicial'] ?? 0,
    );
  }
}