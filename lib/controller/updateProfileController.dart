import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/Repository.dart';
import 'package:ibh/api_handle/apiCallingFormate.dart';
import 'package:ibh/componant/dialogs/customDialog.dart';
import 'package:ibh/componant/dialogs/dialogs.dart';
import 'package:ibh/componant/dialogs/loading_indicator.dart';
import 'package:ibh/componant/input/form_inputs.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/apicall_constant.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/MasterController.dart';
import 'package:ibh/controller/internet_controller.dart';
import 'package:ibh/models/VerificationModel.dart';
import 'package:ibh/models/cityModel.dart';
import 'package:ibh/models/login_model.dart';
import 'package:ibh/models/sign_in_form_validation.dart';
import 'package:ibh/models/stateModel.dart';
import 'package:ibh/preference/UserPreference.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/helper.dart';
import 'package:ibh/utils/log.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:sizer/sizer.dart' as sizer;
import 'package:sizer/sizer.dart';
import 'package:sizer/sizer.dart' as sizer;

class Updateprofilecontroller extends GetxController {
  final InternetController networkManager = Get.find<InternetController>();

  Rx<ScreenState> state = ScreenState.apiLoading.obs;

  late FocusNode nameNode,
      emailNode,
      phoneNode,
      bussinessNode,
      stateNode,
      cityNode,
      pincodeNode,
      websiteNode,
      verificationNode,
      // visitingcardNode,
      addressNode;
  late TextEditingController nameCtr,
      emailCtr,
      phoneCtr,
      bussinessCtr,
      verificationCtr,
      stateCtr,
      cityCtr,
      pincodeCtr,
      websiteCtr,
      // visitingcardCtr,
      addressCtr;

  var nameModel = ValidationModel(null, null, isValidate: false).obs;
  var emailModel = ValidationModel(null, null, isValidate: false).obs;
  var phoneModel = ValidationModel(null, null, isValidate: false).obs;
  var bussinessModel = ValidationModel(null, null, isValidate: false).obs;
  var stateModel = ValidationModel(null, null, isValidate: false).obs;
  var cityModel = ValidationModel(null, null, isValidate: false).obs;
  var pincodeModel = ValidationModel(null, null, isValidate: false).obs;
  var imageModel = ValidationModel(null, null, isValidate: false).obs;
  var websiteModel = ValidationModel(null, null, isValidate: false).obs;
  var addressModel = ValidationModel(null, null, isValidate: false).obs;
  var verificationModel = ValidationModel(null, null, isValidate: false).obs;
  var verificationDocModel = ValidationModel(null, null, isValidate: false).obs;

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

  late TextEditingController searchStatectr,
      searchCityctr,
      searchVerificationctr;
  late FocusNode searchStateNode, searchCityNode, searchVerificationNode;
  var searchStateModel = ValidationModel(null, null, isValidate: false).obs;
  var searchCityModel = ValidationModel(null, null, isValidate: false).obs;
  var searchVerificationModel =
      ValidationModel(null, null, isValidate: false).obs;

  RxBool isStateApiCallLoading = false.obs;
  // RxList stateFilterList = [].obs;
  RxList<StateListData> stateFilterList = <StateListData>[].obs;
  RxList<StateListData> stateList = <StateListData>[].obs;
  RxString stateId = "".obs;
  // RxList stateList = [].obs;

  RxBool isCityApiCallLoading = false.obs;
  RxList<CityListData> cityList = <CityListData>[].obs;
  RxList<CityListData> cityFilterList = <CityListData>[].obs;

  RxBool isVerificationApiCallLoading = false.obs;
  RxList<VerificationData> verificationList = <VerificationData>[].obs;
  // RxString selectedVerification = "".obs;

  RxString cityId = "".obs;

  RxString imageURl = "".obs;
  RxBool isEmailVerifed = false.obs;
  RxBool isUserVerfied = false.obs;

  getProfileData(BuildContext context) async {
    User? retrievedObject = await UserPreferences().getSignInInfo();

    if (retrievedObject == null) {
      // You could show an error, fallback, or early return
      // print("Retrieved user is null");
      return;
    }

    nameCtr.text = retrievedObject.name ?? '';
    emailCtr.text = retrievedObject.email ?? '';
    phoneCtr.text = retrievedObject.phone ?? '';
    bussinessCtr.text = retrievedObject.businessName ?? '';

    if (retrievedObject.state != null) {
      stateCtr.text = retrievedObject.state!.name ?? '';
      stateId.value = retrievedObject.state!.id?.toString() ?? '';
    }

    if (retrievedObject.city != null) {
      cityCtr.text = retrievedObject.city!.city ?? '';
      cityId.value = retrievedObject.city!.id?.toString() ?? '';
      futureDelay(() {
        getCityApi(context, stateId.value.toString(), false);
      }, isOneSecond: false);
    }

    if (retrievedObject.document != null) {
      selectedPDFName.value = retrievedObject.document?.documentUrl ?? '';
      verificationCtr.text = retrievedObject.document?.documentType ?? '';
    }

    isEmailVerifed.value = retrievedObject.isEmailVerified ?? false;
    isUserVerfied.value = retrievedObject.isVerified ?? false;

    // print('isUserVerified:${isUserVerfied.value}');

    imageURl.value = retrievedObject.visitingCardUrl ?? '';
    // print('imageUrl is ::::$imageURl');

    pincodeCtr.text = retrievedObject.pincode ?? '';
    addressCtr.text = retrievedObject.address ?? '';
    websiteCtr.text = retrievedObject.website ?? '';

    // Start validation logic
    if (imageURl.value.isNotEmpty) {
      validateFields(
        imageURl.value,
        model: imageModel,
        errorText1: "Profile picture is required",
        iscomman: true,
        shouldEnableButton: false,
      );
    }

    if (selectedPDFName.value.isNotEmpty) {
      validateFields(
        selectedPDFName.value,
        model: verificationDocModel,
        errorText1: "Document is required",
        iscomman: true,
        shouldEnableButton: false,
      );
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

    if (bussinessCtr.text.isNotEmpty) {
      validateFields(
        bussinessCtr.text,
        model: bussinessModel,
        errorText1: "Business name is required",
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

    if (stateCtr.text.isNotEmpty) {
      validateFields(
        stateCtr.text,
        model: stateModel,
        errorText1: "State is required",
        iscomman: true,
        shouldEnableButton: false,
      );
    }

    if (cityCtr.text.isNotEmpty) {
      validateFields(
        cityCtr.text,
        model: cityModel,
        errorText1: "City is required",
        iscomman: true,
        shouldEnableButton: false,
      );
    }

    if (pincodeCtr.text.isNotEmpty) {
      validateFields(
        pincodeCtr.text,
        model: pincodeModel,
        errorText1: "Pincode is required",
        isPincode: true,
        shouldEnableButton: false,
      );
    }

    if (addressCtr.text.isNotEmpty) {
      validateFields(
        addressCtr.text,
        model: addressModel,
        errorText1: "Address is required",
        iscomman: true,
        shouldEnableButton: false,
      );
    }

    // if (websiteCtr.text.isNotEmpty) {
    //   validateFields(
    //     websiteCtr.text,
    //     model: websiteModel,
    //     errorText1: "Website is required",
    //     iscomman: true,
    //     shouldEnableButton: false,
    //   );
    // }

    if (verificationCtr.text.isNotEmpty) {
      validateFields(
        verificationCtr.text,
        model: verificationModel,
        errorText1: "Verification Type is required",
        iscomman: true,
        shouldEnableButton: false,
      );
    }

    enableSignUpButton();
    update();
  }

  void inti() {
    nameNode = FocusNode();
    emailNode = FocusNode();
    phoneNode = FocusNode();
    bussinessNode = FocusNode();
    stateNode = FocusNode();
    cityNode = FocusNode();
    pincodeNode = FocusNode();
    // visitingcardNode = FocusNode();
    addressNode = FocusNode();
    searchStateNode = FocusNode();
    searchCityNode = FocusNode();
    searchVerificationNode = FocusNode();
    websiteNode = FocusNode();
    verificationNode = FocusNode();

    nameCtr = TextEditingController();
    emailCtr = TextEditingController();
    phoneCtr = TextEditingController();
    bussinessCtr = TextEditingController();
    stateCtr = TextEditingController();
    cityCtr = TextEditingController();
    pincodeCtr = TextEditingController();
    // visitingcardCtr = TextEditingController();
    addressCtr = TextEditingController();
    searchStatectr = TextEditingController();
    searchCityctr = TextEditingController();
    searchVerificationctr = TextEditingController();
    websiteCtr = TextEditingController();
    verificationCtr = TextEditingController();
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
    print('enableSignUpButton executed');
    print('nameModel.isValidate: ${nameModel.value.isValidate}');
    print('emailModel.isValidate: ${emailModel.value.isValidate}');
    print('phoneModel.isValidate: ${phoneModel.value.isValidate}');
    print('imageModel.isValidate: ${imageModel.value.isValidate}');
    print('bussinessModel.isValidate: ${bussinessModel.value.isValidate}');
    print('stateModel.isValidate: ${stateModel.value.isValidate}');
    print('cityModel.isValidate: ${cityModel.value.isValidate}');
    print('pincodeModel.isValidate: ${pincodeModel.value.isValidate}');
    print('addressModel.isValidate: ${addressModel.value.isValidate}');
    print('validateType.isValidate: ${verificationModel.value.isValidate}');
    print('ValidateUrl.isValidate: ${verificationDocModel.value.isValidate}');

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
    } else if (addressModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    }
    // else if (websiteModel.value.isValidate == false) {
    //   isFormInvalidate.value = false;
    // }

    else if (verificationModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (verificationDocModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else {
      isFormInvalidate.value = true;
    }
    //  else if (imageModel.value.isValidate == false) {
    //   isFormInvalidate.value = false;
    // }
    print("isFormInvalidate: ${isFormInvalidate.value}");
    update();
  }

  @override
  void onClose() {
    nameCtr.clear();
    emailCtr.clear();
    phoneCtr.clear();
    bussinessCtr.clear();
    stateCtr.clear();
    cityCtr.clear();
    pincodeCtr.clear();
    // visitingcardCtr.clear();
    addressCtr.clear();
    websiteCtr.clear();

    selectedPdfFile.value = null;

    // Reset all validation models
    nameModel.value = ValidationModel(null, null, isValidate: false);
    emailModel.value = ValidationModel(null, null, isValidate: false);
    phoneModel.value = ValidationModel(null, null, isValidate: false);
    bussinessModel.value = ValidationModel(null, null, isValidate: false);
    stateModel.value = ValidationModel(null, null, isValidate: false);
    cityModel.value = ValidationModel(null, null, isValidate: false);
    pincodeModel.value = ValidationModel(null, null, isValidate: false);
    websiteModel.value = ValidationModel(null, null, isValidate: false);
    addressModel.value = ValidationModel(null, null, isValidate: false);
    verificationModel.value = ValidationModel(null, null, isValidate: false);

    // Reset reactive variables
    isFormInvalidate.value = false;
    isLoading.value = false;
    obsecureTextPass.value = true;
    obsecureTextConPass.value = true;

    super.onClose();
  }

  void resetForm() {
    // Clear text fields
    nameCtr.clear();
    emailCtr.clear();
    phoneCtr.clear();
    bussinessCtr.clear();
    stateCtr.clear();
    cityCtr.clear();
    pincodeCtr.clear();
    // visitingcardCtr.clear();
    addressCtr.clear();
    searchStatectr.clear();
    searchCityctr.clear();
    searchVerificationctr.clear();
    websiteCtr.clear();
    verificationCtr.clear();

    nameNode.unfocus();
    emailNode.unfocus();
    phoneNode.unfocus();
    bussinessNode.unfocus();
    stateNode.unfocus();
    cityNode.unfocus();
    pincodeNode.unfocus();
    // visitingcardNode.unfocus();
    addressNode.unfocus();
    searchStateNode.unfocus();
    searchCityNode.unfocus();
    searchVerificationNode.unfocus();
    websiteNode.unfocus();
    verificationNode.unfocus();

    // Reset validation models
    nameModel.value = ValidationModel(null, null, isValidate: false);
    emailModel.value = ValidationModel(null, null, isValidate: false);
    phoneModel.value = ValidationModel(null, null, isValidate: false);
    bussinessModel.value = ValidationModel(null, null, isValidate: false);
    stateModel.value = ValidationModel(null, null, isValidate: false);
    cityModel.value = ValidationModel(null, null, isValidate: false);
    pincodeModel.value = ValidationModel(null, null, isValidate: false);
    // visitingCardModel.value = ValidationModel(null, null, isValidate: false);
    addressModel.value = ValidationModel(null, null, isValidate: false);
    websiteModel.value = ValidationModel(null, null, isValidate: false);
    verificationModel.value = ValidationModel(null, null, isValidate: false);
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

//stepper
  // var _isMovingForward = true.obs;
  // bool get ismovingForward => _isMovingForward.value;
  // set ismovingForward(bool value) => _isMovingForward.value = value;

  // var _stepperValue = 0.obs;
  // int get StepperValue => _stepperValue.value;
  // set StepperValue(int value) => _stepperValue.value = value;

  // void incrementstepper() {
  //   print(StepperValue);
  //   StepperValue += 1;
  //   update();
  // }

  // void decerementstepper() {
  //   StepperValue -= 1;
  //   update();
  // }

  // final ImagePicker _picker = ImagePicker();
  Rx<File?> imageFile = null.obs;

  updateProfile(context) async {
    if (imageURl.value.isEmpty) {
      imageValidationPopupDialogs(context);
      return;
    }

    var loadingIndicator = LoadingProgressDialog();

    try {
      if (networkManager.connectionType.value == 0) {
        loadingIndicator.hide(context);
        showDialogForScreen(context, "Signup Screen", Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }

      loadingIndicator.show(context, '');

      List<http.MultipartFile> files = [];
      // First file: visiting card
      if (imageFile.value != null) {
        files.add(http.MultipartFile(
          'visiting_card',
          imageFile.value!.readAsBytes().asStream(),
          imageFile.value!.lengthSync(),
          filename: imageFile.value!.path.split('/').last,
        ));
      }

      // Second file: verification document (example)
      if (selectedPdfFile.value != null) {
        files.add(http.MultipartFile(
          'document_url',
          selectedPdfFile.value!.readAsBytes().asStream(),
          selectedPdfFile.value!.lengthSync(),
          filename: selectedPdfFile.value!.path.split('/').last,
        ));
      }

      var response = await Repository.multiPartPost({
        "name": nameCtr.text.trim(),
        "email": emailCtr.text.trim(),
        "phone": phoneCtr.text.trim(),
        "business_name": bussinessCtr.text.trim(),
        "city": cityId.toString(),
        "state": stateId.toString(),
        "address": addressCtr.text.trim(),
        "website": websiteCtr.text.trim(),
        "pincode": pincodeCtr.text.trim(),
        "document_type": verificationCtr.text.trim()
      }, ApiUrl.updateProfile, multiPartData: files, allowHeader: true);

      var responseData = await response.stream.toBytes();
      loadingIndicator.hide(context);

      var result = String.fromCharCodes(responseData);

      var json = jsonDecode(result);

      if (response.statusCode == 200 && json['success'] == true) {
        LoginModel responseDetail = LoginModel.fromJson(json);
        if (responseDetail.data?.user != null) {
          UserPreferences().saveSignInInfo(responseDetail.data!.user);
          logcat("isUpdate", jsonEncode(responseDetail.data?.user));
        }
        showDialogForScreen(context, "Update Profile Screen", json['message'],
            callback: () {
          Get.back(result: true);
        });
      } else {
        showDialogForScreen(context, "Update Profile Screen", json['message'],
            callback: () {});
      }
    } catch (e) {
      logcat("Exception", e);
      loadingIndicator.hide(context);
    }
  }

  // void updateProfile(context) async {
  //   if (imageURl.value.isEmpty) {
  //     imageValidationPopupDialogs(context);
  //     return;
  //   }
  //   var loadingIndicator = LoadingProgressDialog();

  //   try {
  //     if (networkManager.connectionType.value == 0) {
  //       loadingIndicator.hide(context);
  //       showDialogForScreen(context, "Signup Screen", Connection.noConnection,
  //           callback: () {
  //         Get.back();
  //       });
  //       return;
  //     }
  //     loadingIndicator.show(context, '');

  //     var response = await Repository.multiPartPost({
  //       "name": nameCtr.text.toString(),
  //       "email": emailCtr.text.toString().trim(),
  //       "phone": phoneCtr.text.toString(),
  //       "business_name": bussinessCtr.text.toString(),
  //       "city": cityId.toString(),
  //       "state": stateId.toString(),
  //       "address": addressCtr.text.toString(),
  //       "pincode": pincodeCtr.text.toString(),
  //     }, ApiUrl.updateProfile,
  //         multiPart:
  //             imageFile.value != null && imageFile.value.toString().isNotEmpty
  //                 ? http.MultipartFile(
  //                     'visiting_card',
  //                     imageFile.value!.readAsBytes().asStream(),
  //                     imageFile.value!.lengthSync(),
  //                     filename: imageFile.value!.path.split('/').last,
  //                   )
  //                 : null,
  //         allowHeader: true);
  //     var responseData = await response.stream.toBytes();
  //     loadingIndicator.hide(context);

  //     var result = String.fromCharCodes(responseData);
  //     var json = jsonDecode(result);
  //     if (response.statusCode == 200) {
  //       if (json['success'] == true) {
  //         print('pref store succesfully');

  //         print('print json: ${json.toString()}');

  //         print(
  //             'JSON Success Response:\n${JsonEncoder.withIndent('  ').convert(json)}');

  //         var responseDetail = LoginModel.fromJson(json);
  //         UserPreferences().saveSignInInfo(responseDetail.data.user);
  //         // UserPreferences().setToken(responseDetail.data.user.token.toString());
  //         showDialogForScreen(context, "Update Profile Screen", json['message'],
  //             callback: () {
  //           print('go back');
  //           Get.back(result: true); //goto code
  //         });
  //       } else {
  //         showDialogForScreen(context, "Update Profile Screen", json['message'],
  //             callback: () {});
  //       }
  //     } else {
  //       showDialogForScreen(context, "Update Profile Screen", json['message'],
  //           callback: () {});
  //     }
  //   } catch (e) {
  //     logcat("Exception", e);
  //     loadingIndicator.hide(context);
  //     // showDialogForScreen(context, screenName, ServerError.servererror,
  //     //     callback: () {});
  //   }
  // }

  Rx<File?> verificationFile = null.obs;

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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: imageFile.value == null && imageURl.value.isNotEmpty
                  ? CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: imageURl.value,
                      placeholder: (context, url) => ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(Asset.bussinessPlaceholder,
                              fit: BoxFit.contain)),
                      imageBuilder: (context, imageProvider) => Image.network(
                            imageURl.value,
                            fit: BoxFit.cover,
                          ),
                      errorWidget: (context, url, error) => Image.asset(
                            Asset.bussinessPlaceholder,
                            height: 8.0.h,
                            width: 8.0.h,
                            fit: BoxFit.cover,
                          ))
                  : imageFile.value == null
                      ? Image.asset(
                          Asset.bussinessPlaceholder,
                          height: 8.0.h,
                          width: 8.0.h,
                        )
                      : Image.file(
                          imageFile.value!,
                          height: Device.screenType == sizer.ScreenType.mobile
                              ? 8.0.h
                              : 8.5.h,
                          width: Device.screenType == sizer.ScreenType.mobile
                              ? 8.0.h
                              : 8.5.h,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              Asset.bussinessPlaceholder,
                              height: 8.0.h,
                              width: 8.0.h,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
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
                ]),
            child: SvgPicture.asset(
              Asset.add,
              height: 12.0.h,
              width: 15.0.h,
              fit: BoxFit.cover,
              // ignore: deprecated_member_use
              color: white,
            ),
          ),
        ),
      ],
    );
  }

  actionClickUploadImageFromCamera(context, {bool? isCamera}) async {
    await ImagePicker()
        .pickImage(
            source: isCamera == true ? ImageSource.camera : ImageSource.gallery,
            maxWidth: 1080,
            maxHeight: 1080,
            imageQuality: 100)
        .then((file) async {
      if (file != null) {
        //Cropping the image
        CroppedFile? croppedFile = await ImageCropper().cropImage(
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
                  lockAspectRatio: false),
              IOSUiSettings(
                title: 'Crop Image',
                cancelButtonTitle: 'Cancel',
                doneButtonTitle: 'Done',
                aspectRatioLockEnabled: false,
              ),
            ],
            aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1));
        if (croppedFile != null) {
          imageFile = File(croppedFile.path).obs;
          imageURl.value = croppedFile.path;

          validateFields(croppedFile.path,
              model: imageModel,
              errorText1: "Profile picture is required",
              iscomman: true,
              shouldEnableButton: true);

          imageFile.refresh(); // Ensure Obx is notified
          update();
        }
        //   } else {
        //     imageFile.value = null;
        //     imageURl.value = "";
        //     validateFields("",
        //         model: imageModel,
        //         errorText1: "Profile picture is required",
        //         iscomman: true,
        //         shouldEnableButton: true);
        //     update();
        //   }
        // } else {
        //   imageFile.value = null;
        //   imageURl.value = "";
        //   validateFields("",
        //       model: imageModel,
        //       errorText1: "Profile picture is required",
        //       iscomman: true,
        //       shouldEnableButton: true);
        //   update();
      }
    });

    update();
  }

  // final ImagePicker _picker = ImagePicker();
  // Rx<File?> imageFile = null.obs;

  // // String imagePath = "";

  // Future<void> _pickImage({bool iscamera = false}) async {
  //   try {
  //     final XFile? image = await _picker.pickImage(
  //       source: iscamera ? ImageSource.camera : ImageSource.gallery,
  //     );

  //     if (image != null) {
  //       print('Picked Image Path: ${image.path}');
  //       imageFile = File(image.path).obs; // Update the value of the existing Rx
  //       // final String fileName = path.basename(image.path);

  //     //   visitingcardCtr.text = fileName;
  //     //   validateFields(fileName,
  //     //       model: visitingCardModel,
  //     //       errorText1: "Visiting card is required",
  //     //       iscomman: true,
  //     //       shouldEnableButton: true);
  //     //   update();
  //     // } else {
  //     //   imageFile.value =
  //     //       null; // Explicitly set to null if no image is selected
  //     //   validateFields("",
  //     //       model: visitingCardModel,
  //     //       errorText1: "Visiting card is required",
  //     //       iscomman: true,
  //     //       shouldEnableButton: true);

  //       update();
  //       print('No image selected');
  //     }
  //   } catch (e) {
  //     print('Error picking image: $e');
  //   }
  // }

  // void showOptionsCupertinoDialog({required BuildContext context}) {
  //   showGeneralDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     barrierLabel: "Background",
  //     barrierColor: black.withOpacity(0.6), // Dark overlay, no blur
  //     transitionDuration: Duration(milliseconds: 200),
  //     pageBuilder: (context, animation1, animation2) {
  //       return Center(
  //         child: CupertinoAlertDialog(
  //           title: Text('Choose an Option'),
  //           content: Text(
  //             'Select how you want to add the picture.',
  //             style: TextStyle(fontFamily: dM_sans_medium),
  //           ),
  //           actions: [
  //             CupertinoDialogAction(
  //               child: Text('Camera', style: TextStyle(color: black)),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //                 _pickImage(iscamera: true);
  //               },
  //             ),
  //             CupertinoDialogAction(
  //               child: Text('Gallery', style: TextStyle(color: black)),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //                 _pickImage(iscamera: false);
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  void getState(context) async {
    commonGetApiCallFormate(
      allowHeader: true,
      title: 'State',
      context,
      onResponse: (data) {
        var responsDetails = StateModel.fromJson(data);
        stateFilterList.clear();
        stateList.clear();
        stateList.addAll(responsDetails.data);
        stateFilterList.addAll(stateList);
      },
      apiEndPoint: ApiUrl.states,
      networkManager: networkManager,
      apisLoading: (bool val) {
        // isloading = val;
      },
    );
  }

  // void getCity(context) async {
  //   commonGetApiCallFormate(
  //     allowHeader: true,
  //     title: 'City',
  //     context,
  //     onResponse: (data) {
  //       var responsDetails = CityModel.fromJson(data);
  //       cityList.addAll(responsDetails.data);
  //       cityFilterList.clear();
  //       cityFilterList.addAll(cityList);

  //       // print(stateList);

  //       for (var city in cityList) {
  //         print('ID: ${city.id}, Name: ${city.city}');
  //       }
  //     },
  //     apiEndPoint: '${ApiUrl.city}+${stateId.value}',
  //     networkManager: networkManager,
  //     apisLoading: (bool val) {
  //       // isloading = val;
  //     },
  //   );
  // }

  void getCityApi(context, cityID, bool isLoading) async {
    var loadingIndicator = LoadingProgressDialogs();
    commonGetApiCallFormate(context,
        title: SearchScreenConstant.cityList,
        // apiEndPoint: "${ApiUrl.getCity}/" + cityID,
        apiEndPoint: "${ApiUrl.getCity}/$cityID",
        allowHeader: true, apisLoading: (isTrue) {
      if (isLoading == true) {
        if (isTrue) {
          loadingIndicator.show(context, '');
        } else {
          loadingIndicator.hide(context);
        }
      }
      isCityApiCallLoading.value = isTrue;
      logcat("isCityList:", isTrue.toString());
      update();
    }, onResponse: (response) {
      var data = CityModel.fromJson(response);
      cityList.clear();
      cityFilterList.clear();
      cityList.addAll(data.data);
      cityFilterList.addAll(data.data);
      logcat("CITY_RESPONSE", jsonEncode(cityFilterList));
      update();
    }, networkManager: networkManager);
  }

  void getVerificationyApi(context) async {
    print('calllinggg');

    commonGetApiCallFormate(
      allowHeader: true,
      title: 'Edit Profile',
      context,
      onResponse: (data) {
        Verification responsDetails = Verification.fromJson(data);

        verificationList.clear();
        verificationList.addAll(responsDetails.data);
        logcat("VERIFICATION_RESPONSE", jsonEncode(verificationList));
        // print(stateList);

        for (var state in stateList) {
          print('ID: ${state.id}, Name: ${state.name}');
        }
      },
      apiEndPoint: ApiUrl.verification,
      networkManager: networkManager,
      apisLoading: (bool val) {
        // isloading = val;
      },
    );

    // var loadingIndicator = LoadingProgressDialogs();
    // commonGetApiCallFormate(context,
    //     title: SearchScreenConstant.cityList,
    //     // apiEndPoint: "${ApiUrl.getCity}/" + cityID,
    //     apiEndPoint: ApiUrl.verification,
    //     allowHeader: true, apisLoading: (isTrue) {
    //   if (isLoading == true) {
    //     if (isTrue) {
    //       loadingIndicator.show(context, '');
    //     } else {
    //       loadingIndicator.hide(context);
    //     }
    //   }
    //   isVerificationApiCallLoading.value = isTrue;

    //   update();
    // }, onResponse: (response) {
    //   Verification data = Verification.fromJson(response);
    //   cityList.clear();

    //   verificationList.addAll(data.data);

    //   logcat("VERIFICATION_RESPONSE", jsonEncode(verificationList));
    //   update();
    // }, networkManager: networkManager);
  }

  Widget setStateListDialog() {
    return Obx(() {
      if (isStateApiCallLoading.value == true) {
        return setDropDownContent([].obs, const Text("Loading"),
            isApiIsLoading: isStateApiCallLoading.value);
      }
      return setDropDownContent(
          stateFilterList,
          controller: searchStatectr,
          ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: stateFilterList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                dense: true,
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                contentPadding:
                    const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
                horizontalTitleGap: null,
                minLeadingWidth: 5,
                onTap: () async {
                  Get.back();
                  stateId.value = stateFilterList[index].id.toString();
                  stateCtr.text = stateFilterList[index].name;
                  cityCtr.text = "";
                  cityId.value = "";
                  cityFilterList.clear();
                  cityList.clear();
                  if (stateCtr.text.toString().isNotEmpty) {
                    stateFilterList.clear();
                    stateFilterList.addAll(stateList);
                  }

                  validateFields(stateCtr.text,
                      model: stateModel,
                      errorText1: "State is required",
                      iscomman: true,
                      shouldEnableButton: true);
                  update();
                  futureDelay(() {
                    getCityApi(context, stateId.value.toString(), true);
                  }, isOneSecond: false);
                  // validateFields(stateCtr.text);
                },
                title: showSelectedTextInDialog(
                    name: stateFilterList[index].name,
                    modelId: stateFilterList[index].id.toString(),
                    storeId: stateId.value),
              );
            },
          ),
          searchcontent: getReactiveFormField(
              node: searchStateNode,
              controller: searchStatectr,
              hintLabel: "Search Here",
              onChanged: (val) {
                applyFilter(val.toString(), isState: true);
                update();
              },
              isSearch: true,
              inputType: TextInputType.text,
              errorText: searchStateModel.value.error));
    });
  }

  Widget setVerificationListDialog() {
    return Obx(
      () {
        if (isCityApiCallLoading.value == true) {
          return setDropDownContent([].obs, const Text("Loading"),
              isApiIsLoading: isCityApiCallLoading.value);
        }
        return setDropDownContent(
          isVerificationPopup: true,
          verificationList,
          controller: searchVerificationctr,
          ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: verificationList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                dense: true,
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                contentPadding:
                    const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
                horizontalTitleGap: null,
                minLeadingWidth: 5,
                onTap: () async {
                  Get.back();

                  verificationCtr.text = verificationList[index].name;

                  if (verificationCtr.text.isNotEmpty) {
                    validateFields(verificationCtr.text,
                        model: verificationModel,
                        errorText1: "Verification Document is required",
                        iscomman: true,
                        shouldEnableButton: true);
                  }
                  update();
                },
                title: showSelectedTextInDialog(
                  name: verificationList[index].name,
                ),
              );
            },
          ),
        );
      },
    );
  }

//pdf
  RxString pdfFilePath = ''.obs;
  final selectedPdfFile = Rxn<File>();
  RxString selectedPDFName = "".obs;

  void pickPdfFromFile(BuildContext context) async {
    selectedPdfFile.value = null;
    selectedPDFName.value = '';
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      selectedPdfFile.value = file;
      selectedPDFName.value = selectedPdfFile.value!.path.split('/').last;
      print(selectedPdfFile.value);

      validateFields(selectedPDFName.value,
          model: verificationDocModel,
          errorText1: "Profile picture is required",
          iscomman: true,
          shouldEnableButton: true);

      // if (!context.mounted) return;
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Selected: ${file.path.split('/').last}')),
      // );
    } else {
      debugPrint("PDF picking cancelled.");
      validateFields(selectedPDFName.value,
          model: verificationDocModel,
          errorText1: "Profile picture is required",
          iscomman: true,
          shouldEnableButton: false);
    }
  }

  downloadDocument(BuildContext context, String url) async {
    var loadingIndicator = LoadingProgressDialogs();
    loadingIndicator.show(context, '');

    String fileName = extractFileNameFromUrl(url);
    final filePath = await downloadFile(url, fileName);

    loadingIndicator.hide(context);

    if (filePath != null) {
      sharefPopupDialogs(
        context,
        isFromEditProfile: true,
        function: () {
          shareFile(filePath);
        },
      );
    }
  }

  void pickImageFromGallery(BuildContext context) async {
    selectedPdfFile.value = null;
    selectedPDFName.value = '';
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);
      selectedPdfFile.value = imageFile;
      selectedPDFName.value = selectedPdfFile.value!.path.split('/').last;
      print(selectedPdfFile.value);
      validateFields(selectedPDFName.value,
          model: verificationDocModel,
          errorText1: "Profile picture is required",
          iscomman: true,
          shouldEnableButton: true);

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Selected: ${imageFile.path.split('/').last}')),
      // );
    } else {
      debugPrint("Image picking cancelled.");
      validateFields(selectedPDFName.value,
          model: verificationDocModel,
          errorText1: "Profile picture is required",
          iscomman: true,
          shouldEnableButton: false);
    }
  }

  clearpdf() {
    selectedPDFName.value = '';
    selectedPdfFile.value = null;
  }

  Widget setcityListDialog() {
    return Obx(
      () {
        if (isCityApiCallLoading.value == true) {
          return setDropDownContent([].obs, const Text("Loading"),
              isApiIsLoading: isCityApiCallLoading.value);
        }
        return setDropDownContent(
            cityFilterList,
            controller: searchCityctr,
            ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: cityFilterList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  dense: true,
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -4),
                  contentPadding:
                      const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
                  horizontalTitleGap: null,
                  minLeadingWidth: 5,
                  onTap: () async {
                    Get.back();
                    cityId.value = cityFilterList[index].id.toString();
                    cityCtr.text = cityFilterList[index].city;
                    if (cityCtr.text.toString().isNotEmpty) {
                      cityFilterList.clear();
                      cityFilterList.addAll(cityList);
                    }

                    validateFields(cityCtr.text,
                        model: cityModel,
                        errorText1: "City is required",
                        iscomman: true,
                        shouldEnableButton: true);
                    update();
                  },
                  title: showSelectedTextInDialog(
                      name: cityFilterList[index].city,
                      modelId: cityFilterList[index].id.toString(),
                      storeId: cityId.value),
                );
              },
            ),
            searchcontent: getReactiveFormField(
                node: searchCityNode,
                controller: searchCityctr,
                hintLabel: "Search Here",
                onChanged: (val) {
                  applyFilter(val.toString(), isState: false);
                  update();
                },
                isSearch: true,
                inputType: TextInputType.text,
                errorText: searchCityModel.value.error));
      },
    );
  }

  void applyFilter(String keyword, {isState = false}) {
    if (isState == true) {
      stateFilterList.clear();
      for (StateListData stateList in stateList) {
        if (stateList.name
            .toString()
            .toLowerCase()
            .contains(keyword.toLowerCase())) {
          stateFilterList.add(stateList);
        }
      }
      stateFilterList.refresh();
      stateFilterList.call();
      // logcat('filterApply', stateFilterList.length.toString());
    } else {
      cityFilterList.clear();
      for (CityListData citylist in cityList) {
        if (citylist.city
            .toString()
            .toLowerCase()
            .contains(keyword.toLowerCase())) {
          cityFilterList.add(citylist);
        }
      }
      cityFilterList.refresh();
      cityFilterList.call();
      // logcat('filterApply', cityFilterList.length.toString());
    }

    update();
  }

  // getImage() {
  //   return Stack(
  //     children: [
  //       Positioned(
  //         left: 0,
  //         right: 0,
  //         child: Container(
  //           width: 12.h,
  //         ),
  //       ),
  //       Container(
  //         height: Device.screenType == sizer.ScreenType.mobile ? 10.h : 10.8.h,
  //         margin: const EdgeInsets.only(right: 10),
  //         width: Device.screenType == sizer.ScreenType.mobile ? 10.h : 10.8.h,
  //         decoration: BoxDecoration(
  //           border: Border.all(color: white, width: 1.w),
  //           borderRadius: BorderRadius.circular(100.w),
  //           boxShadow: [
  //             BoxShadow(
  //               color: black.withOpacity(0.1),
  //               blurRadius: 5.0,
  //             )
  //           ],
  //         ),
  //         child: CircleAvatar(
  //           child: ClipRRect(
  //             borderRadius: BorderRadius.circular(50.0),
  //             child: imageFile.value == null && imageURl.value.isNotEmpty
  //                 ? CachedNetworkImage(
  //                     fit: BoxFit.fitWidth,
  //                     imageUrl: imageURl.value,
  //                     placeholder: (context, url) => const Center(
  //                           child:
  //                               CircularProgressIndicator(color: primaryColor),
  //                         ),
  //                     imageBuilder: (context, imageProvider) => Image.network(
  //                           imageURl.value,
  //                           fit: BoxFit.fitWidth,
  //                         ),
  //                     errorWidget: (context, url, error) => SvgPicture.asset(
  //                           Asset.profileimg,
  //                           height: 8.0.h,
  //                           width: 8.0.h,
  //                         ))
  //                 : imageFile.value == null
  //                     ? SvgPicture.asset(
  //                         Asset.profileimg,
  //                         height: 8.0.h,
  //                         width: 8.0.h,
  //                       )
  //                     : Image.file(
  //                         imageFile.value!,
  //                         height: Device.screenType == sizer.ScreenType.mobile
  //                             ? 8.0.h
  //                             : 8.5.h,
  //                         width: Device.screenType == sizer.ScreenType.mobile
  //                             ? 8.0.h
  //                             : 8.5.h,
  //                         errorBuilder: (context, error, stackTrace) {
  //                           return SvgPicture.asset(
  //                             Asset.profileimg,
  //                             height: 8.0.h,
  //                             width: 8.0.h,
  //                           );
  //                         },
  //                       ),
  //           ),
  //         ),
  //       ),
  //       Positioned(
  //         right: 5,
  //         bottom: 0.5.h,
  //         child: Container(
  //           height: 3.3.h,
  //           width: 3.3.h,
  //           padding: const EdgeInsets.all(5),
  //           alignment: Alignment.center,
  //           decoration: BoxDecoration(
  //             color: primaryColor,
  //             border: Border.all(color: white, width: 0.6.w),
  //             borderRadius: BorderRadius.circular(100.w),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: black.withOpacity(0.1),
  //                 blurRadius: 5.0,
  //               )
  //             ],
  //           ),
  //           child: SvgPicture.asset(
  //             Asset.add,
  //             height: 12.0.h,
  //             width: 15.0.h,
  //             fit: BoxFit.cover,
  //             // ignore: deprecated_member_use
  //             color: white,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // actionClickUploadImageFromCamera(context, {bool? isCamera}) async {
  //   await ImagePicker()
  //       .pickImage(
  //           source: isCamera == true ? ImageSource.camera : ImageSource.gallery,
  //           maxWidth: 1080,
  //           maxHeight: 1080,
  //           imageQuality: 100)
  //       .then((file) async {
  //     if (file != null) {
  //       //Cropping the image
  //       CroppedFile? croppedFile = await ImageCropper().cropImage(
  //           sourcePath: file.path,
  //           maxWidth: 1080,
  //           maxHeight: 1080,
  //           cropStyle: CropStyle.rectangle,
  //           aspectRatioPresets: Platform.isAndroid
  //               ? [
  //                   CropAspectRatioPreset.square,
  //                   CropAspectRatioPreset.ratio3x2,
  //                   CropAspectRatioPreset.original,
  //                   CropAspectRatioPreset.ratio4x3,
  //                   CropAspectRatioPreset.ratio16x9
  //                 ]
  //               : [
  //                   CropAspectRatioPreset.original,
  //                   CropAspectRatioPreset.square,
  //                   CropAspectRatioPreset.ratio3x2,
  //                   CropAspectRatioPreset.ratio4x3,
  //                   CropAspectRatioPreset.ratio5x3,
  //                   CropAspectRatioPreset.ratio5x4,
  //                   CropAspectRatioPreset.ratio7x5,
  //                   CropAspectRatioPreset.ratio16x9
  //                 ],
  //           uiSettings: [
  //             AndroidUiSettings(
  //                 toolbarTitle: 'Crop Image',
  //                 cropGridColor: primaryColor,
  //                 toolbarColor: primaryColor,
  //                 statusBarColor: primaryColor,
  //                 toolbarWidgetColor: white,
  //                 activeControlsWidgetColor: primaryColor,
  //                 initAspectRatio: CropAspectRatioPreset.original,
  //                 lockAspectRatio: false),
  //             IOSUiSettings(
  //               title: 'Crop Image',
  //               cancelButtonTitle: 'Cancel',
  //               doneButtonTitle: 'Done',
  //               aspectRatioLockEnabled: false,
  //             ),
  //           ],
  //           aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1));
  //       if (croppedFile != null) {
  //         imageFile = File(croppedFile.path).obs;
  //         imageURl.value = croppedFile.path;

  //         update();
  //       }
  //     }
  //   });

  //   update();
  // }
}
