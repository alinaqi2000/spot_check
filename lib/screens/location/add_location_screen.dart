import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spot_check/constants/colors.dart';
import 'package:spot_check/constants/constraints.dart';
import 'package:spot_check/constants/sizes.dart';
import 'package:spot_check/store/controllers/location.controller.dart';
import 'package:spot_check/widgets/components.dart';
import 'package:spot_check/store/models/location.model.dart' as loc;
import 'package:geocoding/geocoding.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geocode/geocode.dart';
import 'package:loading_indicator/loading_indicator.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({super.key});

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation>
    with SingleTickerProviderStateMixin {
  Completer<GoogleMapController> mapController = Completer();
  late LocationController lC = Get.put(LocationController.to);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  String googleApikey = "AIzaSyD6NZ764krClK1AQrspchl4PizSKi2seds";

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.5, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticIn,
  ));
  Set<Circle> circles = Set.from({});
  final args = Get.arguments;

  // LatLng _center = LatLng(9.669111, 80.014007);

  // double _sheetBottomPosition = 150;

  final LatLng _center = const LatLng(9.669111, 80.014007);
  CameraPosition? cameraPosition;
  @override
  void dispose() {
    lC.gotoSelectLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);

    controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(lC.currentLocation.value.latitude,
            lC.currentLocation.value.longitude),
        zoom: _calculateZoom(lC.radius.value))));
    circles.clear();
    setState(() {
      circles = Set.from({
        Circle(
            circleId: const CircleId("place"),
            center: LatLng(lC.currentLocation.value.latitude,
                lC.currentLocation.value.longitude),
            radius: lC.radius.value,
            strokeColor: AppColors.primaryDim,
            strokeWidth: 4)
      });
    });

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
    lC.radius.listen((radiusValue) async {
      print("change $radiusValue");
      lC.currentLocation.value.radius = radiusValue;
      GoogleMapController controller = await mapController.future;
      controller?.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(lC.currentLocation.value.latitude,
                lC.currentLocation.value.longitude),
            zoom: _calculateZoom(radiusValue))),
      );
    });
    _getCurrentLocation();
    super.initState();
  }

  double _calculateZoom(double givenRadius) {
    double breakPoint = givenRadius / 250;
    return 17 - breakPoint;
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

  void _getCurrentLocation() async {
    getUserCurrentLocation().then((value) async {
      // marker added for current users location
      if (!(args != null && args.containsKey("fromLocation"))) {
        // specified current users location
        CameraPosition cameraPosition = CameraPosition(
          target: LatLng(value.latitude, value.longitude),
          zoom: 14,
        );

        final GoogleMapController controller = await mapController.future;
        controller
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _getCurrentLocation,
      //   child: const Icon(Icons.local_activity),
      // ),
      resizeToAvoidBottomInset: false,
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
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                padding: const EdgeInsets.only(top: 130, bottom: 100),
                circles: circles,

                // markers: markers.values.toSet(),
                mapToolbarEnabled: true,
                onCameraMove: (position) => {
                  cameraPosition = position
                  //   setState(() {
                  //   _sheetBottomPosition = 250;
                  // })
                },
                onCameraMoveStarted: () {
                  lC.performingAction.value = true;
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
                      title: placemarks.first.name.toString(),
                      mapTitle: placemarks.first.name.toString(),
                      address: placemarks.first.street.toString(),
                      latitude: cameraPosition!.target.latitude,
                      radius: lC.radius.value,
                      longitude: cameraPosition!.target.longitude);

                  circles.clear();
                  setState(() {
                    circles = Set.from({
                      Circle(
                          circleId: const CircleId("place"),
                          center: LatLng(lC.currentLocation.value.latitude,
                              lC.currentLocation.value.longitude),
                          radius: lC.radius.value,
                          strokeColor: AppColors.primaryDim,
                          strokeWidth: 4)
                    });
                  });
                  lC.performingAction.value = false;
                  // Marker marker = Marker(
                  //   markerId: MarkerId(placemarks.first.street.toString()),
                  //   position: LatLng(cameraPosition!.target.latitude,
                  //       cameraPosition!.target.longitude),
                  //   // icon: BitmapDescriptor.,
                  //   draggable: true,
                  //   infoWindow: InfoWindow(
                  //     title: placemarks.first.subLocality.toString(),
                  //     snippet: placemarks.first.administrativeArea.toString(),
                  //   ),
                  // );

                  // setState(() {
                  //   markers[const MarkerId('place_name')] = marker;
                  // });
                },
                onMapCreated: _onMapCreated,
                zoomGesturesEnabled: true, //enable Zoom in, out on map
                mapType: MapType.normal, //map type
                initialCameraPosition: CameraPosition(
                  target: LatLng(lC.currentCordinates.value!.latitude,
                      lC.currentCordinates.value!.longitude),
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
                          // lC.performingAction.value = true;
                          lC.gotoSelectLocation();

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
                              mapTitle: detail.result.name.toString(),
                              address: address.city.toString(),
                              latitude: lat,
                              radius: lC.radius.value,
                              longitude: lang);

                          //move map camera to selected place with animation
                          GoogleMapController controller =
                              await mapController.future;
                          controller?.animateCamera(
                              CameraUpdate.newCameraPosition(CameraPosition(
                                  target: newlatlang, zoom: 17)));
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
          Obx(() => AnimatedPositioned(
                // curve: Curves.linear,
                duration: const Duration(milliseconds: 250),
                bottom: 0,
                left: 0,
                width: width,
                height: lC.sheetHeight.value,
                child: SizedBox(
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          AppColors.secondaryBg,
                          AppColors.secondaryBg
                        ]),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppConstraints.borderRadius),
                          topRight:
                              Radius.circular(AppConstraints.borderRadius),
                        )),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return SlideTransition(
                          position: Tween(
                            begin: const Offset(1.0, 0.0),
                            end: const Offset(0.0, 0.0),
                          ).animate(animation),
                          child: child,
                        );
                      },
                      child: lC.stage.value == 'select_location'
                          ? const SelectLocationSheet(key: ValueKey<int>(1))
                          : const SelectActionSheet(key: ValueKey<int>(2)),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

class SelectActionSheet extends StatefulWidget {
  const SelectActionSheet({super.key});

  @override
  State<SelectActionSheet> createState() => _SelectActionSheetState();
}

class _SelectActionSheetState extends State<SelectActionSheet> {
  LocationController lC = Get.put(LocationController.to);
  final List<Color> _kDefaultRainbowColors = [
    AppColors.primary,
    AppColors.primary2,
    AppColors.primaryDim
  ];
  final TextEditingController _locationTitleController =
      TextEditingController();
  final List<String> soundModes = ["normal", "silent", "vibrate"];
  @override
  void initState() {
    _locationTitleController.text = lC.currentLocation.value.mapTitle;
    // lC.currentLocation.listen((p0) {
    //   print(p0);
    // });
    _locationTitleController.addListener(() {
      lC.currentLocation.value.title = _locationTitleController.value.text;
      lC.currentLocation.refresh();
    });
    super.initState();
  }

  @override
  void dispose() {
    lC.dispose();
    super.dispose();
  }

  Widget soundIcon(String type) {
    switch (type) {
      case "silent":
        return const Icon(Icons.do_not_disturb);
      case "vibrate":
        return const Icon(Icons.vibration);
      default:
    }
    return const Icon(Icons.ring_volume);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(AppConstraints.hSpace),
      child: Stack(
        children: [
          SizedBox(
            height: lC.sheetHeight.value - 50,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: Wrap(
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
                            lC.gotoSelectLocation();
                          },
                          child: const Icon(Icons.arrow_back),
                        ),
                        const SectionTitleText(text: "Select Action")
                      ],
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      spacing: 8,
                      children: [
                        Obx(
                          () => lC.performingAction.value
                              ? SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: LoadingIndicator(
                                    colors: _kDefaultRainbowColors,
                                    indicatorType: Indicator.ballScaleMultiple,
                                    strokeWidth: 3,
                                    backgroundColor: Colors.transparent,
                                    pause: false,
                                    // pathBackgroundColor: Colors.black45,
                                  ),
                                )
                              : Icon(Icons.location_on,
                                  color: AppColors.primary),
                        ),
                        Obx(() => PromText(
                            text: lC.performingAction.value
                                ? "Loading..."
                                : "${lC.currentLocation.value?.title} - ${lC.currentLocation.value?.address}"))
                      ],
                    ),
                    Wrap(
                      spacing: 24,
                      direction: Axis.vertical,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                backgroundColor: AppColors.primary2,
                                value: lC.currentLocation.value.radius / 1000,
                              ),
                            ),
                            const SizedBox(width: 15),
                            PromText(
                                text:
                                    "Radius: ${lC.currentLocation.value.radius.round().toString()} meters")
                          ],
                        ),
                        SizedBox(
                          height: 60,
                          width: width - (AppConstraints.hSpace * 2),
                          child: TextField(
                            controller: _locationTitleController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Location Title',
                            ),
                          ),
                        )
                      ],
                    ),
                    const Wrap(children: [SectionTitleText(text: "Actions")]),
                    Wrap(
                      spacing: 24,
                      direction: Axis.vertical,
                      children: [
                        SizedBox(
                            height: 80,
                            width: width - (AppConstraints.hSpace * 2),
                            child: Wrap(
                              direction: Axis.vertical,
                              children: [
                                SizedBox(
                                    height: 40,
                                    width: width - (AppConstraints.hSpace * 2),
                                    child: Wrap(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.spaceBetween,
                                      children: [
                                        const PromText(text: "Volume"),
                                        Wrap(
                                          spacing: 8,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            const ParaText(text: "Mute"),
                                            SizedBox(
                                              // width: 60,
                                              height: 30,
                                              child: FittedBox(
                                                  fit: BoxFit.fill,
                                                  child: Obx(
                                                    () => Switch(
                                                      value: lC.currentLocation
                                                                  .value.actions[
                                                              "volume"]?['mute'] ??
                                                          false,
                                                      activeColor:
                                                          AppColors.primary,
                                                      onChanged: (bool value) =>
                                                          lC.setLocationAction(
                                                              'volume',
                                                              "mute",
                                                              value),
                                                    ),
                                                  )),
                                            ),
                                          ],
                                        )
                                      ],
                                    )),
                                SizedBox(
                                  height: 40,
                                  width: width - (AppConstraints.hSpace * 2),
                                  child: Obx(() => Slider(
                                        value: lC.currentLocation.value
                                                .actions["volume"]?['value'] ??
                                            0.0,
                                        thumbColor: AppColors.primary,
                                        activeColor: AppColors.primaryDim,
                                        max: 100,
                                        min: 0,
                                        divisions: 25,
                                        label: lC.currentLocation.value
                                                        .actions["volume"]
                                                    ?['value'] !=
                                                null
                                            ? "${lC.currentLocation.value.actions["volume"]?['value'].round().toString()}"
                                            : "0",
                                        onChanged: (lC.currentLocation.value
                                                        .actions["volume"]
                                                    ?['mute'] ??
                                                false)
                                            ? null
                                            : (double value) {
                                                lC.setLocationAction(
                                                    'volume', "value", value);
                                              },
                                      )),
                                ),
                              ],
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 30,
                      width: width - (AppConstraints.hSpace * 2),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          const PromText(text: "Sound Mode"),
                          SizedBox(
                            // width: 60,
                            height: 30,
                            child: FittedBox(
                                fit: BoxFit.fill,
                                child: Obx(
                                  () => DropdownButton<String>(
                                    value: lC.currentLocation.value
                                            .actions["sound_mode"]?['value'] ??
                                        soundModes.first,
                                    icon: soundIcon(lC.currentLocation.value
                                            .actions["sound_mode"]?['value'] ??
                                        soundModes.first),
                                    elevation: 16,
                                    style: const TextStyle(fontSize: 30),
                                    hint: const Text("Mode"),
                                    underline: Container(
                                      height: 2,
                                      color: AppColors.primary,
                                    ),
                                    onChanged: (String? value) =>
                                        lC.setLocationAction(
                                            'sound_mode', "value", value),
                                    items: soundModes
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: SectionTitleText(
                                            text: value.toUpperCase()),
                                      );
                                    }).toList(),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   height: 30,
                    //   width: width - (AppConstraints.hSpace * 2),
                    //   child: Wrap(
                    //     crossAxisAlignment: WrapCrossAlignment.center,
                    //     alignment: WrapAlignment.spaceBetween,
                    //     children: [
                    //       RichText(
                    //           text: TextSpan(children: [
                    //         TextSpan(
                    //             text: "Airplane Mode",
                    //             style: TextStyle(
                    //                 fontFamily:
                    //                     GoogleFonts.palanquinDark().fontFamily,
                    //                 fontSize: AppSizes.prominentSize)),
                    //         TextSpan(
                    //             text: " (Under Development)",
                    //             style: TextStyle(
                    //                 fontFamily:
                    //                     GoogleFonts.palanquinDark().fontFamily,
                    //                 fontSize: AppSizes.paraSize))
                    //       ])),
                    //       SizedBox(
                    //         // width: 60,
                    //         height: 30,
                    //         child: FittedBox(
                    //             fit: BoxFit.fill,
                    //             child: Obx(
                    //               () => Switch(
                    //                 value: lC.currentLocation.value
                    //                             .actions["airplane_mode"]
                    //                         ?['value'] ??
                    //                     false,
                    //                 activeColor: AppColors.primary,
                    //                 onChanged: null,
                    //                 // onChanged: (bool value) =>
                    //                 //     lC.setLocationAction(
                    //                 //         'airplane_mode', "value", value),
                    //               ),
                    //             )),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 30,
                    //   width: width - (AppConstraints.hSpace * 2),
                    //   child: Wrap(
                    //     crossAxisAlignment: WrapCrossAlignment.center,
                    //     alignment: WrapAlignment.spaceBetween,
                    //     children: [
                    //       RichText(
                    //           text: TextSpan(children: [
                    //         TextSpan(
                    //             text: "Wifi",
                    //             style: TextStyle(
                    //                 fontFamily:
                    //                     GoogleFonts.palanquinDark().fontFamily,
                    //                 fontSize: AppSizes.prominentSize)),
                    //         TextSpan(
                    //             text: " (Under Development)",
                    //             style: TextStyle(
                    //                 fontFamily:
                    //                     GoogleFonts.palanquinDark().fontFamily,
                    //                 fontSize: AppSizes.paraSize))
                    //       ])),
                    //       SizedBox(
                    //         // width: 60,
                    //         height: 30,
                    //         child: FittedBox(
                    //             fit: BoxFit.fill,
                    //             child: Obx(
                    //               () => Switch(
                    //                 value: lC.currentLocation.value
                    //                         .actions["wifi"]?['value'] ??
                    //                     false,
                    //                 activeColor: AppColors.primary,
                    //                 onChanged: null,
                    //                 // onChanged: (bool value) =>
                    //                 //     lC.setLocationAction(
                    //                 //         'wifi', "value", value),
                    //               ),
                    //             )),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 5,
              width: width - (AppConstraints.hSpace * 2),
              child: FilledButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => AppColors.primary),
                    foregroundColor: MaterialStateColor.resolveWith(
                        (states) => AppColors.secondaryText)),
                label: const Text("Apply Actions"),
                icon: const Icon(Icons.check),
                onPressed: lC.performingAction.value
                    ? null
                    : () {
                        lC.addLocation();
                      },
              ))
        ],
      ),
    );
  }
}

class SelectLocationSheet extends StatefulWidget {
  const SelectLocationSheet({super.key});

  @override
  State<SelectLocationSheet> createState() => _SelectLocationSheetState();
}

class _SelectLocationSheetState extends State<SelectLocationSheet> {
  late LocationController lC = Get.put(LocationController.to);
  final List<Color> _kDefaultRainbowColors = [
    AppColors.primary,
    AppColors.primary2,
    AppColors.primaryDim
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(AppConstraints.hSpace),
      child: Stack(
        children: [
          SizedBox(
            height: lC.sheetHeight.value - 50,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: Wrap(
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
                        Obx(() => lC.performingAction.value
                            ? SizedBox(
                                height: 24,
                                width: 24,
                                child: LoadingIndicator(
                                  colors: _kDefaultRainbowColors,
                                  indicatorType: Indicator.ballScaleMultiple,
                                  strokeWidth: 3,
                                  backgroundColor: Colors.transparent,
                                  pause: false,
                                  // pathBackgroundColor: Colors.black45,
                                ),
                              )
                            : Icon(Icons.location_on,
                                color: AppColors.primary)),
                        Obx(() => PromText(
                            text: lC.performingAction.value
                                ? "Loading..."
                                : "${lC.currentLocation.value?.title} - ${lC.currentLocation.value?.address}"))
                      ],
                    ),
                    Wrap(
                      spacing: 8,
                      direction: Axis.vertical,
                      children: [
                        Obx(() => PromText(
                            text:
                                "Radius (${lC.radius.value.round().toString()} meters)")),
                        SizedBox(
                          height: 50,
                          width: width - (AppConstraints.hSpace * 2),
                          child: Obx(() => Slider(
                                value: lC.radius.value,
                                thumbColor: AppColors.primary,
                                activeColor: AppColors.primaryDim,
                                max: 1000,
                                min: 50,
                                divisions: 15,
                                label: "${lC.radius.value.round().toString()}m",
                                onChanged: (double value) {
                                  lC.radius.value = value;
                                },
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 5,
              width: width - (AppConstraints.hSpace * 2),
              child: FilledButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => AppColors.primary),
                    foregroundColor: MaterialStateColor.resolveWith(
                        (states) => AppColors.secondaryText)),
                label: const Text("Select Action"),
                icon: const Icon(Icons.check),
                onPressed: lC.performingAction.value
                    ? null
                    : () {
                        lC.gotoSelectAction(height);
                      },
              ))
        ],
      ),
    );
  }
}
