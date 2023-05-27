import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spot_check/store/controllers/todo.controller.dart';
import 'package:spot_check/store/models/todo.model.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  const TodoItem(this.todo, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: GestureDetector(
        onTap: () {
          Get.toNamed("/todos/${todo.id}/edit");
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: todo.done ? Colors.grey : Colors.green[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  Text(todo.title),
                ]),
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        TodoController.to
                            .updateTodo(todo.copyWith(done: !todo.done));
                      },
                      child: !todo.done
                          ? const Icon(Icons.check_box_outline_blank)
                          : const Icon(Icons.check_box),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () {
                          TodoController.to.deleteTodo(todo.id);
                        },
                        child: const Icon(Icons.cancel)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
