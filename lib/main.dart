import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spot_check/constants/colors.dart';
import 'package:spot_check/store/controllers/auth.controller.dart';
import 'package:spot_check/widgets/snackbar_global.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'package:spot_check/routes/app.routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthController authController = Get.put<AuthController>(AuthController());

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scaffoldMessengerKey: SnackbarGlobal.key,
      theme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          colorSchemeSeed: AppColors.primary,
          textTheme: GoogleFonts.palanquinDarkTextTheme(const TextTheme(
            displayLarge: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
            titleLarge: TextStyle(fontSize: 24),
            bodyMedium: TextStyle(
              fontSize: 14.0,
            ),
          ))),
      initialRoute: "/splashscreen",
      getPages: AppRoutes.routes,
    );
  }
}
