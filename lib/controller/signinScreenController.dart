import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/controller/MasterController.dart';

import 'package:ibh/controller/internet_controller.dart';
import 'package:ibh/models/sign_in_form_validation.dart';
import 'package:ibh/utils/enum.dart';

class Signinscreencontroller extends GetxController {
  final InternetController networkManager = Get.find<InternetController>();

  Rx<ScreenState> state = ScreenState.apiLoading.obs;

  late FocusNode emailNode, passNode;
  late TextEditingController emailCtr, passCtr;
  var emailModel = ValidationModel(null, null, isValidate: false).obs;
  var passModel = ValidationModel(null, null, isValidate: false).obs;
  RxBool isFormInvalidate = false.obs;

  Signinscreencontroller() {
    emailNode = FocusNode();
    passNode = FocusNode();

    emailCtr = TextEditingController();
    passCtr = TextEditingController();
  }

  var _isLoading = false.obs;
  bool get isloading => _isLoading.value;
  set isloading(bool value) => _isLoading.value = value;

  // Obscure text
  var _obsecureTextPass = true.obs;
  bool get isObsecurePassText => _obsecureTextPass.value;
  set isObsecurePassText(bool value) => _obsecureTextPass.value = value;

  void togglePassObscureText() {
    _obsecureTextPass.value = !_obsecureTextPass.value;
    update();
  }

  @override
  void onClose() {
    // Dispose controllers and focus nodes
    emailNode.dispose();
    passNode.dispose();
    emailCtr.dispose();
    passCtr.dispose();
    emailCtr.clear();
    passCtr.clear();

    // Reset all reactive variables
    emailModel.value = ValidationModel(null, null, isValidate: false);
    passModel.value = ValidationModel(null, null, isValidate: false);
    isFormInvalidate.value = false;

    _isLoading.value = false;

    super.onClose();
  }

  void resetForm() {
    emailCtr.clear();
    passCtr.clear();
    emailNode.unfocus();
    passNode.unfocus();

    emailModel.value = ValidationModel(null, null, isValidate: false);
    passModel.value = ValidationModel(null, null, isValidate: false);

    isFormInvalidate.value = false;
    _isLoading.value = false;
    _obsecureTextPass.value = true;

    // update();
  }

  void enableSignUpButton() {
    if (emailModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (passModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else {
      isFormInvalidate.value = true;
    }
    update();
  }

//for api use
  void validateLogin(BuildContext context) async {
    print('press');
  }

  validateFields(
    val, {
    required Rx<ValidationModel> model,
    errorText1,
    errorText2,
    errorText3,
    isemail=false,
    ispassword = false,
  }) {
    return validateField(
        val: val,
        models: model,
        isEmail: isemail,
        errorText1: errorText1,
        errorText2: errorText2,
        errorText3: errorText3,
        ispassword: ispassword,
        notifyListeners: () {
          refresh();
        },
        enableBtnFunction: () {
          enableSignUpButton();
        });
  }
}
