import 'dart:convert';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:spot_check/store/models/notification.dart';
import 'package:spot_check/utils/geolocation.dart';
import 'package:volume_control/volume_control.dart';
import 'package:workmanager/workmanager.dart';

const locationBasedAction = "locationBasedAction";

// @pragma('vm:entry-point')
void callbackDispatcher() async {
  List<dynamic> actionsPerformed = [];

  Workmanager().executeTask((task, inputData) async {
    // try {
    print(task);
    switch (task) {
      case locationBasedAction:
        // load storages
        final LocalStorage locStorage = LocalStorage('local_locs');
        await locStorage.ready;
        final LocalStorage userStorage = LocalStorage('local_user');
        await userStorage.ready;
        final userId = userStorage.getItem("local_storage_id");
        dynamic previousLocation = await locStorage.getItem("previousLocation");

        // get local locations
        List<dynamic>? localLocations =
            await locStorage.getItem("local_locations");
        if (localLocations != null && localLocations.isNotEmpty) {
          Position userLocation = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          locStorage.setItem("previousLocation", userLocation);

          for (var location in localLocations) {
            // get distances
            final distance =
                AppGeolocator.getLocationDistance(location, userLocation);
            double previousDistance = -1;
            if (previousLocation != null) {
              previousDistance = AppGeolocator.getLocationDistance(
                  location, previousLocation as Map);
            }

            // check if user has moved on entered in/out of the locations's radius
            print(previousDistance);
            print(distance);
            if ((previousDistance == -1 ||
                    previousDistance > location['radius']) &&
                distance <= location['radius']) {
              if (location.containsKey("actions") &&
                  location['actions'] != null) {
                await location['actions'].forEach((actionName, action) async {
                  switch (actionName) {
                    case "volume":
                      if ((action as Map).containsKey("mute") &&
                          action['mute']) {
                        await VolumeControl.setVolume(0.0);
                        actionsPerformed.add(jsonDecode(jsonEncode(Notification(
                                id: (actionsPerformed.length + 1).toString(),
                                userId: userId,
                                locationId: location['id'] ?? "",
                                title: "Volume muted",
                                description:
                                    "You were ${AppGeolocator.kmtoMString(distance)} away from ${location['title']}",
                                dateTime: DateTime.now(),
                                latitude: userLocation.latitude,
                                longitude: userLocation.longitude,
                                type: NotificationType.volumeMute)
                            .toJson())));
                      } else if (action.containsKey("value")) {
                        await VolumeControl.setVolume(action['value'] / 100);
                        actionsPerformed.add(jsonDecode(jsonEncode(Notification(
                                id: (actionsPerformed.length + 1).toString(),
                                userId: userId,
                                locationId: location['id'] ?? "",
                                title:
                                    "Volume set to ${action['value'].round()}",
                                description:
                                    "You were ${AppGeolocator.kmtoMString(distance)} away from ${location['title']}",
                                dateTime: DateTime.now(),
                                latitude: userLocation.latitude,
                                longitude: userLocation.longitude,
                                type: action['value'] == 0.0
                                    ? NotificationType.volumeMute
                                    : NotificationType.volume)
                            .toJson())));
                      }
                      break;
                    case "sound_mode":
                      if ((action as Map).containsKey("value")) {
                        if (action['value'] != null) {
                          NotificationType type = NotificationType.silentMode;
                          switch (action['value']) {
                            case "normal":
                              await SoundMode.setSoundMode(
                                  RingerModeStatus.normal);
                              type = NotificationType.volume;
                              break;
                            case "silent":
                              await SoundMode.setSoundMode(
                                  RingerModeStatus.silent);
                              type = NotificationType.silentMode;
                              break;
                            case "vibrate":
                              await SoundMode.setSoundMode(
                                  RingerModeStatus.vibrate);
                              type = NotificationType.vibrationMode;
                              break;
                            default:
                          }

                          actionsPerformed.add(jsonDecode(jsonEncode(Notification(
                                  id: (actionsPerformed.length + 1).toString(),
                                  userId: userId,
                                  locationId: location['id'] ?? "",
                                  title: "Sound mode set to ${action['value']}",
                                  description:
                                      "You were ${AppGeolocator.kmtoMString(distance)} away from ${location['title']}",
                                  dateTime: DateTime.now(),
                                  latitude: userLocation.latitude,
                                  longitude: userLocation.longitude,
                                  type: type)
                              .toJson())));
                        }
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
    List<dynamic> previousNotis =
        await (notiStorage.getItem("local_notifications") ?? Future(() => []));
    previousNotis.addAll(actionsPerformed);
    await notiStorage.setItem('local_notifications', previousNotis);
    print(previousNotis);

    for (var noti in actionsPerformed) {
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
        id: Random().nextInt(100),
        channelKey: "location_actions",
        title: noti['title'],
        body: noti['description'],
      ));
    }
    // } catch (e) {
    //   await AwesomeNotifications().createNotification(
    //       content: NotificationContent(
    //     id: Random().nextInt(100),
    //     channelKey: "location_actions",
    //     title: "Error!",
    //     body: e.toString(),
    //   ));
    // }
    return Future.value(true);
  });
}
