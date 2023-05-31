import 'package:cloud_firestore/cloud_firestore.dart';

class Location {
  String id;
  String title;
  String mapTitle;
  String address;
  double latitude;
  double longitude;
  double radius;
  String userId;
  Map<String, dynamic> actions = {};

  Location({
    required this.id,
    required this.userId,
    required this.title,
    required this.address,
    required this.mapTitle,
    required this.radius,
    required this.latitude,
    required this.longitude,
    this.actions = const {},
  });
  copyWith({title, mapTitle, address, radius, actions, latitude, longitude}) {
    return Location(
      id: id,
      userId: userId,
      title: title ?? this.title,
      mapTitle: mapTitle ?? this.mapTitle,
      address: address ?? this.address,
      radius: radius ?? this.radius,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      actions: actions ?? this.actions,
    );
  }

  factory Location.fromSnapshot(DocumentSnapshot snap) {
    return Location(
      id: snap.id,
      title: snap.get("title"),
      mapTitle: snap.get("mapTitle"),
      address: snap.get("address"),
      radius: snap.get("radius"),
      latitude: snap.get("latitude"),
      longitude: snap.get("longitude"),
      actions: snap.get("actions"),
      userId: "",
    );
  }
  factory Location.empty() {
    return Location(
      id: "",
      title: "",
      mapTitle: "",
      address: "",
      radius: 50.0,
      latitude: 30.3753,
      longitude: 69.3451,
      userId: "",
    );
  }

  toJson() {
    return {
      "actions": actions,
      "title": title,
      "mapTitle": mapTitle,
      "address": address,
      "radius": radius,
      "latitude": latitude,
      "longitude": longitude,
      "userId": userId,
    };
  }
}
