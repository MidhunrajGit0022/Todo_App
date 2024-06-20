import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  final String id;
  final String title;
  final String description;
  final String? currentTime;
  bool isChecked;

  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.currentTime,
    this.isChecked  = false,
  });

  factory TodoModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return TodoModel(
      id: snapshot.id,
      title: data['title'] ?? '',
      description: data['description'].toString(),
      currentTime: data['currentTime'],
      isChecked: data['isChecked'] ?? false,
    );
  }


}
