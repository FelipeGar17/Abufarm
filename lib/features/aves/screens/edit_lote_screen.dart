// lib/features/aves/screens/edit_lote_screen.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:abufarm/features/aves/providers/aves_provider.dart';
// ignore: unused_import
import 'package:abufarm/features/aves/models/lote.dart';

class EditLoteScreen extends StatefulWidget {
  final int loteId;

  const EditLoteScreen({super.key, required this.loteId});

  @override
  State<EditLoteScreen> createState() => _EditLoteScreenState();
}

class _EditLoteScreenState extends State<EditLoteScreen> {
  late final TextEditingController _cantidadController;
  late final TextEditingController _proveedorController;
  late final TextEditingController _alimentoController;
  late final TextEditingController _observacionesController;

  String? _selectedTipo;

  @override
  void initState() {
    super.initState();
    final lote = context.read<AvesProvider>().getLoteById(widget.loteId);

    _cantidadController = TextEditingController(
      text: lote.cantidadInicial.toString(),
    );
    _proveedorController = TextEditingController(text: lote.proveedor);
    _alimentoController = TextEditingController(text: lote.alimentoTipo);
    _observacionesController = TextEditingController(text: lote.observaciones);

    _selectedTipo = lote.tipo;
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    _proveedorController.dispose();
    _alimentoController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Lote'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _guardarCambios),
        ],
      ),
      body: Stack(
        children: [
          // Imagen de fondo que ocupa toda la pantalla
          Positioned.fill(
            child: Image.asset('assets/image/Lislote.jpeg', fit: BoxFit.cover),
          ),
          // Contenido del formulario
          SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom:
                  MediaQuery.of(context).viewInsets.bottom +
                  16, // Espacio para el teclado
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.92),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Título del formulario
                  Text(
                    'Editar Información del Lote',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Tipo de aves
                  DropdownButtonFormField<String>(
                    value: _selectedTipo,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Tipo de Aves',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: FaIcon(FontAwesomeIcons.feather, size: 30, color: Colors.green[600]),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'pollitos',
                        child: Text('Pollitos'),
                      ),
                      DropdownMenuItem(
                        value: 'ponedoras',
                        child: Text('Gallinas Ponedoras'),
                      ),
                      DropdownMenuItem(
                        value: 'engorde',
                        child: Text('Aves de Engorde'),
                      ),
                    ],
                    onChanged: (value) => setState(() => _selectedTipo = value),
                  ),
                  const SizedBox(height: 16),

                  // Cantidad de aves
                  TextFormField(
                    controller: _cantidadController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Cantidad de Aves',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.format_list_numbered,
                        color: Colors.green[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tipo de alimento
                  TextFormField(
                    controller: _alimentoController,
                    decoration: InputDecoration(
                      labelText: 'Tipo de Alimento',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.grain, color: Colors.green[600]),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Proveedor (deshabilitado)
                  TextFormField(
                    controller: _proveedorController,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: 'Proveedor',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      prefixIcon: Icon(Icons.store, color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Observaciones
                  TextFormField(
                    controller: _observacionesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Observaciones',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: Icon(Icons.notes, color: Colors.green[600]),
                      ),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Botón de guardar
                  ElevatedButton(
                    onPressed: _guardarCambios,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    child: const Text(
                      'GUARDAR CAMBIOS',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _guardarCambios() {
    final avesProvider = context.read<AvesProvider>();
    avesProvider.actualizarLote(
      widget.loteId,
      cantidad: int.parse(_cantidadController.text),
      tipo: _selectedTipo!,
      proveedor: _proveedorController.text,
      alimentoTipo: _alimentoController.text,
      observaciones: _observacionesController.text,
    );
    Navigator.pop(context);
  }
}
