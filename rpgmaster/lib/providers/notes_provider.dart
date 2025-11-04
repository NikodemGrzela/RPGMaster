import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note_model.dart';

/// Strumień notatek zalogowanego użytkownika
final userNotesProvider = StreamProvider<List<NoteModel>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    // użytkownik nie jest zalogowany → zwracamy pustą listę
    return Stream.value([]);
  }

  final query = FirebaseFirestore.instance
      .collection('notes')
      .where('userId', isEqualTo: user.uid)
      .orderBy('createdAt', descending: true);

  return query.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      return NoteModel.fromMap(doc.id, doc.data());
    }).toList();
  });
});

/// Provider dla akcji (dodawanie, edycja, usuwanie)
final notesActionsProvider = Provider((ref) => NotesActions());

class NotesActions {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> addNote(String title, String content) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _firestore.collection('notes').add({
      'userId': user.uid,
      'title': title,
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> editNote(String id, String title, String content) async {
    await _firestore.collection('notes').doc(id).update({
      'title': title,
      'content': content,
    });
  }

  Future<void> deleteNote(String id) async {
    await _firestore.collection('notes').doc(id).delete();
  }
}
