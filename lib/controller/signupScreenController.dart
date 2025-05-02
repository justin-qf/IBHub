import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/apiCallingFormate.dart';
import 'package:ibh/configs/apicall_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/MasterController.dart';
import 'package:ibh/controller/internet_controller.dart';
import 'package:ibh/models/login_model.dart';
import 'package:ibh/models/sign_in_form_validation.dart';
import 'package:ibh/preference/UserPreference.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/helper.dart';
import 'package:ibh/utils/log.dart';
import 'package:ibh/views/mainscreen/MainScreen.dart';

class Signupscreencontroller extends GetxController {
  final InternetController networkManager = Get.find<InternetController>();

  Rx<ScreenState> state = ScreenState.apiLoading.obs;

  late FocusNode emailNode, passNode, confpassNode;
  late TextEditingController emailCtr, passCtr, confpassCtr;

  var emailModel = ValidationModel(null, null, isValidate: false).obs;
  var passModel = ValidationModel(null, null, isValidate: false).obs;
  var confpassModel = ValidationModel(null, null, isValidate: false).obs;

  RxBool isFormInvalidate = false.obs;

  var isLoading = false.obs;
  bool get isloading => isLoading.value;
  set isloading(bool value) => isLoading.value = value;

  var obsecureTextPass = true.obs;
  bool get isObsecurePassText => obsecureTextPass.value;
  set isObsecurePassText(bool value) => obsecureTextPass.value = value;

  var obsecureTextConPass = true.obs;
  bool get isObsecureConPassText => obsecureTextConPass.value;
  set isObsecureConPassText(bool value) => obsecureTextConPass.value = value;

  late TextEditingController searchStatectr;
  late FocusNode searchStateNode;
  var searchModel = ValidationModel(null, null, isValidate: false).obs;

  RxBool isStateApiCallLoading = false.obs;
  RxList stateFilterList = [].obs;
  RxString stateId = "".obs;
  RxList stateList = [].obs;

  void inti() {
    emailNode = FocusNode();
    passNode = FocusNode();
    confpassNode = FocusNode();
    searchStateNode = FocusNode();
    emailCtr = TextEditingController();
    passCtr = TextEditingController();
    confpassCtr = TextEditingController();
    searchStatectr = TextEditingController();
  }

  @override
  void onInit() {
    super.onInit();

    inti();
  }

  void togglePassObscureText() {
    obsecureTextPass.value = !obsecureTextPass.value;
    update();
  }

  void toggleConfPassObscureText() {
    obsecureTextConPass.value = !obsecureTextConPass.value;
    update();
  }

  unfocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void enableSignUpButton() {
    if (emailModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (passModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (confpassModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else {
      isFormInvalidate.value = true;
    }
    print("isFormInvalidate: ${isFormInvalidate.value}");
    update();
  }

  @override
  void onClose() {
    emailCtr.clear();

    passCtr.clear();
    confpassCtr.clear();
    emailModel.value = ValidationModel(null, null, isValidate: false);
    passModel.value = ValidationModel(null, null, isValidate: false);
    confpassModel.value = ValidationModel(null, null, isValidate: false);

    // Reset reactive variables
    isFormInvalidate.value = false;
    isLoading.value = false;
    obsecureTextPass.value = true;
    obsecureTextConPass.value = true;

    super.onClose();
  }

  void resetForm() {
    // Clear text fields
    emailCtr.clear();
    passCtr.clear();
    confpassCtr.clear();
    searchStatectr.clear();
    emailNode.unfocus();
    passNode.unfocus();
    confpassNode.unfocus();
    searchStateNode.unfocus();

    // Reset validation models
    emailModel.value = ValidationModel(null, null, isValidate: false);
    passModel.value = ValidationModel(null, null, isValidate: false);
    confpassModel.value = ValidationModel(null, null, isValidate: false);
    isFormInvalidate.value = false;
    isloading = false;
  }

  validateFields(val,
      {model,
      errorText1,
      errorText2,
      errorText3,
      iscomman = false,
      isselectionfield = false,
      isotp = false,
      isnumber = false,
      ispassword = false,
      isemail = false,
      isconfirmpassword = false,
      confirmpasswordctr,
      isPincode = false,
      shouldEnableButton = true}) {
    return validateField(
        iscomman: iscomman,
        val: val,
        models: model,
        errorText1: errorText1,
        errorText2: errorText2,
        errorText3: errorText3,
        isselectionfield: isselectionfield,
        isotp: isotp,
        isnumber: isnumber,
        ispassword: ispassword,
        isEmail: isemail,
        ispincode: isPincode,
        isconfirmpassword: isconfirmpassword,
        confirmpasswordctr: confirmpasswordctr,
        shouldEnableButton: shouldEnableButton,
        notifyListeners: () {
          update();
        },
        enableBtnFunction: () {
          enableSignUpButton();
        });
  }

  void registerAPI(context) async {
    // var loadingIndicator = LoadingProgressDialog();
    String? firebaseToken = await getFirebaseToken();
    logcat("firebaseToken::", firebaseToken.toString());
    commonPostApiCallFormate(context,
        title: LoginConst.signup,
        body: {
          "email": emailCtr.text.toString().trim(),
          "password": passCtr.text.toString().trim(),
          "password_confirmation": confpassCtr.text.toString(),
          "device_token": firebaseToken ?? ''
        },
        apiEndPoint: ApiUrl.register, onResponse: (data) {
      var responseDetail = LoginModel.fromJson(data);
      UserPreferences().saveSignInInfo(responseDetail.data!.user);
      UserPreferences().setToken(responseDetail.data!.user!.token.toString());
      Get.offAll(const MainScreen());
    }, networkManager: networkManager, isModelResponse: true);
  }
}
