import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rpgmaster/ui/widgets/selection_button.dart';
import 'package:rpgmaster/screens/characterSelection/character_screen.dart';

class CampaignSelectionScreen extends ConsumerWidget {
  const CampaignSelectionScreen({super.key});

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
              // TODO: nowa kampania
            },
            icon: const Icon(Icons.add),
            label: const Text('Dodaj Kampanię'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              'Wybierz\nkampanię',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 48),
            Expanded(
              child: ListView(
                children: [
                  SelectionButton(
                    label: 'Kampania 1',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CharacterSelectionScreen(
                            campaignName: 'Kampania 1',
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  SelectionButton(
                    label: 'Kampania 2',
                    onPressed: () {
                      // TODO: Nawigacja do kampanii 2
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
