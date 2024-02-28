import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart'; // firebaseに接続するパッケージ

class Event {
  final String id;
  final String title;
  final String Date;
  final String Location;

  Event({
    required this.id,
    required this.title,
    required this.Date,
    required this.Location,
  });

  factory Event.fromFirestore(Map<String, dynamic> data) {
    return Event(
      id: data['id'],
      title: data['title'],
      Date: data['Date'],
      Location: data['Location'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'Date': Date,
      'Location': Location,
    };
  }
}

final db = FirebaseFirestore.instance;

void addEvent(String title, String Date, String Location) async {
  final docRef = await db.collection('schedule').add({
    'title': title,
    'Date': Date,
    'Location': Location,
  });
  // スケジュールを追加した後の処理
}
