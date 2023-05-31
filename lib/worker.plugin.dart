import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:spot_check/store/models/notification.dart';
import 'package:spot_check/utils/geolocation.dart';
import 'package:volume_control/volume_control.dart';
import 'package:workmanager/workmanager.dart';

const locationBasedAction = "locationBasedAction";

// @pragma('vm:entry-point')
void callbackDispatcher() async {
  List<dynamic> actionsPerformed = [];
  Workmanager().executeTask((task, inputData) async {
    print(task);
    switch (task) {
      case locationBasedAction:
        final LocalStorage locStorage = LocalStorage('local_locs');
        await locStorage.ready;
        final LocalStorage userStorage = LocalStorage('local_user');
        await userStorage.ready;
        final userId = userStorage.getItem("local_storage_id");

        List<dynamic>? localLocations =
            await locStorage.getItem("local_locations");
        if (localLocations != null && localLocations.isNotEmpty) {
          Position userLocation = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);

          for (var location in localLocations) {
            final distance =
                AppGeolocator.getLocationDistance(location, userLocation);
            if (distance <= location['radius']) {
              if (location.containsKey("actions") &&
                  location['actions'] != null) {
                await location['actions'].forEach((actionName, action) async {
                  switch (actionName) {
                    case "volume":
                      if ((action as Map).containsKey("mute") &&
                          action['mute']) {
                        await VolumeControl.setVolume(0.0);
                        actionsPerformed.add(Notification(
                            id: (actionsPerformed.length + 1).toString(),
                            userId: userId,
                            locationId: "loc1",
                            title: "Volume muted",
                            description:
                                "You reached inside the ${AppGeolocator.kmtoMString(distance)} of ${location['title']}",
                            dateTime: DateTime.now(),
                            latitude: userLocation.latitude,
                            longitude: userLocation.longitude,
                            type: NotificationType.volume));
                      } else if (action.containsKey("value")) {
                        await VolumeControl.setVolume(action['value'] / 100);
                        actionsPerformed.add(jsonDecode(jsonEncode(Notification(
                                id: (actionsPerformed.length + 1).toString(),
                                userId: userId,
                                locationId: "loc1",
                                title:
                                    "Volume reduced to ${action['value'].round()}",
                                description:
                                    "You were ${AppGeolocator.kmtoMString(distance)} away from ${location['title']}",
                                dateTime: DateTime.now(),
                                latitude: userLocation.latitude,
                                longitude: userLocation.longitude,
                                type: NotificationType.volume)
                            .toJson())));
                        print(actionsPerformed);
                      }
                      break;
                    default:
                  }
                });
              }
            }
          }
        }

        break;
    }

    final LocalStorage notiStorage = LocalStorage('local_notis');
    await notiStorage.ready;
    await notiStorage.setItem('local_notifications', actionsPerformed);
    print(actionsPerformed);

    for (var noti in actionsPerformed) {
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
        id: 136,
        channelKey: "location_actions",
        title: noti['title'],
        body: noti['description'],
      ));
    }

    return Future.value(true);
  });
}
