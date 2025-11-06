import 'package:flutter/material.dart';
import '../../ui/widgets/attribute_number_field.dart';
import '../../ui/widgets/attribute_stars_field.dart';
import '../../ui/widgets/attribute_text_field.dart';
import '../../ui/widgets/simple_text_field.dart';

/// Typy pól
enum FieldType {
  textAttribute('Atrybut tekstowy', Icons.text_fields, 'Nazwa: tekst'),
  numberAttribute('Atrybut liczbowy', Icons.numbers, 'Nazwa: liczba'),
  starsAttribute('Atrybut ze wskaźnikiem', Icons.star, 'Nazwa: wskaźnik punktowy'),
  textField('Pole tekstowe', Icons.notes, 'Proste pole tekstowe');

  final String label;
  final IconData icon;
  final String description;
  const FieldType(this.label, this.icon, this.description);
}

class AttributeTemplateMeta {
  String name;
  int? maxStars;

  AttributeTemplateMeta({
    this.name = '',
    this.maxStars,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      if (maxStars != null) 'maxStars': maxStars,
    };
  }
}

/// Sekcja = grupa pól tego samego typu
class Section {
  String name;
  FieldType type;
  final List<Widget> fields;
  bool hasCheckboxes;
  final List<AttributeTemplateMeta> attributes;

  Section({
    required this.name,
    required this.type,
    List<AttributeTemplateMeta>? attributes,
    this.hasCheckboxes = false,
  }) : attributes = attributes ??
      [
        AttributeTemplateMeta(
          maxStars: type == FieldType.starsAttribute ? 5 : null,
        ),
      ],
        fields = [] {
    for (final attr in this.attributes) {
      fields.add(_createField(type, hasCheckboxes, attr));
    }
  }

  factory Section.fromMap(Map<String, dynamic> map) {
    final typeString = map['type'] as String? ?? FieldType.textAttribute.name;
    final type = FieldType.values.firstWhere(
          (t) => t.name == typeString,
      orElse: () => FieldType.textAttribute,
    );

    final hasCheckboxes = map['hasCheckboxes'] as bool? ?? false;

    final attrsData = (map['attributes'] as List<dynamic>?)
        ?.cast<Map<String, dynamic>>() ??
        const [];

    List<AttributeTemplateMeta> attrs;

    if (attrsData.isNotEmpty) {
      attrs = attrsData
          .map(
            (a) => AttributeTemplateMeta(
          name: a['name'] as String? ?? '',
          maxStars: a['maxStars'] as int?,
        ),
      )
          .toList();
    } else {
      final fieldsCount = map['fieldsCount'] as int? ?? 1;
      attrs = List.generate(
        fieldsCount,
            (_) => AttributeTemplateMeta(
          maxStars: type == FieldType.starsAttribute ? 5 : null,
        ),
      );
    }

    return Section(
      name: map['name'] as String? ?? 'Sekcja',
      type: type,
      hasCheckboxes: hasCheckboxes,
      attributes: attrs,
    );
  }

  static Widget _createField(FieldType type, bool hasCheckbox,AttributeTemplateMeta meta) {
    switch (type) {
      case FieldType.textAttribute:
        return AttributeTextField(
          isTemplate: true,
          textKey: meta.name,
          onKeyChanged: (key) => meta.name = key,
        );
      case FieldType.numberAttribute:
        return AttributeNumberField(
          isTemplate: true,
          text: meta.name,
          hasCheckbox: hasCheckbox,
          onKeyChanged: (key) => meta.name = key,
        );
      case FieldType.starsAttribute:
        return AttributeStarsField(
          isTemplate: true,
          text: meta.name,
          totalStars: meta.maxStars ?? 5,
          hasCheckbox: hasCheckbox,
          onTextChanged: (text) => meta.name = text,
          onStarsChanged: (stars) => meta.maxStars = stars,
        );
      case FieldType.textField:
        return SimpleTextField(
          isEditable: true,
          text: meta.name,
          onChanged: (text) => meta.name = text,
        );
    }
  }

  void addField() {
    final meta = AttributeTemplateMeta(
      maxStars: type == FieldType.starsAttribute ? 5 : null,
    );
    attributes.add(meta);
    fields.add(_createField(type, hasCheckboxes, meta));
  }

  void removeField(int index) {
    attributes.removeAt(index);
    fields.removeAt(index);
  }
}

/// Widget karty sekcji
class SectionCard extends StatelessWidget {
  final int index;
  final Section section;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onAddField;
  final Function(int fieldIndex) onRemoveField;

  const SectionCard({
    super.key,
    required this.index,
    required this.section,
    required this.isExpanded,
    required this.onToggleExpanded,
    required this.onEdit,
    required this.onDelete,
    required this.onAddField,
    required this.onRemoveField,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isExpanded
              ? BorderSide(color: colorScheme.primary, width: 2)
              : BorderSide(
            color: colorScheme.outlineVariant.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // Nagłówek sekcji
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ReorderableDragStartListener(
                    index: index,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.drag_handle,
                        color: colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                    ),
                  ),
                ),

                // Reszta nagłówka - klikalny obszar
                Expanded(
                  child: InkWell(
                    onTap: onToggleExpanded,
                    borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Ikona typu
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              section.type.icon,
                              color: colorScheme.onPrimaryContainer,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Nazwa i typ
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  section.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${section.type.label} • ${section.fields.length} ${section.fields.length == 1 ? 'pole' : 'pól'}',
                                  style: TextStyle(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Akcje
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 20),
                                onPressed: onEdit,
                                tooltip: 'Zmień nazwę',
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  size: 20,
                                  color: colorScheme.error,
                                ),
                                onPressed: onDelete,
                                tooltip: 'Usuń sekcję',
                              ),
                              Icon(
                                isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: colorScheme.primary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Rozwijana zawartość
            if (isExpanded) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pola
                    ...List.generate(section.fields.length, (fieldIndex) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(child: section.fields[fieldIndex]),
                            if (section.fields.length > 1) ...[
                              const SizedBox(width: 8),
                              IconButton(
                                icon: Icon(
                                  Icons.remove_circle_outline,
                                  color: colorScheme.error,
                                ),
                                onPressed: () => onRemoveField(fieldIndex),
                                tooltip: 'Usuń pole',
                              ),
                            ],
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 8),

                    // Przycisk dodania pola
                    OutlinedButton.icon(
                      onPressed: onAddField,
                      icon: const Icon(Icons.add),
                      label: const Text('Dodaj kolejne pole'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 44),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}