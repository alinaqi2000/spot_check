import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spot_check/constants/colors.dart';
import 'package:spot_check/constants/constraints.dart';
import 'package:spot_check/store/controllers/location.controller.dart';
import 'package:spot_check/widgets/components.dart';
import 'package:spot_check/store/models/location.model.dart' as loc;
import 'package:geocoding/geocoding.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geocode/geocode.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({super.key});

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  Completer<GoogleMapController> mapController = Completer();
  late LocationController lC = Get.put(LocationController.to);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  String googleApikey = "AIzaSyD6NZ764krClK1AQrspchl4PizSKi2seds";

  // LatLng _center = LatLng(9.669111, 80.014007);

  // double _sheetBottomPosition = 150;

  final LatLng _center = const LatLng(9.669111, 80.014007);
  CameraPosition? cameraPosition;

  void _onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);

    // Marker marker = const Marker(
    //   markerId: MarkerId('place_name'),
    //   position: LatLng(9.669111, 80.014007),
    //   // icon: BitmapDescriptor.,
    //   draggable: true,
    //   infoWindow: InfoWindow(
    //     title: 'title',
    //     snippet: 'address',
    //   ),
    // );

    // setState(() {
    //   markers[const MarkerId('place_name')] = marker;
    // });
  }

  @override
  void initState() {
    super.initState();
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR ${error.toString()}");
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          getUserCurrentLocation().then((value) async {
            print("${value.latitude.toString()} ${value.longitude.toString()}");

            // marker added for current users location

            // specified current users location
            CameraPosition cameraPosition = CameraPosition(
              target: LatLng(value.latitude, value.longitude),
              zoom: 14,
            );

            final GoogleMapController controller = await mapController.future;
            controller
                .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setState(() {});
          });
        },
        child: const Icon(Icons.local_activity),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            curve: Curves.fastOutSlowIn,
            duration: const Duration(milliseconds: 250),
            top: 0,
            height: height - (255),
            width: width,
            child: Stack(children: [
              GoogleMap(
                compassEnabled: true,
                markers: markers.values.toSet(),
                mapToolbarEnabled: true,
                onCameraMove: (position) => {
                  cameraPosition = position
                  //   setState(() {
                  //   _sheetBottomPosition = 250;
                  // })
                },
                onCameraIdle: () async {
                  //when map drag stops
                  List<Placemark> placemarks = await placemarkFromCoordinates(
                      cameraPosition!.target.latitude,
                      cameraPosition!.target.longitude);

                  //get place name from lat and lang
                  lC.currentLocation.value = loc.Location(
                      id: "",
                      userId: "",
                      title: placemarks.first.locality.toString(),
                      address: placemarks.first.street.toString(),
                      mapTitle: placemarks.first.administrativeArea.toString(),
                      latitude: cameraPosition!.target.latitude,
                      longitude: cameraPosition!.target.longitude);

                  Marker marker = Marker(
                    markerId: MarkerId(placemarks.first.street.toString()),
                    position: LatLng(cameraPosition!.target.latitude,
                        cameraPosition!.target.longitude),
                    // icon: BitmapDescriptor.,
                    draggable: true,
                    infoWindow: InfoWindow(
                      title: placemarks.first.subLocality.toString(),
                      snippet: placemarks.first.administrativeArea.toString(),
                    ),
                  );

                  setState(() {
                    markers[const MarkerId('place_name')] = marker;
                  });
                },
                onMapCreated: _onMapCreated,
                zoomGesturesEnabled: true, //enable Zoom in, out on map
                mapType: MapType.normal, //map type
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
              ),

              //search autoconplete input
              Positioned(
                  //search input bar
                  top: MediaQuery.of(context).viewPadding.top + 12,
                  child: InkWell(
                      onTap: () async {
                        var place = await PlacesAutocomplete.show(
                            context: context,
                            apiKey: googleApikey,
                            mode: Mode.overlay,
                            types: [],
                            strictbounds: false,
                            // components: [ h Component(Component.country, 'np')],
                            //google_map_webservice package
                            onError: (err) {
                              print(err);
                            });

                        if (place != null) {
                          //form google_maps_webservice package
                          final plist = GoogleMapsPlaces(
                            apiKey: googleApikey,
                            apiHeaders:
                                await const GoogleApiHeaders().getHeaders(),
                            //from google_api_headers package
                          );

                          String placeid = place.placeId ?? "0";
                          final detail =
                              await plist.getDetailsByPlaceId(placeid);
                          final geometry = detail.result.geometry!;
                          final lat = geometry.location.lat;
                          final lang = geometry.location.lng;
                          var newlatlang = LatLng(lat, lang);
                          GeoCode geoCode = GeoCode();
                          Address address = await geoCode.reverseGeocoding(
                              latitude: lat, longitude: lang);

                          lC.currentLocation.value = loc.Location(
                              id: "",
                              userId: "",
                              title: detail.result.name.toString(),
                              address: address.city.toString(),
                              mapTitle: detail.result.name.toString(),
                              latitude: lat,
                              longitude: lang);

                          //move map camera to selected place with animation
                          // GoogleMapController controller =
                          //     await mapController.future;
                          // controller?.animateCamera(
                          //     CameraUpdate.newCameraPosition(CameraPosition(
                          //         target: newlatlang, zoom: 17)));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Card(
                          child: Container(
                              padding: const EdgeInsets.all(0),
                              width: MediaQuery.of(context).size.width - 40,
                              child: ListTile(
                                title: Obx(() => PromText(
                                    text: lC.currentLocation.value.title)),
                                trailing: const Icon(Icons.search),
                                dense: true,
                              )),
                        ),
                      ))),

              AnimatedPositioned(
                  curve: Curves.fastOutSlowIn,
                  duration: const Duration(milliseconds: 250),
                  child: Align(
                    child: Image.asset(
                      "assets/images/marker.png",
                      height: 30,
                    ),
                  )),
            ]),
          ),
          // AnimatedPositioned(
          //     curve: Curves.fastOutSlowIn,
          //     duration: const Duration(milliseconds: 250),
          //     child:),
          AnimatedPositioned(
            curve: Curves.fastOutSlowIn,
            duration: const Duration(milliseconds: 250),
            bottom: 0,
            left: 0,
            width: width,
            height: 275,
            child: SizedBox(
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [AppColors.secondaryBg, AppColors.secondaryBg]),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppConstraints.borderRadius),
                      topRight: Radius.circular(AppConstraints.borderRadius),
                    )),
                child: const Sheet(),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Sheet extends StatefulWidget {
  const Sheet({super.key});

  @override
  State<Sheet> createState() => _SheetState();
}

class _SheetState extends State<Sheet> {
  late LocationController lC = Get.put(LocationController.to);

  double _radius = 20;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(AppConstraints.hSpace),
      child: SizedBox.expand(
          child: Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Wrap(
            spacing: 20,
            direction: Axis.vertical,
            children: [
              Wrap(
                direction: Axis.horizontal,
                spacing: 12,
                children: [
                  InkWell(
                    splashColor: AppColors.dangerBg,
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                  const SectionTitleText(text: "Add Location")
                ],
              ),
              Wrap(
                direction: Axis.horizontal,
                spacing: 8,
                children: [
                  Icon(Icons.location_on, color: AppColors.primary),
                  Obx(() => PromText(
                      text:
                          "${lC.currentLocation.value?.title} - ${lC.currentLocation.value?.address}"))
                ],
              ),
              Wrap(
                spacing: 8,
                direction: Axis.vertical,
                children: [
                  const PromText(text: "Radius (meters)"),
                  SizedBox(
                    height: 50,
                    width: width - (AppConstraints.hSpace * 2),
                    child: Slider(
                      value: _radius,
                      thumbColor: AppColors.primary,
                      activeColor: AppColors.primaryDim,
                      max: 1000,
                      divisions: 10,
                      label: "${_radius.round().toString()}m",
                      onChanged: (double value) {
                        setState(() {
                          _radius = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          FilledButton.icon(
            style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => AppColors.primary),
                foregroundColor: MaterialStateColor.resolveWith(
                    (states) => AppColors.secondaryText)),
            label: const Text("Add Location"),
            icon: const Icon(Icons.add),
            onPressed: () {},
          )
        ],
      )),
    );
  }
}
