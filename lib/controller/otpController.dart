import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/Repository.dart';
import 'package:ibh/api_handle/apiCallingFormate.dart';
import 'package:ibh/componant/dialogs/dialogs.dart';
import 'package:ibh/componant/dialogs/loading_indicator.dart';
import 'package:ibh/configs/apicall_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/internet_controller.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/log.dart';
import 'package:ibh/views/auth/ReserPasswordScreen/ChangepasswordScreen.dart';

class OtpController extends GetxController {
  final InternetController networkManager = Get.find<InternetController>();
  final GlobalKey<FormState> otpkey = GlobalKey<FormState>();
  Rx<ScreenState> states = ScreenState.apiLoading.obs;
  RxBool isLoading = true.obs;
  bool? isPassword;
  late FocusNode oneNode, twoNode, threeNode, fourNode;
  late TextEditingController fieldOne, fieldTwo, fieldThree, fieldFour;
  final otpController = TextEditingController();
  final otpNode = FocusNode();
  RxString message = "".obs;

  @override
  void onInit() {
    oneNode = FocusNode();
    twoNode = FocusNode();
    threeNode = FocusNode();
    fourNode = FocusNode();

    fieldOne = TextEditingController();
    fieldTwo = TextEditingController();
    fieldThree = TextEditingController();
    fieldFour = TextEditingController();
    fieldOne.text = '';
    fieldTwo.text = '';
    fieldThree.text = '';
    fieldFour.text = '';
    isLoading.value = false;

    super.onInit();
  }

  @override
  void onClose() {
    fieldOne.dispose();
    fieldTwo.dispose();
    fieldThree.dispose();
    fieldFour.dispose();
    otpController.dispose();
    otpNode.dispose();
    super.onClose();
  }

  String getOTP() {
    String otp = fieldOne.text.trim() +
        fieldTwo.text.trim() +
        fieldThree.text.trim() +
        fieldFour.text.trim();

    return otp;
  }

  RxInt countdown = 60.obs;
  late Timer timer;
  bool isTimerRunning = false;
  void startTimer() {
    if (!isTimerRunning) {
      isTimerRunning = true;
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (countdown > 0) {
          countdown--;
          update();
        } else {
          stopTimer();
        }
      });
    }
  }

  void stopTimer() {
    if (isTimerRunning) {
      isTimerRunning = false;
      timer.cancel();
    }
  }

  void enableButton(
    value,
  ) {
    if (isPassword == true) {
      if (value.trim().length < 6) {
        isFormInvalidate.value = false;
      } else {
        isFormInvalidate.value = true;
      }
      update();
    } else {
      if (value.trim().length < 6) {
        isFormInvalidate.value = false;
      } else {
        isFormInvalidate.value = true;
      }
    }
    update();
  }

  RxBool isFormStartFilling = false.obs;
  RxBool isFormInvalidate = false.obs;

  void clearFocuseNode() {
    fieldOne.clear();
    fieldTwo.clear();
    fieldThree.clear();
    fieldFour.clear();
  }

  void verifyForgotOtp(context, String email) async {
    var loadingIndicator = LoadingProgressDialog();
    loadingIndicator.show(context, '');

    try {
      if (networkManager.connectionType.value == 0) {
        loadingIndicator.hide(context);
        showDialogForScreen(context, OtpConstant.title, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }
      logcat("RESET_PASS_PARAM", {
        "email": email,
        "otp": otpController.text.toString(),
      });
      var response = await Repository.post({
        "email": email,
        "otp": otpController.text.toString(),
      }, ApiUrl.verifyForgotOtp);
      loadingIndicator.hide(context);
      var data = jsonDecode(response.body);
      logcat("RESPONSE", jsonEncode(data));
      if (response.statusCode == 200) {
        if (data['success'] == true) {
          Get.to(ChangePasswordScreen(
            fromProfile: false,
            email: email,
            otp: otpController.text.toString(),
          ))!
              .then((value) {
            otpController.text = '';
            FocusScope.of(context).requestFocus(otpNode);
          });
        } else {
          showDialogForScreen(
              context,
              OtpConstant.title,
              data['message']
                      .toString()
                      .contains('The selected code is invalid.')
                  ? "Entered OTP is invalid."
                  : data['message'], callback: () {
            FocusScope.of(context).requestFocus(otpNode);
            otpController.text = "";
          });
        }
      } else {
        showDialogForScreen(
            context,
            OtpConstant.title,
            data['message'].toString().contains('The selected code is invalid.')
                ? "Entered OTP is invalid."
                : data['message'], callback: () {
          startTimer();
          FocusScope.of(context).requestFocus(otpNode);
          otpController.text = "";
        });
      }
    } catch (e) {
      logcat("Exception", e);
      showDialogForScreen(context, OtpConstant.title, Connection.servererror,
          callback: () {});
    }
  }

  void getForgotOtp(context, String email) async {
    commonPostApiCallFormate(context,
        title: OtpConstant.title,
        body: {"email": email.toString().trim()},
        apiEndPoint: ApiUrl.forgotPass, onResponse: (data) {
      otpController.text = '';
      FocusScope.of(context).requestFocus(otpNode);
    }, networkManager: networkManager, isModelResponse: false);
  }
}
