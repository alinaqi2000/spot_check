import 'package:get/get.dart';
import 'package:spot_check/store/controllers/auth.controller.dart';
import 'package:spot_check/store/models/location.model.dart';
import 'package:spot_check/store/services/location.service.dart';

class LocationController extends GetxController {
  static LocationController get to => Get.find();
  Rx<Location> currentLocation = Rx(Location.empty());
  RxDouble radius = 50.0.obs;
  RxBool performingAction = false.obs;
  RxString stage = "select_location".obs;
  RxDouble sheetHeight = 275.0.obs;
  late LocationService _locationService;
  LocationController() {
    _locationService = LocationService();
  }
  void gotoSelectLocation() {
    stage.value = 'select_location';
    sheetHeight.value = 275.0;
  }

  void gotoSelectAction(double height) {
    stage.value = 'select_action';
    sheetHeight.value = height - 150.0;
  }

  Stream<List<Location>> loadLocations() {
    AuthController authController = AuthController.to;
    return _locationService!.findAll(authController.user.value!.uid);
  }

  void setLocationAction(String feature, String key, dynamic val) {
    var featureMap =
        Map<String, dynamic>.of(currentLocation.value.actions[feature] ?? {});
    featureMap.putIfAbsent(key, () => val);
    featureMap.update(key, (value) => val);
    var actionsMap = Map.of(currentLocation.value.actions);
    actionsMap.putIfAbsent(feature, () => featureMap);
    actionsMap.update(feature, (value) => featureMap);

    currentLocation.value.actions = actionsMap;

    currentLocation.refresh();
  }

  void addLocation() async {
    try {
      performingAction.value = true;
      AuthController authController = AuthController.to;
      currentLocation.value.userId = authController.user.value!.uid;
      var location = await _locationService!.addOne(currentLocation.value);
      Get.snackbar("Success", location.title,
          snackPosition: SnackPosition.BOTTOM);
      performingAction.value = false;
      Get.offAllNamed("/");
    } catch (e) {
      performingAction.value = false;
      Get.snackbar("Error!", "Something went wrong, please try later.",
          snackPosition: SnackPosition.BOTTOM);
      print(e.toString());
    }
  }

  RxList<Location> locations = <Location>[
    Location(
        id: "123",
        userId: "324324324",
        title: "The University Of Lahore",
        mapTitle: "University of Lahore",
        address: "Defence road",
        radius: 0,
        latitude: 23423423.2,
        longitude: 23423423234.2),
    Location(
        id: "124",
        userId: "324324324",
        title: "Workspace",
        address: "Gulberg",
        mapTitle: "Zairone Solutions",
        radius: 0,
        latitude: 23423423.2,
        longitude: 23423423234.2),
    Location(
        id: "125",
        userId: "324324324",
        title: "Home",
        address: "Green Town",
        mapTitle: "Green Town",
        radius: 0,
        latitude: 23423423.2,
        longitude: 23423423234.2)
  ].obs;
}
