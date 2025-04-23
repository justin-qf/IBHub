import 'package:flutter/material.dart';
import 'package:ibh/componant/button/form_button.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/otpController.dart';
import 'package:ibh/utils/helper.dart';
import 'package:ibh/views/auth/ReserPasswordScreen/ChangepasswordScreen.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';
import 'package:sizer/sizer.dart' as sizer;
import 'package:get/get.dart';

// ignore: must_be_immutable
class OtpScreen extends StatefulWidget {
  OtpScreen({
    super.key,
    this.email,
    this.otp,
  });
  String? otp;
  String? email = '';
  @override
  State<OtpScreen> createState() => OtpScreenState();
}

class OtpScreenState extends State<OtpScreen> {
  final controller = Get.put(OtpController());

  late TextEditingController otp1 = TextEditingController();
  late TextEditingController otp2 = TextEditingController();
  late TextEditingController otp3 = TextEditingController();
  late TextEditingController otp4 = TextEditingController();
  FocusNode node1 = FocusNode();
  FocusNode node2 = FocusNode();
  FocusNode node3 = FocusNode();
  FocusNode node4 = FocusNode();

  @override
  void initState() {
    controller.clearFocuseNode();
    controller.fieldOne.text = '';
    controller.fieldTwo.text = '';
    controller.fieldThree.text = '';
    controller.fieldFour.text = '';
    controller.otpController.text = "";
    controller.otpController.clear();
    controller.startTimer();
    super.initState();
  }

  @override
  void dispose() {
    controller.timer.cancel();
    controller.otpController.clear();
    controller.fieldOne.text = '';
    controller.fieldTwo.text = '';
    controller.fieldThree.text = '';
    controller.fieldFour.text = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomParentScaffold(
      onWillPop: () async {
        return true;
      },
      onTap: () {
        hideKeyboard(context);
      },
      isExtendBodyScreen: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          getDynamicSizedBox(height: 5.h),
          getCommonToolbar(OtpConstant.title, onClick: () {
            Get.back();
          }, showBackButton: true),
          Expanded(
              child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                getDynamicSizedBox(height: 5.h),
                Text(
                  OtpConstant.otpCode,
                  style: TextStyle(
                      fontSize: Device.screenType == sizer.ScreenType.mobile
                          ? 16.sp
                          : 14.sp,
                      fontFamily: fontMedium,
                      fontWeight: FontWeight.w700),
                ),
                getDynamicSizedBox(height: 3.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10.h,
                      child: Pinput(
                        length: 4,
                        controller: controller.otpController,
                        focusNode: controller.otpNode,
                        defaultPinTheme: getPinTheme(),
                        onCompleted: (pin) {
                          if (controller.isFormInvalidate.value =
                              pin.length == 4) {}
                          setState(() {
                            pin.length != 4;
                          });
                        },
                        onChanged: (value) {
                          controller.enableButton(
                            value,
                          );
                          setState(() {});
                        },
                        focusedPinTheme: getPinTheme().copyWith(
                          height: 68.0,
                          width: 64.0,
                          decoration: getPinTheme().decoration!.copyWith(
                                border: Border.all(
                                    color: primaryColor.withOpacity(0.8)),
                                //color: const Color.fromRGBO(114, 178, 238, 1)),
                                borderRadius: BorderRadius.circular(15),
                              ),
                        ),
                        submittedPinTheme: getPinTheme().copyWith(
                          textStyle: TextStyle(
                            color: white,
                            fontSize: getPinTheme().textStyle!.fontSize,
                          ),
                          decoration: getPinTheme().decoration!.copyWith(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: black),
                              ),
                        ),
                        errorPinTheme: getPinTheme().copyWith(
                          decoration: BoxDecoration(
                            color: red,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                getDynamicSizedBox(height: 3.0.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: Obx(
                    () {
                      return InkWell(
                        canRequestFocus: false,
                        onTap: () {
                          controller.clearFocuseNode();
                        },
                        child: controller.countdown.value == 0
                            ? Column(
                                children: [
                                  Text(
                                    OtpConstant.notReceiveCode,
                                    style: TextStyle(
                                        fontSize: Device.screenType ==
                                                sizer.ScreenType.mobile
                                            ? 16.sp
                                            : 12.sp,
                                        fontFamily: fontMedium,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  getDynamicSizedBox(height: 1.5.h),
                                  GestureDetector(
                                    onTap: () {
                                      controller.getForgotOtp(
                                          context, widget.email!);
                                    },
                                    child: Text(OtpConstant.resend,
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: Colors.black,
                                            decorationThickness: 1.5,
                                            fontSize: Device.screenType ==
                                                    sizer.ScreenType.mobile
                                                ? 15.sp
                                                : 10.sp,
                                            fontFamily: fontExtraBold,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                ],
                              )
                            : Text(
                                'Time remaining: ${controller.countdown} seconds',
                                style: TextStyle(
                                    fontSize: Device.screenType ==
                                            sizer.ScreenType.mobile
                                        ? 15.sp
                                        : 14.sp,
                                    fontWeight: FontWeight.w100,
                                    fontFamily: fontRegular,
                                    color:
                                        isDarkMode() ? white : labelTextColor),
                              ),
                      );
                    },
                  ),
                ),
                getDynamicSizedBox(
                    height: Device.screenType == sizer.ScreenType.mobile
                        ? 5.h
                        : 4.h),
                Container(
                  margin: EdgeInsets.only(left: 14.w, right: 14.w),
                  child: Obx(() {
                    return getFormButton(context, () {
                      if (controller.isFormInvalidate.value == true) {
                        // Get.to(ChangePasswordScreen(
                        //   fromProfile: false,
                        //   email: '',
                        //   otp: controller.otpController.text.toString(),
                        // ))!
                        //     .then((value) {
                        //   controller.otpController.text = '';
                        //   FocusScope.of(context)
                        //       .requestFocus(controller.otpNode);
                        // });
                        controller.verifyForgotOtp(context, widget.email!);
                      }
                    }, OtpConstant.verify,
                        validate: controller.isFormInvalidate.value);
                  }),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }
}
