import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'custom_text_field.dart';

enum FieldType { email, mobile, text, dropDownl, countryCode, search }

Widget getReactiveFormField(
    {required node,
    required controller,
    required hintLabel,
    required void Function(String? val) onChanged,
    String? errorText,
    List<TextInputFormatter>? inputFormatters,
    required TextInputType inputType,
    FieldType? formType,
    Function? onVerifyButtonClick,
    bool? isVerified,
    bool? wantSuffix,
    bool? isDataValidated,
    Function? onTap,
    Function? onPrefixTap,
    Function? onAddBtn,
    bool? isStarting,
    bool? isAdd,
    bool? isPhoto,
    bool? isDropdown,
    bool? isCalender,
    bool? isPass,
    
    bool? isReport,
    bool? isdown,
    bool? isMick,
    bool? isReadOnly,
    bool? fetchLocation,
    bool isFromAddStory = false,
    bool isFromIntro = false,
    bool isEnable = true,
    bool isAddress = false,
    bool isSearch = false,
    bool isReview = false,
    bool isClose=false,
    bool? isWhite,
    bool isGst = false,
    String? fromObsecureText,
    String? index,
    final Function? onSave,
    bool isReference = false,
    bool isBorderSideEnable = true,
    bool obscuretext = false,
    Function? obscureTextFunction}) {
  return Container(
    // margin: EdgeInsets.symmetric(
    //     horizontal: isFromIntro
    //         ? Device.screenType == ScreenType.mobile
    //             ? 7.5.w
    //             : 5.5.w
    //         : isSearch == true
    //             ? 0.2.w
    //             : 6.0.w,
    //     vertical: 0.90.h),
    margin: EdgeInsets.symmetric(
        vertical: Device.screenType == ScreenType.mobile ? 1.2.h : 1.h),
    child: CustomFormField(
      index: index,
      fromObsecureText: fromObsecureText,
      hintText: hintLabel,
      errorText: errorText,
      node: node,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      inputType: inputType,
      formType: formType,
      controller: controller,
      isAddressField: isAddress,
      onVerifiyButtonClick: onVerifyButtonClick,
      isVerified: isVerified,
      isStarting: isStarting,
      isDropdown: isDropdown,
      isCalender: isCalender,
      isPassword: isPass,
      isAdd: isAdd,
      isdown: isdown,
      wantSuffix: wantSuffix,
      isReport: isReport,
      onTap: onTap,
      onPrefixTap: onPrefixTap,
      onAddBtn: onAddBtn,
      obsecuretext: obscuretext,
      isReferenceField: isReference,
      isFromAddStory: isFromAddStory,
      isEnable: isEnable,
      isReadOnly: isReadOnly,
      isWhite: isWhite,
      fetchLocation: fetchLocation,
      onSave: onSave,
      isGst: isGst,
      isBorderSideEnable: isBorderSideEnable,
      obscureFunction: obscureTextFunction,
      isMick: isMick,
      isClose: isClose,

    ),
  );
}
