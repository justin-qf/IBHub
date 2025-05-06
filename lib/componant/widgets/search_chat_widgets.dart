import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ibh/componant/input/style.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/categoryBusinessController.dart';
import 'package:ibh/controller/category_controller.dart';
import 'package:ibh/controller/searchController.dart';
import 'package:ibh/utils/helper.dart';
import 'package:ibh/utils/log.dart';
import 'package:sizer/sizer.dart' as sizer;
import 'package:sizer/sizer.dart';

setSearchBar(context, controller, String tag,
    {Function? onCancleClick, Function? onClearClick, bool? isCancle}) {
  return Row(
    children: [
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode() ? tileColour : white,
            borderRadius: BorderRadius.circular(
                Device.screenType == sizer.ScreenType.mobile ? 5.h : 6.h),
            boxShadow: [
              BoxShadow(
                  color: black.withOpacity(0.05),
                  blurRadius: 10.0,
                  offset: const Offset(0, 5))
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal:
                Device.screenType == sizer.ScreenType.mobile ? 0.w : 1.2.w,
          ),
          margin: EdgeInsets.symmetric(
              horizontal:
                  Device.screenType == sizer.ScreenType.mobile ? 3.8.w : 4.0.w,
              vertical:
                  Device.screenType == sizer.ScreenType.mobile ? 0.8.h : 1.5.h),
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
                size: Device.screenType == sizer.ScreenType.mobile ? 20 : 25,
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
                    size:
                        Device.screenType == sizer.ScreenType.mobile ? 20 : 25,
                  ),
                ),
              ),
              contentPadding: EdgeInsets.only(
                  top: Device.screenType == sizer.ScreenType.mobile
                      ? 0.7.h
                      : 0.8.h,
                  bottom: Device.screenType == sizer.ScreenType.mobile
                      ? 0.7.h
                      : 1.6.h),
              hintText: SearchScreenConstant.hint,
              hintStyle: styleTextForFieldHint(),
              border: InputBorder.none,
              alignLabelWithHint: true,
            ),
          ),
        ),
      ),
      if (isCancle == true)
        GestureDetector(
            onTap: () {
              onCancleClick!();
            },
            child: Container(
                padding: EdgeInsets.only(right: 5.w),
                child: Text(SearchScreenConstant.cancel,
                    style: TextStyle(
                        fontFamily: fontRegular,
                        color: isDarkMode() ? white : black,
                        fontSize: 12.sp))))
    ],
  );
}

setSearchBars(context, controller, String tag,
    {Function? onCancleClick,
    Function? onClearClick,
    Function? onFilterClick,
    bool? isCancle,
    String? categoryId = '',
    bool? isFilterApplied,
    bool? isFromCategoryList = false}) {
  return Row(
    children: [
      Expanded(
        child: Container(
            decoration: BoxDecoration(
              color: isDarkMode() ? tileColour : white,
              borderRadius: BorderRadius.circular(
                  Device.screenType == sizer.ScreenType.mobile ? 5.h : 6.h),
              boxShadow: [
                BoxShadow(
                    color: black.withOpacity(0.05),
                    blurRadius: 10.0,
                    offset: const Offset(0, 5))
              ],
            ),
            padding: EdgeInsets.symmetric(
              horizontal:
                  Device.screenType == sizer.ScreenType.mobile ? 0.w : 1.2.w,
            ),
            margin: EdgeInsets.symmetric(
                horizontal: Device.screenType == sizer.ScreenType.mobile
                    ? 3.8.w
                    : 4.0.w,
                vertical: Device.screenType == sizer.ScreenType.mobile
                    ? isFromCategoryList == true
                        ? 0.0.h
                        : 0.8.h
                    : 1.5.h),
            child: Row(children: [
              Expanded(
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (context, value, child) {
                    return TextFormField(
                      controller: controller,
                      cursorColor: primaryColor,
                      textInputAction: TextInputAction.search,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.start,
                      onEditingComplete: () {
                        if (tag == BusinessCategoryConstant.title) {
                          futureDelay(() {
                            Get.find<CategoryBusinessController>()
                                .getBusinessList(context, 1, false,
                                    keyword: controller.text.toString(),
                                    categoryId: categoryId,
                                    isFirstTime: true);
                          }, milliseconds: true);
                          // futureDelay(() {
                          //   controller.getBusinessList(context, 1, false,
                          //       isFirstTime: true,
                          //       categoryId: widget.item.id.toString());
                          // }, isOneSecond: true);
                          Get.find<CategoryBusinessController>()
                              .hideKeyboard(context);
                        } else if (tag == CategoryScreenViewConst.title) {
                          futureDelay(() {
                            Get.find<CategoryController>().getCategoryList(
                                context, 1, false,
                                search: controller.text.toString(),
                                isFirstTime: true);
                          }, milliseconds: true);
                          hideKeyboard(context);
                        } else {
                          futureDelay(() {
                            Get.find<SearchScreenController>().getBusinessList(
                                context, 1, false,
                                keyword: controller.text.toString(),
                                isFirstTime: true);
                          }, milliseconds: true);
                          Get.find<SearchScreenController>()
                              .hideKeyboard(context);
                        }
                      },
                      onChanged: (val) {
                        logcat("Val", val.toString());
                        // No need to call setState() anymore
                      },
                      style: styleTextFormFieldText(isWhite: true),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        fillColor: white.withOpacity(0.1),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SvgPicture.asset(
                            Asset.search2,
                            // colorFilter: ColorFilter.mode(
                            //   controller.currentPage == 1 ? white : primaryColor,
                            //   BlendMode.srcIn,
                            // ),
                          ),
                        ),
                        //  Icon(
                        //   Icons.searc,
                        //   color: isDarkMode() ? black : black,
                        //   size: Device.screenType == sizer.ScreenType.mobile
                        //       ? 20
                        //       : 25,
                        // ),
                        labelStyle: styleTextForFieldHint(),
                        suffixIcon: value.text.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  onClearClick!();
                                },
                                child: Icon(
                                  Icons.cancel,
                                  color: isDarkMode() ? black : black,
                                  size: Device.screenType ==
                                          sizer.ScreenType.mobile
                                      ? 20
                                      : 25,
                                ),
                              )
                            : null,
                        contentPadding: EdgeInsets.only(
                            top: Device.screenType == sizer.ScreenType.mobile
                                ? 0.7.h
                                : 0.8.h,
                            bottom: Device.screenType == sizer.ScreenType.mobile
                                ? 0.7.h
                                : 1.6.h),
                        hintText: SearchScreenConstant.hint,
                        hintStyle: styleTextForFieldHint(),
                        border: InputBorder.none,
                        alignLabelWithHint: true,
                      ),
                    );
                  },
                ),
              ),
              if (isFromCategoryList == false)
                Container(
                    height: 3.5.h,
                    width: 1,
                    color: primaryColor,
                    margin: EdgeInsets.symmetric(horizontal: 2.w)),
              if (isFromCategoryList == false)
                Container(
                  margin: EdgeInsets.only(right: 3.w),
                  child: GestureDetector(
                      onTap: () {
                        if (onFilterClick != null) {
                          onFilterClick();
                        }
                      },
                      child: Icon(Icons.filter_list,
                          color: isFilterApplied == true
                              ? secondaryColor
                              : isDarkMode()
                                  ? black
                                  : black,
                          size: Device.screenType == sizer.ScreenType.mobile
                              ? 24
                              : 25)),
                ),
            ])),
      ),
      if (isCancle == true)
        GestureDetector(
            onTap: () {
              onCancleClick!();
            },
            child: Container(
                padding: EdgeInsets.only(right: 5.w),
                child: Text(SearchScreenConstant.cancel,
                    style: TextStyle(
                        fontFamily: fontRegular,
                        color: isDarkMode() ? white : black,
                        fontSize: 12.sp))))
    ],
  );
}
