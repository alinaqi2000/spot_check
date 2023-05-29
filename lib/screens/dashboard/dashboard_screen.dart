import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spot_check/constants/colors.dart';
import 'package:spot_check/store/controllers/app.controller.dart';

class DashboardBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AppController());
  }
}

class DashboardScreen extends GetView<AppController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: Get.nestedKey(1),
        initialRoute: '/home',
        onGenerateRoute: controller.onGenerateRoute,
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: AppColors.secondaryBg,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
          ],
          currentIndex: controller.currentIndex.value,
          selectedItemColor: AppColors.primary,
          onTap: controller.changePage,
        ),
      ),
    );
  }
}
