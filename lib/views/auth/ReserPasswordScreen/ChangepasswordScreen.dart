import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/componant/button/form_button.dart';
import 'package:ibh/componant/input/form_inputs.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/changePasswordController.dart';
import 'package:ibh/utils/helper.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({super.key, this.email, this.otp, this.fromProfile});
  bool? fromProfile;
  String? email;
  String? otp;

  @override
  State<ChangePasswordScreen> createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final controller = Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
    return CustomParentScaffold(
      onWillPop: () async {
        if (widget.fromProfile == false) {
          Get.back(result: true);
        }
        return true;
      },
      onTap: () {
        hideKeyboard(context);
      },
      isExtendBodyScreen: true,
      body: Form(
        key: controller.resetpasskey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          getDynamicSizedBox(height: 5.h),
          getCommonToolbar(
              showBackButton: true,
              widget.fromProfile == false
                  ? ResetPasstext.title
                  : ChangPasswordScreenConstant.title, onClick: () {
            Get.back(result: true);
          }),
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
                          getLable(ChangPasswordScreenConstant.currentPassHint),
                        if (widget.fromProfile == true)
                          AnimatedSize(
                              duration: const Duration(milliseconds: 300),
                              child: Obx(() {
                                return getReactiveFormField(
                                  node: controller.currentpassNode,
                                  controller: controller.currentCtr,
                                  hintLabel: ChangPasswordScreenConstant
                                      .currentPasswordHint,
                                  wantSuffix: true,
                                  isPass: true,
                                  onChanged: (val) {
                                    controller.validateCurrentPass(val);
                                  },
                                  index: "0",
                                  fromObsecureText: "RESETPASS",
                                  errorText:
                                      controller.currentPassModel.value.error,
                                  inputType: TextInputType.text,
                                );
                              })),
                        getLable(ChangPasswordScreenConstant.newPassHint),
                        AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            child: Obx(() {
                              return getReactiveFormField(
                                node: controller.newpassNode,
                                controller: controller.newpassCtr,
                                hintLabel:
                                    ChangPasswordScreenConstant.newPasswordHint,
                                wantSuffix: true,
                                isPass: true,
                                onChanged: (val) {
                                  widget.fromProfile == true
                                      ? controller.validateNewPass(val)
                                      : controller.validateNewPassword(val);
                                },
                                index: "1",
                                fromObsecureText: "RESETPASS",
                                errorText: controller.newPassModel.value.error,
                                inputType: TextInputType.text,
                              );
                            })),
                        getLable(
                            ChangPasswordScreenConstant.validConfirmPassHint),
                        AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            child: Obx(() {
                              return getReactiveFormField(
                                node: controller.confirmpassNode,
                                controller: controller.confirmCtr,
                                hintLabel: ChangPasswordScreenConstant
                                    .validConfirmPasswordHint,
                                onChanged: (val) {
                                  widget.fromProfile == true
                                      ? controller.validateConfirmPass(val)
                                      : controller.validateForgotPass(val);
                                },
                                index: "2",
                                fromObsecureText: "RESETPASS",
                                wantSuffix: true,
                                isPass: true,
                                errorText:
                                    controller.confirmPassModel.value.error,
                                inputType: TextInputType.text,
                              );
                            })),
                        getDynamicSizedBox(height: 5.0.h),
                        Obx(() {
                          return getFormButton(
                            context,
                            () {
                              if (widget.fromProfile == true) {
                                if (controller.isFormInvalidate.value == true) {
                                  controller.changePasswordApi(context, true);
                                }
                              } else {
                                if (controller.isForgotPasswordValidate.value ==
                                    true) {
                                  controller.forgotPassApi(
                                      context,
                                      widget.email.toString(),
                                      widget.otp.toString());
                                }
                              }
                            },
                            Button.continues,
                            validate: widget.fromProfile == true
                                ? controller.isFormInvalidate.value
                                : controller.isForgotPasswordValidate.value,
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
