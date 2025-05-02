import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:ibh/configs/app_constants.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/utils/log.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static late AndroidNotificationChannel channel;
  static String obtainedFirebaseToken = "";

  static Future<void> initialize() async {
    await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // await requestPermission(messaging);
    await _setupNotificationChannel();
    await _configureLocalNotification();
    _configureFirebaseMessagingHandlers(messaging);

    obtainedFirebaseToken = await messaging.getToken() ?? "";
    final openFirebaseTokenBox =
        await Hive.openBox<String>(AppConstants.openFirebaseTokenBox);
    openFirebaseTokenBox.put(
        AppConstants.storeFirebaseToken, obtainedFirebaseToken);
    logcat("FirebaseToken::", obtainedFirebaseToken);
    await FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? value) {
      // Use addPostFrameCallback to ensure navigation happens after the initial frame
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(const Duration(seconds: 4));
        if (value != null) {
          logcat("initState::", "HandlingInitialMessage: ${value.data}");
          // UserPreferences().saveMemberId(value.data['MemberID']);
          // UserPreferences().saveVaccinationId(value.data['VaccinationID']);
          // String? memberId = value.data['MemberID']?.toString();
          // String? vaccinationId = value.data['VaccinationID']?.toString();

          // if (memberId != null) {
          //   // UserPreferences().saveMemberId(memberId);
          // }
          // if (vaccinationId != null) {
          //   // UserPreferences().saveVaccinationId(vaccinationId);
          // }

          // if (type == "Tips") {
          //   Get.to(() => PregnancyTipsScreen(tipsId: tipsId));
          // } else if (type == "Insurance") {
          //   await Get.to(ViewProfile(
          //     null,
          //     isFromNotification: true,
          //     memberId: memberId,
          //     relationshipId: relationshipId,
          //     relationship: relationship,
          //   ));
          // } else {
          //   Get.to(() => VaccinationListScreen(
          //         memberId: value.data['MemberID'],
          //         vaccinationId: value.data['VaccinationID'],
          //         isFromNotification: true,
          //       ));
          // }
        }
      });
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> requestPermission(
      BuildContext context, FirebaseMessaging messaging) async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true, badge: true, sound: true);

    switch (settings.authorizationStatus) {
      case AuthorizationStatus.authorized:
        logcat("Notification Permission", "User granted permission");
        break;
      case AuthorizationStatus.provisional:
        logcat(
            "Notification Permission", "User granted provisional permission");
        break;
      case AuthorizationStatus.denied:
        logcat("Notification Permission",
            "User declined or has not accepted permission");
        getpopup(context);
        break;
      default:
        break;
    }
  }

  static void getpopup(BuildContext context) async {
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            "Permission Required",
            style: TextStyle(fontFamily: dM_sans_extraBold, fontSize: 18.sp),
          ),
          content: Text(
              'Notification permission is required to use this feature.\n\n'
              'Please go to:\nSettings > Permissions > Notifications\n\n'
              'and enable notifications for this app.',
              style: TextStyle(fontFamily: dM_sans_medium, fontSize: 16.sp)),
          actions: [
            CupertinoDialogAction(
                child: Text(
                  "Setting",
                  style: TextStyle(
                      color: primaryColor,
                      fontFamily: dM_sans_extraBold,
                      fontSize: 18.sp),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                  openAppSettings();
                })
          ],
        );
      },
    );
  }

  static Future<void> _setupNotificationChannel() async {
    channel = const AndroidNotificationChannel(
      Notifications.channelId,
      Notifications.channelName,
      description: Notifications.channelDescription,
      importance: Importance.high,
      enableLights: true,
      ledColor: Colors.red,
      enableVibration: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> _configureLocalNotification() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings(Notifications.appIcon);
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationTap(response);
      },
    );
  }

  static void _configureFirebaseMessagingHandlers(FirebaseMessaging messaging) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // logcat("_configureFirebaseDATA", message.data['MemberID']);
      // logcat("_configureFirebaseDATA", message.data['VaccinationID']);
      _showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      _handleMessageOpenedApp(message);
    });

    messaging.getInitialMessage().then((RemoteMessage? message) async {
      if (message != null) {
        _handleMessageOpenedApp(message);
      }
    });
  }

  static Future<void> _showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    if (notification == null) return;

    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      notification.body ?? '',
      htmlFormatBigText: true,
      contentTitle: notification.title,
      htmlFormatTitle: true,
      htmlFormatContent: true,
      htmlFormatContentTitle: true,
      summaryText: "",
      htmlFormatSummaryText: true,
    );

    var androidDetails = AndroidNotificationDetails(
      Notifications.channelId,
      Notifications.channelName,
      channelDescription: Notifications.channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      playSound: true,
      enableVibration: true,
      autoCancel: true,
      colorized: false,
      setAsGroupSummary: true,
      styleInformation: bigTextStyleInformation,
      color: white,
      icon: Notifications.appIcon,
      channelShowBadge: true,
      groupKey: Notifications.groupKey,
      largeIcon:
          const DrawableResourceAndroidBitmap(Notifications.appLargeIcon),
      enableLights: true,
    );

    var iOSDetails = const DarwinNotificationDetails(
        presentSound: true, presentAlert: true, presentBadge: true);
    var platformDetails =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      notification.title,
      notification.body,
      platformDetails,
      payload: jsonEncode(message.data),
    );
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
  }

  static void _handleMessageOpenedApp(RemoteMessage message) {
    logcat("_handleMessageOpenedApp", message.data['MemberID']);
    logcat("_handleMessageOpenedApp", message.data['VaccinationID']);
    handleNotification(message);
  }

  static void _handleNotificationTap(NotificationResponse response) {
    Map<String, dynamic> data = jsonDecode(response.payload ?? "{}");
    if (data.isNotEmpty) {
      handleNotificationData(data);
    }
  }

  static void handleNotification(RemoteMessage? notificationData) {
    logcat("handleNotification:", notificationData!.data);
    handleNotificationData(notificationData.data);
  }

  // static void handleNotificationData(Map<String, dynamic> data) async {
  //   logcat("NotificationData:", data.toString());
  //   logcat("NotificationDataMemberId", data['MemberID']);
  //   logcat("Type", data['Type']);
  //   UserPreferences().saveMemberId(data['MemberID']);
  //   UserPreferences().saveVaccinationId(data['VaccinationID']);
  //   UserPreferences().setIsFromNotification(true);
  //   logcat("TypeDATAAA", data['Type'] == "Tips");
  //   if (data['Type'].toString() == "Tips") {
  //     Get.to(() => const NotificationScreen());
  //   } else if (data['Type'].toString() == "Insurance") {
  //     await Get.to(const ViewProfile(null))?.then((value) {});
  //   } else {
  //     Get.to(() => VaccinationListScreen(
  //           memberId: data['MemberID'],
  //           vaccinationId: data['VaccinationID'],
  //           isFromNotification: true,
  //         ));
  //   }
  // }

  static void handleNotificationData(Map<String, dynamic> data) async {
    logcat("NotificationData:", data.toString());

    String? memberId = data['MemberID']?.toString();
    String? vaccinationId = data['VaccinationID']?.toString();
    String? relationshipId = data['RelationshipID']?.toString();
    String? relationship = data['Relationship']?.toString();
    String? type = data['Type']?.toString();
    String? tipsId = data['TipsID']?.toString();

    if (memberId != null) {
      // UserPreferences().saveMemberId(memberId);
    }
    if (vaccinationId != null) {
      // UserPreferences().saveVaccinationId(vaccinationId);
    }
    // UserPreferences().setIsFromNotification(true);
    // logcat("NotificationDataMemberId", memberId ?? "null");
    // logcat("Type", type ?? "null");
    // logcat("TypeDATA::", type);
    // logcat("relationshipId::", relationshipId);
    // logcat("relationship::", relationship);

    // if (type == "Tips") {
    //   logcat("TipsID", tipsId);
    //   Get.to(() => PregnancyTipsScreen(tipsId: tipsId));
    // } else if (type == "Insurance") {
    //   await Get.to(ViewProfile(
    //     null,
    //     isFromNotification: true,
    //     memberId: memberId,
    //     relationshipId: relationshipId,
    //     relationship: relationship,
    //   ));
    // } else if (memberId != null && vaccinationId != null) {
    //   Get.to(() => VaccinationListScreen(
    //         memberId: memberId,
    //         vaccinationId: vaccinationId,
    //         isFromNotification: true,
    //       ));
    // }
  }
}
