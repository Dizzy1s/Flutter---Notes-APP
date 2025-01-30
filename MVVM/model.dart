import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String noteId;
  final String title;
  final String content;
  final DateTime createdAt;

  Note({
    required this.noteId,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  // Convert Firestore data to a Note object
  factory Note.fromMap(Map<String, dynamic> data) {
    return Note(
      noteId: data['noteId'] ?? '',
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Convert a Note object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'noteId': noteId,
      'title': title,
      'content': content,
      'createdAt': createdAt,
    };
  }
}
