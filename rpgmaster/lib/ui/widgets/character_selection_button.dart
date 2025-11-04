import 'package:flutter/material.dart';
import 'package:rpgmaster/ui/widgets/selection_button.dart';
import 'package:rpgmaster/screens/characterSheet/character_sheet.dart';

class CharacterSelectionButton extends StatelessWidget {
  final String characterName;
  final String campaignName;
  final VoidCallback? onCharacterSelected;

  const CharacterSelectionButton({
    super.key,
    required this.characterName,
    required this.campaignName,
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
