import 'package:flutter/material.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/utils/helper.dart';
import 'package:sizer/sizer.dart';

styleTextFormFieldText({isWhite}) {
  return TextStyle(
    fontFamily: dM_sans_regular,
    color: isDarkMode() ? (isWhite == true ? black : white) : black,
    fontWeight: FontWeight.w300,
    fontSize: Device.screenType == ScreenType.mobile ? 16.sp : 9.sp,
  );
}

styleTextForFieldLabel(usernameNode) {
  return TextStyle(
    fontFamily: fontRegular,
    color: usernameNode.hasFocus ? primaryColor : black,
    fontSize: 12.sp,
  );
}

styleTextForErrorFieldHint() {
  return TextStyle(
      fontSize: Device.screenType == ScreenType.mobile ? 15.sp : 10.sp,
      fontFamily: dM_sans_regular,
      color: red);
}

styleTextHintFieldLabel({isWhite}) {
  return TextStyle(
      fontFamily: dM_sans_regular,
      fontWeight: FontWeight.w500,
      fontSize: Device.screenType == ScreenType.mobile ? 16.sp : 9.sp,
      color: isDarkMode()
          ? isWhite == true
              ? black
              : const Color.fromARGB(255, 145, 145, 145)
          : const Color.fromARGB(255, 145, 145, 145));
}

styleTextForFieldHintDropDown() {
  return TextStyle(
      fontFamily: dM_sans_regular,
      fontWeight: FontWeight.w500,
      fontSize: Device.screenType == ScreenType.mobile ? 12.sp : 9.sp,
      color: const Color.fromARGB(255, 145, 145, 145));
}

styleTextForFieldHint() {
  return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: Device.screenType == ScreenType.mobile ? 16.sp : 8.sp,
      color: const Color.fromARGB(255, 145, 145, 145));
}

styleTitle() {
  return TextStyle(
      fontFamily: fontExtraBold,
      color: isDarkMode() ? white : headingTextColor,
      fontWeight: FontWeight.w900,
      fontSize: Device.screenType == ScreenType.mobile ? 26.sp : 22.sp);
}

styleTitleSubtaxt() {
  return TextStyle(
      fontFamily: fontExtraBold,
      color: isDarkMode() ? white.withOpacity(0.3) : headingTextColor,
      fontWeight: isDarkMode() ? FontWeight.w900 : FontWeight.w600,
      fontSize: 11.sp);
}

styleForBottomTextOne(context) {
  return TextStyle(
      fontSize: Device.screenType == ScreenType.mobile ? 11.sp : 8.sp,
      fontWeight: FontWeight.w100,
      fontFamily: fontRegular,
      color: isDarkMode() ? white : secondaryColor);
}

styleForBottomTextTwo() {
  return TextStyle(
      fontSize: Device.screenType == ScreenType.mobile ? 11.sp : 8.sp,
      fontWeight: FontWeight.w600,
      fontFamily: fontRegular,
      color: secondaryColor);
}

styleDidtReceiveOTP(context) {
  return TextStyle(
      fontSize: Device.screenType == ScreenType.mobile ? 11.5.sp : 9.sp,
      fontWeight: FontWeight.w100,
      fontFamily: fontRegular,
      color: isDarkMode() ? black : labelTextColor);
}

styleResentButton() {
  return TextStyle(
      fontSize: Device.screenType == ScreenType.mobile ? 11.5.sp : 9.sp,
      fontFamily: fontMedium,
      color: isDarkMode() ? black : secondaryColor);
}
