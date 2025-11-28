import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rpgmaster/ui/widgets/attribute_stars_field.dart';
import 'package:rpgmaster/screens/templateCreator/section_card.dart';
import 'package:rpgmaster/ui/widgets/simple_text_field.dart';
import '../../ui/theme/app_text_styles.dart';
import '../../ui/widgets/attribute_number_field.dart';
import '../../ui/widgets/attribute_text_field.dart';
import '../../ui/widgets/dice_roll_dialog.dart';
import '../../ui/widgets/widget_card.dart';
import '../campaignNotes/campaign_notes.dart';

class CharacterSheetScreen extends StatefulWidget {
  final String characterId;
  final String characterName;
  final String campaignName;
  final String campaignId;

  const CharacterSheetScreen({
    super.key,
    required this.characterId,
    required this.characterName,
    required this.campaignName,
    required this.campaignId,
  });

  @override
  State<CharacterSheetScreen> createState() => _CharacterSheetScreenState();
}

class _CharacterSheetScreenState extends State<CharacterSheetScreen> {
  // Map do przechowywania kluczy dla dynamicznie dodanych widgetów
  final Map<int, List<GlobalKey>> _fieldKeys = {};

  @override
  Widget build(BuildContext context) {
    final characterDocStream = FirebaseFirestore.instance
        .collection('characters')
        .doc(widget.characterId)
        .snapshots();

    return StreamBuilder<DocumentSnapshot>(
      stream: characterDocStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                widget.characterName,
                style: AppTextStyles.title,
              ),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text('Błąd'),
            ),
            body: Center(
              child: Text('Nie udało się wczytać postaci: ${snapshot.error}'),
            ),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text('Postać'),
            ),
            body: const Center(
              child: Text('Ta postać nie istnieje.'),
            ),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final sections = (data['sections'] as List<dynamic>? ?? []);

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
                widget.characterName,
                style: AppTextStyles.title
            ),
            // actions: [
            //   IconButton(
            //     onPressed: () {
            //       //zmiana postaci
            //     },
            //     icon: const Icon(Icons.swap_horiz),
            //   ),
            // ],
          ),
          body: Column(
            children: [
              // Scrollowalna sekcja - zajmuje dostępne miejsce
              Expanded(
                child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                      // nagłówek z nazwą kampanii
                      // Padding(
                      //   padding: const EdgeInsets.only(bottom: 16.0),
                      //   child: Align(
                      //     alignment: Alignment.centerLeft,
                      //     child: Text(
                      //       'Kampania: $campaignName',
                      //       style: Theme.of(context).textTheme.bodyMedium,
                      //     ),
                      //   ),
                      // ),

                      ...sections.asMap().entries.map(
                            (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _buildSectionCard(
                            context,
                            widget.characterId,
                            sections,
                            entry.key,
                            entry.value,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Divider oddzielający
              Divider(
                height: 0.0,
                thickness: 2.0,
              ),

              // Sekcja z przyciskami
              Container(
                padding: EdgeInsets.all(16.0),
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                child: Row(
                  children: [

                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CampaignNotesScreen(
                                  campaignId: widget.campaignId,
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
    );
  }

  Widget _buildSectionCard(
      BuildContext context,
      String characterId,
      List<dynamic> allSections,
      int sectionIndex,
      dynamic rawSection,
      ) {
    final section = rawSection as Map<String, dynamic>;
    final title = section['name'] as String? ?? '';
    final typeStr = section['type'] as String? ?? FieldType.textAttribute.name;
    final hasCheckboxes = section['hasCheckboxes'] as bool? ?? false;
    final fields = (section['fields'] as List<dynamic>? ?? []);

    // Rozpoznanie typu pola
    FieldType fieldType;
    try {
      fieldType = FieldType.values.firstWhere(
            (t) => t.name == typeStr,
      );
    } catch (_) {
      fieldType = FieldType.textAttribute;
    }

    // Inicjalizacja kluczy dla tej sekcji jeśli nie istnieją
    if (!_fieldKeys.containsKey(sectionIndex)) {
      _fieldKeys[sectionIndex] = List.generate(
          fields.length,
              (_) => GlobalKey()
      );
    }

    final widgets = <Widget>[];
    bool isAddable = false;

    for (int i = 0; i < fields.length; i++) {
      final rawField = fields[i];
      final field = rawField as Map<String, dynamic>;
      final key = _fieldKeys[sectionIndex]![i];


      switch (fieldType) {
        case FieldType.textAttribute:
          widgets.add(
            AttributeTextField(
              key: key,
              isTemplate: false,
              isEditable: false,
              textKey: (field['label'] as String?) ?? '',
              textValue: (field['text'] as String?) ??
                  (field['value'] as String?) ??
                  '',
            ),
          );
          break;

        case FieldType.numberAttribute:
          final label = (field['label'] as String?) ?? '';
          final rawValue = field['number'] ?? field['value'];
          int number = 0;
          if (rawValue is num) {
            number = rawValue.toInt();
          } else if (rawValue != null) {
            number = int.tryParse(rawValue.toString()) ?? 0;
          }
          final checked = field['checked'] as bool? ?? false;

          widgets.add(
            AttributeNumberField(
              key: key,
              isTemplate: false,
              isEditable: false,
              hasCheckbox: hasCheckboxes,
              text: label,
              number: number,
              initialChecked: checked,
            ),
          );
          break;

        case FieldType.starsAttribute:
          widgets.add(
            AttributeStarsField(
              key: key,
              isTemplate: false,
              isEditable: false,
              hasCheckbox: hasCheckboxes,
              text: (field['label'] as String?) ?? '',
              totalStars: (field['totalStars'] as int?) ?? 0,
              filledStars: (field['filledStars'] as int?) ?? 0,
              initialChecked: field['checked'] as bool? ?? false,
            ),
          );
          break;

        case FieldType.textField:
          widgets.add(
            SimpleTextField(
              key: key,
              isEditable: false,
              text: (field['text'] as String?) ??
                  (field['value'] as String?) ??
                  '',
            ),
          );
          isAddable = true;
          break;
      }
    }

    return WidgetCard(
      title: title,
      initialWidgets: widgets,
      initiallyExpanded: true,
      isAddable: isAddable,
      onAddWidget: () => _createNewWidget(fieldType, sectionIndex, hasCheckboxes),
      onWidgetAdded: (newWidget) => _onWidgetAdded(
          context,
          widget.characterId,
          allSections,
          sectionIndex,
          fieldType,
          hasCheckboxes
      ),
      onSave: (values) async {
        await _saveSectionChanges(
          context: context,
          characterId: characterId,
          allSections: allSections,
          sectionIndex: sectionIndex,
          fieldType: fieldType,
          updatedValues: values,
        );
      },
    );
  }

  // Tworzy nowy widget
  Widget _createNewWidget(FieldType fieldType, int sectionIndex, bool hasCheckboxes) {
    final newKey = GlobalKey();

    if (!_fieldKeys.containsKey(sectionIndex)) {
      _fieldKeys[sectionIndex] = [];
    }
    _fieldKeys[sectionIndex]!.add(newKey);

    switch (fieldType) {
      case FieldType.textAttribute:
        return AttributeTextField(
          key: newKey,
          isTemplate: true,
          isEditable: false,
          textKey: 'Nowy atrybut',
          textValue: '',
        );

      case FieldType.numberAttribute:
        return AttributeNumberField(
          key: newKey,
          isTemplate: true,
          isEditable: false,
          hasCheckbox: hasCheckboxes,
          text: 'Nowy atrybut',
          number: 0,
          initialChecked: false,
        );

      case FieldType.starsAttribute:
        return AttributeStarsField(
          key: newKey,
          isTemplate: true,
          isEditable: false,
          hasCheckbox: hasCheckboxes,
          text: 'Nowa cecha',
          totalStars: 5,
          filledStars: 0,
          initialChecked: false,
        );

      case FieldType.textField:
        return SimpleTextField(
          key: newKey,
          isEditable: true,
          text: 'Nowe pole tekstowe',
        );
    }
  }

// Callback gdy dodano nowy widget - zapisuje do Firebase
  void _onWidgetAdded(
      BuildContext context,
      String characterId,
      List<dynamic> allSections,
      int sectionIndex,
      FieldType fieldType,
      bool hasCheckboxes,
      ) {
    // Znajdź ostatnio dodany widget (ten z najnowszym kluczem)
    final fieldKeys = _fieldKeys[sectionIndex]!;
    final newWidgetKey = fieldKeys.last;

    // Pobierz dane z nowego widgetu
    final newFieldData = _getFieldDataFromWidget(newWidgetKey, fieldType, hasCheckboxes);

    // Zaktualizuj dane w Firebase
    _addNewFieldToSection(
      context: context,
      characterId: characterId,
      allSections: allSections,
      sectionIndex: sectionIndex,
      newFieldData: newFieldData,
    );
  }

// Pobiera dane z widgetu na podstawie klucza
  Map<String, dynamic> _getFieldDataFromWidget(
      GlobalKey key,
      FieldType fieldType,
      bool hasCheckboxes
      ) {
    final state = key.currentState;
    if (state == null) return {};

    final dyn = state as dynamic;

    switch (fieldType) {
      case FieldType.textAttribute:
        return {
          'label': dyn.getCurrentKey() ?? 'Nowy atrybut',
          'value': dyn.getCurrentValue() ?? '',
        };

      case FieldType.numberAttribute:
        return {
          'label': dyn.getCurrentKey() ?? 'Nowy atrybut',
          'value': dyn.getCurrentValue() ?? 0,
          'checked': dyn.getCheckedState() ?? false,
        };

      case FieldType.starsAttribute:
        return {
          'label': dyn.getCurrentText() ?? 'Nowa cecha',
          'filledStars': dyn.getCurrentFilledStars() ?? 0,
          'totalStars': dyn.getCurrentTotalStars() ?? 5,
          'checked': dyn.getCheckedState() ?? false,
        };

      case FieldType.textField:
        return {
          'value': dyn.getCurrentValue() ?? '',
        };
    }
  }

  Future<void> _addNewFieldToSection({
    required BuildContext context,
    required String characterId,
    required List<dynamic> allSections,
    required int sectionIndex,
    required Map<String, dynamic> newFieldData,
  }) async {
    try {
      final sectionsCopy = List<dynamic>.from(allSections);
      final section = Map<String, dynamic>.from(sectionsCopy[sectionIndex] as Map<String, dynamic>);
      final fields = List<dynamic>.from(section['fields'] as List<dynamic>? ?? []);

      // Dodaj nowe pole
      fields.add(newFieldData);

      section['fields'] = fields;
      sectionsCopy[sectionIndex] = section;

      await FirebaseFirestore.instance
          .collection('characters')
          .doc(characterId)
          .update({'sections': sectionsCopy});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dodano nowe pole')),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd podczas dodawania pola: $e')),
      );
    }
  }

  Future<void> _saveSectionChanges({
    required BuildContext context,
    required String characterId,
    required List<dynamic> allSections,
    required int sectionIndex,
    required FieldType fieldType,
    required Map<int, dynamic> updatedValues,
  }) async {
    final sectionsCopy = List<dynamic>.from(allSections);
    final section = Map<String, dynamic>.from(sectionsCopy[sectionIndex] as Map<String, dynamic>);
    final fields = List<dynamic>.from(section['fields'] as List<dynamic>? ?? []);

    for (var i = 0; i < fields.length; i++) {
      if (!updatedValues.containsKey(i)) continue;

      final fieldMap = Map<String, dynamic>.from(fields[i] as Map<String, dynamic>);
      final newValue = updatedValues[i];

      switch (fieldType) {
        case FieldType.textAttribute:
          fieldMap['label'] = newValue;
          fieldMap['value'] = newValue;
          break;
        case FieldType.numberAttribute:
          fieldMap['label'] = newValue;
          fieldMap['value'] = newValue is num
              ? newValue
              : int.tryParse(newValue.toString()) ?? 0;
          break;
        case FieldType.starsAttribute:
          fieldMap['label'] = newValue;
          fieldMap['filledStars'] = newValue is num
              ? newValue.toInt()
              : int.tryParse(newValue.toString()) ?? 0;
          break;
        case FieldType.textField:
          fieldMap['value'] = newValue;
          break;
      }

      fields[i] = fieldMap;
    }

    section['fields'] = fields;
    sectionsCopy[sectionIndex] = section;

    try {
      await FirebaseFirestore.instance
          .collection('characters')
          .doc(characterId)
          .update({'sections': sectionsCopy});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Zapisano zmiany atrybutów')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd zapisu: $e')),
      );
    }
  }
}