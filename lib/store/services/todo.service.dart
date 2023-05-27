import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spot_check/store/models/todo.model.dart';

class TodoService {
  CollectionReference todosRef = FirebaseFirestore.instance.collection("todos");
  Stream<List<Todo>> findAll(userId) {
    return todosRef.where("user_id", isEqualTo: userId).get().then((value) {
      return value.docs.map((e) => Todo.fromSnapshot(e)).toList();
    }).asStream();
    //Here we are converting the firebase snapshot to a stream of user todo list.
  }

  Future<Todo> findOne(String id) async {
    var result = await todosRef.doc(id).get();
    return Todo.fromSnapshot(result);
  }

  Future<Todo> addOne(String userId, String title, {bool done = false}) async {
    var result =
        await todosRef.add({"user_id": userId, "title": title, "done": done});
    return Todo(id: result.id, title: title, done: done, userId: "");
  }

  Future<void> updateOne(Todo todo) async {
    todosRef.doc(todo.id).update(todo.toJson());
  }

  deleteOne(String id) {
    todosRef.doc(id).delete();
  }
}
