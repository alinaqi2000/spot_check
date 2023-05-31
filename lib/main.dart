import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spot_check/constants/colors.dart';
import 'package:spot_check/store/controllers/auth.controller.dart';
import 'package:spot_check/widgets/snackbar_global.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'package:spot_check/routes/app.routes.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:volume_control/volume_control.dart';

const fetchBackground = "fetchBackground";
// @pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    print(
        "Native called background task: $fetchBackground"); //simpleTask will be emitted here.
    return Future.value(true);
  });
  // Workmanager().executeTask((task, inputData) async {
  //   print(task);
  //   switch (task) {
  //     case fetchBackground:
  //       // Position userLocation = await Geolocator.getCurrentPosition(
  //       //     desiredAccuracy: LocationAccuracy.high);
  //       print("reduced");
  //       await VolumeControl.setVolume(0.0);
  //       // print(userLocation);
  //       // Get.snackbar("Success", userLocation.toString(),
  //       //     snackPosition: SnackPosition.BOTTOM);
  //       break;
  //   }
  //   return Future.value(true);
  // });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: "test_channel",
        channelName: "Test Channel",
        channelDescription: "This is a test channel")
  ]);
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
  Workmanager().registerOneOffTask(
    "1",
    fetchBackground,
    // existingWorkPolicy: ExistingWorkPolicy.append,
    initialDelay: const Duration(seconds: 2),
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
    AwesomeNotifications().isNotificationAllowed().then((value) {
      if (!value) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scaffoldMessengerKey: SnackbarGlobal.key,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.native,
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
