import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:lottie/lottie.dart';
import 'package:spot_check/constants/colors.dart';
import 'package:spot_check/constants/constraints.dart';
import 'package:spot_check/constants/sizes.dart';
import 'package:spot_check/screens/dashboard/partial/app_bar.dart';
import 'package:spot_check/store/controllers/activity.controller.dart';
import 'package:spot_check/store/controllers/location.controller.dart';
import 'package:spot_check/store/models/location.model.dart';
import 'package:spot_check/utils/geolocation.dart';
import 'package:spot_check/widgets/components.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:geolocator/geolocator.dart';

const locationBoxHeight = 210.0;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LocationController lC = Get.put(LocationController(), permanent: true);
  void _determinePosition() async {
    if (!(lC.currentCordinates.value != null)) {
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      if (permission != LocationPermission.denied) {
        lC.currentCordinates.value = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        final LocalStorage locStorage = LocalStorage('local_locs');
        Future.delayed(const Duration(seconds: 10)).then((value) async {
          await locStorage.ready;
          await locStorage.setItem(
              "previousLocation", lC.currentCordinates.value);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DashboardAppBar(),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          onPressed: () {
            Get.toNamed("/add_location");
          },
          label: const PromText(text: "Location"),
          icon: const Icon(Icons.add_location_alt),
        ),
        body: SingleChildScrollView(
            child: ConstrainedBox(
          constraints: const BoxConstraints(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstraints.hSpace,
                vertical: AppConstraints.hSpace),
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BrandText(
                    text: "All you need for your location accessibility."),
                const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: SectionTitleText(text: "My Locations"),
                ),
                SizedBox(
                  height: locationBoxHeight,
                  width: MediaQuery.of(context).size.width,
                  child: const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: LocationsList()),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: SectionTitleText(text: "Recent Activity"),
                ),
                ActivityList()
              ],
            ),
          ),
        )));
  }
}

class ActivityList extends StatelessWidget {
  final ActivityController aC = Get.put(ActivityController());
  ActivityList({super.key});
  final ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 60),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 800, minHeight: 200.0),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          controller: controller,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemCount: aC.activities.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(),
              child: Container(
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(2, 2),
                          blurRadius: 14,
                          color: Color.fromRGBO(33, 10, 15, 0.75),
                        )
                      ],
                      borderRadius:
                          BorderRadius.circular(AppConstraints.borderRadius),
                      gradient: LinearGradient(
                        colors: [AppColors.secondaryBg, AppColors.secondaryBg],
                        stops: const [0, 0.4],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )),
                  child: ListTile(
                    dense: true,
                    horizontalTitleGap: 10,
                    isThreeLine: true,
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary2,
                      radius: 20,
                      child: const Icon(
                          size: AppSizes.heading2Size, Icons.location_on),
                    ),
                    title: Flex(
                        direction: Axis.horizontal,
                        clipBehavior: Clip.hardEdge,
                        children: [
                          SizedBox(
                            width: 175,
                            child: PromText(text: aC.activities[index].title),
                          ),
                          const Spacer(),
                          SizedBox(
                              width: 25,
                              child: Text(
                                  style: TextStyle(
                                      fontSize: AppSizes.paraSize,
                                      overflow: TextOverflow.ellipsis,
                                      color: AppColors.primary),
                                  timeago.format(aC.activities[index].dateTime,
                                      locale: "en_short")))
                        ]),
                    subtitle: ParaText(text: aC.activities[index].description),
                  )),
            );
          },
        ),
      ),
    );
  }
}

class LocationsList extends StatefulWidget {
  const LocationsList({super.key});

  @override
  State<LocationsList> createState() => _LocationsListState();
}

class _LocationsListState extends State<LocationsList> {
  final LocationController lC = Get.put(LocationController());
  bool reload = false;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: LocationController.to.loadLocations(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return SizedBox(
              child: Center(
                child: Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Lottie.asset("assets/lottie/location_empty.json",
                        height: 100),
                    const PromText(text: "Locations list is empty")
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                final Location location = snapshot.data![index];
                return Padding(
                  key: ValueKey(location.id),
                  padding: const EdgeInsets.only(top: 20, bottom: 20, right: 8),
                  child: SizedBox(
                    width: 146,
                    child: InkWell(
                      onTap: () {
                        lC.currentLocation.value = location;
                        Get.toNamed("/add_location",
                            arguments: {"fromLocation": true});
                      },
                      onLongPress: () {
                        Get.defaultDialog(
                            contentPadding:
                                const EdgeInsets.all(AppConstraints.hSpace),
                            title: "Delete location",
                            content: const ParaText(
                                text:
                                    "Are you sure, you want to delete this location?"),
                            cancel: ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text("Cancel")),
                            actions: [
                              FilledButton(
                                  onPressed: () {
                                    lC.deleteLocation(location.id);
                                    // setState(() {
                                    //   reload = !reload;
                                    // });
                                    Get.back();
                                  },
                                  child: const Text("Delete"))
                            ]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(2, 2),
                                blurRadius: 14,
                                color: Color.fromRGBO(33, 10, 15, 0.75),
                              )
                            ],
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(64),
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12)),
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xff781b2e),
                                AppColors.primary
                              ],
                              stops: const [0.2, 1],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Stack(clipBehavior: Clip.none, children: [
                            Positioned(
                                left: -20,
                                top: -30,
                                child: SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: Lottie.asset(
                                      'assets/lottie/map_marker_animation.json'),
                                )),
                            Positioned(
                                top: 28,
                                height: locationBoxHeight - 105,
                                child: Wrap(
                                  direction: Axis.vertical,
                                  alignment: WrapAlignment.spaceBetween,
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  clipBehavior: Clip.antiAlias,
                                  spacing: 8,
                                  children: [
                                    Wrap(
                                      direction: Axis.vertical,
                                      children: [
                                        SizedBox(
                                          width: 125,
                                          child: Text(
                                            location.title ?? "",
                                            softWrap: true,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize:
                                                    AppSizes.prominentSize),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 125,
                                          child: Text(
                                            location.address ?? "",
                                            softWrap: true,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: AppSizes.paraSize),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Positioned(
                              bottom: 0,
                              child: SizedBox(
                                width: 110,
                                child: Obx(() => lC.currentCordinates.value !=
                                        null
                                    ? RichText(
                                        text: TextSpan(children: [
                                        TextSpan(
                                            text: AppGeolocator.kmtoMString(
                                                lC.distanceBetweenLocation(
                                                    snapshot.data![index])),
                                            style: TextStyle(
                                                fontFamily:
                                                    GoogleFonts.palanquinDark()
                                                        .fontFamily,
                                                fontSize:
                                                    AppSizes.headingSize)),
                                        TextSpan(
                                            text: " away",
                                            style: TextStyle(
                                                fontFamily:
                                                    GoogleFonts.palanquinDark()
                                                        .fontFamily,
                                                fontSize: AppSizes.paraSize)),
                                      ]))
                                    : const Wrap(
                                        spacing: 4,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Icon(Icons.location_off, size: 16),
                                          ParaText(text: "Off")
                                        ],
                                      )),
                              ),
                            )
                          ]),
                        ),
                      ),
                    ),
                  ),
                );
              });
        }

        return SizedBox(
          child: Center(
            child: Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Lottie.asset("assets/lottie/location_empty.json", height: 100),
                const PromText(text: "Loading locations...")
              ],
            ),
          ),
        );
      },
    );
  }
}
