// lib/features/dashboard/screens/dashboard_screen.dart

import 'package:abufarm/app/routes/app_routes.dart';
import 'package:abufarm/core/constants/colors.dart';
import 'package:abufarm/core/widgets/custom_bottom_nav.dart';
import 'package:abufarm/core/widgets/mortalidad_card.dart';
import 'package:abufarm/core/widgets/transacciones/balance_card.dart';
import 'package:abufarm/features/huevos/providers/huevos_provider.dart';
import 'package:abufarm/features/transacciones/providers/transacciones_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:abufarm/features/aves/providers/aves_provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _cargarDatosIniciales();
  }

  Future<void> _cargarDatosIniciales() async {
    // Carga los datos de los providers necesarios
    final contextRead = context;
    await Provider.of<AvesProvider>(contextRead, listen: false).loadLotes();
    await Provider.of<AvesProvider>(contextRead, listen: false).verificarYEliminarLotesVacios();
    await Provider.of<HuevosProvider>(contextRead, listen: false).cargarHuevosHoy();
    final provider = Provider.of<TransaccionesProvider>(context, listen: false);
    provider.totalIngresos = await provider.getTotalMes('ingreso');
    provider.totalGastos = await provider.getTotalMes('gasto');
  }

  Future<void> recargarDashboard() async {
    // Aquí puedes recargar los providers que necesites
    await Provider.of<AvesProvider>(context, listen: false).loadLotes();
    await Provider.of<AvesProvider>(context, listen: false).verificarYEliminarLotesVacios();
    await Provider.of<HuevosProvider>(context, listen: false).cargarHuevosHoy();
    final provider = Provider.of<TransaccionesProvider>(context, listen: false);
    provider.totalIngresos = await provider.getTotalMes('ingreso');
    provider.totalGastos = await provider.getTotalMes('gasto');
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      EasyLoading.dismiss();
    });
    final avesProvider = Provider.of<AvesProvider>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('AbuFarm'), centerTitle: true),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/image/FondoAbufarm.png',
              fit: BoxFit.cover,
            ),
          ),
          RefreshIndicator(
            onRefresh: recargarDashboard,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Tarjeta de lotes activos
                  Card(
                    color: Colors.white.withOpacity(0.70),
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        EasyLoading.show(status: 'Cargando...');
                        Navigator.pushNamed(context, AppRoutes.listLotes);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.list_alt,
                                  color: AppColors.verdePasto,
                                  size: 40,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    'Lotes Activos',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.verdeOscuro,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '${avesProvider.lotes.length}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.verdePasto,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: () {
                                EasyLoading.show(status: 'Cargando...');
                                Navigator.pushNamed(context, AppRoutes.addLote);
                              },
                              icon: const Icon(Icons.add_circle),
                              label: const Text('Agregar Lote'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.verdePasto,
                                foregroundColor: Colors.white,
                                textStyle: const TextStyle(fontSize: 18),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Tarjeta de huevos hoy
                  Consumer<HuevosProvider>(
                    builder: (context, provider, _) {
                      return Card(
                        color: Colors.white.withOpacity(0.70),
                        elevation: 4,
                        margin: const EdgeInsets.only(bottom: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.registroHuevos,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.egg,
                                      color: const Color.fromARGB(255, 216, 167, 40),
                                      size: 40,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        'Huevos Hoy',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.verdeOscuro,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.add_circle,
                                        color: AppColors.verdeOscuro,
                                        size: 36,
                                      ),
                                      onPressed: () async {
                                        await provider.agregarHuevos(1);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('+1 huevo agregado'),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  '${provider.huevosHoy}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.verdeOscuro,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.registroHuevos,
                                    );
                                  },
                                  icon: const Icon(Icons.list),
                                  label: const Text('Registro Completo'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.verdePasto,
                                    foregroundColor: Colors.white,
                                    textStyle: const TextStyle(fontSize: 18),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  MortalidadCard(
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.registrarMortalidad,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // BalanceCard usando el provider
                  Consumer<TransaccionesProvider>(
                    builder: (context, provider, _) {
                      return BalanceCard(
                        ingresos: provider.totalIngresos,
                        gastos: provider.totalGastos,
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 0,
        onTap: (index) {
          final routes = [
            AppRoutes.dashboard,
            AppRoutes.registroHuevos,
            AppRoutes.listLotes,
            AppRoutes.ventas,
          ];
          if (index != 0) {
            Navigator.pushNamed(context, routes[index]);
          }
        },
      ),
    );
  }
}
