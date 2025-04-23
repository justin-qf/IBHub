import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/componant/button/form_button.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/signinScreenController.dart';
import 'package:ibh/utils/log.dart';
import 'package:ibh/views/sigin_signup/signupScreen.dart';
import 'package:sizer/sizer.dart';

class Signinscreen extends StatelessWidget {
  const Signinscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Signinscreencontroller ctr = Get.put(Signinscreencontroller());
    Statusbar().trasparentStatusbar();
    return CustomParentScaffold(
        isExtendBodyScreen: true,
        onWillPop: () async {
          return false;
        },
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  getDynamicSizedBox(height: 2.h),
                  SafeArea(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Login To Your Account',
                        style: TextStyle(
                            fontFamily: dM_sans_bold, fontSize: 20.sp),
                      ),
                    ),
                  ),
                  getDynamicSizedBox(height: 4.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Empowering creators and clients alike \nJoin the platform where work meets talent.',
                      style:
                          TextStyle(fontFamily: dM_sans_semiBold, color: grey),
                    ),
                  ),
                  getDynamicSizedBox(height: 10.h),
                  Obx(() {
                    return getTextField(
                      label: SignUpConstant.email,
                      hint: SignUpConstant.enterEmail,
                      ctr: ctr.emailCtr,
                      node: ctr.emailNode,
                      model: ctr.emailModel.value,
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
                      onTap: () {
                        logcat('Print:', 'goto forgot password screen');
                        // ctr.resetForm();

                        // Get.to(() => Forgotpasswordscreen(
                        //       loginController: ctr,
                        //     ));
                      },
                      child: Container(
                        //  color: black,
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 6),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              LoginConst.forgotpass,
                              style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: dM_sans_regular,
                              ),
                            ),
                            Positioned(
                              bottom: 1,
                              // Adjust this value to control the gap
                              child: Container(
                                width:
                                    35.w, // Adjust width based on text length
                                height: 0.2.h, // Thickness of the underline
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  getDynamicSizedBox(height: 4.h),
                  Obx(() {
                    return ctr.isloading == false
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.w),
                            child: getFormButton(context, () async {
                              if (ctr.isFormInvalidate.value == true) {
                                // ctr.loginAPI(context);
                                ctr.validateLogin(context);
                              }
                            }, LoginConst.title,
                                validate: ctr.isFormInvalidate.value),
                          )
                        : CircularProgressIndicator();
                  }),
                  getDynamicSizedBox(height: 4.h),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          'By registering you agree to',
                          style: TextStyle(
                              color: grey, fontFamily: dM_sans_regular),
                        ),
                        Text(
                          'Terms & Conditions and Privacy Policy',
                          style: TextStyle(
                              color: grey, fontFamily: dM_sans_regular),
                        ),
                      ],
                    ),
                  ),
                  getDynamicSizedBox(height: 4.h),
                ],
              ),
            ),
            Positioned(
              left: 0.w,
              right: 0.w,
              bottom: 2.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    LoginConst.dontHaveAccount,
                    style: TextStyle(color: grey, fontFamily: dM_sans_medium),
                    /*style: TextStyle(fontWeight: FontWeight.bold),*/
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.offAll(Signupscreen());

                      print('go to signup screen');

                      // ctr.resetForm();
                      logcat('print:', 'click');
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 1.w, top: 10, bottom: 10, right: 5),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            LoginConst.signup,
                            style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: dM_sans_medium),
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
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
