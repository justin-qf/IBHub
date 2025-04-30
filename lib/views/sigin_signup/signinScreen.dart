import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
import 'package:ibh/controller/signinScreenController.dart';
import 'package:ibh/utils/helper.dart';
import 'package:ibh/views/auth/ReserPasswordScreen/EmailScreen.dart';
import 'package:ibh/views/sigin_signup/signupScreen.dart';
import 'package:sizer/sizer.dart';

class Signinscreen extends StatefulWidget {
  const Signinscreen({super.key});

  @override
  State<Signinscreen> createState() => _SigninscreenState();
}

class _SigninscreenState extends State<Signinscreen> {
  final Signinscreencontroller ctr = Get.put(Signinscreencontroller());

  @override
  Widget build(BuildContext context) {
    Statusbar().trasparentStatusbar();
    return CustomParentScaffold(
      isExtendBodyScreen: true,
      onWillPop: () async {
        getpopup(context,
            title: 'Exit App',
            message: 'Are you sure you want to quit the app?', function: () {
          exit(0);
        });
        return false;
      },
      onTap: () {
        hideKeyboard(context);
      },
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              getDynamicSizedBox(height: 10.h),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                    // color: Colors.yellow,
                    height: 8.h,
                    width: 30.w,
                    child: Image.asset(
                      Asset.applogo,
                    )),
              ),
              getDynamicSizedBox(height: 4.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Login To Your Account',
                  style: TextStyle(
                      fontFamily: dM_sans_bold, fontSize: 20.sp, height: 1.1),
                ),
              ),
              getDynamicSizedBox(height: 4.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    'Empowering creators and clients alike \nJoin the platform where work meets talent.',
                    style: TextStyle(
                        fontFamily: dM_sans_semiBold,
                        fontSize: 16.sp,
                        color: grey)),
              ),
              getDynamicSizedBox(height: 4.h),
              Obx(() {
                return getTextField(
                  label: SignUpConstant.email,
                  hint: SignUpConstant.enterEmail,
                  ctr: ctr.emailCtr,
                  node: ctr.emailNode,
                  model: ctr.emailModel.value,
                  isRequired: true,
                  function: (val) {
                    ctr.validateFields(val,
                        isemail: true,
                        model: ctr.emailModel,
                        errorText1: SignUpConstant.enterEmail,
                        errorText2: SignUpConstant.emailcontain,
                        errorText3: SignUpConstant.invalidEmailFormat);
                  },
                );
              }),
              Obx(
                () {
                  return getTextField(
                      label: LoginConst.passwordLable,
                      hint: LoginConst.passwordHint,
                      ctr: ctr.passCtr,
                      node: ctr.passNode,
                      model: ctr.passModel.value,
                      isRequired: true,
                      function: (val) {
                        ctr.validateFields(
                          val,
                          ispassword: true,
                          model: ctr.passModel,
                          errorText1: LoginConst.passwordHint,
                          errorText2: LoginConst.hintSpaceNotAllowed,
                          errorText3: LoginConst.validPasswordHint,
                        );
                      },
                      isNumeric: false,
                      wantsuffix: true,
                      ispass: true,
                      isobscure: ctr.isObsecurePassText,
                      obscureFunction: () {
                        ctr.togglePassObscureText();
                      });
                },
              ),
              getDynamicSizedBox(height: 2.h),
              Container(
                margin: EdgeInsets.only(left: 55.w),
                child: GestureDetector(
                  onTap: () async {
                    // Get.to(ChangePasswordScreen(
                    //   email: '',
                    //   fromProfile: true,
                    // ));

                    ctr.unfocusAll();
                    final result = await Get.to(() => const EmailScreen());

                    if (result == true) {
                      ctr.resetForm();
                    }
                  },
                  child: 
                  Container(
                    // color: Colors.yellow,
                    padding: EdgeInsets.only(top: 3.h, bottom: 3.h, left: 2.w),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Text(
                          LoginConst.forgotpass,
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: dM_sans_regular,
                          ),
                        ),
                        Positioned(
                            bottom: 1,
                            child: Container(
                                width: 35.w,
                                height: 0.2.h,
                                color: primaryColor)),
                      ],
                    ),
                  ),
                ),
              ),
              getDynamicSizedBox(height: 4.h),
              Obx(() {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  child: getFormButton(context, () async {
                    if (ctr.isFormInvalidate.value == true) {
                      ctr.loginAPI(context);
                    }
                  }, LoginConst.title,
                      validate: ctr.isFormInvalidate.value, isdelete: false),
                );
              }),
              getDynamicSizedBox(height: 5.h),
              // Align(
              //   alignment: Alignment.center,
              //   child: Column(
              //     children: [
              //       const Text(
              //         'By registering you agree to',
              //         style: TextStyle(
              //           color: grey,
              //           fontFamily: dM_sans_regular,
              //         ),
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           GestureDetector(
              //             onTap: () {
              //               print('navigate to term screen');
              //             },
              //             child: Stack(
              //               alignment: Alignment.center,
              //               children: [
              //                 const Text(
              //                   'Terms & Conditions',
              //                   style: TextStyle(
              //                       color: primaryColor,
              //                       fontWeight: FontWeight.bold,
              //                       fontFamily: dM_sans_medium),
              //                 ),
              //                 Positioned(
              //                   bottom: 0,
              //                   child: Container(
              //                     width:
              //                         40.w, // Adjust according to text length
              //                     height: 0.2.h,
              //                     color: primaryColor,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //           const Text(' and ',
              //               style: TextStyle(
              //                   color: grey, fontFamily: dM_sans_regular)),
              //           GestureDetector(
              //             onTap: () {
              //               // Navigate to Privacy Policy page
              //               print('navigate to policy screen');
              //             },
              //             child: Stack(
              //               alignment: Alignment.center,
              //               children: [
              //                 const Text(
              //                   'Privacy Policy',
              //                   style: TextStyle(
              //                     color: primaryColor,
              //                     fontWeight: FontWeight.bold,
              //                     fontFamily: dM_sans_medium,
              //                   ),
              //                 ),
              //                 Positioned(
              //                   bottom: 0,
              //                   child: Container(
              //                     width:
              //                         30.w, // Adjust according to text length
              //                     height: 0.2.h,
              //                     color: primaryColor,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              getDynamicSizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(LoginConst.dontHaveAccount,
                      style:
                          TextStyle(color: grey, fontFamily: dM_sans_medium)),
                  GestureDetector(
                    onTap: () async {
                      //  Get.to(ChangePasswordScreen(
                      //       email: '',
                      //       fromProfile: false,
                      //     ));
                      final result = await Get.to(() => const Signupscreen());

                      if (result == true) {
                        // ctr.init();
                        ctr.resetForm();
                        ctr.unfocusAll();
                      }
                    },
                    child: Container(
                      // color: Colors.yellow,
                      padding: EdgeInsets.only(
                          left: 1.w, top: 3.h, bottom: 4.h, right: 4.w),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Text(LoginConst.signup,
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: dM_sans_medium)),
                          Positioned(
                            bottom: 1,
                            child: Container(
                                width: 35.w,
                                height: 0.2.h,
                                color: primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
