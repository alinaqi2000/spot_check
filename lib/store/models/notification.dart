import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType { wifi, volume, airplaneMode }

class Notification {
  String id;
  String title;
  String description;
  double latitude;
  double longitude;
  DateTime dateTime;
  String userId;
  String locationId;
  NotificationType type;

  Notification({
    required this.id,
    required this.userId,
    required this.locationId,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.latitude,
    required this.longitude,
    required this.type,
  });
  copyWith({title, description, address, dateTime, type, latitude, longitude}) {
    return Notification(
      id: id,
      userId: userId,
      locationId: locationId,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      type: type ?? this.type,
    );
  }

  factory Notification.fromSnapshot(DocumentSnapshot snap) {
    return Notification(
      id: snap.id,
      title: snap.get("title"),
      description: snap.get("description"),
      latitude: snap.get("latitude"),
      dateTime: snap.get("dateTime"),
      longitude: snap.get("longitude"),
      type: snap.get("type"),
      userId: "",
      locationId: "",
    );
  }

  toJson() {
    return {
      "title": title,
      "description": description,
      "dateTime": dateTime.toString(),
      "latitude": latitude,
      "longitude": longitude,
      "type": type.toString(),
    };
  }
}
