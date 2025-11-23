import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rpgmaster/models/campaign_model.dart';
import 'package:rpgmaster/providers/campaign_provider.dart';
import 'package:rpgmaster/screens/campaignCreator/campaign_creator_screen.dart';
import 'package:rpgmaster/ui/widgets/selection_button.dart';
import 'package:rpgmaster/screens/characterSelection/character_screen.dart';

class CampaignSelectionScreen extends ConsumerWidget {
  const CampaignSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campaignsAsync = ref.watch(userCampaignsProvider);

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
                  builder: (_) => const CampaignCreatorScreen(),
                ),
              );
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

            const SizedBox(height: 12),
            Divider(
              color: Theme.of(context).colorScheme.outlineVariant,
              height: 0.0,
              thickness: 2.0,
            ),

            Expanded(
              child: campaignsAsync.when(
                data: (List<Campaign> campaigns) {
                  if (campaigns.isEmpty) {
                    return const Center(
                      child: Text('Brak kampanii.'),
                    );
                  }

                  return ListView.separated(
                    itemCount: campaigns.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final campaign = campaigns[index];

                      return Padding(
                        padding: EdgeInsets.only(top: index == 0 ? 12 : 0),
                        child: SelectionButton(
                        label: campaign.title,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CharacterSelectionScreen(
                                  campaignName: campaign.title,
                                  campaignId: campaign.id,
                                ),
                              ),
                            );
                          },
                        )
                      );
                    },
                  );
                },
                loading: () =>
                const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Błąd: $e')),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
