import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:spot_check/constants/colors.dart';
import 'package:spot_check/constants/constraints.dart';
import 'package:spot_check/store/controllers/auth.controller.dart';
import 'package:spot_check/widgets/components.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthController aC = AuthController.to;
  void _logOut() {
    aC.handleSignOut();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(title: const Text("Profile")),
        body: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstraints.hSpace,
              vertical: AppConstraints.hSpace),
          child: Wrap(
            direction: Axis.vertical,
            spacing: 20,
            children: [
              Wrap(
                spacing: 15,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage:
                        NetworkImage(aC?.user?.value?.photoURL ?? ""),
                  ),
                  SectionTitleText(text: aC?.user?.value?.displayName ?? "")
                ],
              ),
              Card(
                  child: SizedBox(
                      width: width - (AppConstraints.hSpace * 2),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Wrap(
                          children: [PromText(text: "Profile Setting")],
                        ),
                      ))),
              SizedBox(
                  width: width - (AppConstraints.hSpace * 2),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        InkWell(
                          onTap: _logOut,
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text("SignOut",
                                style: TextStyle(color: AppColors.dangerBg)),
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }
}
