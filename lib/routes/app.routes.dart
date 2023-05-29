import 'package:get/get.dart';
import 'package:spot_check/screens/auth/login_screen.dart';
import 'package:spot_check/screens/dashboard/dashboard_screen.dart';
import 'package:spot_check/screens/dashboard/home_screen.dart';
import 'package:spot_check/screens/dashboard/notifications_screen.dart';
import 'package:spot_check/screens/demo/add_todo.dart';
import 'package:spot_check/screens/demo/todos.screen.dart';
import 'package:spot_check/screens/general/settings_screen.dart';
import 'package:spot_check/screens/general/splash_screen.dart';
import 'package:spot_check/screens/location/add_location_screen.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/splashscreen',
      page: () => const SplashScreen(),
    ),
    GetPage(
        name: '/',
        page: () => const DashboardScreen(),
        binding: DashboardBindings()),
    GetPage(
      name: '/home',
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: '/notifications',
      page: () => const NotidicationScreen(),
    ),
    GetPage(
      name: '/add_location',
      page: () => const AddLocation(),
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
    GetPage(
      name: '/settings',
      page: () => const SettingsScreen(),
    ),
  ];
}
