import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:spot_check/screens/dashboard/partial/app_bar.dart';
import 'package:spot_check/store/controllers/auth.controller.dart';
import 'package:spot_check/widgets/components.dart';

class NotidicationScreen extends StatefulWidget {
  const NotidicationScreen({super.key});

  @override
  State<NotidicationScreen> createState() => _NotidicationScreenState();
}

class _NotidicationScreenState extends State<NotidicationScreen> {
  AuthController authController = AuthController.to;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: DashboardAppBar(),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
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
