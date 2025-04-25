import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/Repository.dart';
import 'package:ibh/componant/dialogs/dialogs.dart';
import 'package:ibh/componant/dialogs/loading_indicator.dart';
import 'package:ibh/configs/apicall_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/models/login_model.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/views/sigin_signup/signinScreen.dart';
import '../../preference/UserPreference.dart';
import '../../utils/log.dart';
import 'internet_controller.dart';

class ProfileController extends GetxController {
  final InternetController networkManager = Get.find<InternetController>();

  Rx<ScreenState> states = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  RxString customerId = "".obs;

  RxString userName = "".obs;
  RxString number = "".obs;
  RxString email = "".obs;
  RxString profilePic = "".obs;
  RxString gender = "".obs;
  AnimationController? controllers;
  RxString? referCode = "".obs;

  @override
  void onInit() {
    logcat("test", "DONE");
    super.onInit();
  }

  getProfileData() async {
    states.value = ScreenState.apiLoading;
    User? retrievedObject = await UserPreferences().getSignInInfo();
    userName.value = retrievedObject!.name;
    email.value = retrievedObject.email;
    number.value = retrievedObject.phone;
    gender.value = retrievedObject.city.city;
    referCode!.value = retrievedObject.state.name;
    update();
    states.value = ScreenState.apiSuccess;
    logcat("referCode::", referCode!.value.toString());
  }

  BuildContext? contexts;
  // void getProfile(context) async {
  //   states.value = ScreenState.apiLoading;
  //   message.value = "There is error from the server";
  //   try {
  //     if (networkManager.connectionType.value == 0) {
  //       showDialogForScreen(context, "No Connection", callback: () {
  //         Get.back();
  //       });
  //       return;
  //     }

  //     var response = await Repository.get(
  //         {}, "${ApiUrl.getProfile}/$customerId",
  //         list: true);
  //     var data = jsonDecode(response.body);

  //     if (response.statusCode == 200) {
  //       if (data['status'] == true) {
  //         var models = User.fromJson(data['user_info']);
  //         UserPreferences().saveSignInInfo(data['user_info']);
  //         userName.value = models.fullName;
  //         email.value = models.emailId;
  //         number.value = models.mobileNumber;
  //         profilePic.value = models.profilePic;
  //         gender.value = models.gender;
  //       } else {
  //         showDialogForScreen(context, data['message'], callback: () {});
  //       }
  //       states.value = ScreenState.apiSuccess;
  //       message.value = "Server Error";
  //       update();
  //     } else {
  //       states.value = ScreenState.apiError;
  //       showDialogForScreen(context, data['message'], callback: () {});
  //     }
  //   } catch (e) {
  //     states.value = ScreenState.apiError;
  //   }
  // }

  void logoutApi(context) async {
    var loadingIndicator = LoadingProgressDialog();
    loadingIndicator.show(context, '');
    try {
      if (networkManager.connectionType.value == 0) {
        showDialogForScreen(context, "Profile", Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }

      var response = await Repository.get({}, ApiUrl.logout);
      loadingIndicator.hide(context);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (data['status'] == true) {
          Navigator.pop(context);
          UserPreferences().logout();
          Get.offAll(const Signinscreen());
        } else {
          showDialogForScreen(context, "Profile", data['message'],
              callback: () {
            Get.back();
          });
        }
        states.value = ScreenState.apiSuccess;
        message.value = "";
        update();
      } else {
        states.value = ScreenState.apiError;
        showDialogForScreen(context, "Profile", data['message'],
            callback: () {});
      }
    } catch (e) {
      states.value = ScreenState.apiError;
      showDialogForScreen(context, "Profile", ServerError.retryServererror,
          callback: () {});
    }
  }

  // deleteAccount(
  //   context,
  // ) async {
  //   var loadingIndicator = LoadingProgressDialog();
  //   loadingIndicator.show(context, '');

  //   try {
  //     if (networkManager.connectionType == 0) {
  //       loadingIndicator.hide(context);
  //       showDialogForScreen(context, Connection.noConnection, callback: () {
  //         Get.back();
  //       });
  //       return;
  //     }
  //     UserModelList? retrievedObject = await UserPreferences().getSignInInfo();
  //     var response = await Repository.delete(
  //         {}, '${ApiUrl.deleteAccount}/${retrievedObject!.customerId}',
  //         allowHeader: true);
  //     loadingIndicator.hide(context);
  //     var responseData = jsonDecode(response.body);
  //     if (response.statusCode == 200) {
  //       var data = DeleteModel.fromJson(responseData);
  //       if (data.status == true) {
  //         Navigator.pop(context);
  //         UserPreferences().logout();
  //         showDialogForScreen(context, responseData['message'], callback: () {
  //           Get.offAll(SignInScreen(isFromLogout: true));
  //         });
  //       } else {
  //         Navigator.pop(context);
  //         showDialogForScreen(context, responseData['message'],
  //             callback: () {});
  //         loadingIndicator.hide(context);
  //       }
  //     } else {
  //       loadingIndicator.hide(context);
  //       showDialogForScreen(context, responseData['message'] ?? "Server Error",
  //           callback: () {});
  //     }
  //   } catch (e) {
  //     loadingIndicator.hide(context);
  //     logcat('Exception', e);
  //   }
  // }
}
