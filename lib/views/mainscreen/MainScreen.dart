import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/homeController.dart';
import 'package:ibh/controller/mainScreenController.dart';
import 'package:ibh/views/mainscreen/HomeScreen/HomeScreen.dart';
import 'package:ibh/views/mainscreen/Profile/ProfileScreen.dart';
import 'package:ibh/views/mainscreen/SearchScreen/SearchScreen.dart';
import 'package:sizer/sizer.dart';
import 'package:sizer/sizer.dart' as sizer;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var controller = Get.put(MainScreenController());
  var homeController = Get.put(HomeScreenController());
  var pageOptions = <Widget>[];

  @override
  void initState() {
    controller.currentPage = 0;
    controller.getProfileData();

    controller.getTimerPopup(context);
    setState(() {
      pageOptions = [
        HomeScreen(callback),
        SearchScreen(callback),
        ProfileScreen(callback)
      ];
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Center(child: pageOptions.elementAt(controller.currentPage)),
          resizeToAvoidBottomInset: false,
          extendBody: true,
          bottomNavigationBar: Obx(
            () {
              return Visibility(
                visible: homeController.showGNav.value == true ? true : false,
                child: ZoomIn(
                  child: Container(
                    margin: EdgeInsets.only(
                        left: Device.screenType == sizer.ScreenType.mobile
                            ? 10
                            : Device.width / 5,
                        right: Device.screenType == sizer.ScreenType.mobile
                            ? 10
                            : Device.width / 5,
                        bottom: 10,
                        top: 10),
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, bottom: 10, top: 10),
                    decoration: BoxDecoration(
                      color: white.withOpacity(0.8),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          spreadRadius: 2,
                          color: black.withOpacity(0.2),
                        )
                      ],
                    ),
                    child: GNav(
                      rippleColor: Colors.grey[300]!,
                      hoverColor: Colors.grey[100]!,
                      gap: 5,
                      curve: Curves.bounceInOut,
                      activeColor: white,
                      iconSize: Device.screenType == sizer.ScreenType.mobile
                          ? 24
                          : 30,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      duration: const Duration(milliseconds: 400),
                      tabBorderRadius: 15,
                      tabBackgroundColor: primaryColor,
                      color: primaryColor,
                      tabs: const [
                        GButton(
                            icon: Icons.home_rounded,
                            text: BottomConstant.home),
                        GButton(
                            icon: Icons.search_rounded,
                            text: BottomConstant.search),
                        GButton(
                            icon: Icons.person_rounded,
                            text: BottomConstant.profile)
                      ],
                      selectedIndex: controller.currentPage,
                      onTabChange: (index) {
                        setState(() {
                          controller.changeIndex(index);
                        });
                      },
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }

  void callback(int index) async {
    setState(() {
      controller.currentPage = index;
    });
  }
}
