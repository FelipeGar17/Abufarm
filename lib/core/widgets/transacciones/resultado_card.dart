import 'package:flutter/material.dart';
import 'package:abufarm/core/constants/colors.dart';

class ResultadoCard extends StatelessWidget {
  final double balance;

  const ResultadoCard({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    final esPositivo = balance >= 0;
    return SizedBox(
      width: double.infinity, // <-- Esto hace que ocupe todo el ancho
      child: Card(
        color: (esPositivo ? const Color.fromARGB(255, 136, 244, 140) : Colors.red[100])!.withOpacity(0.8),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                esPositivo ? 'GANANCIAS NETAS' : 'PÉRDIDAS NETAS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: esPositivo ? AppColors.verdeOscuro : AppColors.rojoCresta,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '\$${balance.abs().toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: esPositivo ? AppColors.verdeOscuro : AppColors.rojoCresta,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}