import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note_model.dart';

/// Strumień notatek zalogowanego użytkownika
final userNotesProvider = StreamProvider.family<List<NoteModel>, String>((ref, campaignId) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return Stream.value([]);
  }

  final query = FirebaseFirestore.instance
      .collection('notes')
      .where('campaignId', isEqualTo: campaignId)
      .where('userId', isEqualTo: user.uid)
      .orderBy('createdAt', descending: true);

  return query.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      return NoteModel.fromMap(doc.id, doc.data());
    }).toList();
  });
});

/// Provider dla akcji (dodawanie, edycja, usuwanie)
// final notesActionsProvider = Provider((ref) => NotesActions());

final notesActionsProvider =
Provider.family<NotesActions, String>((ref, campaignId) {
return NotesActions(campaignId);
});

class NotesActions {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final String campaignId;

  NotesActions(this.campaignId);

  CollectionReference<Map<String, dynamic>> get _notesRef =>
      _firestore.collection('notes');

  Future<void> addNote(String title, String content) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _notesRef.add({
      'userId': user.uid,
      'campaignId': campaignId,
      'title': title,
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> editNote(String id, String title, String content) async {
    await _notesRef.doc(id).update({
      'title': title,
      'content': content,
    });
  }

  Future<void> deleteNote(String id) async {
    await _notesRef.doc(id).delete();
  }
}
