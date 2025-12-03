// lib/features/huevos/screens/huevos_screen.dart
import 'package:abufarm/app/routes/app_routes.dart';
import 'package:abufarm/core/widgets/custom_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:abufarm/core/constants/colors.dart';
import 'package:abufarm/features/huevos/providers/huevos_provider.dart';
// ignore: unused_import
import 'package:abufarm/features/aves/providers/aves_provider.dart';
import 'package:intl/intl.dart'; // Para formatear fechas

class HuevosScreen extends StatefulWidget {
  const HuevosScreen({super.key});

  @override
  State<HuevosScreen> createState() => _HuevosScreenState();
}

class _HuevosScreenState extends State<HuevosScreen> {
  final _cantidadController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HuevosProvider>(context, listen: false).cargarHuevosHoy();
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      EasyLoading.dismiss();
    });

    final huevosProvider = Provider.of<HuevosProvider>(context);
    final totalGallinas = huevosProvider.getTotalGallinas(context);

    return Scaffold(
      resizeToAvoidBottomInset: true, // <-- Esto ayuda con el teclado
      appBar: AppBar(
        title: const Text('Registro de Huevos'),
        backgroundColor: AppColors.verdePasto,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/huevos.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tarjeta Resumen
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      color: Colors.white.withOpacity(0.7),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'Huevos Hoy',
                              style: TextStyle(
                                fontSize: 20,
                                color: AppColors.verdeOscuro,
                              ),
                            ),
                            Text(
                              '${huevosProvider.huevosHoy}',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: AppColors.verdeOscuro,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Gallinas disponibles: $totalGallinas',
                              style: TextStyle(color: AppColors.cafeTierra),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Controles
                  Column(
                    children: [
                      TextField(
                        controller: _cantidadController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Cantidad',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.7),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              int actual =
                                  int.tryParse(_cantidadController.text) ?? 0;
                              actual++;
                              _cantidadController.text = actual.toString();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _agregarHuevos,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              184,
                              161,
                              244,
                              175,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('GUARDAR REGISTRO'),
                        ),
                      ),
                    ],
                  ),

                  // Resúmenes (reemplaza la gráfica)
                  const SizedBox(height: 20),
                  Card(
                    color: Colors.white.withOpacity(0.8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Resúmenes',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppColors.verdeOscuro,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Consumer<HuevosProvider>(
                            builder: (context, provider, _) {
                              return FutureBuilder<Map<String, int>>(
                                future: provider.obtenerResumenes(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const CircularProgressIndicator();
                                  }
                                  final datos = snapshot.data!;
                                  return Column(
                                    children: [
                                      _buildResumenItem(
                                        'Ayer', 
                                        datos['ayer']
                                      ),
                                      _buildResumenItem(
                                        'Esta semana',
                                        datos['semana'],
                                      ),
                                      _buildResumenItem(
                                        'Este mes',
                                        datos['mes'],
                                      ),
                                      _buildResumenItem(
                                        'Total histórico',
                                        datos['total'],
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Notas Diarias',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                  const _NotasWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 1,
        onTap: (index) {
          final routes = [
            AppRoutes.dashboard,
            AppRoutes.registroHuevos,
            AppRoutes.listLotes,
            AppRoutes.ventas,
          ];
          if (index != 1) {
            Navigator.pushNamed(context, routes[index]);
          }
        },
      ),
    );
  }

  void _agregarHuevos() {
    final cantidad = int.tryParse(_cantidadController.text) ?? 0;
    if (cantidad > 0) {
      Provider.of<HuevosProvider>(
        context,
        listen: false,
      ).agregarHuevos(cantidad);
      _cantidadController.clear();
    }
  }

  Widget _buildResumenItem(String titulo, int? valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titulo,
            style: TextStyle(color: AppColors.cafeTierra, fontSize: 16),
          ),
          Text(
            '${valor ?? 0}',
            style: TextStyle(
              color: AppColors.verdeOscuro,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    super.dispose();
  }
}

class _NotasWidget extends StatefulWidget {
  const _NotasWidget({Key? key}) : super(key: key);

  @override
  __NotasWidgetState createState() => __NotasWidgetState();
}

class __NotasWidgetState extends State<_NotasWidget> {
  final _notaController = TextEditingController();
  List<Map<String, dynamic>> _notas = [];

  @override
  void initState() {
    super.initState();
    _cargarNotas();
  }

  Future<void> _cargarNotas() async {
    final provider = Provider.of<HuevosProvider>(context, listen: false);
    final notas = await provider.obtenerNotas();
    setState(() => _notas = notas);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _notaController,
          decoration: InputDecoration(
            labelText: 'Nueva nota',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () async {
                if (_notaController.text.isNotEmpty) {
                  await Provider.of<HuevosProvider>(
                    context,
                    listen: false,
                  ).agregarNota(_notaController.text);
                  _notaController.clear();
                  await _cargarNotas();
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _notas.length,
          itemBuilder: (context, index) {
            final nota = _notas[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                title: Text(nota['texto']),
                subtitle: Text(
                  DateFormat(
                    'dd/MM/yyyy - HH:mm',
                  ).format(DateTime.parse(nota['fecha'])),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await Provider.of<HuevosProvider>(
                      context,
                      listen: false,
                    ).eliminarNota(nota['id']);
                    await _cargarNotas();
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _notaController.dispose();
    super.dispose();
  }
}
