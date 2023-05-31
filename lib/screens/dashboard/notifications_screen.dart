import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:spot_check/screens/dashboard/partial/app_bar.dart';
import 'package:spot_check/store/controllers/auth.controller.dart';
import 'package:spot_check/store/controllers/notification.controller.dart';
import 'package:spot_check/widgets/components.dart';
import 'package:spot_check/worker.plugin.dart';

class NotidicationScreen extends StatefulWidget {
  const NotidicationScreen({super.key});

  @override
  State<NotidicationScreen> createState() => _NotidicationScreenState();
}

class _NotidicationScreenState extends State<NotidicationScreen> {
  AuthController authController = AuthController.to;
  NotificationController nC = Get.put(NotificationController());
  String redisData = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: DashboardAppBar(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => callbackDispatcher(),
          label: const PromText(text: "Send Notis"),
          icon: const Icon(Icons.notification_add),
        ),
        body: ListView.builder(
            itemCount: nC.notifications.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: PromText(text: nC.notifications[index]['title']),
              );
            }));
  }
}
