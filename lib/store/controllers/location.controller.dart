import 'package:get/get.dart';
import 'package:spot_check/store/models/location.model.dart';

class LocationController extends GetxController {
  static LocationController get to => Get.find();
  Rx<Location> currentLocation = Rx(Location.empty());
  RxList<Location> locations = <Location>[
    Location(
        id: "123",
        userId: "324324324",
        title: "The University Of Lahore",
        mapTitle: "University of Lahore",
        address: "Defence road",
        latitude: 23423423.2,
        longitude: 23423423234.2),
    Location(
        id: "124",
        userId: "324324324",
        title: "Workspace",
        address: "Gulberg",
        mapTitle: "Zairone Solutions",
        latitude: 23423423.2,
        longitude: 23423423234.2),
    Location(
        id: "125",
        userId: "324324324",
        title: "Home",
        address: "Green Town",
        mapTitle: "Green Town",
        latitude: 23423423.2,
        longitude: 23423423234.2)
  ].obs;
}
