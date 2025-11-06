import 'package:cloud_firestore/cloud_firestore.dart';
import '../../screens/templateCreator/section_card.dart';

class TemplateSectionModel {
  final String name;
  final FieldType type;
  final bool hasCheckboxes;
  final List<AttributeTemplateMeta> attributes;

  TemplateSectionModel({
    required this.name,
    required this.type,
    required this.hasCheckboxes,
    required this.attributes,
  });

  factory TemplateSectionModel.fromMap(Map<String, dynamic> map) {
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

    return TemplateSectionModel(
      name: map['name'] as String? ?? 'Sekcja',
      type: type,
      hasCheckboxes: hasCheckboxes,
      attributes: attrs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type.name,
      'hasCheckboxes': hasCheckboxes,
      'attributes': attributes.map((a) => a.toMap()).toList(),
    };
  }
}

class TemplateModel {
  final String id;
  final String uid;
  final String name;
  final List<TemplateSectionModel> sections;

  TemplateModel({
    required this.id,
    required this.uid,
    required this.name,
    required this.sections,
  });

  factory TemplateModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return TemplateModel(
      id: doc.id,
      uid: data['uid'] ?? '',
      name: data['name'] ?? 'Bez nazwy',
      sections: (data['sections'] as List<dynamic>? ?? [])
          .map((s) => TemplateSectionModel.fromMap(s))
          .toList(),
    );
  }
}
