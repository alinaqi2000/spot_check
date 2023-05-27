import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spot_check/store/services/auth.service.dart';
import 'package:spot_check/store/enums/signin_enum.dart';

class AuthController extends GetxController {
  static AuthController to = Get.find();
  RxBool isLogged = false.obs;
  late AuthService _authService;
  Rx<User?> user = Rx<User?>(null);

  AuthController() {
    _authService = AuthService();
  }

  @override
  void onInit() async {
    ever(isLogged, handleAuthChanged);
    user.value = await _authService.getCurrentUser();
    isLogged.value = user.value != null;
    _authService.onAuthChanged().listen((event) {
      isLogged.value = event != null;
      user.value = event;
    });

    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  handleAuthChanged(isLoggedIn) {
    if (isLoggedIn == false) {
      Get.offAllNamed("/login");
    } else {
      Get.offAllNamed("/");
    }
  }

  handleSignIn() async {
    try {
      await _authService.signInWithGoogle();
    } catch (e) {
      Get.back();
      Get.defaultDialog(title: "Error", middleText: e.toString(), actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("Close"),
        ),
      ]);
      print(e);
    }
  }

  handleSignOut() {
    _authService.firebaseAuth.signOut();
  }
}
