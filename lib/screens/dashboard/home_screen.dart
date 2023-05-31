import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spot_check/constants/colors.dart';
import 'package:spot_check/constants/constraints.dart';
import 'package:spot_check/constants/sizes.dart';
import 'package:spot_check/screens/dashboard/partial/app_bar.dart';
import 'package:spot_check/store/controllers/activity.controller.dart';
import 'package:spot_check/store/controllers/location.controller.dart';
import 'package:spot_check/widgets/components.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? position;

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.denied) {
      Position userLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        position = userLocation;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 123,
            channelKey: "test_channel",
            title: "This is test",
            body: "this is test message body"));
    _determinePosition();

  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DashboardAppBar(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Get.toNamed("/add_location");
          },
          label: const PromText(text: "Location"),
          icon: const Icon(Icons.add),
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
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: SectionTitleText(text: position.toString()),
                ),
                SizedBox(
                  height: 174,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: LocationsList()),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: SectionTitleText(text: "Recent Activity"),
                ),
                SizedBox(
                  height: 400,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 33),
                      child: ActivityList()),
                )
              ],
            ),
          ),
        )));
  }
}

class ActivityList extends StatelessWidget {
  final ActivityController aC = Get.put(ActivityController());
  ActivityList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
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
        });
  }
}

class LocationsList extends StatelessWidget {
  final LocationController tC = Get.put(LocationController());
  LocationsList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: LocationController.to.loadLocations(),
      builder: (context, snapshot) {
        return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20, right: 8),
                child: SizedBox(
                  width: 146,
                  child: Container(
                    decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(2, 2),
                            blurRadius: 14,
                            color: Color.fromRGBO(33, 10, 15, 0.75),
                          )
                        ],
                        borderRadius: BorderRadius.only(
                            topLeft:
                                Radius.circular(AppConstraints.borderRadius),
                            topRight: Radius.circular(6),
                            bottomLeft:
                                Radius.circular(AppConstraints.borderRadius),
                            bottomRight:
                                Radius.circular(AppConstraints.borderRadius)),
                        gradient: LinearGradient(
                          colors: [Color(0xff781b2e), Color(0x82201a1a)],
                          stops: [0, 0.4],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Flex(
                          direction: Axis.vertical,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Heading2Text(
                              text: snapshot.data![index].title ?? "",
                            )
                          ]),
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}
