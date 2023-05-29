import 'package:cloud_firestore/cloud_firestore.dart';

class Location {
  String id;
  String title;
  String mapTitle;
  String address;
  double latitude;
  double longitude;
  String userId;

  Location({
    required this.id,
    required this.userId,
    required this.title,
    required this.address,
    required this.mapTitle,
    required this.latitude,
    required this.longitude,
  });
  copyWith({title, mapTitle, address, latitude, longitude}) {
    return Location(
      id: id,
      userId: userId,
      title: title ?? this.title,
      mapTitle: mapTitle ?? this.mapTitle,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  factory Location.fromSnapshot(DocumentSnapshot snap) {
    return Location(
      id: snap.id,
      title: snap.get("title"),
      mapTitle: snap.get("mapTitle"),
      address: snap.get("address"),
      latitude: snap.get("latitude"),
      longitude: snap.get("longitude"),
      userId: "",
    );
  }
  factory Location.empty() {
    return Location(
      id: "",
      title: "",
      mapTitle: "",
      address: "",
      latitude: 0.0,
      longitude: 0.0,
      userId: "",
    );
  }

  toJson() {
    return {
      "title": title,
      "mapTitle": mapTitle,
      "address": address,
      "latitude": latitude,
      "longitude": longitude
    };
  }
}
