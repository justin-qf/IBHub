import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/apiCallingFormate.dart';
import 'package:ibh/configs/apicall_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/internet_controller.dart';
import 'package:ibh/models/login_model.dart';
import 'package:ibh/preference/UserPreference.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/log.dart';
import 'package:ibh/views/sigin_signup/signinScreen.dart';

import '../Models/sign_in_form_validation.dart';

class ChangePasswordController extends GetxController {
  final InternetController networkManager = Get.find<InternetController>();
  Rx<ScreenState> states = ScreenState.apiLoading.obs;
  final resetpasskey = GlobalKey<FormState>();

  late FocusNode currentpassNode, newpassNode, confirmpassNode;
  late TextEditingController currentCtr, newpassCtr, confirmCtr;

  var currentPassModel = ValidationModel(null, null, isValidate: false).obs;
  var newPassModel = ValidationModel(null, null, isValidate: false).obs;
  var confirmPassModel = ValidationModel(null, null, isValidate: false).obs;

  RxString message = "".obs;

  RxBool isFormInvalidate = false.obs;
  RxBool isForgotPasswordValidate = false.obs;

  RxBool obsecureOldPasswordText = true.obs;
  RxBool obsecureNewPasswordText = true.obs;
  RxBool obsecureConfirmPasswordText = true.obs;

  @override
  void onInit() {
    currentpassNode = FocusNode();
    newpassNode = FocusNode();
    confirmpassNode = FocusNode();
    currentCtr = TextEditingController();
    newpassCtr = TextEditingController();
    confirmCtr = TextEditingController();
    super.onInit();
  }

  void validateCurrentPass(String? val) {
    currentPassModel.update((model) {
      if (val != null && val.toString().trim().isEmpty) {
        model!.error = ChangPasswordScreenConstant.currentPasswordHint;
        model.isValidate = false;
      } else if (val!.contains(' ')) {
        model!.error = LoginConst.hintSpaceNotAllowed;
        model.isValidate = false;
      } else if (val.toString().trim().length <= 7) {
        model!.error = ChangPasswordScreenConstant.validPasswordHint;
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });
    enableSignUpButton();
  }

  void validateNewPass(String? val) {
    newPassModel.update((model) {
      if (val != null && val.toString().trim().isEmpty) {
        model!.error = ChangPasswordScreenConstant.newPasswordHint;
        model.isValidate = false;
      } else if (val!.contains(' ')) {
        model!.error = LoginConst.hintSpaceNotAllowed;
        model.isValidate = false;
      } else if (val.toString().trim().length <= 7) {
        model!.error = ChangPasswordScreenConstant.validPasswordHint;
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
      if (confirmCtr.text.toString().isNotEmpty) {
        if (val.toString().trim() != confirmCtr.text.toString().trim()) {
          confirmPassModel.update((model1) {
            model1!.error = ChangPasswordScreenConstant.notMatchPasswordHint;
            model1.isValidate = false;
          });
        } else {
          confirmPassModel.update((model1) {
            model1!.error = null;
            model1.isValidate = true;
          });
        }
      }
    });

    enableSignUpButton();
  }

  void validateConfirmPass(String? val) {
    confirmPassModel.update((model) {
      if (val != null && val.toString().trim().isEmpty) {
        model!.error = ChangPasswordScreenConstant.validConfirmPasswordHint;
        model.isValidate = false;
      } else if (val!.contains(' ')) {
        model!.error = LoginConst.hintSpaceNotAllowed;
        model.isValidate = false;
      } else if (val.toString().trim() != newpassCtr.text.toString().trim()) {
        model!.error = ChangPasswordScreenConstant.notMatchPasswordHint;
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });

    enableSignUpButton();
  }

  void validateNewPassword(String? val) {
    newPassModel.update((model) {
      if (val != null && val.toString().trim().isEmpty) {
        model!.error = ChangPasswordScreenConstant.newPasswordHint;
        model.isValidate = false;
      } else if (val!.contains(' ')) {
        model!.error = LoginConst.hintSpaceNotAllowed;
        model.isValidate = false;
      } else if (val.toString().trim().length <= 7) {
        model!.error = ChangPasswordScreenConstant.validPasswordHint;
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });
    if (confirmCtr.text.toString().isNotEmpty) {
      if (val.toString().trim() != confirmCtr.text.toString().trim()) {
        confirmPassModel.update((model1) {
          model1!.error = ChangPasswordScreenConstant.notMatchPasswordHint;
          model1.isValidate = false;
        });
      } else {
        confirmPassModel.update((model1) {
          model1!.error = null;
          model1.isValidate = true;
        });
      }
    }

    enableForgotButton();
  }

  void validateForgotPass(String? val) {
    confirmPassModel.update((model) {
      if (val != null && val.toString().trim().isEmpty) {
        model!.error = ChangPasswordScreenConstant.validConfirmPasswordHint;
        model.isValidate = false;
      } else if (val!.contains(' ')) {
        model!.error = LoginConst.hintSpaceNotAllowed;
        model.isValidate = false;
      } else if (val.toString().trim() != newpassCtr.text.toString().trim()) {
        model!.error = ChangPasswordScreenConstant.notMatchPasswordHint;
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });
    enableForgotButton();
  }

  void enableSignUpButton() {
    if (currentPassModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (newPassModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (confirmPassModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else {
      isFormInvalidate.value = true;
    }
  }

  void enableForgotButton() {
    if (newPassModel.value.isValidate == false) {
      isForgotPasswordValidate.value = false;
    } else if (confirmPassModel.value.isValidate == false) {
      isForgotPasswordValidate.value = false;
    } else {
      isForgotPasswordValidate.value = true;
    }
  }

  void changePasswordApi(context, bool fromProfile) async {
    // User? signInData = await UserPreferences().getSignInInfo();
    commonPostApiCallFormate(context,
        title: ChangPasswordScreenConstant.title,
        body: {
          "current_password": currentCtr.text.toString().trim(),
          "password": newpassCtr.text.toString().trim(),
          "confirm_password": confirmCtr.text.toString().trim(),
        },
        apiEndPoint: ApiUrl.changePassword,
        allowHeader: true, onResponse: (data) {
      if (fromProfile) {
        Get.back();
      } else {
        // Get.to(const MainScreen());
      }
    }, networkManager: networkManager);
  }

  void forgotPassApi(context, String email, String otp) async {
    logcat("PARAM", {
      "email": email,
      "password": newpassCtr.text.toString().trim(),
      "password_confirmation": confirmCtr.text.toString().trim()
    });
    commonPostApiCallFormate(context,
        title: ResetPasstext.title,
        body: {
          "email": email,
          "password": newpassCtr.text.toString().trim(),
          "password_confirmation": confirmCtr.text.toString().trim()
        },
        apiEndPoint: ApiUrl.updateForgotPassword, onResponse: (data) {
      Get.offAll(const Signinscreen());
    }, networkManager: networkManager);
  }
}
