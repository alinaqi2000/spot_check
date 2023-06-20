import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:spot_check/constants/colors.dart';
import 'package:spot_check/constants/constraints.dart';
import 'package:spot_check/screens/dashboard/partial/app_bar.dart';
import 'package:spot_check/store/controllers/auth.controller.dart';
import 'package:spot_check/store/controllers/notification.controller.dart';
import 'package:spot_check/widgets/components.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotidicationScreen extends StatefulWidget {
  const NotidicationScreen({super.key});

  @override
  State<NotidicationScreen> createState() => _NotidicationScreenState();
}

class _NotidicationScreenState extends State<NotidicationScreen> {
  AuthController authController = AuthController.to;
  NotificationController nC = Get.put(NotificationController());
  int _counter = 0;
  static const platform = MethodChannel('example.com/channel');

  @override
  void initState() {
    super.initState();
  }

  void invokeNative() async {
    int random;
    try {
      random = await platform.invokeMethod('getRandomNumber');
    } on PlatformException catch (e) {
      random = 0;
    }
    setState(() {
      _counter = random;
    });
  }

  Widget notificationIcon(String type) {
    switch (type) {
      case "NotificationType.silentMode":
        return const Icon(Icons.volume_off);
      case "NotificationType.volumeMute":
        return const Icon(Icons.volume_mute);
      case "NotificationType.vibrationMode":
        return const Icon(Icons.vibration);
      case "NotificationType.airplaneModeOn":
        return const Icon(Icons.airplanemode_active);
      case "NotificationType.airplaneModeOff":
        return const Icon(Icons.airplanemode_inactive);
      case "NotificationType.wifiOn":
        return const Icon(Icons.network_wifi);
      case "NotificationType.wifiOff":
        return const Icon(Icons.wifi_off);
      default:
        return const Icon(Icons.volume_up);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width =
        MediaQuery.of(context).size.width - (AppConstraints.hSpace * 2);
    return Scaffold(
        appBar: DashboardAppBar(title: const Text("Notifications")),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () => invokeNative(),
        //   label: const PromText(text: "InVoke Native"),
        //   icon: const Icon(Icons.notification_add),
        // ),
        body: Obx(() => nC.notifications.isEmpty
            ? Center(
                child: Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Lottie.asset("assets/lottie/empty_notifications.json",
                        height: 250),
                    const PromText(text: "No notifications yet!")
                  ],
                ),
              )
            : ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemCount: nC.notifications.length,
                itemBuilder: (context, index) {
                  final dateTime = DateTime.parse(
                      nC.notifications[index]!['dateTime'] ??
                          DateTime.now().toString());

                  return Padding(
                    padding: EdgeInsets.only(
                        left: AppConstraints.hSpace,
                        right: AppConstraints.hSpace,
                        top: (index == 0) ? 20.0 : 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(2, 2),
                              blurRadius: 14,
                              color: Color.fromRGBO(33, 10, 15, 0.75),
                            )
                          ],
                          borderRadius: const BorderRadius.only(
                              topLeft:
                                  Radius.circular(AppConstraints.borderRadius),
                              topRight:
                                  Radius.circular(AppConstraints.borderRadius),
                              bottomLeft:
                                  Radius.circular(AppConstraints.borderRadius),
                              bottomRight:
                                  Radius.circular(AppConstraints.borderRadius)),
                          gradient: LinearGradient(
                            colors: [AppColors.primary2, AppColors.themeColor],
                            stops: const [0.6, 1],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )),
                      child: ListTile(
                        title: PromText(text: nC.notifications[index]['title']),
                        leading: CircleAvatar(
                            backgroundColor: AppColors.themeColor,
                            child: notificationIcon(
                                nC.notifications[index]['type'])),
                        subtitle: ParaText(
                            text: nC.notifications[index]['description']),
                        dense: true,
                        trailing: ParaText(
                            text: timeago.format(dateTime,
                                locale: "en_short", allowFromNow: true)),
                      ),
                    ),
                  );
                })));
  }
}
