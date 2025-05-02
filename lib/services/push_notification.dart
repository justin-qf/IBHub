import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/utils/log.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
var obtainedFirebaseToken = "";
late AndroidNotificationChannel channel;

Future<void> showNotificationInForeground(
  RemoteMessage message,
) async {
  RemoteNotification? notification = message.notification;
  String? title = notification!.title;
  String? msg = notification.body;
  setNotificationPopupDialogConfig(title!, msg!, message);
}

Future<void> initNotifications() async {
  var initializationSettingsAndroid =
      const AndroidInitializationSettings(Notifications.appIcon);
  // Ios initialization
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
    // onDidReceiveLocalNotification: onDidReceiveLocalNotification,
  );
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: onSelectNotification,
  );
}

Future onSelectNotification(NotificationResponse notificationResponse) async {
  //fcmMessageHandlerFunction(payload);
}

// ignore: prefer_typing_uninitialized_variables
var fcmMessageHandlerFunction;

initFirebaseNotification({fcmMessageHandler}) async {
  await Firebase.initializeApp();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  fcmMessageHandlerFunction = fcmMessageHandler;
  requestPermission();
  channel = const AndroidNotificationChannel(
    Notifications.channelId,
    Notifications.channelName,
    description: Notifications.channelDescription,
    importance: Importance.high,
    enableLights: true,
    ledColor: Colors.red,
    enableVibration: true,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await firebaseMessaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  firebaseMessaging.getToken().then((value) {
    logcat("FirebaseToken", value.toString());
    obtainedFirebaseToken = value!;
  });

  firebaseMessaging.getInitialMessage().then((message) {
    logcat("getInitialMessage", message.toString());
    if (message != null) {}
  });

  ///forground work
  FirebaseMessaging.onMessage.listen((message) async {
    // logcat("onMessage", message.toString());
    showNotificationInForeground(message);
  });

  ///When the app is in background but opened and user taps
  ///on the notification
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //logcat("onMessageOpenedApp", message.toString());
    //showNotificationInForeground(message);
  });

  initNotifications();
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

setNotificationPopupDialogConfig(
  String title,
  String msg,
  RemoteMessage message,
) async {
  BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
    msg,
    htmlFormatBigText: true,
    contentTitle: title,
    htmlFormatTitle: true,
    htmlFormatContent: true,
    htmlFormatContentTitle: true,
    summaryText: "",
    htmlFormatSummaryText: true,
  );

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
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
    largeIcon: const DrawableResourceAndroidBitmap(Notifications.appLargeIcon),
    enableLights: true,
  );

  var iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
      presentSound: true, presentAlert: true, presentBadge: true);

  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);

  if (Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.show(
        message.notification.hashCode, title, msg, platformChannelSpecifics,
        payload: jsonEncode(message.data));
  }
}

void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    logcat("Granted", 'User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    logcat("Provisional", 'User granted provisional permission');
  } else {
    logcat("Denied", 'User declined or has not accepted permission');
  }
}
