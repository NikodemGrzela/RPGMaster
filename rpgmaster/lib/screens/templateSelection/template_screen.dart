import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rpgmaster/ui/widgets/selection_button.dart';

class TemplateSelectionScreen extends ConsumerWidget {
  const TemplateSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              // TODO: nowy szablon
            },
            icon: const Icon(Icons.add),
            label: const Text('Dodaj Szablon'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Tytuł
            Text(
              'Wybierz\nszablon Karty\npostaci',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium,
            ),

            const SizedBox(height: 48),

            // Lista szablonów
            Expanded(
              child: ListView(
                children: [
                  SelectionButton(
                    label: 'Szablon 1',
                    onPressed: () {
                      // TODO: Nawigacja do szablonu 1
                    },
                  ),
                  const SizedBox(height: 12),
                  SelectionButton(
                    label: 'Szablon 2',
                    onPressed: () {
                      // TODO: Nawigacja do szablonu 2
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
