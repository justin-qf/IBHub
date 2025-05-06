// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ibh/componant/dialogs/dialogs.dart';
// import 'package:ibh/configs/string_constant.dart';
// import 'package:ibh/utils/enum.dart';
// import 'internet_controller.dart';

// class UpdatedProfileController extends GetxController {
//   final InternetController networkManager = Get.find<InternetController>();

//   Rx<ScreenState> state = ScreenState.apiLoading.obs;
 
//   // late PageController pageController;
//   // var currentPage = 0;
//   // bool states = false;
//   // int isDarkModes = 0;
//   // String name = '';
//   // String number = '';
//   // RxString profilePic = "".obs;
//   // final formKey = GlobalKey<FormState>();
//   // var isLoading = false.obs;
//   // final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  

//   void hideKeyboard(context) {
//     FocusScopeNode currentFocus = FocusScope.of(context);
//     if (!currentFocus.hasPrimaryFocus) {
//       currentFocus.unfocus();
//     }
//   }


//   // showDialogForScreen(context, String message, {Function? callback}) {
//   //   showMessage(
//   //       context: context,
//   //       callback: () {
//   //         if (callback != null) {
//   //           callback();
//   //         }
//   //         return true;
//   //       },
//   //       message: message,
//   //       title: "Profile",
//   //       negativeButton: '',
//   //       positiveButton: Button.continues);
//   // }

//   // void initDataSet(BuildContext context) async {
//   //   SignInData? signInData = await UserPreferences().getSignInInfo();
//   //   name = signInData!.userName.toString();
//   //   update();
//   // }
// }
