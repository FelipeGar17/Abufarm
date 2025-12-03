import 'package:flutter/material.dart';
import 'package:abufarm/core/constants/colors.dart';

class BalanceCard extends StatelessWidget {
  final double ingresos;
  final double gastos;

  const BalanceCard({
    super.key,
    required this.ingresos,
    required this.gastos,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.white.withOpacity(0.7),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildColumna('Ingresos', ingresos, AppColors.verdePasto),
              const SizedBox(height: 12),
              _buildColumna('Gastos', gastos, AppColors.rojoCresta),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColumna(String titulo, double monto, Color color) {
    return Column(
      children: [
        Text(titulo, style: TextStyle(color: color)),
        Text(
          '\$${monto.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}