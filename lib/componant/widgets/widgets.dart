import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ibh/componant/input/form_inputs.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/utils/helper.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../configs/colors_constant.dart';
import '../../configs/font_constant.dart';

// getleftsidebackbtn({required backFunction, required title}) {
//   return Row(
//     children: [
//       GestureDetector(
//           onTap: () {
//             backFunction();
//           },
//           child: SvgPicture.asset(Asset.arrowBack,

//               // ignore: deprecated_member_use
//               color: black,
//               height: 4.h)),
//       getDynamicSizedBox(width: 1.w),
//       Text(
//         title,
//         style: TextStyle(fontFamily: dM_sans_bold, fontSize: 18.sp),
//       )
//     ],
//   );
// }

Future<bool?> getpopup(BuildContext context,
    {istimerrunout = false,
    title,
    message,
    function,
    isFromProfile = true}) async {
  return showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(
          title ?? '',
          style: TextStyle(fontFamily: dM_sans_extraBold, fontSize: 18.sp),
        ),
        content: Text(message,
            style: TextStyle(fontFamily: dM_sans_medium, fontSize: 16.sp)),
        actions: [
          if (istimerrunout == false)
            CupertinoDialogAction(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      color: primaryColor,
                      fontFamily: dM_sans_extraBold,
                      fontSize: 18.sp),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                }),
          CupertinoDialogAction(
              child: Text(
                isFromProfile == true ? 'Confirm' : 'Add',
                style: TextStyle(
                    color: primaryColor,
                    fontFamily: dM_sans_extraBold,
                    fontSize: 18.sp),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
                function();
              })
        ],
      );
    },
  );
}

Future openDialogBox(context, {title, desc, function}) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      title: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Text(
              title,
              style: const TextStyle(fontFamily: dM_sans_medium),
            ),
          ),
          Positioned(
            top: -22,
            right: -22,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                size: 20.sp,
                color: grey,
              ),
            ),
          ),
        ],
      ),
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        height: 15.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getDynamicSizedBox(height: 0.2.h),
            Text(
              desc,
              style: TextStyle(fontSize: 16.5.sp, fontFamily: dM_sans_regular),
              textAlign: TextAlign.center, // Centering text
            ),
            getDynamicSizedBox(height: 4.h),
            Container(
              height: 0.2.h,
              width: double.infinity, // Ensuring full width
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center buttons horizontally
              children: [
                CupertinoButton(
                  color: CupertinoColors.white,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  borderRadius: BorderRadius.circular(10),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(Popupconst.cancel,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: black,
                          fontSize: 21.sp,
                          fontFamily: dM_sans_bold)),
                ),
                Container(
                  width: 0.2.w,
                  height: 7.5.h,
                  color: grey,
                ),
                // Added spacing between buttons
                CupertinoButton(
                  color: CupertinoColors.white,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  borderRadius: BorderRadius.circular(10),
                  onPressed: () {
                    function();
                  },
                  child: Text(
                    Popupconst.confirm,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: green,
                        fontSize: 21.sp,
                        fontFamily: dM_sans_bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

getProfileTabbar(
    {isanalysisScreen = false, required controller, required tabs}) {
  return Container(
    height: 6.h,
    margin: EdgeInsets.symmetric(horizontal: 1.w),
    decoration: const BoxDecoration(color: transparent),
    child: Container(
      height: 7.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: black),
      ),
      child: SizedBox(
        height: 7.h,
        child: TabBar(
          tabAlignment: isanalysisScreen ? TabAlignment.start : null,
          indicatorPadding: EdgeInsets.zero,
          isScrollable: isanalysisScreen ? true : false,
          padding: EdgeInsets.all(0),
          dividerColor: transparent,
          controller: controller,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: primaryColor,
          ),
          unselectedLabelColor: black,
          labelColor: white,
          labelStyle: TextStyle(fontSize: 17.sp, fontFamily: dM_sans_bold),
          splashFactory: NoSplash.splashFactory,

          // overlayColor: WidgetStatePropertyAll(transparent),
          labelPadding: EdgeInsets.symmetric(horizontal: 3.w),
          tabs: tabs,
          // tabtitles.map((title) => Tab(text: title)).toList(),
        ),
      ),
    ),
  );
}

PreferredSizeWidget getTabbar(
    {isanalysisScreen = false, required controller, required tabs}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(7.h),
    child: ClipRRect(
      child: Container(
        height: 6.h,
        margin: EdgeInsets.symmetric(horizontal: 1.w),
        decoration: const BoxDecoration(color: transparent),
        child: Stack(
          children: [
            Container(
              height: 7.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: black),
              ),
            ),
            Positioned(
              top: 0.h,
              bottom: 0.h,
              right: 0.w,
              left: 0.w,
              child: SizedBox(
                height: 7.h,
                child: TabBar(
                  tabAlignment: isanalysisScreen ? TabAlignment.start : null,
                  indicatorPadding: EdgeInsets.zero,
                  isScrollable: isanalysisScreen ? true : false,
                  padding: EdgeInsets.all(0),
                  dividerColor: transparent,
                  controller: controller,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: tabBarColor,
                  ),
                  unselectedLabelColor: black,
                  labelColor: primaryColor,
                  labelStyle:
                      TextStyle(fontSize: 17.sp, fontFamily: dM_sans_bold),
                  splashFactory: NoSplash.splashFactory,

                  // overlayColor: WidgetStatePropertyAll(transparent),
                  labelPadding: EdgeInsets.symmetric(horizontal: 3.w),
                  tabs: tabs,
                  // tabtitles.map((title) => Tab(text: title)).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

getSeeAll({title, onCLick}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 3.w),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title,
            style: TextStyle(
              color: isDarkMode() ? white : black,
              fontFamily: fontBold,
              fontWeight: FontWeight.w800,
              fontSize: Device.screenType == ScreenType.mobile ? 18.sp : 13.sp,
            )),
        const Spacer(),
        GestureDetector(
          onTap: () {
            onCLick();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DashboardText.seeAll,
                  style: TextStyle(
                    color: isDarkMode() ? white : primaryColor,
                    fontFamily: dM_sans_medium,
                    fontWeight: FontWeight.w500,
                    fontSize:
                        Device.screenType == ScreenType.mobile ? 16.sp : 14.sp,
                  )),
              getDynamicSizedBox(width: 1.w),
              Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: primaryColor),
                  child: Padding(
                      padding: EdgeInsets.all(2),
                      child: Icon(Icons.arrow_forward, color: white, size: 2.h)

                      // SvgPicture.asset(
                      //   Asset.arrowBack,
                      //   colorFilter: ColorFilter.mode(white, BlendMode.srcIn),
                      //   fit: BoxFit.contain,
                      // ),
                      )),
            ],
          ),
        )
      ],
    ),
  );
}

Widget getHomeLable(String title, Function onCLick,
    {bool? isShowSeeMore = true, bool? isFromDetailScreen = false}) {
  return Container(
    margin: EdgeInsets.only(
        left: isFromDetailScreen == true ? 0.0 : 5.w,
        right: isFromDetailScreen == true ? 0.0 : 2.w),
    width: double.infinity,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title,
            style: TextStyle(
              color: isDarkMode() ? white : black,
              fontFamily: fontBold,
              fontWeight: FontWeight.w800,
              fontSize: Device.screenType == ScreenType.mobile ? 18.sp : 13.sp,
            )),
        const Spacer(),
        isShowSeeMore == true
            ? GestureDetector(
                onTap: () {
                  onCLick();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DashboardText.seeAll,
                        style: TextStyle(
                          color: isDarkMode() ? white : primaryColor,
                          fontFamily: dM_sans_medium,
                          fontWeight: FontWeight.w500,
                          fontSize: Device.screenType == ScreenType.mobile
                              ? 16.sp
                              : 14.sp,
                        )),
                    getDynamicSizedBox(width: 1.w),
                    Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: primaryColor),
                        child: Padding(
                            padding: EdgeInsets.all(2),
                            child: Icon(Icons.arrow_forward,
                                color: white, size: 2.h)

                            // SvgPicture.asset(
                            //   Asset.arrowBack,
                            //   colorFilter: ColorFilter.mode(white, BlendMode.srcIn),
                            //   fit: BoxFit.contain,
                            // ),
                            )),
                  ],
                ),
              )
            : Container()
      ],
    ),
  );
}

Widget seeMoreText({
  required title,
  required textButton,
  required textButtonText,
}) {
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        children: [
          // getDynamicSizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontFamily: dM_sans_medium, fontSize: 18.sp),
              ),
              GestureDetector(
                onTap: textButton,
                child: Text(
                  textButtonText,
                  style: TextStyle(
                      fontFamily: dM_sans_regular,
                      fontSize: 16.sp,
                      color: black),
                ),
              ),
            ],
          ),
          getDynamicSizedBox(height: 2.h),
        ],
      ));
}

// void unfocusAll(context) {
//   FocusScope.of(context).unfocus();
// }
void unfocusAll() {
  FocusManager.instance.primaryFocus?.unfocus();
}

Widget getTextField(
    {label,
    hint,
    node,
    ctr,
    model,
    function,
    bool isNumeric = false,
    bool isReadOnly = false,
    bool wantsuffix = false,
    bool ispass = false,
    bool isenable = true,
    bool isdropdown = false,
    bool usegesture = false,
    bool isBorderSideEnable = false,
    bool isRequired = false,
    bool isMultipline = false,
    Function? gestureFunction,
    bool isobscure = false,
    Function? obscureFunction,
    bool useOnChanged = true,
    bool isVerified = false,
    bool isAdd = false,
    Function? onAddBtn,
    Function? ontap,
    context}) {
  Widget formfield = getReactiveFormField(
      isDropdown: isdropdown ? true : false,
      isEnable: isenable ? true : false,
      node: node, // Ensure correct FocusNode
      controller: ctr, // Ensure correct Controller
      hintLabel: hint,
      onAddBtn: onAddBtn,
      onChanged: useOnChanged
          ? (val) {
              function(val);
            }
          : (val) {},
      errorText: model.error, // Corrected error binding
      isAdd: isAdd ? true : false,
      isAddress: isMultipline,
      inputType: isMultipline
          ? TextInputType.multiline
          : isNumeric
              ? TextInputType.number
              : TextInputType.text,
      inputFormatters: isNumeric
          ? [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10)
            ]
          : [],
      wantSuffix: wantsuffix ? true : false,
      isPass: ispass ? true : false,
      isWhite: true,
      isBorderSideEnable: isBorderSideEnable ? true : false,
      obscuretext: isobscure ? true : false,
      obscureTextFunction: obscureFunction,
      onTap: ontap,
      isVerified: isVerified);

  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      getLable(label, isRequired: isRequired, isVerified: isVerified),
      usegesture
          ? GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();

                if (gestureFunction != null) {
                  gestureFunction();
                }
              },
              child: formfield,
            )
          : formfield
    ],
  );
}

Widget getUpperContainer({
  isbackbtnshow = true,
  backbtnFunction,
  firstpurpleText,
  secondwhiteText,
  firstDescText,
  isSecondDescNeeded = false,
  secondDescText,
  issmallDesc = false,
  isEditScreen = false,
}) {
  return Container(
    padding: EdgeInsets.only(right: 3.w, left: 3.w, bottom: 5.h, top: 1.h),
    decoration: const BoxDecoration(
      color: secondaryColor,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(35),
        bottomRight: Radius.circular(35),
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SafeArea(
          child: SizedBox(
            height: 5.h,
            child: getAppbar(
                isBackPressShow: isbackbtnshow, onBackPress: backbtnFunction),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 5.w, right: 5.w),
          child: Column(
            children: [
              getDynamicSizedBox(height: 1.h),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: firstpurpleText,
                      style: TextStyle(
                          fontFamily: dM_sans_semiBold,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: black),
                    ),
                    TextSpan(
                      text: secondwhiteText,
                      style: TextStyle(
                          fontFamily: dM_sans_semiBold,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: black),
                    ),
                  ],
                ),
              ),
              getDynamicSizedBox(height: 1.h),
              isEditScreen
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Text(
                        firstDescText,
                        textAlign: TextAlign
                            .center, // Ensures multi-line text stays left-aligned
                        style: TextStyle(
                            fontFamily: dM_sans_regular,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: black),
                      ),
                    )
                  : Text(
                      firstDescText,
                      textAlign: TextAlign
                          .center, // Ensures multi-line text stays left-aligned
                      style: TextStyle(
                          fontFamily: dM_sans_regular,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: black),
                    ),

              issmallDesc
                  ? getDynamicSizedBox(height: 2.2.h)
                  : getDynamicSizedBox(height: 0.2.h),
              if (isSecondDescNeeded)
                Text(
                  // ignore: prefer_interpolation_to_compose_strings
                  '+91 ' + secondDescText,
                  textAlign: TextAlign
                      .center, // Ensures multi-line text stays left-aligned
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: black,
                  ),
                ),
              // if (isbackbtnshow == false) getDynamicSizedBox(height: 2.5.h)
            ],
          ),
        ),
      ],
    ),
  );
}

void showCustomToast(BuildContext context, String message) {
  OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 10.h,
      width: Device.width,
      child: Material(
        color: transparent,
        child: Container(
          margin: EdgeInsets.only(left: 10.w, right: 10.w),
          padding:
              EdgeInsets.only(top: 1.5.h, bottom: 1.5.h, left: 5.w, right: 5.w),
          decoration: BoxDecoration(
            color: isDarkMode() ? darkBackgroundColor : primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: isDarkMode() ? white : white,
                fontSize:
                    Device.screenType == ScreenType.mobile ? 16.sp : 14.sp),
          ),
        ),
      ),
    ),
  );

  Overlay.of(context).insert(overlayEntry);
  Future.delayed(const Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}

Widget getRadio(String title, String groupValue, Function onChange) {
  return RadioListTile(
    activeColor: primaryColor,
    contentPadding: EdgeInsets.only(
        left: Device.screenType == ScreenType.mobile ? 5.5.w : 15.w),
    visualDensity: const VisualDensity(horizontal: -4),
    title: Text(
      title,
      style: TextStyle(
          fontSize: Device.screenType == ScreenType.mobile ? 12.sp : 10.sp),
    ),
    value: title,
    groupValue: groupValue,
    onChanged: (value) {
      onChange(value);
    },
  );
}

// Widget getFooter(isLogin) {
//   return RichText(
//     overflow: TextOverflow.clip,
//     textAlign: TextAlign.start,
//     softWrap: true,
//     text: TextSpan(
//       text: isLogin == true
//           ? LoginConst.dontHaveAccount
//           : SignupConstant.haveAnAccount,
//       style: TextStyle(
//           color: isDarkMode() ? grey : lableColor,
//           fontWeight: FontWeight.w500,
//           fontSize: 11.sp),
//       children: [
//         TextSpan(
//           text: isLogin == true
//               ? " ${LoginConst.signup}"
//               : " ${LoginConst.title}",
//           style: TextStyle(
//               fontFamily: fontBold,
//               color: isDarkMode() ? white : primaryColor,
//               fontSize: 13.sp,
//               fontWeight: FontWeight.w800),
//         )
//       ],
//     ),
//     textScaler: const TextScaler.linear(1),
//   );
// }

Widget getRichText(title, desc) {
  return RichText(
      overflow: TextOverflow.clip,
      textAlign: TextAlign.start,
      softWrap: true,
      maxLines: 16,
      text: TextSpan(
        text: title,
        style: TextStyle(
            overflow: TextOverflow.ellipsis,
            color: isDarkMode() ? black : black,
            fontFamily: fontExtraBold,
            fontSize: 11.sp),
        children: [
          TextSpan(
              text: desc,
              style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontFamily: fontRegular,
                  color: isDarkMode() ? black : black,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400))
        ],
      ),
      textScaler: const TextScaler.linear(1));
}

getLable(
  String title, {
  bool? isFromVisitReport,
  bool? isFromRetailer = false,
  bool isRequired = false,
  isVerified = false,
}) {
  return Container(
    // height: 2.h,
    margin: isFromRetailer != null && isFromRetailer == true
        ? EdgeInsets.only(left: 9.w, right: 9.w)
        : EdgeInsets.only(top: 2.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: title,
                style: TextStyle(
                  color: isVerified ? grey : black,
                  fontFamily: dM_sans_bold,
                  fontSize:
                      Device.screenType == ScreenType.mobile ? 16.sp : 8.5.sp,
                  // fontWeight: FontWeight.w700,
                ),
              ),
              if (isRequired) // Conditionally add the '*'
                const TextSpan(
                  text: SignUpConstant.required,
                  style: TextStyle(
                    color: red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
        // Text(
        //   title,
        //   textAlign: TextAlign.start,
        //   style: TextStyle(
        //       color: isDarkMode() ? white : black,
        //       fontFamily: fontRegular,
        //       fontSize: Device.screenType == ScreenType.mobile ? 16.sp : 8.5.sp,
        //       fontWeight: FontWeight.w700),
        // ),
        if (isFromVisitReport == null)
          SizedBox(
              height: Device.screenType == ScreenType.mobile ? 0.5.h : 0.2.h),
      ],
    ),
  );
}

Widget getLogo(islogo) {
  return Container(
    margin: EdgeInsets.only(left: 3.w),
    child: GestureDetector(
        onTap: () {
          islogo();
        },
        child: Container(
            padding: EdgeInsets.only(left: 1.w, right: 1.w),
            margin: EdgeInsets.only(right: 5.w, left: 4.w),
            height: 3.5.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Image(image: AssetImage(Asset.logoIcon)))),
  );
}

Widget noDataFoundWidget({bool? isFromBlog}) {
  return SizedBox(
    height: Device.height / 1.5,
    child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Text(Common.datanotfound,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: fontMedium,
                  fontSize: 16.sp,
                  color: isDarkMode() ? white : black)),
        ])),
  );
}

Widget getDivider() {
  return Divider(height: 0.1.h, color: grey);
}

Widget headerDivider() {
  return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)), color: grey),
      height: 5.h,
      width: 0.1.w);
}

getBgDividerWeb(Color? selectedColor, {size}) {
  return Container(
    width: size,
    height: 0.3.h,
    decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: selectedColor),
  );
}

Widget getFooterLogoWeb() {
  return SvgPicture.asset(Asset.logo, width: 120);
}

getEmptyUi({isservice = false}) {
  return SizedBox(
    height: Device.height / 1.4,
    child: Center(
      child: Text(
        isservice ? 'Service Not Found' : Common.datanotfound,
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: dM_sans_medium, fontSize: 16.sp),
      ),
    ),
  );
}

void showUpdatePopup(BuildContext context, String appUrl, String description,
    bool isForcefully) {
  Future.delayed(const Duration(seconds: 0), () {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(2.0.w), // Responsive border radius
          ),
          child: Container(
            padding: EdgeInsets.all(4.0.w), // Responsive padding
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2.0.w),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isForcefully == false)
                  Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                              padding: const EdgeInsets.all(5),
                              child: Icon(Icons.cancel,
                                  size: Device.screenType == ScreenType.mobile
                                      ? 4.h
                                      : 5.h,
                                  color: isDarkMode() ? white : black)))),
                // Placeholder for the celebratory character image
                Image.asset(Asset.applogo, height: 6.0.h),
                SizedBox(height: 4.0.h), // Responsive spacing
                Text(
                  'New Update is Here!',
                  style: TextStyle(
                    fontFamily: dM_sans_medium,
                    fontSize: 18.0.sp, // Responsive font size
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 1.5.h), // Responsive spacing
                // Generic description
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: dM_sans_medium,
                    fontSize: 14.0.sp, // Responsive font size
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 2.0.h), // Responsive spacing
                // Update App button
                ElevatedButton(
                  onPressed: () async {
                    if (await canLaunchUrl(Uri.parse(appUrl))) {
                      await launchUrl(Uri.parse(appUrl),
                          mode: LaunchMode.externalApplication);
                    } else {
                      throw 'Could not launch $appUrl';
                    }
                    // Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1.5.w),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0.w,
                      vertical: 1.5.h,
                    ),
                  ),
                  child: Text(
                    'Install & Explore',
                    style: TextStyle(
                      fontFamily: dM_sans_medium,
                      fontSize: 16.0.sp, // Responsive font size
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  });
}

showLoader() {
  return SizedBox(
      height: Device.height / 1.5,
      child: Center(
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
      ));
}

getFloatingActionButton({Function? onClick}) {
  return FloatingActionButton(
      backgroundColor: isDarkMode() ? white : primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      onPressed: () {
        onClick!();
      },
      child: Icon(
        Icons.add,
        color: isDarkMode() ? black : white,
        size: Device.screenType == ScreenType.mobile ? null : 3.h,
      ));
}

getEmptyListUi() {
  return SizedBox(
    height: Device.height / 1.5,
    child: Center(
      child: Text(Common.datanotfound,
          style: TextStyle(
              fontFamily: fontMedium,
              fontSize: 12.sp,
              color: isDarkMode() ? white : black)),
    ),
  );
}

Widget getMaterialContainer(bool isLeft, final index,
    {String title = "",
    String count = "",
    String icon = "",
    Color? color,
    bool? isFromOrdersCount,
    Gradient? gradient,
    Function? onTap,
    bool? isParty}) {
  return Container(
    margin: isLeft
        ? EdgeInsets.only(left: 7.w, right: 3.w)
        : EdgeInsets.only(
            right: 7.w, left: index == 1 && isParty == true ? 7.w : 3.w),
    child: Material(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(index == 2 || index == 1 ? 0.0 : 2.8.h),
        bottomLeft: Radius.circular(index == 2 || index == 1 ? 0.0 : 2.8.h),
        bottomRight: Radius.circular(index == 2 || index == 1 ? 2.8.h : 0.0),
        topLeft: Radius.circular(index == 3
            ? 0.0
            : index == 2
                ? 2.8.h
                : index == 1
                    ? 2.8.h
                    : 0.0),
      ),
      color: color,
      elevation: 5.0,
      child: InkWell(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(2.8.h),
            bottomLeft: Radius.circular(2.8.h)),
        onTap: () {
          onTap!();
        },
        splashColor: primaryColor.withOpacity(0.2),
        highlightColor: grey.withOpacity(0.1),
        child: Container(
            padding: EdgeInsets.only(
                left: 2.h,
                right: 2.h,
                top: 3.h,
                bottom: isFromOrdersCount == true ? 0.6.h : 3.h),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon.isNotEmpty
                      ? SvgPicture.asset(
                          icon,
                          height: 4.5.h,
                          width: 4.5.h,
                          // ignore: deprecated_member_use
                          color: black,
                        )
                      : Icon(Icons.receipt_long_rounded,
                          color: tileColour, size: 2.5.h),
                  getDynamicSizedBox(height: 2.h),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13.sp,
                        color: black),
                  ),
                  if (isFromOrdersCount == true)
                    Text(count,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.sp,
                            color: black))
                ])),
      ),
    ),
  );
}

// getRow(String title, String data,
//     {isFromProfile, isContact, String? orserStatus, bool? isFromOrder}) {
//   return Row(
//     mainAxisSize: MainAxisSize.min,
//     crossAxisAlignment: CrossAxisAlignment.start,
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       Text(
//         title,
//         style: TextStyle(
//             fontSize: Device.screenType == ScreenType.mobile
//                 ? isFromProfile == true
//                     ? 12.sp
//                     : 11.sp
//                 : 10.sp,
//             fontFamily: fontExtraBold,
//             color: isDarkMode() ? white : black),
//       ),
//       getDynamicSizedBox(width: 1.w),
//       isContact != null && isContact == true
//           ? GestureDetector(
//               onTap: () {
//                 launchPhoneCall(data);
//               },
//               child: getSubText(data,
//                   isContact: isContact,
//                   isFromProfile: isFromProfile,
//                   orserStatus: orserStatus))
//           : Expanded(
//               child: getSubText(data,
//                   isFromProfile: isFromProfile,
//                   orserStatus: orserStatus,
//                   isFromOrder: isFromOrder))
//     ],
//   );
// }

getSubText(String data,
    {isFromProfile, isContact, String? orserStatus, bool? isFromOrder}) {
  return Container(
    margin: EdgeInsets.only(top: isFromProfile == true ? 0.1.h : 0.2.h),
    child: Text(
      data,
      maxLines: isFromOrder == true ? 2 : 4,
      style: TextStyle(
          overflow: TextOverflow.ellipsis,
          fontSize: Device.screenType == ScreenType.mobile
              ? isFromProfile == true
                  ? 11.sp
                  : 10.sp
              : 8.sp,
          decorationColor: black,
          fontFamily: fontExtraBold,
          color: isContact == true
              ? Colors.blue
              : orserStatus != null && orserStatus.toString().isNotEmpty
                  ? orserStatus.toString() == "1"
                      ? red
                      : orserStatus.toString() == "2"
                          ? green
                          : orserStatus.toString() == "3"
                              ? red
                              : orserStatus.toString() == "4"
                                  ? dispatch
                                  : delivered
                  : black),
    ),
  );
}

getImageView(String url) {
  return SizedBox(
      height: Device.screenType == ScreenType.mobile ? 15.h : 18.h,
      width: 70.w,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: url,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(color: primaryColor),
            ),
            errorWidget: (context, url, error) => Image.asset(
              Asset.placeholder,
              height: 11.h,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ));
}

getPartyDetailRow(context, String title, String data, {bool? isAddress}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 0.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: Device.screenType == ScreenType.mobile ? 16.sp : 6.sp,
            fontWeight: FontWeight.w800,
            fontFamily: fontExtraBold,
            color: isDarkMode() ? white : black,
          ),
        ),
        // getDynamicSizedBox(height: 0.5.h),
        isAddress == true
            ? Text(
                data,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize:
                      Device.screenType == ScreenType.mobile ? 16.sp : 10.sp,
                  color: isDarkMode() ? white : black,
                  fontFamily: fontRegular,
                ),
              )
            :
            // SizedBox(
            //     width: double.infinity,
            //     height: Device.screenType == ScreenType.mobile
            //         ? isSmallDevice(context)
            //             ? 10.h
            //             : 16.h
            //         : 5.h,
            //     child: Scrollbar(
            //       thumbVisibility: true,
            //       thickness: 1.5,
            //       radius: const Radius.circular(50),
            //       child: SingleChildScrollView(
            //         physics: const BouncingScrollPhysics(),
            //         child: Text(
            //           data,
            //           textAlign: TextAlign.start,
            //           style: TextStyle(
            //             fontSize: Device.screenType == ScreenType.mobile
            //                 ? 16.sp
            //                 : 10.sp,
            //             color: isDarkMode() ? white : black,
            //             fontFamily: fontRegular,
            //           ),
            //         ),
            //       ),
            //     ),
            //   )
            Text(
                data,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize:
                      Device.screenType == ScreenType.mobile ? 16.sp : 12.sp,
                  color: isDarkMode() ? white : black,
                  fontFamily: fontRegular,
                ),
              ),
      ],
    ),
  );
}

// getPartyDetailRow(title, data, {bool? isAddress}) {
//   return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(title,
//             style: TextStyle(
//                 fontSize: Device.screenType == ScreenType.mobile ? 16.sp : 6.sp,
//                 fontWeight: FontWeight.w800,
//                 fontFamily: fontExtraBold,
//                 color: isDarkMode() ? white : black)),
//         getDynamicSizedBox(width: 1.w),
//         isAddress == true
//             ? Expanded(
//                 child: SizedBox(
//                   width: Device.screenType == ScreenType.mobile ? 25.w : 10.w,
//                   height: Device.screenType == ScreenType.mobile ? 18.h : 10.h,
//                   child: Scrollbar(
//                     thumbVisibility: true,
//                     thickness: 1.5,
//                     radius: const Radius.circular(50),
//                     child: SingleChildScrollView(
//                       physics: const BouncingScrollPhysics(),
//                       scrollDirection: Axis.vertical,
//                       child: Text(
//                         data,
//                         textAlign: TextAlign.start,
//                         // maxLines: 2,
//                         style: TextStyle(
//                             fontSize: Device.screenType == ScreenType.mobile
//                                 ? 16.sp
//                                 : 10.sp,
//                             color: isDarkMode() ? white : black,
//                             fontFamily: fontRegular),
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             : Expanded(
//                 child: Text(
//                   data,
//                   maxLines: 3,
//                   overflow: TextOverflow.ellipsis,
//                   textAlign: TextAlign.start,
//                   style: TextStyle(
//                       fontSize: Device.screenType == ScreenType.mobile
//                           ? 16.sp
//                           : 12.sp,
//                       color: isDarkMode() ? white : black,
//                       fontFamily: fontRegular),
//                 ),
//               ),
//       ]);
// }

getItemImageView(String url, isFromProductScreen) {
  return Container(
    padding: const EdgeInsets.all(0.5),
    decoration: BoxDecoration(
      border: Border.all(
        color: grey,
        width: isDarkMode() ? 0.2 : 0.6,
      ),
      color: isDarkMode() ? itemDarkBackgroundColor : white,
      borderRadius: BorderRadius.circular(
          Device.screenType == ScreenType.mobile ? 3.5.w : 2.5.w),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(
          Device.screenType == ScreenType.mobile ? 3.5.w : 2.5.w),
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        height: isFromProductScreen == true ? 8.h : 10.h,
        width: isFromProductScreen == true ? 8.h : 10.h,
        imageUrl: url,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(color: primaryColor),
        ),
        errorWidget: (context, url, error) => Image.asset(
          Asset.placeholder,
          height: 10.h,
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}

getExtendedAppBar(context, title, isFromProfile,
    {salesPersonName, gender, profilePic}) {
  return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 35.h,
        padding: EdgeInsets.symmetric(
            horizontal: 1.h,
            vertical: Device.screenType == ScreenType.mobile ? 2.h : 2.5.h),
        decoration: BoxDecoration(
            image: const DecorationImage(
                image: AssetImage(Asset.appBarBg),
                fit: BoxFit.cover,
                alignment: Alignment.center),
            color: isDarkMode()
                ? darkBackgroundColor
                : primaryColor.withOpacity(0.8),
            // border: Border(
            //   bottom: BorderSide(
            //     color: grey.withOpacity(0.6),
            //   ),
            // ),
            boxShadow: [
              BoxShadow(
                  color: grey.withOpacity(0.2),
                  blurRadius: 1.0,
                  offset: const Offset(0, 1),
                  //offset: const Offset(0, 1),
                  spreadRadius: 1.0)
            ],
            // gradient: LinearGradient(
            //     colors: [
            //       primaryColor,
            //       secondaryColor.withOpacity(0.7)
            //     ],
            //     begin: const FractionalOffset(0.0, 0.0),
            //     // end: FractionalOffset(0.8, 0.0),
            //     end: const FractionalOffset(0.0, 1.0),
            //     stops: const [0.0, 1.0],
            //     tileMode: TileMode.clamp),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.h))),
        child: Column(
          children: [
            getDynamicSizedBox(height: isFromProfile == true ? 2.h : 2.5.h),
            isFromProfile == true
                ? getCommonToolbar(title,
                    onClick: () {},
                    isLogo: true,
                    showBackButton: false,
                    isWhiteText: false)
                : getLogoAppBar(),
            getDynamicSizedBox(height: isFromProfile == true ? 5.5.h : 8.h),
            if (isFromProfile != true)
              Column(
                children: [
                  Text(
                    'Welcome',
                    style: TextStyle(
                        color: isDarkMode() ? white : black,
                        fontFamily: fontBold,
                        fontSize: Device.screenType == ScreenType.mobile
                            ? 18.sp
                            : 12.sp,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    salesPersonName,
                    style: TextStyle(
                        color: isDarkMode() ? white : black,
                        fontFamily: fontBold,
                        fontSize: Device.screenType == ScreenType.mobile
                            ? 18.sp
                            : 12.sp,
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),
            if (isFromProfile == true)
              Column(
                children: [
                  Center(
                      child: Container(
                    height: 10.h,
                    width: 10.h,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: black, width: 0.5.w),
                      borderRadius: BorderRadius.circular(100.w),
                      boxShadow: [
                        BoxShadow(
                          color: black.withOpacity(0.1),
                          blurRadius: 5.0,
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      child: profilePic != null &&
                              profilePic.toString().isNotEmpty
                          ? CachedNetworkImage(
                              fit: BoxFit.cover,
                              height: 15.h,
                              width: 40.w,
                              imageUrl: profilePic.toString(),
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                    color: primaryColor),
                              ),
                              errorWidget: (context, url, error) =>
                                  SvgPicture.asset(
                                Asset.male,
                                height: 11.h,
                                fit: BoxFit.cover,
                              ),
                              imageBuilder: (context, imageProvider) => Image(
                                image: imageProvider,
                                height: 11.h,
                                fit: BoxFit.cover,
                              ),
                            )
                          : SvgPicture.asset(
                              gender == null
                                  ? Asset.male
                                  : gender == 'Male'
                                      ? Asset.male
                                      : Asset.female,
                              height: 8.h,
                              width: 8.h,
                              // ignore: deprecated_member_use
                              fit: BoxFit.cover,
                            ),
                    ),
                  )),
                  getDynamicSizedBox(height: 1.h),
                  Text(
                    salesPersonName,
                    style: TextStyle(
                        color: isDarkMode() ? white : black,
                        fontFamily: fontBold,
                        fontSize: Device.screenType == ScreenType.mobile
                            ? 18.sp
                            : 12.sp,
                        fontWeight: FontWeight.w700),
                  )
                ],
              )
          ],
        ),
      ));
}

getFilterHeader(BuildContext context, isFromParty) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: isFromParty == true ? 9.w : 0.0),
    child: Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                AppConstant.filter,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: fontBold,
                    fontWeight: FontWeight.w700,
                    fontSize:
                        Device.screenType == ScreenType.mobile ? 20.sp : 15.sp,
                    color: isDarkMode() ? white : black),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.cancel,
                  size: Device.screenType == ScreenType.mobile ? 24.0 : 35,
                  color: isDarkMode() ? white : black,
                ),
              ),
            ]),
        const SizedBox(height: 8.0),
        Divider(height: 1.0, color: isDarkMode() ? white : black),
        const SizedBox(height: 8.0),
      ],
    ),
  );
}

Widget showSelectedTextInDialog({name, modelId, storeId}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        child: Text(
          name,
          style: TextStyle(
              fontFamily: fontRegular,
              fontSize: Device.screenType == ScreenType.mobile ? 16.sp : 14.sp,
              fontWeight: modelId == storeId ? FontWeight.w700 : null,
              color: modelId == storeId ? primaryColor : black),
        ),
      ),
      if (storeId != null && modelId == storeId)
        Container(
          width: 1.h,
          height: 1.h,
          decoration: BoxDecoration(
              color: primaryColor, borderRadius: BorderRadius.circular(50.0)),
        ),
    ],
  );
}

Widget getIntroText(firsttext, secondtext, thirdtext, desription,
    {secondColor, thirdcolor, isthirdpage}) {
  double size = 23;
  return Container(
    padding: EdgeInsets.only(left: 7.w, right: 7.w),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: firsttext,
                style: TextStyle(
                    fontSize: size.sp,
                    fontFamily: dM_sans_extraBold,
                    fontWeight: FontWeight.bold,
                    color: black),
              ),
              TextSpan(
                text: secondtext,
                style: TextStyle(
                    fontSize: size.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: dM_sans_extraBold,
                    color: secondColor),
              ),
              TextSpan(
                text: thirdtext,
                style: TextStyle(
                    fontSize: size.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: dM_sans_extraBold,
                    color: thirdcolor),
              )
            ],
          ),
        ),
        getDynamicSizedBox(height: 3.h),
        Text(desription,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: dM_sans_regular,
                fontSize: 17.sp,
                // fontWeight: FontWeight.bold,
                color: black))
      ],
    ),
  );
}
