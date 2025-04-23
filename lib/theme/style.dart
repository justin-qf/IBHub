import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';

ThemeData lightTheme = ThemeData(
    fontFamily: fontMedium,
    appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(color: black),
        iconTheme: IconThemeData(color: black),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: white, statusBarIconBrightness: Brightness.dark),
        color: white,
        elevation: 0.0),
    scaffoldBackgroundColor: white,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: white,
        selectedItemColor: Colors.orange,
        showUnselectedLabels: true,
        unselectedItemColor: black,
        type: BottomNavigationBarType.fixed,
        elevation: 0.0));

ThemeData darkTheme = ThemeData(
    fontFamily: fontMedium,
    appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(color: white),
        iconTheme: IconThemeData(color: white),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: darkBackgroundColor,
            statusBarIconBrightness: Brightness.light),
        color: darkBackgroundColor,
        elevation: 0.0),
    scaffoldBackgroundColor: darkBackgroundColor,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkBackgroundColor,
        selectedLabelStyle: TextStyle(),
        selectedItemColor: Colors.orange,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: darkBackgroundColor,
        elevation: 0.0));
