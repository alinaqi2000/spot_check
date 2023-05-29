import 'package:cloud_firestore/cloud_firestore.dart';

enum ActivityType { entered, left }

class Activity {
  String id;
  String title;
  String description;
  String address;
  double latitude;
  double longitude;
  DateTime dateTime;
  String userId;
  String locationId;
  dynamic action;
  ActivityType type;

  Activity({
    required this.id,
    required this.userId,
    required this.locationId,
    required this.title,
    required this.address,
    required this.description,
    required this.dateTime,
    required this.latitude,
    required this.longitude,
    required this.type,
    this.action,
  });
  copyWith({title, description, address, dateTime, type, latitude, longitude}) {
    return Activity(
      id: id,
      userId: userId,
      locationId: locationId,
      title: title ?? this.title,
      description: description ?? this.description,
      address: address ?? this.address,
      dateTime: dateTime ?? this.dateTime,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      type: type ?? this.type,
    );
  }

  factory Activity.fromSnapshot(DocumentSnapshot snap) {
    return Activity(
      id: snap.id,
      title: snap.get("title"),
      description: snap.get("description"),
      address: snap.get("address"),
      latitude: snap.get("latitude"),
      dateTime: snap.get("dateTime"),
      longitude: snap.get("longitude"),
      action: snap.get("action"),
      type: snap.get("type"),
      userId: "",
      locationId: "",
    );
  }

  toJson() {
    return {
      "title": title,
      "description": description,
      "dateTime": dateTime,
      "address": address,
      "latitude": latitude,
      "longitude": longitude,
      "action": action,
      "type": type,
    };
  }
}
