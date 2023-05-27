import 'package:get/get.dart';
import 'package:spot_check/screens/auth/login_screen.dart';
import 'package:spot_check/screens/dashboard/home_screen.dart';
import 'package:spot_check/screens/demo/add_todo.dart';
import 'package:spot_check/screens/demo/todos.screen.dart';
import 'package:spot_check/screens/general/splash_screen.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/splashscreen',
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: '/',
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: '/todos',
      page: () => const TodosScreen(),
    ),
    GetPage(
      name: '/add-todo',
      page: () => const AddTodo(),
    ),
    GetPage(
      name: '/login',
      page: () => const LoginScreen(),
    ),
  ];
}
