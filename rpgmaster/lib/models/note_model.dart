import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String id;
  final String title;
  final String content;
  final String userId;
  final String campaignId;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.userId,
    required this.campaignId,
  });

  factory NoteModel.fromMap(String id, Map<String, dynamic> data) {
    return NoteModel(
      id: id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      userId: data['userId'] ?? '',
      campaignId: data['campaignId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'title': title,
    'content': content,
    'userId': userId,
    'campaignId': campaignId,
    'createdAt': FieldValue.serverTimestamp(),
  };
}
