import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/Repository.dart';
import 'package:ibh/componant/dialogs/dialogs.dart';
import 'package:ibh/componant/dialogs/loading_indicator.dart';
import 'package:ibh/configs/apicall_constant.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/string_constant.dart';
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
import 'package:http/http.dart' as http;

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

    if (nameCtr.text.isNotEmpty) {
      validateFields(
        nameCtr.text,
        model: nameModel,
        errorText1: "Name is required",
        iscomman: true,
        shouldEnableButton: false,
      );
    }
    if (emailCtr.text.isNotEmpty) {
      validateFields(
        emailCtr.text,
        model: emailModel,
        errorText1: "Email is required",
        errorText2: "Invalid email format",
        isemail: true,
        shouldEnableButton: false,
      );
    }
    if (phoneCtr.text.isNotEmpty) {
      validateFields(
        phoneCtr.text,
        model: phoneModel,
        errorText1: "Phone number is required",
        isnumber: true,
        shouldEnableButton: false,
      );
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

  Rx<File?> imageFile = Rx<File?>(null);

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

  getContactusImage() {
    return Stack(
      children: [
        Container(
          height: Device.screenType == sizer.ScreenType.mobile ? 10.h : 10.8.h,
          margin: const EdgeInsets.only(right: 10),
          width: Device.screenType == sizer.ScreenType.mobile ? 10.h : 10.8.h,
          decoration: BoxDecoration(
            border: Border.all(color: white, width: 1.w),
            borderRadius: BorderRadius.circular(10), // Rounded rectangle
            boxShadow: [
              BoxShadow(color: black.withOpacity(0.1), blurRadius: 5.0)
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
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
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          if (Platform.isAndroid)
            AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: primaryColor,
              statusBarColor: primaryColor,
              backgroundColor: Colors.white,
              toolbarWidgetColor: white,
              activeControlsWidgetColor: primaryColor,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
          if (Platform.isIOS)
            IOSUiSettings(
              title: 'Crop Image',
              cancelButtonTitle: 'Cancel',
              doneButtonTitle: 'Done',
              aspectRatioLockEnabled: false,
            ),
        ],
      );

      if (croppedFile == null) return;

      // imageFile = File(croppedFile.path).obs;
      imageFile.value = File(croppedFile.path);
      imageFile.refresh(); // This is safe to force a refresh if needed

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

  contactUsApiCall(
    context,
  ) async {
    var loadingIndicator = LoadingProgressDialog();

    if (networkManager.connectionType.value == 0) {
      loadingIndicator.hide(context);
      showDialogForScreen(context, "Contact Us Screen", Connection.noConnection,
          callback: () {
        Get.back();
      });
      return;
    }

    loadingIndicator.show(context, '');

    List<http.MultipartFile> files = [];
    // First file: visiting card

    // Second file: verification document (example)
    if (imageFile.value != null) {
      files.add(http.MultipartFile(
        'thumbnail',
        imageFile.value!.readAsBytes().asStream(),
        imageFile.value!.lengthSync(),
        filename: imageFile.value!.path.split('/').last,
      ));
    }

    var response = await Repository.multiPartPost(
        multiPartData: files,
        allowHeader: true,
        {
          "contact_person_name": nameCtr.text.trim(),
          "contact_no": phoneCtr.text.trim(),
          "email_id": emailCtr.text.trim(),
          "message": messageCtr.text.trim(),
        },
        ApiUrl.contactUS);

    var responseData = await response.stream.toBytes();
    loadingIndicator.hide(context);

    var result = String.fromCharCodes(responseData);

    var json = jsonDecode(result);

    if (response.statusCode == 200 && json['success'] == true) {
      showDialogForScreen(
          context, "Contact Us Screen", 'Your request submitted successfully.',
          callback: () {
        Get.back(result: true);
        // Get.back(result: true);
      });
    } else {
      showDialogForScreen(context, "Contact Us Screen", json['message'],
          callback: () {});
    }

    //  catch (e) {
    //   logcat("Exception", e);
    //   loadingIndicator.hide(context);
    // }
  }
}
