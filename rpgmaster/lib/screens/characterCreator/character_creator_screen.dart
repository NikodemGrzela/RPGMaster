import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:rpgmaster/models/template_model.dart';
import 'package:rpgmaster/screens/templateCreator/section_card.dart';
import 'package:rpgmaster/ui/widgets/widget_card.dart';
import 'package:rpgmaster/ui/widgets/attribute_text_field.dart';
import 'package:rpgmaster/ui/widgets/attribute_number_field.dart';
import 'package:rpgmaster/ui/widgets/attribute_stars_field.dart';
import 'package:rpgmaster/ui/widgets/simple_text_field.dart';
import 'package:rpgmaster/ui/widgets/selection_button.dart';


class CharacterCreatorScreen extends StatefulWidget {
  final String campaignId;
  final String campaignName;

  const CharacterCreatorScreen({
    super.key,
    required this.campaignId,
    required this.campaignName,
  });

  @override
  State<CharacterCreatorScreen> createState() => _CharacterCreatorScreenState();
}

class _CharacterCreatorScreenState extends State<CharacterCreatorScreen> {
  final TextEditingController _nameController = TextEditingController();

  TemplateModel? _selectedTemplate;

  List<List<GlobalKey>> _fieldKeys = [];

  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _prepareFieldsForTemplate(TemplateModel template) {
    _fieldKeys = template.sections
        .map(
          (section) =>
          List.generate(
            section.attributes.length,
                (_) => GlobalKey(),
          ),
    )
        .toList();
  }

  void _onTemplateSelected(TemplateModel template) {
    setState(() {
      _selectedTemplate = template;
      _prepareFieldsForTemplate(template);
    });
  }

  Future<void> _saveCharacter() async {
    if (_selectedTemplate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Najpierw wybierz szablon')),
      );
      return;
    }

    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Podaj nazwę postaci')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final template = _selectedTemplate!;
      final sectionsData = <Map<String, dynamic>>[];

      for (int si = 0; si < template.sections.length; si++) {
        final section = template.sections[si];
        final fieldKeys = _fieldKeys[si];
        final fieldsData = <Map<String, dynamic>>[];

        for (int fi = 0; fi < fieldKeys.length; fi++) {
          final key = fieldKeys[fi];
          final state = key.currentState;
          if (state == null) continue;

          final dyn = state as dynamic;

          switch (section.type) {
            case FieldType.textAttribute:
              fieldsData.add({
                'label': dyn.getCurrentKey(),
                'value': dyn.getCurrentValue(),
              });
              break;

            case FieldType.numberAttribute:
              fieldsData.add({
                'label': dyn.getCurrentKey(),
                'value': dyn.getCurrentValue(),
                'checked': dyn.getCheckedState(),
              });
              break;

            case FieldType.starsAttribute:
              fieldsData.add({
                'label': dyn.getCurrentText(),
                'filledStars': dyn.getCurrentFilledStars(),
                'totalStars': dyn.getCurrentTotalStars(),
                'checked': dyn.getCheckedState(),
              });
              break;

            case FieldType.textField:
              fieldsData.add({
                'value': dyn.getCurrentValue(),
              });
              break;
          }
        }

        sectionsData.add({
          'name': section.name,
          'type': section.type.name,
          'hasCheckboxes': section.hasCheckboxes,
          'fields': fieldsData,
        });
      }

      final now = DateTime.now();

      await FirebaseFirestore.instance.collection('characters').add({
        'campaignId': widget.campaignId,
        'templateId': template.id,
        'characterName': name,
        'sections': sectionsData,
        'createdAt': now.toIso8601String(),
      });

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Postać "$name" została utworzona')),
      );
    } catch (e) {
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (_) =>
            AlertDialog(
              title: const Text('Błąd zapisu'),
              content: Text('Nie udało się zapisać postaci: $e'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Nowa postać'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveCharacter,
            child: Text(
              'Zapisz',
              style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(
                color: _isSaving
                    ? Theme
                    .of(context)
                    .disabledColor
                    : Theme
                    .of(context)
                    .colorScheme
                    .primary,
              ),
            ),
          ),
        ],
      ),
      body: _selectedTemplate == null
          ? _buildTemplateSelection()
          : _buildCharacterForm(),
    );
  }

  /// Krok 1 – wybór szablonu
  Widget _buildTemplateSelection() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text('Musisz być zalogowany, aby tworzyć postacie.'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Text(
            'Wybierz szablon\npostaci',
            textAlign: TextAlign.center,
            style: Theme
                .of(context)
                .textTheme
                .displayMedium,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('templates')
                  .where('uid', isEqualTo: user.uid)
                  .orderBy('name')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                      child: Text('Błąd: ${snapshot.error}'));
                }

                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Center(
                    child: Text(
                        'Brak szablonów. Utwórz szablon w zakładce szablonów.'),
                  );
                }

                return ListView.separated(
                  itemCount: docs.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final template = TemplateModel.fromDoc(doc);

                    return SelectionButton(
                      label: template.name,
                      onPressed: () => _onTemplateSelected(template),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Krok 2 – edycja atrybutów postaci w oparciu o szablon
  Widget _buildCharacterForm() {
    final template = _selectedTemplate!;
    if (_fieldKeys.length != template.sections.length) {
      _prepareFieldsForTemplate(template);
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Imię postaci',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Kampania: ${widget.campaignName}',
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium,
            ),
            const SizedBox(height: 24),

            // Sekcje z szablonu
            ...List.generate(
              template.sections.length,
                  (index) =>
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildSectionCard(index),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(int sectionIndex) {
    final section = _selectedTemplate!.sections[sectionIndex];
    final fieldKeys = _fieldKeys[sectionIndex];

    final fieldWidgets = <Widget>[];

    for (int i = 0; i < section.attributes.length; i++) {
      final key = fieldKeys[i];
      final meta = section.attributes[i];
      Widget field;

      switch (section.type) {
        case FieldType.textAttribute:
          field = AttributeTextField(
            key: key,
            isTemplate: false,
            isEditable: true,
            textKey: meta.name.isNotEmpty ? meta.name : 'Atrybut ${i + 1}',
          );
          break;

        case FieldType.numberAttribute:
          field = AttributeNumberField(
            key: key,
            isTemplate: false,
            isEditable: true,
            hasCheckbox: section.hasCheckboxes,
            text: meta.name.isNotEmpty ? meta.name : 'Atrybut ${i + 1}',
            number: 0,
            initialChecked: false,
          );
          break;

        case FieldType.starsAttribute:
          field = AttributeStarsField(
            key: key,
            isTemplate: false,
            isEditable: true,
            hasCheckbox: section.hasCheckboxes,
            text: meta.name.isNotEmpty ? meta.name : 'Cecha ${i + 1}',
            totalStars: meta.maxStars ?? 5,
            filledStars: 0,
            initialChecked: false,
          );
          break;

        case FieldType.textField:
          field = SimpleTextField(
            key: key,
            isEditable: true,
            text: meta.name,
          );
          break;
      }

      fieldWidgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: field,
      ));
    }

    return WidgetCard(
      title: section.name,
      initialWidgets: fieldWidgets,
      initiallyExpanded: true,
      isAddable: true,
      onAddWidget: () => _createNewWidget(section.type, sectionIndex),
      onWidgetAdded: (newWidget) => _onWidgetAdded(sectionIndex, newWidget),
    );
  }

  Widget _createNewWidget(FieldType fieldType, int sectionIndex) {
    final newKey = GlobalKey();

    _fieldKeys[sectionIndex].add(newKey);

    switch (fieldType) {
      case FieldType.textAttribute:
        return AttributeTextField(
          key: newKey,
          isTemplate: true,
        );

      case FieldType.numberAttribute:
        return AttributeNumberField(
          key: newKey,
          isTemplate: true,
          hasCheckbox: _selectedTemplate!.sections[sectionIndex].hasCheckboxes,
          number: 0,
          initialChecked: false,
        );

      case FieldType.starsAttribute:
        return AttributeStarsField(
          key: newKey,
          isTemplate: true,
          hasCheckbox: _selectedTemplate!.sections[sectionIndex].hasCheckboxes,
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

  void _onWidgetAdded(int sectionIndex, Widget newWidget) {
    // _saveCharacter();
  }
}
