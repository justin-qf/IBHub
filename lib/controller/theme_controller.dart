// import 'package:flutter/material.dart';
// import 'package:get/get.dart';


// class ThemeController extends GetxController {
//   final GetStorage storage = GetStorage();
//   final Statusbar _statusbar = Statusbar();
//   RxBool isDark = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     isDark.value = storage.read(GetStorageKey.IS_DARK_MODE) == 1;
//     _updateStatusBar();
//   }

//   void toggleTheme() {
//     isDark.value = !isDark.value;
//     Get.changeTheme(
//       isDark.value
//           ? ThemeData.dark(useMaterial3: true)
//           : ThemeData.light(useMaterial3: true),
//     );
//     storage.write(GetStorageKey.IS_DARK_MODE, isDark.value ? 1 : 0);
//     _updateStatusBar();
//   }

//   void resetTheme() {
//     isDark.value = false;
//     Get.changeTheme(ThemeData.light(useMaterial3: true));
//     storage.write(GetStorageKey.IS_DARK_MODE, 0);
//     _updateStatusBar();
//   }

//   void _updateStatusBar() {
//     _statusbar.trasparentStatusbar(); 
//   }
// }
