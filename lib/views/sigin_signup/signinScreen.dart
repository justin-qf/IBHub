import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
          return false;
        },
        body: SizedBox(
          height: Device.height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0.w,
                right: 0.w,
                bottom: 2.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(LoginConst.dontHaveAccount,
                        style:
                            TextStyle(color: grey, fontFamily: dM_sans_medium)),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const Signupscreen());
                        ctr.resetForm();
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 1.w, top: 10, bottom: 10, right: 5),
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
                ),
              ),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      getDynamicSizedBox(height: 5.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Login To Your Account',
                          style: TextStyle(
                              fontFamily: dM_sans_bold, fontSize: 20.sp),
                        ),
                      ),
                      getDynamicSizedBox(height: 4.h),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            'Empowering creators and clients alike \nJoin the platform where work meets talent.',
                            style: TextStyle(
                                fontFamily: dM_sans_semiBold, color: grey)),
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
                      Container(
                        margin: EdgeInsets.only(left: 55.w),
                        child: GestureDetector(
                          onTap: () {
                            ctr.resetForm();
                            Get.to(() => const EmailScreen());
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 6),
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
                              validate: ctr.isFormInvalidate.value),
                        );
                      }),
                      getDynamicSizedBox(height: 4.h),
                      const Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text('By registering you agree to',
                                style: TextStyle(
                                    color: grey, fontFamily: dM_sans_regular)),
                            Text('Terms & Conditions and Privacy Policy',
                                style: TextStyle(
                                    color: grey, fontFamily: dM_sans_regular)),
                          ],
                        ),
                      ),
                      getDynamicSizedBox(height: 4.h)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
