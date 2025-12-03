// lib/core/database/database_tables.dart

class AppTables {
  static const String lotes = '''
    CREATE TABLE lotes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      tipo TEXT NOT NULL,
      cantidad_inicial INTEGER NOT NULL,
      fecha_creacion TEXT NOT NULL,
      proveedor TEXT,
      alimento_tipo TEXT,
      observaciones TEXT,
      edad_inicial INTEGER DEFAULT 0
    );
  ''';

  static const String aves = '''
    CREATE TABLE aves (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      lote_id INTEGER NOT NULL,
      tipo TEXT NOT NULL,
      estado TEXT NOT NULL,
      fecha_nacimiento TEXT NOT NULL,
      FOREIGN KEY (lote_id) REFERENCES lotes (id)
    );
  ''';

  // static const String produccion = '''
  //   CREATE TABLE produccion (
  //     id INTEGER PRIMARY KEY AUTOINCREMENT,
  //     fecha TEXT NOT NULL,
  //     cantidad INTEGER NOT NULL,
  //     lote_id INTEGER,
  //     FOREIGN KEY (lote_id) REFERENCES lotes (id)
  //   );
  // ''';

  static const String registroHuevos = '''
    CREATE TABLE registro_huevos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      fecha TEXT NOT NULL,  -- Formato ISO8601: YYYY-MM-DD
      cantidad INTEGER NOT NULL,
      observaciones TEXT
    );
  ''';
  static const String notas = '''
  CREATE TABLE notas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    texto TEXT NOT NULL,
    fecha TEXT NOT NULL,  
    lote_id INTEGER  
  );
''';
// Gastos
static const String gastos = '''
  CREATE TABLE gastos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    monto REAL NOT NULL CHECK(monto > 0),
    concepto TEXT NOT NULL,
    descripcion TEXT,
    fecha TEXT NOT NULL,
    categoria TEXT NOT NULL CHECK(
      categoria IN (
        'medicina', 'alimento', 'aseo', 
        'construccion', 'mantenimiento'
      )
    )
  );
''';

// Ingresos
static const String ingresos = '''
  CREATE TABLE ingresos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    monto REAL NOT NULL CHECK(monto > 0),
    concepto TEXT NOT NULL,
    descripcion TEXT,
    fecha TEXT NOT NULL,
    categoria TEXT NOT NULL CHECK(
      categoria IN (
        'huevos', 'carne', 'animal_vivo', 
        'abono_organico'
      )
    )
  );
''';
static const String mortalidad = '''
  CREATE TABLE mortalidad (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    lote_id INTEGER NOT NULL,
    cantidad INTEGER NOT NULL CHECK(cantidad > 0),
    fecha TEXT NOT NULL,
    causa TEXT CHECK(causa IN ('enfermedad', 'accidente', 'desconocida', 'otros')),
    observaciones TEXT,
    FOREIGN KEY (lote_id) REFERENCES lotes (id)
  );
''';
  // ... otras tablas (bajas, gastos, ventas)

  static List<String> get all => [lotes, aves, registroHuevos,notas, gastos, ingresos, mortalidad];
}
