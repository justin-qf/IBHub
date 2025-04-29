import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/utils/helper.dart';
import 'package:sizer/sizer.dart';

class AppTheme {
  const AppTheme._();
  static final lightTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.light,
    primaryColor: lightPrimaryColor,
    textTheme: TextTheme(
      displayLarge:
          TextStyle(fontWeight: FontWeight.bold, fontSize: 25.sp, color: black),
      displayMedium:
          TextStyle(fontSize: 10.sp, color: black, fontFamily: dM_sans_regular),
      bodyMedium: const TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ),
  );

  static final darkTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.dark,
    primaryColor: lightPrimaryColor,
    textTheme: TextTheme(
        displayMedium:
            TextStyle(fontSize: 10.sp, color: white, fontFamily: dM_sans_regular),
        displayLarge: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 25.sp, color: white)),
  );

  static Brightness currentSystemBrightness() {
    // ignore: deprecated_member_use
    return SchedulerBinding.instance.window.platformBrightness;
  }

  static setStatusNavigationbarColor(ThemeMode themeMode) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            themeMode == ThemeMode.light ? Brightness.dark : Brightness.light,
        systemNavigationBarIconBrightness:
            themeMode == ThemeMode.light ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: themeMode == ThemeMode.light
            ? Colors.transparent
            : darkBackgroundColor,
        systemNavigationBarDividerColor: Colors.transparent));

    //change status bar text color
    SystemChrome.setSystemUIOverlayStyle(themeMode == ThemeMode.light
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light);
  }

  static ThemeData getDatePickerTheme() {
    return isDarkMode()
        ? ThemeData.dark().copyWith(
            primaryColor: primaryColor,
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(50), // Set your border radius
              ),
            ),
            colorScheme: const ColorScheme.dark(primary: Colors.teal)
                .copyWith(secondary: secondaryColor)
                .copyWith(background: white),
          )
        : ThemeData.light().copyWith(
            primaryColor: primaryColor,
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(50), // Set your border radius
              ),
            ),
            colorScheme: const ColorScheme.light(primary: Colors.teal)
                .copyWith(secondary: secondaryColor)
                .copyWith(background: white),
          );
  }
}
