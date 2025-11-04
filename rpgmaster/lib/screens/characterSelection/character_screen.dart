import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rpgmaster/ui/widgets/character_selection_button.dart';
import 'package:rpgmaster/screens/campaignNotes/campaign_notes.dart';

class CharacterSelectionScreen extends ConsumerWidget {
  final String campaignName;

  const CharacterSelectionScreen({
    super.key,
    required this.campaignName,
  });

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
              //TODO: nowa postać
            },
            icon: const Icon(Icons.add),
            label: const Text('Dodaj Postać'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 16),

            Text(
              campaignName,
              textAlign: TextAlign.center,
              style: Theme
                  .of(context)
                  .textTheme
                  .displayMedium,
            ),

            const SizedBox(height: 48),

            Expanded(
              child: ListView(
                children: [
                  CharacterSelectionButton(
                    characterName: 'Frodo',
                    campaignName: campaignName,
                  ),
                  const SizedBox(height: 12),
                  CharacterSelectionButton(
                    characterName: 'Gandalf',
                    campaignName: campaignName,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Nawigacja do notatek
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CampaignNotesScreen(
              )
            ),
          );
        },
        icon: const Icon(Icons.notes),
        label: const Text('Notatki'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
