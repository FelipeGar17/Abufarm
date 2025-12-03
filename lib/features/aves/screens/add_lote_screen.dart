// lib/features/aves/screens/add_lote_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:abufarm/features/aves/providers/aves_provider.dart';
import 'package:abufarm/features/aves/models/lote.dart';

class AddLoteScreen extends StatefulWidget {
  const AddLoteScreen({super.key});

  @override
  _AddLoteScreenState createState() => _AddLoteScreenState();
}

class _AddLoteScreenState extends State<AddLoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tipoController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _alimentoController = TextEditingController();
  final _proveedorController = TextEditingController();
  final _observacionesController = TextEditingController();
  final _edadController = TextEditingController();

  DateTime _fecha = DateTime.now();

  @override
  void dispose() {
    _tipoController.dispose();
    _cantidadController.dispose();
    _alimentoController.dispose();
    _proveedorController.dispose();
    _observacionesController.dispose();
    _edadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      EasyLoading.dismiss();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Lote'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/image/Lislote.jpeg', fit: BoxFit.cover),
          ),
          // SingleChildScrollView para evitar overflow con el teclado
          SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom:
                  MediaQuery.of(context).viewInsets.bottom +
                  16, // Espacio para el teclado
            ),
            child: Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(
                    0.92,
                  ), // Más opaco para mejor legibilidad
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
                      'Información del Lote',
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
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'Tipo de Aves',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(FontAwesomeIcons.feather, size: 30, color: Colors.green[600]),
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
                      onChanged: (value) {
                        _tipoController.text = value!;
                      },
                      validator: (value) {
                        if (value == null) return 'Seleccione un tipo';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Cantidad de aves
                    TextFormField(
                      controller: _cantidadController,
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
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Ingrese la cantidad';
                        if (int.tryParse(value) == null)
                          return 'Número inválido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Edad inicial
                    TextFormField(
                      controller: _edadController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Edad al adquirir (días)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.access_time,
                          color: Colors.green[600],
                        ),
                        helperText: 'Edad en días',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Ingrese la edad';
                        if (int.tryParse(value) == null) return 'Edad inválida';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Fecha de adquisición
                    TextFormField(
                      readOnly: true,
                      controller: TextEditingController(
                        text: "${_fecha.day}/${_fecha.month}/${_fecha.year}",
                      ),
                      decoration: InputDecoration(
                        labelText: 'Fecha de Adquisición',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          color: Colors.green[600],
                        ),
                        suffixIcon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.green[600],
                        ),
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _fecha,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _fecha = picked;
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Seleccione la fecha';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Proveedor
                    TextFormField(
                      controller: _proveedorController,
                      decoration: InputDecoration(
                        labelText: 'Proveedor (opcional)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.store, color: Colors.green[600]),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tipo de alimento
                    TextFormField(
                      controller: _alimentoController,
                      decoration: InputDecoration(
                        labelText: 'Tipo de alimento (opcional)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.grain, color: Colors.green[600]),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Observaciones
                    TextFormField(
                      controller: _observacionesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Observaciones (opcional)',
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
                      onPressed: _submitForm,
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
                        'Guardar Lote',
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
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final lote = Lote(
        tipo: _tipoController.text,
        cantidadInicial: int.parse(_cantidadController.text),
        fechaCreacion: _fecha,
        alimentoTipo: _alimentoController.text,
        proveedor: _proveedorController.text,
        observaciones: _observacionesController.text,
        edadInicial: int.tryParse(_edadController.text) ?? 0,
      );

      await Provider.of<AvesProvider>(context, listen: false).addLote(lote);
      Navigator.pop(context);
    }
  }
}
