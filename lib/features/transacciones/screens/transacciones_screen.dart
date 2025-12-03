import 'package:abufarm/core/widgets/transacciones/historial_card.dart';
import 'package:abufarm/features/transacciones/models/transaccion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:abufarm/core/widgets/transacciones/balance_card.dart';
import 'package:abufarm/core/widgets/transacciones/resultado_card.dart';
import 'package:abufarm/features/transacciones/providers/transacciones_provider.dart';
import 'package:abufarm/core/widgets/custom_bottom_nav.dart';
import 'package:abufarm/app/routes/app_routes.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TransaccionesScreen extends StatefulWidget {
  const TransaccionesScreen({super.key});

  @override
  State<TransaccionesScreen> createState() => _TransaccionesScreenState();
}

class _TransaccionesScreenState extends State<TransaccionesScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    EasyLoading.show(status: 'Cargando...');
    final provider = Provider.of<TransaccionesProvider>(context, listen: false);
    provider.totalIngresos = await provider.getTotalMes('ingreso');
    provider.totalGastos = await provider.getTotalMes('gasto');
    EasyLoading.dismiss();
    setState(() {}); // <-- Esto recarga la pantalla
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transacciones')),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/image/huevos.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Consumer<TransaccionesProvider>(
            builder: (context, provider, _) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        kToolbarHeight -
                        MediaQuery.of(context).padding.top -
                        kBottomNavigationBarHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        BalanceCard(
                          ingresos: provider.totalIngresos,
                          gastos: provider.totalGastos,
                        ),
                        const SizedBox(height: 16),
                        ResultadoCard(
                          balance: provider.balance,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add, color: Colors.green),
                          label: const Text('Agregar Ingreso'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.withOpacity(0.7),
                            minimumSize: const Size.fromHeight(48),
                            foregroundColor: Colors.black87,
                          ),
                          onPressed: () async {
                            final result = await Navigator.pushNamed(context, AppRoutes.agregarIngreso);
                            if (result == true) {
                              _loadData();
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.remove, color: Colors.red),
                          label: const Text('Agregar Gasto'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(0.7),
                            minimumSize: const Size.fromHeight(48),
                            foregroundColor: Colors.black87,
                          ),
                          onPressed: () async {
                            final result = await Navigator.pushNamed(context, AppRoutes.agregarGasto);
                            if (result == true) {
                              _loadData();
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                        // Aquí agregas el historial
                        FutureBuilder<List<Transaccion>>(
                          future: Provider.of<TransaccionesProvider>(context, listen: false).getUltimasTransacciones(limit: 10),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState != ConnectionState.done) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            final transacciones = snapshot.data ?? [];
                            return HistorialCard(
                              transacciones: transacciones,
                              onTap: () {
                                Navigator.pushNamed(context, AppRoutes.historialTransacciones);
                              },
                            );
                          },
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 3,
        onTap: (index) {
          final routes = [
            AppRoutes.dashboard,
            AppRoutes.registroHuevos,
            AppRoutes.listLotes,
            AppRoutes.ventas,
          ];
          if (index != 3) {
            Navigator.pushNamed(context, routes[index]);
          }
        },
      ),
    );
  }
}