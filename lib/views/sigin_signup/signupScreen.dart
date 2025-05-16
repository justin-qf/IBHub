import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/componant/button/form_button.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/signupScreenController.dart';
import 'package:ibh/utils/helper.dart';
import 'package:ibh/views/privacypolicy/PrivacyPolicyScreen.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class Signupscreen extends StatefulWidget {
  String? emailId;
  Signupscreen({super.key, this.emailId});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  final Signupscreencontroller ctr = Get.put(Signupscreencontroller());

  @override
  void initState() {
    super.initState();
    if (widget.emailId != null) {
      ctr.emailCtr.text = widget.emailId!;
      ctr.isGmailLogin.value = true;
    }
    ctr.validateEmailFields();
  }

  @override
  Widget build(BuildContext context) {
    Statusbar().trasparentStatusbar();
    return CustomParentScaffold(
      isExtendBodyScreen: true,
      onWillPop: () async {
        ctr.resetForm();
        ctr.unfocusAll();
        return true;
      },
      onTap: () {
        hideKeyboard(context);
      },
      body: SingleChildScrollView(
        // physics: NeverScrollableScrollPhysics(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 3.h, left: 0.w),
                child: getleftsidebackbtn(
                    title: 'Create Your Account',
                    backFunction: () {
                      Get.back(result: true);
                      ctr.resetForm();
                      ctr.unfocusAll();
                    },
                    istitle: false),
              ),
              getDynamicSizedBox(height: 1.h),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                    // color: Colors.yellow,
                    height: 7.h,
                    width: 30.w,
                    child: Image.asset(
                      Asset.applogo,
                    )),
              ),
              getDynamicSizedBox(height: 2.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Create Your Account',
                  style: TextStyle(
                      fontFamily: dM_sans_bold, fontSize: 20.sp, height: 1.1),
                ),
              ),
              getDynamicSizedBox(height: 2.h),
              Obx(() {
                return getTextField(
                  label: SignUpConstant.email,
                  hint: SignUpConstant.enterEmail,
                  ctr: ctr.emailCtr,
                  node: ctr.emailNode,
                  model: ctr.emailModel.value,
                  isenable: ctr.isGmailLogin.value == true ? false : true,
                  function: (val) {
                    ctr.validateFields(val,
                        isemail: true,
                        model: ctr.emailModel,
                        errorText1: SignUpConstant.enterEmail,
                        errorText2: SignUpConstant.emailcontain,
                        errorText3: SignUpConstant.invalidEmailFormat);
                  },
                  isRequired: true,
                );
              }),
              Obx(() {
                return getTextField(
                    label: SignUpConstant.passwordLable,
                    ctr: ctr.passCtr,
                    node: ctr.passNode,
                    model: ctr.passModel.value,
                    function: (val) {
                      ctr.validateFields(
                        val,
                        ispassword: true,
                        model: ctr.passModel,
                        errorText1: SignUpConstant.passwordHint,
                        errorText2: SignUpConstant.hintSpaceNotAllowed,
                        errorText3: SignUpConstant.validPasswordHint,
                      );

                      if (ctr.confpassCtr.text.isNotEmpty) {
                        ctr.validateFields(
                          val,
                          isconfirmpassword: true,
                          confirmpasswordctr: ctr.confpassCtr.text,
                          model: ctr.confpassModel,
                          errorText1: SignUpConstant.confirmPasswordHint,
                          errorText2: SignUpConstant.hintSpaceNotAllowed,
                          errorText3: SignUpConstant.passwordMismatchHint,
                        );
                      }
                    },
                    hint: SignUpConstant.validPasswordHint,
                    wantsuffix: true,
                    ispass: true,
                    isRequired: true,
                    isobscure: ctr.isObsecurePassText,
                    obscureFunction: () {
                      ctr.togglePassObscureText();
                    });
              }),
              Obx(() {
                return getTextField(
                    label: SignUpConstant.repasswordLable,
                    ctr: ctr.confpassCtr,
                    node: ctr.confpassNode,
                    model: ctr.confpassModel.value,
                    function: (val) {
                      ctr.validateFields(
                        val,
                        isconfirmpassword: true,
                        model: ctr.confpassModel,
                        errorText1: SignUpConstant.confirmPasswordHint,
                        errorText2: SignUpConstant.hintSpaceNotAllowed,
                        errorText3: SignUpConstant.passwordMismatchHint,
                        confirmpasswordctr: ctr.passCtr.text,
                      );
                    },
                    hint: SignUpConstant.confirmPasswordHint,
                    wantsuffix: true,
                    ispass: true,
                    isRequired: true,
                    isobscure: ctr.isObsecureConPassText,
                    obscureFunction: () {
                      ctr.toggleConfPassObscureText();
                    });
              }),
              getDynamicSizedBox(height: isSmallDevice(context) ? 3.h : 5.h),
              Obx(() {
                return ctr.isloading == false
                    ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 5.w),
                        child: getFormButton(context, () async {
                          if (ctr.isFormInvalidate.value == true) {
                            ctr.registerAPI(context);
                            // ctr.validateLogin(context);
                          }
                        }, SignUpConstant.signup,
                            validate: ctr.isFormInvalidate.value),
                      )
                    : const CircularProgressIndicator();
              }),
              getDynamicSizedBox(height: 5.h),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const Text(
                      'By registering you agree to',
                      style: TextStyle(
                        color: grey,
                        fontFamily: dM_sans_regular,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(PrivacyPolicyScreen(
                              ispolicyScreen: false,
                            ));
                          },
                          child: Container(
                            // color: Colors.yellow,
                            padding: const EdgeInsets.all(5),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                const Text(
                                  'Terms & Conditions',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: dM_sans_medium),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    width:
                                        40.w, // Adjust according to text length
                                    height: 0.2.h,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Text(' and ',
                            style: TextStyle(
                                color: grey, fontFamily: dM_sans_regular)),
                        GestureDetector(
                          onTap: () {
                            // Navigate to Privacy Policy page
                            Get.to(PrivacyPolicyScreen(
                              ispolicyScreen: true,
                            ));
                            // print('navigate to policy screen');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                const Text(
                                  'Privacy Policy',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: dM_sans_medium,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    width:
                                        30.w, // Adjust according to text length
                                    height: 0.2.h,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              getDynamicSizedBox(height: isSmallDevice(context) ? null : 3.h),
              GestureDetector(
                onTap: () {
                  ctr.resetForm();
                  Get.back(result: true);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        SignUpConstant.alreadyhaveaccount,
                        style:
                            TextStyle(color: grey, fontFamily: dM_sans_medium),
                      ),
                      getDynamicSizedBox(width: 1.w),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          const Text(
                            SignUpConstant.title,
                            style: TextStyle(
                              fontFamily: dM_sans_medium,
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Positioned(
                            bottom: 1,
                            // Adjust this value to control the gap
                            child: Container(
                              width: 35.w, // Adjust width based on text length
                              height: 0.2.h, // Thickness of the underline
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // getDynamicSizedBox(height: 3.h)
            ],
          ),
        ),
      ),
    );
  }
}
