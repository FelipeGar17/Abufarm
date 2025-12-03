// lib/features/aves/screens/registrar_mortalidad_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:abufarm/features/aves/providers/mortalidad_provider.dart';
import 'package:abufarm/features/aves/models/mortalidad.dart';
import 'package:abufarm/features/aves/providers/aves_provider.dart';

class RegistrarMortalidadScreen extends StatefulWidget {
  const RegistrarMortalidadScreen({super.key});

  @override
  State<RegistrarMortalidadScreen> createState() => _RegistrarMortalidadScreenState();
}

class _RegistrarMortalidadScreenState extends State<RegistrarMortalidadScreen> {
  final _formKey = GlobalKey<FormState>();
  int? _loteId;
  int _cantidad = 1;
  String? _causa;
  final _observacionesController = TextEditingController();
  DateTime _fecha = DateTime.now();

  final List<String> _causas = [
    'enfermedad',
    'accidente',
    'desconocida',
    'otros'
  ];

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
  void dispose() {
    _observacionesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final avesProvider = Provider.of<AvesProvider>(context);
    final lotesActivos = avesProvider.lotes.where((l) => l.cantidadInicial > 0).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Mortalidad')),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/image/piedra.jpeg', // Cambia la ruta si tu imagen tiene otro nombre o ubicación
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  DropdownButtonFormField<int>(
                    value: _loteId,
                    decoration: const InputDecoration(
                      labelText: 'Lote afectado',
                      border: OutlineInputBorder(),
                    ),
                    items: lotesActivos.map((lote) {
                      return DropdownMenuItem<int>(
                        value: lote.id,
                        child: Text('Lote ${lote.id} - ${lote.tipo} (${lote.cantidadInicial} aves)'),
                      );
                    }).toList(),
                    validator: (value) => value == null ? 'Seleccione un lote' : null,
                    onChanged: (value) => setState(() => _loteId = value),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Cantidad de aves',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: _cantidad.toString(),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Ingrese una cantidad';
                      final cantidad = int.tryParse(value);
                      if (cantidad == null || cantidad <= 0) return 'Cantidad inválida';
                      if (_loteId != null) {
                        final lote = lotesActivos.firstWhere((l) => l.id == _loteId);
                        if (cantidad > lote.cantidadInicial) return 'No hay suficientes aves en el lote';
                      }
                      return null;
                    },
                    onChanged: (value) => _cantidad = int.tryParse(value) ?? _cantidad,
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _causa,
                    decoration: const InputDecoration(
                      labelText: 'Causa (opcional)',
                      border: OutlineInputBorder(),
                    ),
                    items: _causas.map((causa) {
                      return DropdownMenuItem<String>(
                        value: causa,
                        child: Text(causa.capitalize()),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _causa = value),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _observacionesController,
                    decoration: const InputDecoration(
                      labelText: 'Observaciones (opcional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 20),
                  // Tarjeta para la fecha
                  Card(
                    color: Colors.white.withOpacity(0.85),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today, color: Colors.green),
                      title: Text(
                        'Fecha',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[900]),
                      ),
                      subtitle: Text(
                        DateFormat('dd/MM/yyyy').format(_fecha),
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: TextButton(
                        onPressed: () => _selectDate(context),
                        child: const Text('Cambiar'),
                      ),
                      onTap: () => _selectDate(context),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() && _loteId != null) {
                        final registro = RegistroMortalidad(
                          loteId: _loteId!,
                          cantidad: _cantidad,
                          fecha: _fecha,
                          causa: _causa,
                          observaciones: _observacionesController.text.isNotEmpty 
                              ? _observacionesController.text 
                              : null,
                        );

                        await Provider.of<MortalidadProvider>(context, listen: false)
                            .registrarMortalidad(registro);

                        if (mounted) Navigator.pop(context);
                      }
                    },
                    child: const Text('Registrar Mortalidad'),
                  ),
                ],
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