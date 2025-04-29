import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/apiCallingFormate.dart';
import 'package:ibh/configs/apicall_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/internet_controller.dart';
import 'package:ibh/models/sign_in_form_validation.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/log.dart';
import 'package:ibh/views/sigin_signup/signinScreen.dart';
import 'MasterController.dart';

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

  var _obsecureCurrentTextPass = true.obs;
  bool get isObsecureCurrentPassText => _obsecureCurrentTextPass.value;
  set isObsecureCurrentPassText(bool value) =>
      _obsecureCurrentTextPass.value = value;

  var _obsecureNewTextCPass = true.obs;
  bool get isObsecureNewPassText => _obsecureNewTextCPass.value;
  set isObsecureNewPassText(bool value) => _obsecureNewTextCPass.value = value;

  var _obsecureNewConTextCPass = true.obs;
  bool get isObsecureNewConPassText => _obsecureNewConTextCPass.value;
  set isObsecureNewConPassText(bool value) =>
      _obsecureNewConTextCPass.value = value;

  void toggleCurrentPassObscureText() {
    _obsecureCurrentTextPass.value = !_obsecureCurrentTextPass.value;
  }

  void toggleNewPassObscureText() {
    _obsecureNewTextCPass.value = !_obsecureNewTextCPass.value;
  }

  void toggleNewConPassObscureText() {
    _obsecureNewConTextCPass.value = !_obsecureNewConTextCPass.value;
  }

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

  @override
  void onClose() {
    newpassCtr.clear();
    currentCtr.clear();
    confirmCtr.clear();

    isFormInvalidate.value = false;
    isForgotPasswordValidate.value = false;

    currentPassModel = ValidationModel(null, null, isValidate: false).obs;
    newPassModel = ValidationModel(null, null, isValidate: false).obs;
    confirmPassModel = ValidationModel(null, null, isValidate: false).obs;

    super.onClose();
  }

  validateFields(val,
      {model,
      errorText1,
      errorText2,
      errorText3,
      ispassword = false,
      isconfirmpassword = false,
      confirmpasswordctr,
      isforgotpasswordfunction = false}) {
    return validateField(
      val: val,
      models: model,
      errorText1: errorText1,
      errorText2: errorText2,
      errorText3: errorText3,
      ispassword: ispassword,
      isconfirmpassword: isconfirmpassword,
      confirmpasswordctr: confirmpasswordctr,
      notifyListeners: () {
        update();
      },
      enableBtnFunction: () {
        if (isforgotpasswordfunction == true) {
          enableForgotButton();
        } else {
          enableSignUpButton();
        }
      },
    );
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
          "new_password": newpassCtr.text.toString().trim(),
          "new_password_confirmation": confirmCtr.text.toString().trim(),
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
      Future.delayed(Duration(milliseconds: 100), () {
        Get.offAll(const Signinscreen());
      });
    }, networkManager: networkManager);
  }
}
