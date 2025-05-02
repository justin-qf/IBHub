import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/device_type.dart';
import 'package:ibh/models/login_model.dart';
import 'package:ibh/preference/UserPreference.dart';
import 'package:ibh/utils/log.dart';
import 'package:ibh/views/auth/ReserPasswordScreen/OtpScreen.dart';
import 'package:ibh/views/mainscreen/MainScreen.dart';
import 'package:ibh/views/sigin_signup/signinScreen.dart';
import 'package:sizer/sizer.dart' as sizer;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  double _scale = 0.8;

  @override
  void initState() {
    super.initState();
    // Trigger the animation after a short delay (e.g. 50ms)
    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        _opacity = 1.0;
        _scale = 1.0;
      });
    });

    Timer(const Duration(seconds: 3), () async {
      User? userData = await UserPreferences().getSignInInfo();
      if (userData != null && userData.isEmailVerified == true) {
        Get.offAll(const MainScreen());
      } else if (userData != null && userData.isEmailVerified == false) {
        Get.to(() => OtpScreen(
              email: userData.email.toString().trim(),
              otp: "1235",
              isFromSingIn: true,
            ))?.then((value) {});
      } else {
        Get.offAll(const Signinscreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: sizer.Device.width,
      height: sizer.Device.height,
      decoration: const BoxDecoration(color: white),
      child: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          child: AnimatedScale(
            scale: _scale,
            duration: Duration(milliseconds: 800),
            curve: Curves.easeOutBack,
            child: Image.asset(
              Asset.applogo,
              fit: BoxFit.cover,
              width: sizer.Device.screenType == sizer.ScreenType.mobile
                  ? 150
                  : DeviceScreenType.isWeb(context)
                      ? 300
                      : 200,
            ),
          ),
        ),
      ),
    );
  }
}

// import 'dart:async';
// import 'package:animate_do/animate_do.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ibh/configs/colors_constant.dart';
// import 'package:ibh/configs/device_type.dart';
// import 'package:ibh/configs/statusbar.dart';
// import 'package:ibh/models/login_model.dart';
// import 'package:ibh/preference/UserPreference.dart';
// import 'package:ibh/views/mainscreen/MainScreen.dart';
// import 'package:ibh/views/sigin_signup/signinScreen.dart';
// import 'package:sizer/sizer.dart' as sizer;
// import '../../../configs/assets_constant.dart';

// class Splashscreen extends StatefulWidget {
//   const Splashscreen({super.key});

//   @override
//   State<Splashscreen> createState() => SplashscreenState();
// }

// class SplashscreenState extends State<Splashscreen> {
//   @override
//   void initState() {
//     super.initState();
//     Timer(const Duration(seconds: 3), () async {
//       User? retrievedObject = await UserPreferences().getSignInInfo();
//       if (retrievedObject != null) {
//         Get.offAll(const MainScreen());
//       } else {
//         Get.offAll(const Signinscreen());
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     Statusbar().trasparentStatusbar();
//     return Container(
//         height: sizer.Device.height,
//         width: sizer.Device.width,
//         decoration: const BoxDecoration(color: white),
//         child: AnimatedOpacity(
//           opacity:
//               1.0, // Change this to 0.0 then back to 1.0 on rebuild to trigger
//           duration: Duration(milliseconds: 600),
//           curve: Curves.easeIn,
//           child: Center(
//             child: Image.asset(
//               Asset.applogo,
//               fit: BoxFit.cover,
//               width: sizer.Device.screenType == sizer.ScreenType.mobile
//                   ? 150
//                   : DeviceScreenType.isWeb(context)
//                       ? 300
//                       : 200,
//             ),
//           ),
//         )

//         //  Bounce(
//         //   from: 150,
//         //   child: Center(
//         //     child: Image.asset(Asset.applogo,
//         //         fit: BoxFit.cover,
//         //         width: sizer.Device.screenType == sizer.ScreenType.mobile
//         //             ? 150
//         //             : DeviceScreenType.isWeb(context)
//         //                 ? 300
//         //                 : 200),
//         //   ),
//         // ),
//         );
//   }
// }
