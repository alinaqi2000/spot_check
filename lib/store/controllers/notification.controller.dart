import 'package:get/get.dart';
import 'package:localstorage/localstorage.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();
  NotificationController() {
    getNotifications();
  }
  RxList<dynamic> notifications = RxList.from([]);
  final LocalStorage storage = LocalStorage('local_notis');

  void setNotification(notification) async {
    await storage.ready;
    notifications.add(notification);
    await storage.setItem('local_notifications', notifications);
  }

  void getNotifications() async {
    await storage.ready;

    notifications.value = await storage.getItem('local_notifications');
    notifications.value = notifications.reversed.toList();
    notifications.refresh();
  }
}
