import 'package:flutter/material.dart';
import 'package:spot_check/constants/assets.dart';
import 'package:spot_check/constants/constraints.dart';
import 'package:spot_check/constants/colors.dart';
import 'package:spot_check/constants/sizes.dart';
import 'package:spot_check/constants/strings.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spot_check/store/controllers/auth.controller.dart';
import 'package:spot_check/store/enums/signin_enum.dart';
import 'package:spot_check/widgets/components.dart';
import 'package:spot_check/widgets/snackbar_global.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = AuthController.to;

  void _googleSignIn() async {
    authController.handleSignIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(AppAssets.brandLogo, height: 34),
        elevation: 2,
        surfaceTintColor: Colors.transparent,
      ),
      body: SizedBox.expand(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppConstraints.hSpace),
          child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                const HeadingText(
                  text: "Welcome to ${AppStrings.appName} 👋",
                ),
                const SizedBox(height: 20),
                const Text(
                  "Manage your mobile features based on your location.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: AppSizes.prominentSize),
                ),
                const Spacer(flex: 1),
                SizedBox(
                  width: 300,
                  child: Lottie.asset('assets/lottie/login_animation.json'),
                ),
                const Spacer(flex: 1),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: ElevatedButton(
                      onPressed: _googleSignIn,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Image.asset(
                                "assets/images/google.png",
                                height: 30,
                              ),
                            ),
                            const Text("Signin to continue")
                          ],
                        ),
                      )),
                )
              ]),
        ),
      ),
    );
  }
}
