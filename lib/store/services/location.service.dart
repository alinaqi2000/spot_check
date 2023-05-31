import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spot_check/store/models/location.model.dart';
import 'package:localstorage/localstorage.dart';

class LocationService {
  CollectionReference locationsRef =
      FirebaseFirestore.instance.collection("locations");
  Stream<List<Location>> findAll(userId) {
    final LocalStorage storage = LocalStorage('local_locs');

    return locationsRef
        .where("userId", isEqualTo: userId)
        .get()
        .then((value) async {
      var items = value.docs.map((e) => Location.fromSnapshot(e)).toList();
      await storage.ready;
      await storage.setItem('local_locations', items);
      return items;
    }).asStream();
    //Here we are converting the firebase snapshot to a stream of user todo list.
  }

  Future<Location> findOne(String id) async {
    var result = await locationsRef.doc(id).get();
    return Location.fromSnapshot(result);
  }

  Future<Location> addOne(Location location, {bool done = false}) async {
    var result = await locationsRef.add(location.toJson());
    return location;
  }

  Future<void> updateOne(Location location) async {
    locationsRef.doc(location.id).update(location.toJson());
  }

  deleteOne(String id) {
    locationsRef.doc(id).delete();
  }
}
