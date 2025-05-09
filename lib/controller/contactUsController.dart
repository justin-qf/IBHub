import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/controller/MasterController.dart';
import 'package:ibh/controller/internet_controller.dart';
import 'package:ibh/models/login_model.dart';
import 'package:ibh/models/sign_in_form_validation.dart';
import 'package:ibh/preference/UserPreference.dart';
import 'package:ibh/utils/enum.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:sizer/sizer.dart' as sizer;

class Contactuscontroller extends GetxController {
  final InternetController networkManager = Get.find<InternetController>();

  Rx<ScreenState> state = ScreenState.apiLoading.obs;

  late FocusNode nameNode, emailNode, phoneNode, messageNode;

  late TextEditingController nameCtr, emailCtr, phoneCtr, messageCtr;

  var nameModel = ValidationModel(null, null, isValidate: false).obs;
  var emailModel = ValidationModel(null, null, isValidate: false).obs;
  var phoneModel = ValidationModel(null, null, isValidate: false).obs;
  var messageModel = ValidationModel(null, null, isValidate: false).obs;
  // var imageModel = ValidationModel(null, null, isValidate: false).obs;

  RxBool isFormInvalidate = false.obs;

  void inti() {
    nameNode = FocusNode();
    emailNode = FocusNode();
    phoneNode = FocusNode();
    messageNode = FocusNode();

    nameCtr = TextEditingController();
    emailCtr = TextEditingController();
    phoneCtr = TextEditingController();
    messageCtr = TextEditingController();
  }

  getprofile(BuildContext context) async {
    User? retrievedObject = await UserPreferences().getSignInInfo();

    if (retrievedObject == null) {
      // You could show an error, fallback, or early return
      // print("Retrieved user is null");
      return;
    }

    if (retrievedObject.name != null) {
      nameCtr.text = retrievedObject.name!;
    }

    if (retrievedObject.phone != null) {
      phoneCtr.text = retrievedObject.phone!;
    }

    if (retrievedObject.email != null) {
      emailCtr.text = retrievedObject.email!;
    }
  }

  @override
  void onInit() {
    super.onInit();

    inti();
  }

  @override
  void onClose() {
    nameCtr.clear();
    emailCtr.clear();
    phoneCtr.clear();
    messageCtr.clear();

    // Reset all validation models
    nameModel.value = ValidationModel(null, null, isValidate: false);
    emailModel.value = ValidationModel(null, null, isValidate: false);
    phoneModel.value = ValidationModel(null, null, isValidate: false);
    messageModel.value = ValidationModel(null, null, isValidate: false);
    // imageModel.value = ValidationModel(null, null, isValidate: false);
    // Reset reactive variables
    isFormInvalidate.value = false;

    super.onClose();
  }

  void enableSubmitBtn() {
    if (nameModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (emailModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (phoneModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (messageModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    }

    //  else if (imageModel.value.isValidate == false) {
    //   isFormInvalidate.value = false;
    // }

    else {
      isFormInvalidate.value = true;
    }

    update();
  }

  validateFields(
    val, {
    model,
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
    shouldEnableButton = true,
    validateIndex = 0,
  }) {
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
          enableSubmitBtn();
        });
  }

  Rx<File?> imageFile = null.obs;

  getImage() {
    return Stack(
      children: [
        Container(
          height: Device.screenType == sizer.ScreenType.mobile ? 10.h : 10.8.h,
          margin: const EdgeInsets.only(right: 10),
          width: Device.screenType == sizer.ScreenType.mobile ? 10.h : 10.8.h,
          decoration: BoxDecoration(
            border: Border.all(color: white, width: 1.w),
            borderRadius: BorderRadius.circular(100.w),
            boxShadow: [
              BoxShadow(color: black.withOpacity(0.1), blurRadius: 5.0)
            ],
          ),
          child: ClipOval(
            child: imageFile.value != null
                ? Image.file(
                    imageFile.value!,
                    height: 8.0.h,
                    width: 8.0.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        Asset.bussinessPlaceholder,
                        height: 8.0.h,
                        width: 8.0.h,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Image.asset(
                    Asset.bussinessPlaceholder,
                    height: 8.0.h,
                    width: 8.0.h,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        Positioned(
          right: 5,
          bottom: 0.5.h,
          child: Container(
            height: 3.3.h,
            width: 3.3.h,
            padding: const EdgeInsets.all(5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: primaryColor,
              border: Border.all(color: white, width: 0.6.w),
              borderRadius: BorderRadius.circular(100.w),
              boxShadow: [
                BoxShadow(color: black.withOpacity(0.1), blurRadius: 5.0)
              ],
            ),
            child: SvgPicture.asset(
              Asset.add,
              height: 12.0.h,
              width: 15.0.h,
              fit: BoxFit.cover,
              color: white,
            ),
          ),
        ),
      ],
    );
  }

  actionClickUploadImageFromCamera(context, {bool? isCamera}) async {
    try {
      final file = await ImagePicker().pickImage(
        source: isCamera == true ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 100,
      );

      if (file == null) return;

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: file.path,
        maxWidth: 1080,
        maxHeight: 1080,
        cropStyle: CropStyle.rectangle,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            cropGridColor: primaryColor,
            toolbarColor: primaryColor,
            statusBarColor: primaryColor,
            toolbarWidgetColor: white,
            activeControlsWidgetColor: primaryColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            cancelButtonTitle: 'Cancel',
            doneButtonTitle: 'Done',
            aspectRatioLockEnabled: false,
          ),
        ],
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      );

      if (croppedFile == null) return;

      imageFile = File(croppedFile.path).obs;

      // await updateLogo(context);

      // validateFields(
      //   croppedFile.path,
      //   model: imageModel,
      //   errorText1: "Pic is required",
      //   iscomman: true,
      //   shouldEnableButton: true,
      // );

      imageFile.refresh();
      update();
    } catch (e) {
      // Handle or log the error if needed
    }
  }
}
