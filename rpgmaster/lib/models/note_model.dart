class NoteModel {
  final String id;
  final String title;
  final String content;
  final String userId;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.userId,
  });

  factory NoteModel.fromMap(String id, Map<String, dynamic> data) {
    return NoteModel(
      id: id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      userId: data['userId'] ?? '',
    );
  }
}
