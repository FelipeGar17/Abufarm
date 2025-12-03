// lib/core/widgets/mortalidad_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:abufarm/features/aves/providers/mortalidad_provider.dart';

class MortalidadCard extends StatelessWidget {
  final VoidCallback onTap;

  const MortalidadCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: Provider.of<MortalidadProvider>(context, listen: false).getTotalMortalidadMes(),
      builder: (context, snapshot) {
        final total = snapshot.data ?? 0;
        final color = total > 0 ? Colors.red : Colors.green;

        return SizedBox(
          width: double.infinity,
          child: Card(
            color: Colors.white.withOpacity(0.75), // Fondo semi-transparente
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mortalidad del Mes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$total aves',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      total > 0 ? '¡Necesita atención!' : 'Todo en orden',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}