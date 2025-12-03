// lib/features/transacciones/screens/historial_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:abufarm/features/transacciones/providers/transacciones_provider.dart';
import 'package:abufarm/features/transacciones/models/transaccion.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({Key? key}) : super(key: key);

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  DateTimeRange? _rangoFechas;
  String? _filtroTipo;
  String? _expandedId;
  final ScrollController _scrollController = ScrollController();
  String _filtroTexto = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Establecer rango por defecto (últimos 30 días)
    final ahora = DateTime.now();
    _rangoFechas = DateTimeRange(
      start: DateTime(ahora.year, ahora.month - 1, ahora.day),
      end: ahora,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarRangoFechas(BuildContext context) async {
    final initialRange = _rangoFechas ?? DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 30)),
      end: DateTime.now(),
    );

    final newRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: initialRange,
      helpText: 'Seleccionar rango de fechas',
    );

    if (newRange != null) {
      setState(() {
        _rangoFechas = newRange;
        _expandedId = null; // Cerrar cualquier tarjeta expandida al cambiar filtros
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransaccionesProvider>(context);
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Transacciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => _mostrarFiltros(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/image/pasto.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              // Barra de búsqueda
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Buscar transacciones...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _filtroTexto = value;
                      _expandedId = null;
                    });
                  },
                ),
              ),
              // Lista de transacciones
              Expanded(
                child: FutureBuilder<List<Transaccion>>(
                  future: _rangoFechas != null 
                      ? provider.getTransaccionesPorFecha(_rangoFechas!.start, _rangoFechas!.end)
                      : provider.getUltimasTransacciones(limit: 100),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final transacciones = _aplicarFiltroTipo(snapshot.data ?? []);

                    if (transacciones.isEmpty) {
                      return const Center(
                        child: Text(
                          'No hay transacciones que coincidan con los filtros',
                          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: transacciones.length,
                      itemBuilder: (context, index) {
                        final t = transacciones[index];
                        final uniqueId = '${t.tipo}-${t.id}';
                        final isExpanded = _expandedId == uniqueId;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _expandedId = isExpanded ? null : uniqueId;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Encabezado
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          t.concepto,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${t.tipo == 'ingreso' ? '+' : '-'}${formatter.format(t.monto)}',
                                        style: TextStyle(
                                          color: t.tipo == 'ingreso' ? Colors.green : Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        t.tipo == 'ingreso' 
                                            ? Icons.arrow_circle_up 
                                            : Icons.arrow_circle_down,
                                        color: t.tipo == 'ingreso' ? Colors.green : Colors.red,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        t.fechaFormateada,
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                      const Spacer(),
                                      Text(
                                        t.categoria.replaceAll('_', ' ').capitalize(),
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),

                                  // Detalles expandidos con animación
                                  AnimatedCrossFade(
                                    firstChild: const SizedBox.shrink(),
                                    secondChild: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Divider(height: 20),
                                        if (t.descripcion != null && t.descripcion!.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 8),
                                            child: Text(t.descripcion!),
                                          ),
                                        Text(
                                          'ID: ${t.id}',
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                    crossFadeState: isExpanded
                                        ? CrossFadeState.showSecond
                                        : CrossFadeState.showFirst,
                                    duration: const Duration(milliseconds: 200),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Transaccion> _aplicarFiltroTipo(List<Transaccion> transacciones) {
    var lista = transacciones;
    if (_filtroTipo != null) {
      lista = lista.where((t) => t.tipo == _filtroTipo).toList();
    }
    if (_filtroTexto.isNotEmpty) {
      final filtro = _filtroTexto.toLowerCase();
      lista = lista.where((t) =>
        t.concepto.toLowerCase().contains(filtro) ||
        (t.descripcion?.toLowerCase().contains(filtro) ?? false) ||
        t.categoria.toLowerCase().contains(filtro)
      ).toList();
    }
    return lista;
  }

  Future<void> _mostrarFiltros(BuildContext context) async {
    String? filtroTipoLocal = _filtroTipo;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permitir que el modal sea scrollable
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.4,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Indicador de arrastre
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Filtros',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          title: const Text('Rango de fechas'),
                          subtitle: Text(_rangoFechas != null
                              ? '${DateFormat('dd/MM/yyyy').format(_rangoFechas!.start)} - ${DateFormat('dd/MM/yyyy').format(_rangoFechas!.end)}'
                              : 'Seleccionar fechas'),
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () {
                            Navigator.pop(context);
                            _seleccionarRangoFechas(context);
                          },
                        ),
                        const Divider(),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Tipo de transacción',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        RadioListTile<String?>(
                          title: const Text('Todas'),
                          value: null,
                          groupValue: filtroTipoLocal,
                          onChanged: (value) {
                            setModalState(() {
                              filtroTipoLocal = value;
                            });
                          },
                        ),
                        RadioListTile<String?>(
                          title: const Text('Ingresos'),
                          value: 'ingreso',
                          groupValue: filtroTipoLocal,
                          onChanged: (value) {
                            setModalState(() {
                              filtroTipoLocal = value;
                            });
                          },
                        ),
                        RadioListTile<String?>(
                          title: const Text('Gastos'),
                          value: 'gasto',
                          groupValue: filtroTipoLocal,
                          onChanged: (value) {
                            setModalState(() {
                              filtroTipoLocal = value;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _filtroTipo = filtroTipoLocal;
                                _expandedId = null;
                              });
                              Navigator.pop(context);
                            },
                            child: const Text('Aplicar Filtros'),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}