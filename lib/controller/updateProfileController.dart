import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/Repository.dart';
import 'package:ibh/api_handle/apiCallingFormate.dart';
import 'package:ibh/componant/dialogs/dialogs.dart';
import 'package:ibh/componant/dialogs/loading_indicator.dart';
import 'package:ibh/componant/input/form_inputs.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/apicall_constant.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/MasterController.dart';
import 'package:ibh/controller/internet_controller.dart';
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
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
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
      // visitingcardNode,
      addressNode;
  late TextEditingController nameCtr,
      emailCtr,
      phoneCtr,
      bussinessCtr,
      stateCtr,
      cityCtr,
      pincodeCtr,
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
  // var visitingCardModel = ValidationModel(null, null, isValidate: false).obs;
  var addressModel = ValidationModel(null, null, isValidate: false).obs;

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

  late TextEditingController searchStatectr, searchCityctr;
  late FocusNode searchStateNode, searchCityNode;
  var searchStateModel = ValidationModel(null, null, isValidate: false).obs;
  var searchCityModel = ValidationModel(null, null, isValidate: false).obs;

  RxBool isStateApiCallLoading = false.obs;
  RxList stateFilterList = [].obs;
  RxString stateId = "".obs;
  RxList stateList = [].obs;

  RxBool isCityApiCallLoading = false.obs;
  RxList cityFilterList = [].obs;
  RxString cityId = "".obs;
  RxList cityList = [].obs;

  RxString imageURl = "".obs;

  getProfileData() async {
    // state.value = ScreenState.apiLoading;
    User? retrievedObject = await UserPreferences().getSignInInfo();
    nameCtr.text = retrievedObject!.name;
    emailCtr.text = retrievedObject.email;

    phoneCtr.text = retrievedObject.phone;
    bussinessCtr.text = retrievedObject.businessName;
    if (retrievedObject.state != null) {
      stateCtr.text = retrievedObject.state!.name;
      stateId.value = retrievedObject.state!.id.toString();
    }
    if (retrievedObject.city != null) {
      cityCtr.text = retrievedObject.city!.city;
      cityId.value = retrievedObject.city!.id.toString();
    }

    imageURl.value = retrievedObject.visitingCardUrl;
    print('imageUrl is ::::$imageURl');

    pincodeCtr.text = retrievedObject.pincode;
    addressCtr.text = retrievedObject.address;

    // if( nameCtr.text.isNotEmpty &&emailCtr.text.isNotEmpty&&bussinessCtr.text.isNotEmpty&&phoneCtr.text.isNotEmpty && stateCtr.text.isNotEmpty&&cityCtr.text.isNotEmpty&&pincodeCtr. ){}

    validateFields(nameCtr.text,
        model: nameModel,
        errorText1: "Name is required",
        iscomman: true,
        shouldEnableButton: false);

    validateFields(retrievedObject.email,
        model: emailModel,
        errorText1: "Email is required",
        errorText2: "Invalid email format",
        isemail: true,
        shouldEnableButton: false);

    validateFields(phoneCtr.text,
        model: phoneModel,
        errorText1: "Phone number is required",
        isnumber: true,
        shouldEnableButton: false);

    validateFields(bussinessCtr.text,
        model: bussinessModel,
        errorText1: "Business name is required",
        iscomman: true,
        shouldEnableButton: false);

    validateFields(imageURl.value,
        model: imageModel,
        errorText1: "Profile picture is required",
        iscomman: true,
        shouldEnableButton: false);

    validateFields(stateCtr.text,
        model: stateModel,
        errorText1: "State is required",
        iscomman: true,
        shouldEnableButton: false);

    validateFields(cityCtr.text,
        model: cityModel,
        errorText1: "City is required",
        iscomman: true,
        shouldEnableButton: false);

    validateFields(pincodeCtr.text,
        model: pincodeModel,
        errorText1: "Pincode is required",
        isPincode: true,
        shouldEnableButton: false);

    // validateFields(visitingcardCtr.text,
    //     model: visitingCardModel,
    //     errorText1: "Visiting card is required",
    //     iscomman: true,
    //     shouldEnableButton: false);

    validateFields(addressCtr.text,
        model: addressModel,
        errorText1: "Address is required",
        iscomman: true,
        shouldEnableButton: false);

    enableSignUpButton(); // Call explicitly after initial validation

    // state.value = ScreenState.apiSuccess;
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

    if (nameModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (emailModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (phoneModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (imageModel.value.isValidate == false) {
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
    } else {
      isFormInvalidate.value = true;
    }
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

    // Reset all validation models
    nameModel.value = ValidationModel(null, null, isValidate: false);
    emailModel.value = ValidationModel(null, null, isValidate: false);
    phoneModel.value = ValidationModel(null, null, isValidate: false);
    bussinessModel.value = ValidationModel(null, null, isValidate: false);
    stateModel.value = ValidationModel(null, null, isValidate: false);
    cityModel.value = ValidationModel(null, null, isValidate: false);
    pincodeModel.value = ValidationModel(null, null, isValidate: false);
    // visitingCardModel.value = ValidationModel(null, null, isValidate: false);
    addressModel.value = ValidationModel(null, null, isValidate: false);

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

  // final ImagePicker _picker = ImagePicker();
  Rx<File?> imageFile = null.obs;

  void updateProfile(context) async {
    var loadingIndicator = LoadingProgressDialog();

    // try {
    if (networkManager.connectionType == 0) {
      loadingIndicator.hide(context);
      showDialogForScreen(context, "Signup Screen", Connection.noConnection,
          callback: () {
        Get.back();
      });
      return;
    }
    loadingIndicator.show(context, '');

    var response = await Repository.multiPartPost({
      "name": nameCtr.text.toString(),
      "email": emailCtr.text.toString().trim(),
      "phone": phoneCtr.text.toString(),
      "business_name": bussinessCtr.text.toString(),
      "city": cityId.toString(),
      "state": stateId.toString(),
      "address": addressCtr.text.toString(),
      "pincode": pincodeCtr.text.toString(),
      // "visiting_card": visitingcardCtr.text.toString(),
    }, ApiUrl.updateProfile,
        multiPart:
            imageFile.value != null && imageFile.value.toString().isNotEmpty
                ? http.MultipartFile(
                    'visiting_card',
                    imageFile.value!.readAsBytes().asStream(),
                    imageFile.value!.lengthSync(),
                    filename: imageFile.value!.path.split('/').last,
                  )
                : null,
        allowHeader: true);
    var responseData = await response.stream.toBytes();
    loadingIndicator.hide(context);

    var result = String.fromCharCodes(responseData);
    var json = jsonDecode(result);
    if (response.statusCode == 200) {
      if (json['success'] == true) {
        print('pref store succesfully');

        print('print json: ${json.toString()}');

        print(
            'JSON Success Response:\n${JsonEncoder.withIndent('  ').convert(json)}');

        var responseDetail = LoginModel.fromJson(json);
        UserPreferences().saveSignInInfo(responseDetail.data.user);
        // UserPreferences().setToken(responseDetail.data.user.token.toString());
        showDialogForScreen(context, "Update Profile Screen", json['message'],
            callback: () {
          print('go back');
          Get.back(result: true); //goto code
        });
      } else {
        showDialogForScreen(context, "Update Profile Screen", json['message'],
            callback: () {});
      }
    } else {
      showDialogForScreen(context, "Update Profile Screen", json['message'],
          callback: () {
        // Get.back();
      });
    }
  }

  // Rx<File?> avatarFile = null.obs;
  // RxString profilePic = "".obs;

  getImage() {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          child: Container(
            width: 12.h,
          ),
        ),
        Container(
          height: Device.screenType == sizer.ScreenType.mobile ? 10.h : 10.8.h,
          margin: const EdgeInsets.only(right: 10),
          width: Device.screenType == sizer.ScreenType.mobile ? 10.h : 10.8.h,
          decoration: BoxDecoration(
            border: Border.all(color: white, width: 1.w),
            borderRadius: BorderRadius.circular(100.w),
            boxShadow: [
              BoxShadow(
                color: black.withOpacity(0.1),
                blurRadius: 5.0,
              )
            ],
          ),
          child: CircleAvatar(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: imageFile.value == null && imageURl.value.isNotEmpty
                  ? CachedNetworkImage(
                      fit: BoxFit.fitWidth,
                      imageUrl: imageURl.value,
                      placeholder: (context, url) => const Center(
                            child:
                                CircularProgressIndicator(color: primaryColor),
                          ),
                      imageBuilder: (context, imageProvider) => Image.network(
                            imageURl.value,
                            fit: BoxFit.fitWidth,
                          ),
                      errorWidget: (context, url, error) => SvgPicture.asset(
                            Asset.profileimg,
                            height: 8.0.h,
                            width: 8.0.h,
                          ))
                  : imageFile.value == null
                      ? SvgPicture.asset(
                          Asset.profileimg,
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
                            return SvgPicture.asset(
                              Asset.profileimg,
                              height: 8.0.h,
                              width: 8.0.h,
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
                BoxShadow(
                  color: black.withOpacity(0.1),
                  blurRadius: 5.0,
                )
              ],
            ),
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
        } else {
          imageFile.value = null;
          imageURl.value = "";
          validateFields("",
              model: imageModel,
              errorText1: "Profile picture is required",
              iscomman: true,
              shouldEnableButton: true);
          update();
        }
      } else {
        imageFile.value = null;
        imageURl.value = "";
        validateFields("",
            model: imageModel,
            errorText1: "Profile picture is required",
            iscomman: true,
            shouldEnableButton: true);
        print('No image selected');
        update();
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
        stateList.addAll(responsDetails.data);
        stateFilterList.clear();
        stateFilterList.addAll(stateList);

        // print(stateList);

        for (var state in stateList) {
          print('ID: ${state.id}, Name: ${state.name}');
        }
      },
      apiEndPoint: ApiUrl.states,
      networkManager: networkManager,
      apisLoading: (bool val) {
        // isloading = val;
      },
    );
  }

  void getCity(context) async {
    commonGetApiCallFormate(
      allowHeader: true,
      title: 'City',
      context,
      onResponse: (data) {
        var responsDetails = CityModel.fromJson(data);
        cityList.addAll(responsDetails.data);
        cityFilterList.clear();
        cityFilterList.addAll(cityList);

        // print(stateList);

        for (var city in cityList) {
          print('ID: ${city.id}, Name: ${city.city}');
        }
      },
      apiEndPoint: '${ApiUrl.city}+${stateId.value}',
      networkManager: networkManager,
      apisLoading: (bool val) {
        // isloading = val;
      },
    );
  }

  Widget setStateListDialog() {
    return Obx(() {
      if (isStateApiCallLoading.value == true) {
        return setDropDownContent([].obs, const Text("Loading"),
            isApiIsLoading: isStateApiCallLoading.value);
      }
      return setDropDownContent(
          stateFilterList,
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
                  if (stateCtr.text.toString().isNotEmpty) {
                    stateFilterList.clear();
                    stateFilterList.addAll(stateList);
                  }

                  validateFields(stateCtr.text,
                      model: stateModel,
                      errorText1: "State is required",
                      iscomman: true,
                      shouldEnableButton: true);
                  // getState(context);
                  cityCtr.text = "";
                  cityId.value = "";
                  update();
                  futureDelay(() {
                    // getCityApi(context, stateId.value.toString(), "", "");
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
                applyFilter(val.toString());

                update();
              },
              isSearch: true,
              inputType: TextInputType.text,
              errorText: searchStateModel.value.error));
    });
  }

  Widget setcityListDialog() {
    return Obx(() {
      if (isCityApiCallLoading.value == true) {
        return setDropDownContent([].obs, const Text("Loading"),
            isApiIsLoading: isCityApiCallLoading.value);
      }
      return setDropDownContent(
          cityFilterList,
          ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: cityFilterList.length,
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
                  // getState(context);
                  // cityctr.text = "";
                  // cityId.value = "";
                  update();
                  futureDelay(() {
                    // getCityApi(context, stateId.value.toString(), "", "");
                  }, isOneSecond: false);
                  // validateFields(stateCtr.text);
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
    });
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
      logcat('filterApply', stateFilterList.length.toString());
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
      logcat('filterApply', cityFilterList.length.toString());
    }

    update();
  }
}
