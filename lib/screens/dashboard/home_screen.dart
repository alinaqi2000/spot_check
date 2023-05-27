import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:spot_check/store/controllers/auth.controller.dart';
import 'package:spot_check/widgets/components.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthController authController = AuthController.to;
  @override
  Widget build(BuildContext context) {
    final userImage = Obx(() => CircleAvatar(
          radius: 30,
          backgroundImage:
              NetworkImage(authController?.user?.value?.photoURL ?? ""),
        ));
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          userImage,
          ElevatedButton(
              onPressed: () {
                Get.toNamed("/todos");
              },
              child: const PromText(text: "Todos Screen")),
          ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: const PromText(text: "Signout"))
        ]),
      ),
    );
  }
}
