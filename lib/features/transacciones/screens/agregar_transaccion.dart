// lib/features/transacciones/screens/agregar_transaccion.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:abufarm/features/transacciones/providers/transacciones_provider.dart';
import 'package:abufarm/features/transacciones/models/transaccion.dart';

class AgregarTransaccionScreen extends StatefulWidget {
  final bool esIngreso;
  
  const AgregarTransaccionScreen({
    Key? key,
    required this.esIngreso,
  }) : super(key: key);

  @override
  State<AgregarTransaccionScreen> createState() => _AgregarTransaccionScreenState();
}

class _AgregarTransaccionScreenState extends State<AgregarTransaccionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _conceptoController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _montoController = TextEditingController();
  
  DateTime _fecha = DateTime.now();
  String _categoria = 'alimento'; // Valor por defecto para gastos

  @override
  void initState() {
    super.initState();
    if (widget.esIngreso) {
      _categoria = 'huevos'; // Valor por defecto para ingresos
    }
  }

  @override
  void dispose() {
    _conceptoController.dispose();
    _descripcionController.dispose();
    _montoController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _fecha) {
      setState(() {
        _fecha = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categorias = widget.esIngreso 
        ? ['huevos', 'carne', 'animal_vivo', 'abono_organico']
        : ['medicina', 'alimento', 'aseo', 'construccion', 'mantenimiento'];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.esIngreso ? 'Agregar Ingreso' : 'Agregar Gasto'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/image/FondoAbufarm.png',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    kToolbarHeight -
                    MediaQuery.of(context).padding.top,
              ),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _conceptoController,
                        decoration: const InputDecoration(
                          labelText: 'Concepto',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese un concepto';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _montoController,
                        decoration: const InputDecoration(
                          labelText: 'Monto',
                          border: OutlineInputBorder(),
                          prefixText: '\$',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese un monto';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Ingrese un número válido';
                          }
                          if (double.parse(value) <= 0) {
                            return 'El monto debe ser mayor a cero';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _categoria,
                        decoration: const InputDecoration(
                          labelText: 'Categoría',
                          border: OutlineInputBorder(),
                        ),
                        items: categorias.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value.replaceAll('_', ' ').capitalize()),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _categoria = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descripcionController,
                        decoration: const InputDecoration(
                          labelText: 'Descripción (opcional)',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      // Campo de fecha en tarjeta blanca
                      Card(
                        color: Colors.white.withOpacity(0.85),
                        elevation: 2,
                        child: ListTile(
                          leading: const Icon(Icons.calendar_today, color: Colors.black54),
                          title: Text(
                            DateFormat('dd/MM/yyyy').format(_fecha),
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                          onTap: () => _selectDate(context),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final transaccion = Transaccion(
                              tipo: widget.esIngreso ? 'ingreso' : 'gasto',
                              monto: double.parse(_montoController.text),
                              concepto: _conceptoController.text,
                              descripcion: _descripcionController.text.isNotEmpty 
                                  ? _descripcionController.text 
                                  : null,
                              fecha: _fecha,
                              categoria: _categoria,
                            );

                            await Provider.of<TransaccionesProvider>(context, listen: false)
                                .agregarTransaccion(transaccion);

                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(widget.esIngreso
                                      ? 'Ingreso registrado correctamente'
                                      : 'Gasto registrado correctamente'),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                              Navigator.pop(context, true); // <-- Devuelve true para indicar éxito
                            }
                          }
                        },
                        child: const Text('Realizar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}