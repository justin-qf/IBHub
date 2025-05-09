import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:ibh/componant/input/style.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/utils/helper.dart';
import 'package:sizer/sizer.dart';
// import 'package:sizer/sizer.dart' as sizer;
// import 'package:get/get.dart' as getx;

setSearchBar(context, controller, String tag,
    {Function? onCancleClick, Function? onClearClick, bool? isCancle}) {
  return FadeInLeft(
    child: Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode() ? tileColour : white,
              borderRadius: BorderRadius.circular(
                  Device.screenType == ScreenType.mobile ? 5.h : 6.h),
              boxShadow: [
                BoxShadow(
                    color: black.withOpacity(0.05),
                    blurRadius: 10.0,
                    offset: const Offset(0, 5))
              ],
            ),
            padding: EdgeInsets.symmetric(
              horizontal: Device.screenType == ScreenType.mobile ? 0.w : 1.2.w,
            ),
            margin: EdgeInsets.symmetric(
                horizontal:
                    Device.screenType == ScreenType.mobile ? 3.8.w : 4.0.w,
                vertical:
                    Device.screenType == ScreenType.mobile ? 0.8.h : 1.5.h),
            child: TextFormField(
              controller: controller,
              cursorColor: primaryColor,
              textInputAction: TextInputAction.search,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.start,
              onEditingComplete: () {
                // if (tag == SavedScreenText.title) {
                //   Get.find<SavedScreenController>()
                //       .setSearchQuery(controller.text.toString());
                //   Get.find<SavedScreenController>().hideKeyboard(context);
                // }
              },
              onChanged: (val) {
                // if (tag == PartyScreenConstant.title) {
                //   Get.find<PartyScreenController>()
                //       .filterPartyList(controller.text.toString());
                // }
              },
              style: styleTextFormFieldText(isWhite: true),
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                fillColor: white.withOpacity(0.1),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDarkMode() ? black : black,
                  size: Device.screenType == ScreenType.mobile ? 20 : 25,
                ),
                labelStyle: styleTextForFieldHint(),
                suffixIcon: GestureDetector(
                  onTap: () {
                    onClearClick!();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 1.w),
                    child: Icon(
                      Icons.cancel,
                      color: isDarkMode() ? black : black,
                      size: Device.screenType == ScreenType.mobile ? 20 : 25,
                    ),
                  ),
                ),
                contentPadding: EdgeInsets.only(
                    top: Device.screenType == ScreenType.mobile ? 0.7.h : 0.8.h,
                    bottom:
                        Device.screenType == ScreenType.mobile ? 0.7.h : 1.6.h),
                hintText: SearchScreenConstant.hint,
                hintStyle: styleTextForFieldHint(),
                border: InputBorder.none,
                alignLabelWithHint: true,
              ),
            ),
          ),
        ),
        if (isCancle == true)
          FadeInRight(
            child: GestureDetector(
                onTap: () {
                  onCancleClick!();
                },
                child: Container(
                    padding: EdgeInsets.only(right: 5.w),
                    child: Text(SearchScreenConstant.cancle,
                        style: TextStyle(
                            fontFamily: fontRegular,
                            color: isDarkMode() ? white : black,
                            fontSize: 12.sp)))),
          )
      ],
    ),
  );
}
