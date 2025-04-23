import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/views/splashscreen/SplashScreen.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
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
        home: const Splashscreen(),
        defaultTransition: Transition.fadeIn,
      );
    });
  }
}
