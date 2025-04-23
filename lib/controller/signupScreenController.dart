import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/MasterController.dart';
import 'package:ibh/controller/internet_controller.dart';
import 'package:ibh/models/sign_in_form_validation.dart';
import 'package:ibh/utils/enum.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class Signupscreencontroller extends GetxController {
  final InternetController networkManager = Get.find<InternetController>();

  Rx<ScreenState> state = ScreenState.apiLoading.obs;

  late FocusNode nameNode,
      emailNode,
      phoneNode,
      bussinessNode,
      stateNode,
      cityNode,
      pincodeNode,
      visitingcardNode,
      passNode,
      confpassNode;
  late TextEditingController nameCtr,
      emailCtr,
      phoneCtr,
      bussinessCtr,
      stateCtr,
      cityCtr,
      pincodeCtr,
      visitingcardCtr,
      passCtr,
      confpassCtr;

  var nameModel = ValidationModel(null, null, isValidate: false).obs;
  var emailModel = ValidationModel(null, null, isValidate: false).obs;
  var phoneModel = ValidationModel(null, null, isValidate: false).obs;
  var bussinessModel = ValidationModel(null, null, isValidate: false).obs;
  var stateModel = ValidationModel(null, null, isValidate: false).obs;
  var cityModel = ValidationModel(null, null, isValidate: false).obs;
  var pincodeModel = ValidationModel(null, null, isValidate: false).obs;
  var visitingCardModel = ValidationModel(null, null, isValidate: false).obs;
  var passModel = ValidationModel(null, null, isValidate: false).obs;
  var confpassModel = ValidationModel(null, null, isValidate: false).obs;

  RxBool isFormInvalidate = false.obs;

  var _isLoading = false.obs;
  bool get isloading => _isLoading.value;
  set isloading(bool value) => _isLoading.value = value;

  var _obsecureTextPass = true.obs;
  bool get isObsecurePassText => _obsecureTextPass.value;
  set isObsecurePassText(bool value) => _obsecureTextPass.value = value;

  var _obsecureTextConPass = true.obs;
  bool get isObsecureConPassText => _obsecureTextConPass.value;
  set isObsecureConPassText(bool value) => _obsecureTextConPass.value = value;

  Signupscreencontroller() {
    nameNode = FocusNode();
    emailNode = FocusNode();
    phoneNode = FocusNode();
    bussinessNode = FocusNode();
    stateNode = FocusNode();
    cityNode = FocusNode();
    pincodeNode = FocusNode();
    visitingcardNode = FocusNode();
    passNode = FocusNode();
    confpassNode = FocusNode();

    nameCtr = TextEditingController();
    emailCtr = TextEditingController();
    phoneCtr = TextEditingController();
    bussinessCtr = TextEditingController();
    stateCtr = TextEditingController();
    cityCtr = TextEditingController();
    pincodeCtr = TextEditingController();
    visitingcardCtr = TextEditingController();
    passCtr = TextEditingController();
    confpassCtr = TextEditingController();
  }

  void togglePassObscureText() {
    _obsecureTextPass.value = !_obsecureTextPass.value;
    update();
  }

  void toggleConfPassObscureText() {
    _obsecureTextConPass.value = !_obsecureTextConPass.value;
    update();
  }

  unfocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void enableSignUpButton() {
    if (nameModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (emailModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (phoneModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (bussinessModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (stateModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (cityModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (pincodeModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (visitingCardModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (passModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (confpassModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else {
      isFormInvalidate.value = true;
    }
    update();
  }

  @override
  void onClose() {
    // Dispose focus nodes
    nameNode.dispose();
    emailNode.dispose();
    phoneNode.dispose();
    bussinessNode.dispose();
    stateNode.dispose();
    cityNode.dispose();
    pincodeNode.dispose();
    visitingcardNode.dispose();
    passNode.dispose();
    confpassNode.dispose();

    // Dispose and clear text controllers
    nameCtr.dispose();
    emailCtr.dispose();
    phoneCtr.dispose();
    bussinessCtr.dispose();
    stateCtr.dispose();
    cityCtr.dispose();
    pincodeCtr.dispose();
    visitingcardCtr.dispose();
    passCtr.dispose();
    confpassCtr.dispose();

    nameCtr.clear();
    emailCtr.clear();
    phoneCtr.clear();
    bussinessCtr.clear();
    stateCtr.clear();
    cityCtr.clear();
    pincodeCtr.clear();
    visitingcardCtr.clear();
    passCtr.clear();
    confpassCtr.clear();

    // Reset all validation models
    nameModel.value = ValidationModel(null, null, isValidate: false);
    emailModel.value = ValidationModel(null, null, isValidate: false);
    phoneModel.value = ValidationModel(null, null, isValidate: false);
    bussinessModel.value = ValidationModel(null, null, isValidate: false);
    stateModel.value = ValidationModel(null, null, isValidate: false);
    cityModel.value = ValidationModel(null, null, isValidate: false);
    pincodeModel.value = ValidationModel(null, null, isValidate: false);
    visitingCardModel.value = ValidationModel(null, null, isValidate: false);
    passModel.value = ValidationModel(null, null, isValidate: false);
    confpassModel.value = ValidationModel(null, null, isValidate: false);

    // Reset reactive variables
    isFormInvalidate.value = false;
    _isLoading.value = false;
    _obsecureTextPass.value = true;
    _obsecureTextConPass.value = true;

    super.onClose();
  }

  void resetForm() {
    // Clear text controllers
    nameCtr.clear();
    emailCtr.clear();
    phoneCtr.clear();
    bussinessCtr.clear();
    stateCtr.clear();
    cityCtr.clear();
    pincodeCtr.clear();
    visitingcardCtr.clear();
    passCtr.clear();
    confpassCtr.clear();

    // Unfocus all nodes
    nameNode.unfocus();
    emailNode.unfocus();
    phoneNode.unfocus();
    bussinessNode.unfocus();
    stateNode.unfocus();
    cityNode.unfocus();
    pincodeNode.unfocus();
    visitingcardNode.unfocus();
    passNode.unfocus();
    confpassNode.unfocus();

    // Reset validation models
    nameModel.value = ValidationModel(null, null, isValidate: false);
    emailModel.value = ValidationModel(null, null, isValidate: false);
    phoneModel.value = ValidationModel(null, null, isValidate: false);
    bussinessModel.value = ValidationModel(null, null, isValidate: false);
    stateModel.value = ValidationModel(null, null, isValidate: false);
    cityModel.value = ValidationModel(null, null, isValidate: false);
    pincodeModel.value = ValidationModel(null, null, isValidate: false);
    visitingCardModel.value = ValidationModel(null, null, isValidate: false);
    passModel.value = ValidationModel(null, null, isValidate: false);
    confpassModel.value = ValidationModel(null, null, isValidate: false);

    // Reset reactive variables
    isFormInvalidate.value = false;
    _isLoading.value = false;
    _obsecureTextPass.value = true;
    _obsecureTextConPass.value = true;

    update();
  }

  final ImagePicker _picker = ImagePicker();
  Rxn<XFile> imageFile = Rxn<XFile>();

  // String imagePath = "";

  Future<void> _pickImage({bool iscamera = false}) async {
    final XFile? image = await _picker.pickImage(
      source: iscamera ? ImageSource.camera : ImageSource.gallery,
    );

    if (image != null) {
      print('Picked Image Path: ${image.path}');
      // imagePath = image.path;
      imageFile.value = image;
      final String fileName = path.basename(image.path);
      visitingcardCtr.text = fileName;
      update(); // not needed if you're using Obx(), but required for GetBuilder
    } else {
      print('No image selected');
    }
  }

  void showOptionsCupertinoDialog({required BuildContext context}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Background",
    barrierColor:  black.withOpacity(0.6), // Dark overlay, no blur
    transitionDuration: Duration(milliseconds: 200),
    pageBuilder: (context, animation1, animation2) {
      return Center(
        child: CupertinoAlertDialog(
          title: Text('Choose an Option'),
          content: Text(
            'Select how you want to add the picture.',
            style: TextStyle(fontFamily: dM_sans_medium),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text('Camera', style: TextStyle(color: black)),
              onPressed: () {
                Navigator.of(context).pop();
                _pickImage(iscamera: true);
              },
            ),
            CupertinoDialogAction(
              child: Text('Gallery', style: TextStyle(color: black)),
              onPressed: () {
                Navigator.of(context).pop();
                _pickImage(iscamera: false);
              },
            ),
          ],
        ),
      );
    },
  );
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
}
