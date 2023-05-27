import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String id;
  String title;
  bool done;
  String userId;
  Todo(
      {required this.id,
      required this.userId,
      required this.title,
      required this.done});
  copyWith({title, done}) {
    return Todo(
      id: id,
      title: title ?? this.title,
      userId: userId,
      done: done ?? this.done,
    );
  }

  factory Todo.fromSnapshot(DocumentSnapshot snap) {
    return Todo(
        id: snap.id,
        done: snap.get("data"),
        title: snap.get("title"),
        userId: "");
  }

  toJson() {
    return {"title": title, "done": done};
  }
}
