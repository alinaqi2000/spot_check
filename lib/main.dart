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
import 'package:geolocator/geolocator.dart';
import 'package:volume_control/volume_control.dart';
import 'package:permission_handler/permission_handler.dart';

final flNotiPlugin = FlutterLocalNotificationsPlugin();

const fetchBackground = "fetchBackground";
// @pragma('vm:entry-point')
void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     try {
//       final flNotiPlugin = FlutterLocalNotificationsPlugin();
//       // Noti.initialize(flNotiPlugin).then((value) async {
//       Noti.showBigTextNotification(
//               title: "NotiTitle",
//               body: "this is test message body",
//               id: "un123",
//               fln: flNotiPlugin)
//           .then((value) => {print(value)})
//           .catchError((error) => {print(error)});
//       // });
//       print("Native called background task: $fetchBackground");
//     } catch (e) {
//       print(e.toString());
//     }
// //simpleTask will be emitted here.
//     return Future.value(true);
//   });
  Workmanager().executeTask((task, inputData) async {
    print(task);
    switch (task) {
      case fetchBackground:
        // final LocalStorage storage = LocalStorage('local_locs');
        // await storage.ready;
        // print(await storage.getItem("local_locations"));
        Position userLocation = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        await VolumeControl.setVolume(0.0);
        print(userLocation);
        Get.snackbar("Success", userLocation.toString(),
            snackPosition: SnackPosition.BOTTOM);
        break;
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );

  await Noti.initialize(flNotiPlugin);
  // await AwesomeNotifications()
  //     .initialize("resource://mipmap-hdpi/ic_launcher", [
  //   NotificationChannel(
  //       channelKey: "test_channel",
  //       channelName: "Test Channel",
  //       channelDescription: "This is a test channel")
  // ]);
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
    // AwesomeNotifications().isNotificationAllowed().then((value) async {

    Workmanager().registerOneOffTask(
      "3453451",
      fetchBackground,
      // existingWorkPolicy: ExistingWorkPolicy.append,
    );
    Position userLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final LocalStorage storage = LocalStorage('local_locs');
    await storage.ready;
    List<dynamic> locations = storage.getItem("local_locations");
    for (var loc in locations) {
      double dis = Geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        loc.latitude,
        loc.longitude,
      );
      print(dis);
    }
    // });
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
