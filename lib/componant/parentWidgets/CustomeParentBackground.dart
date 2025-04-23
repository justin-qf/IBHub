import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/controller/internet_controller.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class CustomParentScaffold extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Widget body;
  Future<bool> Function()? onWillPop;
  bool isExtendBodyScreen;
  final Widget? floatingActionBtn;
  Widget? bottomNavigationBar;
  bool isdraweruse;
  Drawer? drower;
  bool drawerEnableOpenDragGesture;

  Function()? onTap;

  CustomParentScaffold({
    this.scaffoldKey,
    super.key,
    this.onWillPop,
    required this.body,
    this.floatingActionBtn,
    this.onTap,
    this.bottomNavigationBar,
    this.isdraweruse = false,
    this.drower,
    this.isExtendBodyScreen = false,
    this.drawerEnableOpenDragGesture = false,
  });

  @override
  Widget build(BuildContext context) {
    final InternetController internetController =
        Get.find<InternetController>();

    return GestureDetector(
      onTap: () {
        if (onTap != null) onTap!();
      },
      child: Obx(() {
        if (internetController.connectivityResult.value ==
            ConnectivityResult.none) {
          return checkInternet();
        }
        Color bgColor = Theme.of(context).scaffoldBackgroundColor;
        return PopScope(
          canPop: onWillPop == null, // Allow pop if no callback
          onPopInvoked: (didPop) async {
            if (didPop) return; // If already popped, do nothing
            if (onWillPop != null) {
              final shouldPop = await onWillPop!();
              if (shouldPop && context.mounted) {
                Get.back();
              }
            }
          },
          child: isExtendBodyScreen
              ? Scaffold(
                  extendBodyBehindAppBar: true,
                  resizeToAvoidBottomInset: true,
                  key: scaffoldKey,
                  drawer: isdraweruse
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: SizedBox(height: 80.h, child: drower))
                      : null,
                  drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
                  bottomNavigationBar: bottomNavigationBar,
                  backgroundColor: bgColor,
                  // resizeToAvoidBottomInset: isSmallDevice(context),
                  body: body,
                )
              : SafeArea(
                  child: Scaffold(
                    key: scaffoldKey,
                    drawer: isdraweruse
                        ? Align(
                            alignment: Alignment.topLeft,
                            child: SizedBox(height: 80.h, child: drower))
                        : null,
                    drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
                    bottomNavigationBar: bottomNavigationBar,
                    backgroundColor: bgColor,
                    body: body,
                  ),
                ),
        );
      }),
    );
  }
}

// class CustomParentScaffold extends StatelessWidget {
//   final GlobalKey<ScaffoldState>? scaffoldKey;
//   final Widget body;
//   Future<bool> Function()? onWillPop;
//   bool isNormalScreen;
//   bool isFormScreen;
//   bool isExtendBodyScreen;

//   final Widget? floatingActionBtn;
//   Widget? bottomNavigationBar;
//   bool isdraweruse;
//   Drawer? drower;
//   bool drawerEnableOpenDragGesture;

//   Function()? onTap;

//   CustomParentScaffold({
//     this.scaffoldKey,
//     super.key,
//     this.onWillPop,
//     required this.body,
//     this.floatingActionBtn,
//     this.isNormalScreen = false,
//     this.isFormScreen = false,
//     this.isExtendBodyScreen = false,
//     this.onTap,
//     this.bottomNavigationBar,
//     this.isdraweruse = false,
//     this.drower,
//     this.drawerEnableOpenDragGesture = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final InternetController internetController =
//         Get.find<InternetController>();

//     return GestureDetector(
//       onTap: () {
//         if (onTap != null) onTap!();
//       },
//       child: Obx(() {
//         if (internetController.connectivityResult.value ==
//             ConnectivityResult.none) {
//           return checkInternet();
//         }

//         Color bgColor = Theme.of(context).scaffoldBackgroundColor;
//         return isNormalScreen
//             ? Scaffold(
//                 key: scaffoldKey,
//                 drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
//                 drawer: isdraweruse
//                     ? Align(
//                         alignment: Alignment.topLeft,
//                         child: SizedBox(height: 80.h, child: drower))
//                     : null,
//                 backgroundColor: bgColor,
//                 floatingActionButton: floatingActionBtn,
//                 resizeToAvoidBottomInset: false,
//                 bottomNavigationBar: bottomNavigationBar,
//                 body: SafeArea(child: body),
//               )
//             : isExtendBodyScreen
//                 ? Scaffold(
//                     key: scaffoldKey,
//                     drawer: isdraweruse
//                         ? Align(
//                             alignment: Alignment.topLeft,
//                             child: SizedBox(height: 80.h, child: drower))
//                         : null,
//                     drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
//                     bottomNavigationBar: bottomNavigationBar,
//                     backgroundColor: bgColor,
//                     extendBodyBehindAppBar: true,
//                     resizeToAvoidBottomInset: isSmallDevice(context),
//                     body: body,
//                   )
//                 : isFormScreen
//                     ? PopScope(
//                         canPop: onWillPop == null, // Allow pop if no callback
//                         onPopInvokedWithResult: (didPop, result) async {
//                           if (didPop) return; // If already popped, do nothing
//                           if (onWillPop != null) {
//                             final shouldPop = await onWillPop!();
//                             if (shouldPop && context.mounted) {
//                               Get.back();
//                             }
//                           }
//                         },
//                         child: Scaffold(
//                           key: scaffoldKey,
//                           drawer: isdraweruse
//                               ? Align(
//                                   alignment: Alignment.topLeft,
//                                   child: SizedBox(height: 80.h, child: drower))
//                               : null,
//                           drawerEnableOpenDragGesture:
//                               drawerEnableOpenDragGesture,
//                           bottomNavigationBar: bottomNavigationBar,
//                           backgroundColor: bgColor,
//                           extendBodyBehindAppBar: true,
//                           resizeToAvoidBottomInset: true,
//                           body: SafeArea(child: body),
//                         ),
//                       )
//                     : PopScope(
//                         canPop: onWillPop == null, // Allow pop if no callback
//                         onPopInvokedWithResult: (didPop, result) async {
//                           if (didPop) return; // If already popped, do nothing
//                           if (onWillPop != null) {
//                             final shouldPop = await onWillPop!();
//                             if (shouldPop && context.mounted) {
//                               Get.back();
//                             }
//                           }
//                         },
//                         child: Scaffold(
//                           key: scaffoldKey,
//                           drawer: isdraweruse
//                               ? Align(
//                                   alignment: Alignment.topLeft,
//                                   child: SizedBox(height: 80.h, child: drower))
//                               : null,
//                           drawerEnableOpenDragGesture:
//                               drawerEnableOpenDragGesture,
//                           bottomNavigationBar: bottomNavigationBar,
//                           backgroundColor: bgColor,
//                           body: body,
//                         ),
//                       );
//       }),
//     );
//   }
// }

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:science_cafe/componant/toolbar/toolbar.dart';
// import 'package:science_cafe/controller/internet_controller.dart';
// import 'package:sizer/sizer.dart';

// class CustomParentScaffold extends StatelessWidget {
//   final GlobalKey<ScaffoldState>? scaffoldKey;
//   final Widget body;
//   Future<bool> Function()? onWillPop;
//   bool isNormalScreen;
//   bool isFormScreen;
//   bool isExtendBodyScreen;

//   final Widget? floatingActionBtn;
//   Widget? bottomNavigationBar;
//   bool isdraweruse;
//   Drawer? drower;
//   bool drawerEnableOpenDragGesture;

//   Function()? onTap;

//   CustomParentScaffold({
//     this.scaffoldKey,
//     super.key,
//     this.onWillPop,
//     required this.body,
//     this.floatingActionBtn,
//     this.isNormalScreen = false,
//     this.isFormScreen = false,
//     this.isExtendBodyScreen = false,
//     this.onTap,
//     this.bottomNavigationBar,
//     this.isdraweruse = false,
//     this.drower,
//     this.drawerEnableOpenDragGesture = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final InternetController internetController =
//         Get.find<InternetController>();

//     return GestureDetector(
//       onTap: () {
//         if (onTap != null) onTap!();
//       },
//       child: Obx(() {
//         if (internetController.connectivityResult.value ==
//             ConnectivityResult.none) {
//           return checkInternet();
//         }

//         Color bgColor = Theme.of(context).scaffoldBackgroundColor;
//         return isNormalScreen
//             ? Scaffold(
//                 key: scaffoldKey,
//                 drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
//                 drawer: isdraweruse
//                     ? Align(
//                         alignment: Alignment.topLeft,
//                         child: SizedBox(height: 80.h, child: drower))
//                     : null,
//                 backgroundColor: bgColor,
//                 floatingActionButton: floatingActionBtn,
//                 resizeToAvoidBottomInset: false,
//                 bottomNavigationBar: bottomNavigationBar,
//                 body: SafeArea(child: body),
//               )
//             : isExtendBodyScreen
//                 ? Scaffold(
//                     key: scaffoldKey,
//                     drawer: isdraweruse
//                         ? Align(
//                             alignment: Alignment.topLeft,
//                             child: SizedBox(height: 80.h, child: drower))
//                         : null,
//                     drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
//                     bottomNavigationBar: bottomNavigationBar,
//                     backgroundColor: bgColor,
//                     extendBodyBehindAppBar: true,
//                     resizeToAvoidBottomInset: isSmallDevice(context),
//                     body: body,
//                   )
//                 : isFormScreen
//                     ? WillPopScope(
//                         onWillPop: onWillPop,
//                         child: Scaffold(
//                           key: scaffoldKey,
//                           drawer: isdraweruse
//                               ? Align(
//                                   alignment: Alignment.topLeft,
//                                   child: SizedBox(height: 80.h, child: drower))
//                               : null,
//                           drawerEnableOpenDragGesture:
//                               drawerEnableOpenDragGesture,
//                           bottomNavigationBar: bottomNavigationBar,
//                           backgroundColor: bgColor,
//                           extendBodyBehindAppBar: true,
//                           resizeToAvoidBottomInset: true,
//                           body: SafeArea(child: body),
//                         ),
//                       )
//                     : WillPopScope(
//                         onWillPop: onWillPop,
//                         child: Scaffold(
//                           key: scaffoldKey,
//                           drawer: isdraweruse
//                               ? Align(
//                                   alignment: Alignment.topLeft,
//                                   child: SizedBox(height: 80.h, child: drower))
//                               : null,
//                           drawerEnableOpenDragGesture:
//                               drawerEnableOpenDragGesture,
//                           bottomNavigationBar: bottomNavigationBar,
//                           backgroundColor: bgColor,
//                           body: body,
//                         ),
//                       );
//       }),
//     );
//   }
// }
