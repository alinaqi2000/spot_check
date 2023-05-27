import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spot_check/store/controllers/todo.controller.dart';
import 'package:spot_check/store/models/todo.model.dart';
import 'package:spot_check/widgets/components.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController titleController = TextEditingController();
  Todo? todo;

  @override
  void initState() {
    print(Get.parameters);
    if (Get.parameters != null) {
      var id = Get.parameters["id"];
      if (id != null) {
        TodoController.to.loadDetails(id).then((value) => setState(() {
              todo = value;
              titleController.text = value.title;
            }));
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const PromText(text: "Add Todo"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: "Add title",
                border: OutlineInputBorder(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  if (titleController.text != "") {
                    if (todo != null) {
                      todo?.title = titleController.text;
                      TodoController.to.updateTodo(todo!);
                      titleController.clear();
                    } else {
                      TodoController.to.addTodo(titleController.text);
                      titleController.clear();
                    }
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * .6,
                  height: 50,
                  color: Colors.blue,
                  child: const Center(
                    child: Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Obx(
              () => TodoController.to.isAddingTodo.value
                  ? const Center(
                      child: CircularProgressIndicator(
                      backgroundColor: Colors.green,
                    ))
                  : Container(),
            )
          ],
        ),
      ),
    );
  }
}
