import 'package:flutter/material.dart';
import 'package:rpgmaster/ui/widgets/selection_button.dart';
import 'package:rpgmaster/screens/characterSheet/character_sheet.dart';

class CharacterSelectionButton extends StatelessWidget {
  final String characterId;
  final String characterName;
  final String campaignName;
  final String campaignId;
  final VoidCallback? onCharacterSelected;

  const CharacterSelectionButton({
    super.key,
    required this.characterId,
    required this.characterName,
    required this.campaignName,
    required this.campaignId,
    this.onCharacterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SelectionButton(
      label: characterName,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CharacterSheetScreen(
              campaignId:  campaignId,
              characterId: characterId,
              characterName: characterName,
              campaignName: campaignName,
            ),
          ),
        );
        onCharacterSelected?.call();
      },
    );
  }
}
