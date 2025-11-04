import 'package:flutter/material.dart';
import '../../ui/widgets/attribute_text_field.dart';

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
        title: Text(characterName),
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
                children: List.generate(
                  20, // Przykładowa liczba widgetów
                      (index) => Container(
                    margin: EdgeInsets.only(bottom: 12.0),
                    padding: EdgeInsets.all(16.0),
                    child: AttributeTextField(
                      isTemplate: false,
                      text: 'Widget nr ${index + 1}',
                      onChanged: (value) {
                        print('Wartość zmieniona: $value');
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Divider oddzielający
          Divider(
            height: 1.0,
            thickness: 1.0,
            color: Colors.grey.shade400,
          ),

          // Sekcja z przyciskami
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [

                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      // TODO: Nawigacja do notatek
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
                      // TODO: Nawigacja do rzutu kością
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
