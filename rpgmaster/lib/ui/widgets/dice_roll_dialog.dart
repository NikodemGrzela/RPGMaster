import 'package:flutter/material.dart';
import 'dart:math';
import 'dice_row.dart';

/// Dialog do rzutu kością
class DiceRollDialog extends StatefulWidget {
  const DiceRollDialog({super.key});

  @override
  State<DiceRollDialog> createState() => _DiceRollDialogState();
}

class _DiceRollDialogState extends State<DiceRollDialog> {
  // Stan kości
  final Map<String, int> diceCount = {
    'k4': 0,
    'k6': 6,
    'k8': 0,
    'k10': 0,
    'k12': 2,
    'k20': 0,
  };

  // Mapowanie typu kości na liczbę ścianek
  static const Map<String, int> diceSides = {
    'k4': 4,
    'k6': 6,
    'k8': 8,
    'k10': 10,
    'k12': 12,
    'k20': 20,
  };

  // Lista nazw kości
  static const List<MapEntry<String, String>> diceConfig = [
    MapEntry('k4', 'Kość czworościenna'),
    MapEntry('k6', 'Kość sześciościenna'),
    MapEntry('k8', 'Kość ośmiościenna'),
    MapEntry('k10', 'Kość 10-ciościenna'),
    MapEntry('k12', 'Kość 12-stościenna'),
    MapEntry('k20', 'Kość 20-stościenna'),
  ];

  // Wyniki rzutu
  List<int>? results;
  int? total;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tytuł
            Text(
              results == null ? 'Rzut kością' : 'Wyniki rzutu',
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 24),

            // Wyniki (jeśli są)
            if (results != null) ...[
              Text(
                'Wylosował/eś liczby:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                results!.join(', '),
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Suma: $total',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                label: const Text('Wyjdź'),
              ),
            ]
            // Wybór kości (jeśli nie ma wyników)
            else ...[
              ...diceConfig.map((config) => [
                DiceRow(
                  label: config.value,
                  initialValue: diceCount[config.key]!,
                  onChanged: (value) => diceCount[config.key] = value,
                ),
                const SizedBox(height: 16),
              ]).expand((widget) => widget),

              const SizedBox(height: 8),

              FilledButton.icon(
                onPressed: _rollDice,
                icon: const Icon(Icons.casino),
                label: const Text('Rzuć'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _rollDice() {
    final random = Random();
    final allResults = <int>[];

    // Iteruj przez wszystkie typy kości
    diceCount.forEach((diceType, count) {
      final sides = diceSides[diceType]!;
      for (int i = 0; i < count; i++) {
        allResults.add(random.nextInt(sides) + 1);
      }
    });

    setState(() {
      results = allResults;
      total = allResults.fold<int>(0, (sum, value) => sum + value);
    });
  }
}

/// Funkcja pomocnicza do pokazania dialogu
void showDiceRollDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const DiceRollDialog(),
  );
}