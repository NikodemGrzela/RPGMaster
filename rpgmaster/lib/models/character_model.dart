import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rpgmaster/screens/templateCreator/section_card.dart';

class CharacterFieldModel {
  final String? label;
  final String? text;        // tekst / wartość
  final int? number;         // liczba
  final int? filledStars;    // ile gwiazdek wypełnionych
  final int? totalStars;     // max gwiazdek
  final bool? checked;       // checkbox

  const CharacterFieldModel({
    this.label,
    this.text,
    this.number,
    this.filledStars,
    this.totalStars,
    this.checked,
  });

  Map<String, dynamic> toMap() {
    return {
      if (label != null) 'label': label,
      if (text != null) 'text': text,
      if (number != null) 'number': number,
      if (filledStars != null) 'filledStars': filledStars,
      if (totalStars != null) 'totalStars': totalStars,
      if (checked != null) 'checked': checked,
    };
  }

  factory CharacterFieldModel.fromMap(Map<String, dynamic> map) {
    return CharacterFieldModel(
      label: map['label'] as String?,
      text: map['text'] as String?,
      number: _toInt(map['number']),
      filledStars: _toInt(map['filledStars']),
      totalStars: _toInt(map['totalStars']),
      checked: map['checked'] as bool?,
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}

class CharacterSectionModel {
  final String name;
  final FieldType type;
  final bool hasCheckboxes;
  final List<CharacterFieldModel> fields;

  const CharacterSectionModel({
    required this.name,
    required this.type,
    required this.hasCheckboxes,
    required this.fields,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type.name,
      'hasCheckboxes': hasCheckboxes,
      'fields': fields.map((f) => f.toMap()).toList(),
    };
  }

  factory CharacterSectionModel.fromMap(Map<String, dynamic> map) {
    final typeStr = map['type'] as String? ?? FieldType.textAttribute.name;
    final type = FieldType.values.firstWhere(
          (t) => t.name == typeStr,
      orElse: () => FieldType.textAttribute,
    );

    return CharacterSectionModel(
      name: map['name'] as String? ?? 'Sekcja',
      type: type,
      hasCheckboxes: map['hasCheckboxes'] as bool? ?? false,
      fields: (map['fields'] as List<dynamic>? ?? [])
          .map((f) => CharacterFieldModel.fromMap(f as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CharacterModel {
  final String id;           // Firestore doc id
  final String campaignId;      // 🟢 tu jest powiązanie z kampanią
  final String templateId;
  final String characterName;
  final List<CharacterSectionModel> sections;
  final DateTime? createdAt;

  const CharacterModel({
    required this.id,
    required this.campaignId,
    required this.templateId,
    required this.characterName,
    required this.sections,
    this.createdAt,
  });

  CharacterModel copyWith({
    String? id,
    String? campaignId,
    String? templateId,
    String? characterName,
    List<CharacterSectionModel>? sections,
    DateTime? createdAt,
  }) {
    return CharacterModel(
      id: id ?? this.id,
      campaignId: campaignId ?? this.campaignId,
      templateId: templateId ?? this.templateId,
      characterName: characterName ?? this.characterName,
      sections: sections ?? this.sections,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'campaignId': campaignId,
      'templateId': templateId,
      'characterName': characterName,
      'sections': sections.map((s) => s.toMap()).toList(),
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  factory CharacterModel.fromMap(String id, Map<String, dynamic> map) {
    return CharacterModel(
      id: id,
      campaignId: map['campaignId'] as String? ?? '',
      templateId: map['templateId'] as String? ?? '',
      characterName: map['characterName'] as String? ?? 'Bez nazwy',
      sections: (map['sections'] as List<dynamic>? ?? [])
          .map((s) => CharacterSectionModel.fromMap(s as Map<String, dynamic>))
          .toList(),
      createdAt: _toDateTime(map['createdAt']),
    );
  }

  factory CharacterModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CharacterModel.fromMap(doc.id, data);
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }
}
