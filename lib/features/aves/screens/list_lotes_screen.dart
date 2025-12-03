// lib/features/aves/screens/list_lotes_screen.dart
import 'package:abufarm/core/widgets/custom_bottom_nav.dart';
import 'package:abufarm/features/aves/models/lote.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:abufarm/core/constants/colors.dart';
import 'package:abufarm/features/aves/providers/aves_provider.dart';
import 'package:abufarm/app/routes/app_routes.dart';
import 'package:intl/intl.dart';

class ListLotesScreen extends StatefulWidget {
  const ListLotesScreen({super.key});

  @override
  State<ListLotesScreen> createState() => _ListLotesScreenState();
}

class _ListLotesScreenState extends State<ListLotesScreen> {
  final _dateFormat = DateFormat('dd/MM/yyyy');
  DateTimeRange? _selectedDateRange;

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.verdePasto),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDateRange = picked);
    }
  }

  List<Lote> _filterLotes(List<Lote> lotes) {
    if (_selectedDateRange == null) return lotes;
    return lotes.where((lote) {
      return lote.fechaCreacion.isAfter(_selectedDateRange!.start) &&
          lote.fechaCreacion.isBefore(_selectedDateRange!.end);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      EasyLoading.dismiss();
    });

    final avesProvider = Provider.of<AvesProvider>(context);
    final filteredLotes = _filterLotes(avesProvider.lotes);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Lotes'),
        backgroundColor: AppColors.verdePasto,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, size: 26),
            onPressed: () => _selectDateRange(context),
            tooltip: 'Filtrar por fecha',
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 30),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.addLote),
            tooltip: 'Agregar nuevo lote',
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/image/Lislote.jpeg', // Cambia la ruta si tu fondo es otro
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              if (_selectedDateRange != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Filtrado: ${_dateFormat.format(_selectedDateRange!.start)} - ${_dateFormat.format(_selectedDateRange!.end)}',
                        style: TextStyle(
                          color: AppColors.verdeOscuro,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed:
                            () => setState(() => _selectedDateRange = null),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredLotes.length,
                  itemBuilder: (context, index) {
                    final lote = filteredLotes[index];
                    final edad =
                        lote.edadInicial +
                        DateTime.now().difference(lote.fechaCreacion).inDays;
                    return Card(
                      color: Colors.white.withOpacity(
                        0.85,
                      ), // Fondo translúcido
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ExpansionTile(
                        leading: Icon(
                          _getIconForTipo(lote.tipo),
                          color: AppColors.verdePasto,
                          size: 32,
                        ),
                        title: Text(
                          'Lote #${lote.id}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.verdeOscuro,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${lote.cantidadInicial} aves'),
                            Text(
                              'Edad: ${_formatEdad(edad)}',
                              style: TextStyle(
                                color: AppColors.cafeTierra,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailRow(
                                  'Tipo:',
                                  _getTipoName(lote.tipo),
                                ),
                                _buildDetailRow(
                                  'Fecha creación:',
                                  _dateFormat.format(lote.fechaCreacion),
                                ),
                                _buildDetailRow(
                                  'Proveedor:',
                                  lote.proveedor ?? 'No especificado',
                                ),
                                _buildDetailRow(
                                  'Alimento:',
                                  lote.alimentoTipo ?? 'No especificado',
                                ),
                                _buildDetailRow(
                                  'Edad actual:',
                                  '$edad días (${_formatEdad(edad)})',
                                ),
                                if (lote.observaciones != null &&
                                    lote.observaciones!.isNotEmpty)
                                  _buildDetailRow(
                                    'Observaciones:',
                                    lote.observaciones!,
                                  ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed:
                                            () => _editarLote(context, lote),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color.fromARGB(255, 216, 170, 43),
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text('Editar'),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed:
                                            () => _clasificarPollitos(
                                              context,
                                              lote,
                                            ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.verdePasto,
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text('Clasificar'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 2, // Índice de "Aves"
        onTap: (index) {
          final routes = [
            AppRoutes.dashboard,
            AppRoutes.registroHuevos,
            AppRoutes.listLotes,
            AppRoutes.ventas,
          ];
          if (index != 2) {
            Navigator.pushNamed(context, routes[index]);
          }
        },
      ),
    );
  }

  // Métodos auxiliares
  String _formatEdad(int dias) {
    if (dias < 30) return '$dias días';
    final meses = dias ~/ 30;
    final diasRestantes = dias % 30;
    return '$meses meses${diasRestantes > 0 ? ' y $diasRestantes días' : ''}';
  }

  void _editarLote(BuildContext context, Lote lote) {
    Navigator.pushNamed(context, AppRoutes.editLote, arguments: lote.id);
  }

  void _clasificarPollitos(BuildContext context, Lote lote) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clasificar Pollitos'),
            content: const Text('¿A qué categoría deseas mover este lote?'),
            actions: [
              TextButton(
                onPressed: () => _moverLote(context, lote.id, 'ponedoras'),
                child: const Text('Gallinas ponedoras'),
              ),
              TextButton(
                onPressed: () => _moverLote(context, lote.id, 'engorde'),
                child: const Text('Pollos de engorde'),
              ),
            ],
          ),
    );
  }

  void _moverLote(BuildContext context, int? loteId, String nuevoTipo) {
    if (loteId == null) return;
    final avesProvider = context.read<AvesProvider>();
    final lote = avesProvider.getLoteById(loteId);

    avesProvider.actualizarLote(
      loteId,
      tipo: nuevoTipo,
      cantidad: lote.cantidadInicial,
      proveedor: lote.proveedor,
      alimentoTipo: lote.alimentoTipo,
      observaciones: lote.observaciones,
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Lote movido a $nuevoTipo')));
  }

  IconData _getIconForTipo(String tipo) {
    switch (tipo) {
      case 'ponedoras':
        return Icons.egg;
      case 'engorde':
        return Icons.restaurant;
      default:
        return FontAwesomeIcons.feather;
    }
  }

  String _getTipoName(String tipo) {
    switch (tipo) {
      case 'ponedoras':
        return 'Gallinas Ponedoras';
      case 'engorde':
        return 'Aves de Engorde';
      default:
        return 'Pollitos';
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.verdeOscuro,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(color: AppColors.cafeTierra, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
