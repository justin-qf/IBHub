import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:ibh/configs/app_constants.dart';
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/internet_controller.dart';
import 'package:ibh/services/firebaseNoticationsHandler.dart';
import 'package:ibh/services/push_notification.dart';
import 'package:ibh/utils/helper.dart';
import 'package:ibh/views/splashscreen/SplashScreen.dart';
import 'package:sizer/sizer.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp();
  if (Platform.isAndroid) {
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
  }
  // Initialize Hive
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  await Hive.openBox<String>(AppConstants.openFirebaseTokenBox);
  await Hive.openBox<bool>(AppConstants.openLanguageBox);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await NotificationService.initialize();
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
          home: const SplashScreen(),
          defaultTransition: Transition.fadeIn);
    });
  }
}
