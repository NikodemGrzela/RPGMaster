import 'package:flutter/material.dart';
import '../../ui/theme/app_text_styles.dart';
import '../../ui/widgets/attribute_number_field.dart';
import '../../ui/widgets/attribute_text_field.dart';
import '../../ui/widgets/dice_roll_dialog.dart';
import '../../ui/widgets/widget_card.dart';
import '../campaignNotes/campaign_notes.dart';

class CharacterSheetScreen extends StatelessWidget {
  final String characterName;
  final String campaignName;

  const CharacterSheetScreen({
    super.key,
    required this.characterName,
    required this.campaignName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
            characterName,
            style: AppTextStyles.title
        ),
        actions: [
          IconButton(
            onPressed: () {
              //TODO: zmiana postaci
            },
            icon: const Icon(Icons.swap_horiz),
          ),
        ],
      ),
      body: Column(
        children: [
          // Scrollowalna sekcja - zajmuje dostępne miejsce
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [

                  WidgetCard(
                    title: 'Cechy',
                    initialWidgets: [
                      AttributeTextField(
                        textKey: 'Nazwa:',
                        textValue: 'Frodo',
                        isEditable: false,
                        isTemplate: false,
                      ),
                      AttributeTextField(
                        textKey: 'Rasa:',
                        textValue: 'Hobbit',
                        isEditable: false,
                        isTemplate: false,
                      ),
                    ],
                    onAddWidget: () => AttributeTextField(
                      textKey: 'Atrybut:',
                      textValue: 'Nazwa',
                      isEditable: true,
                      isTemplate: false,
                    ),
                  ),

                  WidgetCard(
                    title: 'Statystyki',
                    initialWidgets: [
                      AttributeNumberField(
                        text: 'Siła',
                        number: 5,
                        onValueChanged: (value) {
                          print('AttributeNumberField value: $value');
                        },
                      ),
                      AttributeNumberField(
                        text: 'Rozum',
                        number: 7,
                        onValueChanged: (value) {
                          print('AttributeNumberField value: $value');
                        },
                      ),
                    ],
                    onAddWidget: () => AttributeNumberField(
                      text: 'Statystyka',
                      number: 0,
                      onValueChanged: (value) {
                        print('AttributeNumberField value: $value');
                      },
                    ),
                  ),
                ]
              ),
            ),
          ),

          // Divider oddzielający
          Divider(
            height: 1.0,
            thickness: 1.0,
          ),

          // Sekcja z przyciskami
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [

                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CampaignNotesScreen(
                            )
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notes),
                        SizedBox(width: 8.0),
                        Text('Notatki'),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 16.0),

                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      showDiceRollDialog(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.casino),
                        SizedBox(width: 8.0),
                        Text('Rzuć kością'),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
