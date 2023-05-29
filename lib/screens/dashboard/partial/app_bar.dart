import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spot_check/constants/constraints.dart';
import 'package:spot_check/store/controllers/auth.controller.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AuthController authController = AuthController.to;

  DashboardAppBar({super.key});
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    final userImage = Obx(() => Padding(
          padding: const EdgeInsets.only(right: AppConstraints.hSpace),
          child: CircleAvatar(
            radius: 16,
            backgroundImage:
                NetworkImage(authController?.user?.value?.photoURL ?? ""),
          ),
        ));
    return AppBar(
      title: Image.asset("assets/images/brand.png", height: 30),
      centerTitle: true,
      actions: [
        InkWell(
          onTap: () => Get.toNamed("/settings"),
          child: userImage,
        )
      ],
    );
  }
}
