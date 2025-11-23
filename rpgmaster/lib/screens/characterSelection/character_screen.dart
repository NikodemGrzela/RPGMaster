import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rpgmaster/screens/characterCreator/character_creator_screen.dart';
import 'package:rpgmaster/ui/widgets/character_selection_button.dart';
import 'package:rpgmaster/screens/campaignNotes/campaign_notes.dart';
import 'package:rpgmaster/providers/character_provider.dart';

class CharacterSelectionScreen extends ConsumerWidget {
  final String campaignName;
  final String campaignId;

  const CharacterSelectionScreen({
    super.key,
    required this.campaignId,
    required this.campaignName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charactersAsync = ref.watch(charactersForCampaignProvider(campaignId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CharacterCreatorScreen(
                    campaignId:  campaignId,
                    campaignName: campaignName,
                  ),
                ),
              );
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

            const SizedBox(height: 12),
            Divider(color: Theme.of(context).colorScheme.outlineVariant,),

            Expanded(
              child: charactersAsync.when(
                data: (characters) {
                  if (characters.isEmpty) {
                    return const Center(
                      child: Text(
                        'Brak postaci w tej kampanii.\nDodaj pierwszą!',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: characters.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final character = characters[index];

                      return CharacterSelectionButton(
                        campaignId:  campaignId,
                        characterId: character.id,
                        characterName: character.characterName,
                        campaignName: campaignName,
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text('Błąd ładowania: $e'),
                ),
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
                campaignId: campaignId,
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
