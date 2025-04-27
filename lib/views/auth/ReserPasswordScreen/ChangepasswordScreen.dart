import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/componant/button/form_button.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/changePasswordController.dart';
import 'package:ibh/utils/helper.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen(
      {super.key, this.email, this.otp, this.fromProfile = false});
  bool? fromProfile;
  String? email;
  String? otp;

  @override
  State<ChangePasswordScreen> createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final ctr = Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
    return CustomParentScaffold(
      onWillPop: () async {
        if (widget.fromProfile == false) {
          Get.close(2);
        }
        return true;
      },
      onTap: () {
        hideKeyboard(context);
      },
      isExtendBodyScreen: true,
      body: Form(
        key: ctr.resetpasskey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          getDynamicSizedBox(height: 5.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            child: getleftsidebackbtn(
                title: widget.fromProfile == false
                    ? ResetPasstext.title
                    : ChangPasswordScreenConstant.title,
                backFunction: () {
                  if (widget.fromProfile == false) {
                    Get.close(2);
                  } else {
                    Get.back();
                  }
                }),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getDynamicSizedBox(height: 3.h),
                  Container(
                    padding: EdgeInsets.only(
                        left: 7.0.w, right: 7.0.w, top: 1.h, bottom: 3.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.fromProfile == true)
                          Obx(() {
                            return getTextField(
                              label:
                                  ChangPasswordScreenConstant.currentPassHint,
                              hint: ChangPasswordScreenConstant
                                  .currentPasswordHint,
                              ctr: ctr.currentCtr,
                              node: ctr.currentpassNode,
                              model: ctr.currentPassModel.value,
                              function: (val) {
                                ctr.validateFields(val,
                                    ispassword: true,
                                    model: ctr.currentPassModel,
                                    errorText1: ChangPasswordScreenConstant
                                        .currentPasswordHint,
                                    errorText2: ChangPasswordScreenConstant
                                        .hintSpaceNotAllowed,
                                    errorText3: ChangPasswordScreenConstant
                                        .validPasswordHint,
                                    isforgotpasswordfunction: false);
                              },
                              ispass: true,
                              wantsuffix: true,
                              isobscure: ctr.isObsecureCurrentPassText,
                              obscureFunction: ctr.toggleCurrentPassObscureText,
                            );
                          }),
                        Obx(() {
                          return getTextField(
                            label: ChangPasswordScreenConstant.newPassHint,
                            hint: ChangPasswordScreenConstant.newPasswordHint,
                            ctr: ctr.newpassCtr,
                            node: ctr.newpassNode,
                            model: ctr.newPassModel.value,
                            function: (val) {
                              ctr.validateFields(
                                val,
                                ispassword: true,
                                model: ctr.newPassModel,
                                isforgotpasswordfunction:
                                    widget.fromProfile == false ? true : false,
                                errorText1:
                                    ChangPasswordScreenConstant.newPasswordHint,
                                errorText2: ChangPasswordScreenConstant
                                    .hintSpaceNotAllowed,
                                errorText3: ChangPasswordScreenConstant
                                    .validPasswordHint,
                              );

                              if (ctr.confirmCtr.text.isNotEmpty) {
                                ctr.validateFields(
                                  val,
                                  isconfirmpassword: true,
                                  model: ctr.confirmPassModel,
                                  isforgotpasswordfunction:
                                      widget.fromProfile == false
                                          ? true
                                          : false,
                                  confirmpasswordctr: ctr.confirmCtr.text,
                                  errorText1: ChangPasswordScreenConstant
                                      .confirmPasswordHint,
                                  errorText2: ChangPasswordScreenConstant
                                      .hintSpaceNotAllowed,
                                  errorText3: ChangPasswordScreenConstant
                                      .passwordMismatchHint,
                                );
                              }
                            },
                            ispass: true,
                            wantsuffix: true,
                            isobscure: ctr.isObsecureNewPassText,
                            obscureFunction: ctr.toggleNewPassObscureText,
                          );
                        }),
                        Obx(() {
                          return getTextField(
                            label: ChangPasswordScreenConstant
                                .validConfirmPassHint,
                            hint: ChangPasswordScreenConstant
                                .validConfirmPasswordHint,
                            ctr: ctr.confirmCtr,
                            node: ctr.confirmpassNode,
                            model: ctr.confirmPassModel.value,
                            function: (val) {
                              ctr.validateFields(
                                val,
                                isconfirmpassword: true,
                                model: ctr.confirmPassModel,
                                isforgotpasswordfunction:
                                    widget.fromProfile == false ? true : false,
                                errorText1: ChangPasswordScreenConstant
                                    .confirmPasswordHint,
                                errorText2: ChangPasswordScreenConstant
                                    .hintSpaceNotAllowed,
                                errorText3: ChangPasswordScreenConstant
                                    .passwordMismatchHint,
                                confirmpasswordctr: ctr.newpassCtr.text,
                              );
                            },
                            ispass: true,
                            wantsuffix: true,
                            isobscure: ctr.isObsecureNewConPassText,
                            obscureFunction: ctr.toggleNewConPassObscureText,
                          );
                        }),
                        getDynamicSizedBox(height: 5.0.h),
                        Obx(() {
                          return getFormButton(
                            context,
                            () {
                              if (widget.fromProfile == true) {
                                if (ctr.isFormInvalidate.value == true) {
                                  ctr.changePasswordApi(context, true);
                                }
                              } else {
                                if (ctr.isForgotPasswordValidate.value ==
                                    true) {
                                  ctr.forgotPassApi(
                                      context,
                                      widget.email.toString(),
                                      widget.otp.toString());
                                }
                              }
                            },
                            Button.continues,
                            validate: widget.fromProfile == true
                                ? ctr.isFormInvalidate.value
                                : ctr.isForgotPasswordValidate.value,
                          );
                        }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
