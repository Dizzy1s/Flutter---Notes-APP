import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app/MVVM/model.dart';

class NoteViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fetch Notes
  Stream<List<Note>> fetchNotes() {
    User? user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Note.fromMap(doc.data())).toList());
  }

  // Add Note
  Future<void> addNote(String title, String content) async {
    User? user = _auth.currentUser;
    if (user == null) return;

    DocumentReference docRef =
        _firestore.collection('users').doc(user.uid).collection('notes').doc();

    Note newNote = Note(
      noteId: docRef.id,
      title: title,
      content: content,
      createdAt: DateTime.now(),
    );

    await docRef.set(newNote.toMap());
  }

  // Update Note
  Future<void> updateNote(Note note) async {
    User? user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .doc(note.noteId)
        .update(note.toMap());
  }

  // Delete Note
  Future<void> deleteNote(String noteId) async {
    User? user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .doc(noteId)
        .delete();
  }
}
