import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/componant/button/form_button.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/utils/enum.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

Widget apiOtherStates(
    state, controller, RxList<dynamic> list, Function onClick) {
  if (state == ScreenState.apiLoading) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: SizedBox(
          height: 30,
          width: 30,
          child: LoadingAnimationWidget.discreteCircle(
            color: primaryColor,
            size: 35,
          ),
        ),
      ),
    );
  }

  Widget? button;
  if (list.isEmpty) {
    Container();
  }
  if (state == ScreenState.noDataFound) {
    // button = getMiniButton(() {
    //   Get.back();
    // }, BottomConstant.back);
  }
  if (state == ScreenState.noNetwork) {
    button = getMiniButton(() {
      onClick();
    }, BottomConstant.tryAgain);
  }

  if (state == ScreenState.apiError) {
    button = getMiniButton(() {
      Get.back();
    }, BottomConstant.back);
  }
  return Center(
    child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.w),
        child: controller.message.value.isNotEmpty
            ? Text(
                controller.message.value,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: dM_sans_medium, fontSize: 16.sp, color: black),
              )
            : button),
  );
}
