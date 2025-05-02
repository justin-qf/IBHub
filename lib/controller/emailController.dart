import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/apiCallingFormate.dart';
import 'package:ibh/configs/apicall_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/internet_controller.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/log.dart';
import 'package:ibh/views/auth/ReserPasswordScreen/OtpScreen.dart';
import '../Models/sign_in_form_validation.dart';

class EmailController extends GetxController {
  final InternetController networkManager = Get.find<InternetController>();
  final resetpasskey = GlobalKey<FormState>();

  late FocusNode emailNode;
  late TextEditingController emailctr;
  var emailModel = ValidationModel(null, null, isValidate: false).obs;
  Rx<ScreenState> states = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  RxBool isFormInvalidate = false.obs;

  @override
  void onInit() {
    emailNode = FocusNode();
    emailctr = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    emailNode.dispose();
    emailctr.dispose();
    isFormInvalidate.value = false;
    emailModel = ValidationModel(null, null, isValidate: false).obs;
    super.onClose();
  }

  void unfocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // resetfilled() {
  //   isFormInvalidate.value = false;
  //   unfocusAll();
  //   // emailctr.clear();
  //   // emailNode.unfocus();
  // }

  void validateEmail(String? val) {
    emailModel.update((model) {
      String trimmedValue = val?.trim() ?? '';
      if (trimmedValue.isEmpty ||
          trimmedValue != val ||
          val!.startsWith(' ') ||
          val.endsWith(' ')) {
        model!.error = LoginConst.emailHint;
        model.isValidate = false;
      } else if (!RegExp(r'^\S+@\S+\.\S+$').hasMatch(trimmedValue)) {
        model!.error = LoginConst.validEmailHint;
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });

    enableSignUpButton();
  }

  void enableSignUpButton() {
    if (emailModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else {
      isFormInvalidate.value = true;
    }
  }

  getForgotOtp(context) async {
    commonPostApiCallFormate(
      context,
      title: EmailScreenConstant.forgotpassword,
      body: {"email": emailctr.text.toString().trim()},
      apiEndPoint: ApiUrl.forgotPass,
      onResponse: (data) {
        Get.to(() => OtpScreen(
              email: emailctr.text.toString(),
              otp: "1235",
              isFromSingIn: false,
            ))?.then((value) {
          validateEmail(emailctr.text);
        });
      },
      networkManager: networkManager,
    );
  }
}
