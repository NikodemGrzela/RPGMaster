import 'package:cloud_firestore/cloud_firestore.dart';

class Campaign {
  final String id;
  final String userId;
  final String title;
  final int? tetra;
  final int? hexa;
  final int? octa;
  final int? deca;
  final int? dodeca;
  final int? icosa;
  final DateTime? createdAt;

  const Campaign({
    required this.id,
    required this.userId,
    required this.title,
    this.tetra,
    this.hexa,
    this.octa,
    this.deca,
    this.dodeca,
    this.icosa,
    this.createdAt,
  });

  /// Tworzy obiekt Campaign z mapy
  factory Campaign.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Campaign(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['Title'] ?? '',
      tetra: _toInt(data['Tetra']),
      hexa: _toInt(data['Hexa']),
      octa: _toInt(data['Octa']),
      deca: _toInt(data['Deca']),
      dodeca: _toInt(data['Dodeca']),
      icosa: _toInt(data['Icosa']),
      createdAt: _toDateTime(data['CreatedAt']),
    );
  }

  /// Zamienia obiekt Campaign na mapę
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'Title': title,
      'Tetra': tetra,
      'Hexa': hexa,
      'Octa': octa,
      'Deca': deca,
      'Dodeca': dodeca,
      'Icosa': icosa,
      'CreatedAt': createdAt?.toIso8601String(),
    };
  }

  /// Tworzy nowy obiekt na podstawie istniejącego, nadpisując wybrane pola
  Campaign copyWith({
    String? id,
    String? userId,
    String? title,
    int? tetra,
    int? hexa,
    int? octa,
    int? deca,
    int? dodeca,
    int? icosa,
    DateTime? createdAt,
  }) {
    return Campaign(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      tetra: tetra ?? this.tetra,
      hexa: hexa ?? this.hexa,
      octa: octa ?? this.octa,
      deca: deca ?? this.deca,
      dodeca: dodeca ?? this.dodeca,
      icosa: icosa ?? this.icosa,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Campaign('
        'id: $id, userId: $userId, title: $title, '
        'tetra: $tetra, hexa: $hexa, octa: $octa, '
        'deca: $deca, dodeca: $dodeca, icosa: $icosa, '
        'createdAt: $createdAt'
        ')';
  }

  // --- Pomocnicze metody prywatne ---
  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
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
