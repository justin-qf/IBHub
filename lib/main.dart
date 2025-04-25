import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/internet_controller.dart';
import 'package:ibh/utils/helper.dart';
import 'package:ibh/views/Profile/updateprofilescreen.dart';
import 'package:ibh/views/auth/ReserPasswordScreen/ChangepasswordScreen.dart';
import 'package:ibh/views/auth/ReserPasswordScreen/OtpScreen.dart';
import 'package:ibh/views/mainscreen/HomeScreen/CategoryScreen.dart';
import 'package:ibh/views/mainscreen/HomeScreen/HomeScreen.dart';
import 'package:ibh/views/mainscreen/MainScreen.dart';
import 'package:ibh/views/mainscreen/Profile/ProfileScreen.dart';
import 'package:ibh/views/services/addserviceScreen.dart';
import 'package:ibh/views/services/viewserviceScreen.dart';
import 'package:ibh/views/sigin_signup/signinScreen.dart';
import 'package:ibh/views/sigin_signup/signupScreen.dart';
import 'package:ibh/views/splashscreen/SplashScreen.dart';
import 'package:sizer/sizer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  screenOrientations();
  Get.lazyPut<InternetController>(() => InternetController());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final internetController = Get.put(InternetController(), permanent: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Statusbar().trasparentStatusbar();
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child!);
        },
        enableLog: true,
        title: AppConstant.name,
        debugShowCheckedModeBanner: false,
        home: Signinscreen(),
        defaultTransition: Transition.fadeIn,
      );
    });
  }
}
