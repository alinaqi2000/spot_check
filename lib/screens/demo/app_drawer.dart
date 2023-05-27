import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spot_check/store/controllers/auth.controller.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

  final AuthController authController = AuthController.to;
  @override
  Widget build(BuildContext context) {
    User? user = authController.user.value;
    return Drawer(
        child: ListView(
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blueGrey[500],
          ),
          child: Column(
            children: <Widget>[
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      user?.photoURL ?? "",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  user?.email ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
        ListTile(
          onTap: () {
            Get.offAllNamed("/");
          },
          title: const Text("Switch to Snap Sell"),
          trailing: const Icon(Icons.camera),
        ),
        const Divider(),
        ListTile(
          onTap: () {
            Get.offAllNamed("/todos");
          },
          title: const Text("Switch to Todo App"),
          trailing: const Icon(Icons.swap_horizontal_circle),
        ),
        const Divider(),
        ListTile(
          onTap: () {
            authController.handleSignOut();
          },
          title: const Text("Logout"),
          trailing: const Icon(Icons.exit_to_app),
        ),
        const Divider(),
      ],
    ));
  }
}
