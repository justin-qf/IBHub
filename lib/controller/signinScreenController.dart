import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ibh/api_handle/Repository.dart';
import 'package:ibh/api_handle/apiCallingFormate.dart';
import 'package:ibh/componant/dialogs/dialogs.dart';
import 'package:ibh/componant/dialogs/loading_indicator.dart';
import 'package:ibh/configs/apicall_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/MasterController.dart';

import 'package:ibh/controller/internet_controller.dart';
import 'package:ibh/models/login_model.dart';
import 'package:ibh/models/googleAuthResponse.dart';
import 'package:ibh/models/sign_in_form_validation.dart';
import 'package:ibh/preference/UserPreference.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/log.dart';
import 'package:ibh/views/RemoteConfig/remoteConfig.dart';
import 'package:ibh/views/auth/ReserPasswordScreen/OtpScreen.dart';
import 'package:ibh/views/mainscreen/MainScreen.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:ibh/views/sigin_signup/signupScreen.dart';

class Signinscreencontroller extends GetxController {
  final InternetController networkManager = Get.find<InternetController>();
  final RemoteConfigService remoteConfigService =
      Get.find<RemoteConfigService>(); // Get RemoteConfigService
  RxBool isGoogleAuthVisible = false.obs; // Reactive boolean

  // // Optional: Refresh Remote Config
  // Future<void> refreshRemoteConfig() async {
  //   await remoteConfigService.initialize();
  //   isGoogleAuthVisible.value = remoteConfigService.isGoogleAuthVisible;
  // }

  Rx<ScreenState> state = ScreenState.apiLoading.obs;

  late FocusNode emailNode, passNode;
  late TextEditingController emailCtr, passCtr;
  var emailModel = ValidationModel(null, null, isValidate: false).obs;
  var passModel = ValidationModel(null, null, isValidate: false).obs;
  RxBool isFormInvalidate = false.obs;

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
  void onInit() {
    super.onInit();
    emailNode = FocusNode();
    passNode = FocusNode();
    emailCtr = TextEditingController();
    passCtr = TextEditingController();
    isFormInvalidate.value = false;
    _obsecureTextPass.value = true;
    _isLoading.value = false;
    // print('call signin screeen');
    resetForm();

    isGoogleAuthVisible.value = remoteConfigService.isGoogleAuthVisible;
    remoteConfigService.remoteConfig.onConfigUpdated.listen((event) async {
      await remoteConfigService.remoteConfig.activate();
      isGoogleAuthVisible.value = remoteConfigService.isGoogleAuthVisible;
    });
  }

  @override
  void onClose() {
    // Clear before disposing
    // emailCtr.clear();
    // passCtr.clear();

    // Then dispose controllers and focus nodes
    // emailCtr.dispose();
    // passCtr.dispose();
    // emailNode.dispose();
    // passNode.dispose();

    // Reset all reactive variables
    emailModel.value = ValidationModel(null, null, isValidate: false);
    passModel.value = ValidationModel(null, null, isValidate: false);
    isFormInvalidate.value = false;
    _isLoading.value = false;

    super.onClose();
  }

  unfocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void resetForm() {
    emailCtr.clear();
    passCtr.clear();
    emailNode.unfocus();
    passNode.unfocus();
    unfocusAll();
    emailModel.value = ValidationModel(null, null, isValidate: false);
    passModel.value = ValidationModel(null, null, isValidate: false);
    _obsecureTextPass.value = true;
    _isLoading.value = false;
    isFormInvalidate.value = false;

    emailModel.refresh();
    passModel.refresh();
    isFormInvalidate.refresh();
    _obsecureTextPass.refresh();
    _isLoading.refresh();

    update();
  }

  // void resetForm() {
  //   emailCtr.clear();
  //   passCtr.clear();
  //   emailNode.unfocus();
  //   passNode.unfocus();

  //   emailModel.value = ValidationModel(null, null, isValidate: false);
  //   passModel.value = ValidationModel(null, null, isValidate: false);

  //   isFormInvalidate.value = false;
  //   _isLoading.value = false;
  //   _obsecureTextPass.value = true;

  //   // update();
  // }

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

  void loginAPI(context) async {
    commonPostApiCallFormate(
      context,
      title: LoginConst.title,
      body: {
        "email": emailCtr.text.toString().trim(),
        "password": passCtr.text.toString().trim()
      },
      apiEndPoint: ApiUrl.login,
      onResponse: (data) async {
        var responseDetail = LoginModel.fromJson(data);
        UserPreferences().saveSignInInfo(responseDetail.data!.user);
        UserPreferences().setToken(responseDetail.data!.user!.token.toString());
        logcat("LoginResponse::", jsonEncode(responseDetail));
        // User? retrievedObject = await UserPreferences().getSignInInfo();
        if (responseDetail.data!.user!.isEmailVerified == true) {
          emailCtr.text = '';
          passCtr.text = '';
          emailModel.value = ValidationModel(null, null, isValidate: false);
          passModel.value = ValidationModel(null, null, isValidate: false);
          Get.offAll(const MainScreen());
        } else {
          Get.to(() => OtpScreen(
                email: responseDetail.data!.user!.email.toString().trim(),
                otp: "1235",
                isFromSingIn: true,
              ))?.then((value) {});
          // getRegiaterOtp(context, responseDetail.data.user.email.toString());
        }
      },
      networkManager: networkManager,
      isModelResponse: true,
    );
  }

// google

  Future<firebase.User?> signinWithGmail(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    await googleSignIn.signOut(); // optional: to force fresh sign-in

    final user = await googleSignIn.signIn();

    if (user == null) return null; // User canceled

    final GoogleSignInAuthentication userAuth = await user.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: userAuth.idToken,
      accessToken: userAuth.accessToken,
    );

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    firebase.User? firebaseUser = userCredential.user;

    if (firebaseUser != null) {
      await callingAuthApi(context, user: firebaseUser);
    }

    return firebaseUser;
  }

  Future<void> callingAuthApi(BuildContext context,
      {required firebase.User user}) async {
    // Construct user data map with all relevant fields
    // logcat("PARAM", {
    //   "uid": user.uid,
    //   "email": user.email,
    //   "displayName": user.displayName,
    //   "email Verified": user.emailVerified,
    //   "phoneNumber": user.phoneNumber
    // });

    // final Map<String, dynamic> userData = {
    //   "uid": user.uid,
    //   "email": user.email,
    //   "displayName": user.displayName,
    //   "emailVerified": user.emailVerified,
    //   "phoneNumber": user.phoneNumber,
    // };

    var loadingIndicator = LoadingProgressDialogs();

    try {
      if (networkManager.connectionType.value == 0) {
        loadingIndicator.hide(context);
        showDialogForScreen(context, AddServiceScreenViewConst.serviceScr,
            Connection.noConnection, callback: () {
          Get.back();
        });
        return;
      }
      print("SHOW LOADING...");
      await loadingIndicator.show(context, '');
      print("LOADING SHOWN...");

      logcat("PARAM", {
        "uid": user.uid,
        "email": user.email,
        "displayName": user.displayName,
        "email Verified": user.emailVerified,
        "phoneNumber": user.phoneNumber
      });

      var response = await Repository.post({
        "uid": user.uid,
        "email": user.email ?? '',
        "displayName": user.displayName ?? '',
        "emailVerified": user.emailVerified,
        "phoneNumber": user.phoneNumber ?? '',
      }, ApiUrl.authCallback, allowHeader: true);

      loadingIndicator.hide(context);

      var json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (json['success'] == true) {
          final res = GoogleAuth.fromJson(json);

          UserPreferences().saveSignInInfo(res.data.user);
          UserPreferences().setToken(res.data.user.token.toString());

          if (res.data.user.isEmailVerified == true) {
            Get.offAll(MainScreen());
            print('user is verified and goto dashboard');
          } else {
            Get.to(Signupscreen(
              emailId: user.email,
            ));
          }
        }
      } else {
        showDialogForScreen(context, 'Authentication', json['message'],
            callback: () {});
      }
    } catch (e) {
      logcat("Service Creation Exception", e.toString());
      showDialogForScreen(context, 'Authentication', Connection.servererror,
          callback: () {});
      loadingIndicator.hide(context);

      // Call your API
      // commonPostApiCallFormate(
      //   context,
      //   onResponse: (response) async {
      //     final res = GoogleAuth.fromJson(response);

      //     UserPreferences().saveSignInInfo(res.data.user);
      //     UserPreferences().setToken(res.data.user.token.toString());

      //     if (res.data.user.isEmailVerified == true) {
      //       Get.offAll(MainScreen());
      //       print('user is verified and goto dashboard');
      //     } else {
      //       Get.to(Signupscreen(
      //         emailId: user.email,
      //       ));
      //     }
      //   },
      //   body: userData,
      //   networkManager: networkManager,
      //   allowHeader: true,
      //   apiEndPoint: ApiUrl.authCallback,
      //   title: 'Authentication',
      //   isModelResponse: true,
      // );
    }
  }

  validateFields(
    val, {
    required Rx<ValidationModel> model,
    errorText1,
    errorText2,
    errorText3,
    isemail = false,
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
