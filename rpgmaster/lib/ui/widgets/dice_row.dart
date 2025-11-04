import 'package:flutter/material.dart';
import 'counter_widget.dart';

/// Widget wyświetlający wiersz z nazwą kości i licznikiem
class DiceRow extends StatelessWidget {
  final String label;
  final int initialValue;
  final ValueChanged<int> onChanged;

  const DiceRow({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        CounterWidget(
          initialValue: initialValue,
          onChanged: onChanged,
        ),
      ],
    );
  }
}