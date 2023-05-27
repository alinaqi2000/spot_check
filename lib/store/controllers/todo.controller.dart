import 'package:get/get.dart';
import 'package:spot_check/store/controllers/auth.controller.dart';
import 'package:spot_check/store/models/todo.model.dart';
import 'package:spot_check/store/services/todo.service.dart';

class TodoController extends GetxController {
  static TodoController to = Get.find();
  RxList todos = [].obs; // Observable of the user todo list
  RxBool isLoadingTodos = false.obs;
  RxBool isAddingTodo = false.obs;
  RxBool isLoadingDetails = false.obs;
  late Todo activeTodo;
  late TodoService _todoService;
  TodoController() {
    _todoService = TodoService();
  }

  onInit() {
    //here we tell todos to stream from the load todos method.
    todos.bindStream(loadTodos());
  }

  Stream<List<Todo>> loadTodos() {
    AuthController authController = AuthController.to;
    return _todoService!.findAll(authController.user.value!.uid);
  }

  Future<Todo> loadDetails(String id) async {
    isLoadingDetails.value = true;
    activeTodo = await _todoService!.findOne(id);
    print(activeTodo);
    isLoadingDetails.value = false;
    return activeTodo;
  }

  addTodo(String title) async {
    try {
      AuthController authController = AuthController.to;
      isAddingTodo.value = true;
      var todo =
          await _todoService!.addOne(authController.user.value!.uid, title);
      todos.add(todo);
      Get.snackbar("Success", todo.title, snackPosition: SnackPosition.BOTTOM);
      isAddingTodo.value = false;
    } catch (e) {
      isAddingTodo.value = false;
      print(e);
    }
  }

  updateTodo(Todo todo) async {
    try {
      isAddingTodo.value = true;
      await _todoService!.updateOne(todo);
      int index = todos.indexWhere((element) => element.id == todo.id);

      todos[index] = todo;
      print(todos);
      Get.snackbar("Success", " updated", snackPosition: SnackPosition.BOTTOM);
      isAddingTodo.value = false;
    } catch (e) {
      isAddingTodo.value = false;
      print(e);
    }
  }

  deleteTodo(String id) async {
    try {
      await _todoService!.deleteOne(id);
      int index = todos.indexWhere((element) => element.id == id);
      todos.removeAt(index);
      Get.snackbar("Success", "Deleted", snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      print(e);
    }
  }
}
