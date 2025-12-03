// lib/core/widgets/historial_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:abufarm/features/transacciones/models/transaccion.dart';

class HistorialCard extends StatelessWidget {
  final List<Transaccion> transacciones;
  final VoidCallback onTap;
  
  const HistorialCard({
    Key? key,
    required this.transacciones,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ultimas = transacciones.take(3).toList();
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Últimos movimientos',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (ultimas.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('No hay transacciones recientes'),
                )
              else
                Column(
                  children: ultimas.map((t) => _TransaccionItem(t, formatter)).toList(),
                ),
              if (transacciones.length > 3)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: onTap,
                    child: const Text('Ver más'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransaccionItem extends StatelessWidget {
  final Transaccion transaccion;
  final NumberFormat formatter;

  const _TransaccionItem(this.transaccion, this.formatter);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                transaccion.tipo == 'ingreso'
                    ? Icons.arrow_circle_up
                    : Icons.arrow_circle_down,
                color: transaccion.tipo == 'ingreso'
                    ? Colors.green
                    : Colors.red,
                size: 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  transaccion.concepto,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${transaccion.tipo == 'ingreso' ? '+' : '-'}${formatter.format(transaccion.monto)}',
                style: TextStyle(
                  color: transaccion.tipo == 'ingreso' ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 2),
            child: Text(
              transaccion.fechaFormateada,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}