import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/device_type.dart';
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/models/login_model.dart';
import 'package:ibh/preference/UserPreference.dart';
import 'package:ibh/views/mainscreen/MainScreen.dart';
import 'package:ibh/views/sigin_signup/signinScreen.dart';
import 'package:sizer/sizer.dart' as sizer;
import '../../../configs/assets_constant.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => SplashscreenState();
}

class SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      User? retrievedObject = await UserPreferences().getSignInInfo();
      if (retrievedObject != null) {
        Get.offAll(const MainScreen());
      } else {
        Get.offAll(const Signinscreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Statusbar().trasparentStatusbar();
    return Container(
      height: sizer.Device.height,
      width: sizer.Device.width,
      decoration: const BoxDecoration(color: secondaryColor),
      child: Bounce(
        from: 150,
        child: Center(
          child: SvgPicture.asset(Asset.logo,
              fit: BoxFit.cover,
              width: sizer.Device.screenType == sizer.ScreenType.mobile
                  ? 150
                  : DeviceScreenType.isWeb(context)
                      ? 300
                      : 200),
        ),
      ),
    );
  }
}
