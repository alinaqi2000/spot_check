import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:localstorage/localstorage.dart';
import 'package:spot_check/constants/colors.dart';
import 'package:spot_check/noti.dart';
import 'package:spot_check/store/controllers/auth.controller.dart';
import 'package:spot_check/widgets/snackbar_global.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'package:spot_check/routes/app.routes.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spot_check/worker.plugin.dart';

final flNotiPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );

  await Noti.initialize(flNotiPlugin);
  await AwesomeNotifications().initialize("resource://drawable/noti", [
    NotificationChannel(
        channelKey: "location_actions",
        channelName: "Location Actions",
        channelDescription: "This is a local channel")
  ]);

  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
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
  void _setNotis() async {
    // Noti.showBigTextNotification(
    //     title: "NotiTitle",
    //     body: "this is test message body",
    //     id: "un123",
    //     fln: flNotiPlugin);
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
      Permission.notification
    ].request();

    Workmanager().registerOneOffTask(
        DateTime.now().toString(), locationBasedAction,
        initialDelay: const Duration(seconds: 5)
        // existingWorkPolicy: ExistingWorkPolicy.append,
        );
  }

  @override
  void initState() {
    super.initState();
    _setNotis();

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
