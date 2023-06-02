import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spot_check/screens/dashboard/home_screen.dart';
import 'package:spot_check/screens/dashboard/notifications_screen.dart';

class AppController extends GetxController {
  static AppController get to => Get.find();

  var currentIndex = 0.obs;

  final pages = <String>['/home', '/notifications'];

  void changePage(int index) {
    currentIndex.value = index;
    Get.offAllNamed(pages[index], id: 1);
  }

  Route? onGenerateRoute(RouteSettings settings) {
    if (settings.name == '/home') {
      return GetPageRoute(
        settings: settings,
        page: () => const HomeScreen(),
      );
    }
    if (settings.name == '/notifications') {
      return GetPageRoute(
        settings: settings,
        page: () => const NotidicationScreen(),
      );
    }

    return null;
  }
}
