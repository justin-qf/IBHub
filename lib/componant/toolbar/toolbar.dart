import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/utils/helper.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart' as getx;

getToolbar(
    {bool? isBackPressShow, String? title, Function? onClick, currentPage}) {
  return Stack(
    children: [
      if (isBackPressShow == true)
        Positioned(left: 0, top: 0, child: backPress(onClick)),
      if (title != null)
        Center(
            child: Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: fontBold,
                    color: isDarkMode() ? white : black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp))),
      TextButton(
          onPressed: () {},
          child: Text(currentPage < 2 ? Button.skip : Button.getStarted,
              style: TextStyle(
                  fontSize: 16.sp, color: black, fontWeight: FontWeight.bold)))
    ],
  );
}

getIntroToolbar(context,
    {iconColor, String? title, Function? onClick, currentPage}) {
  return Padding(
    padding: const EdgeInsets.only(left: 10, top: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          (Asset.logopurple),
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          height: 7.h,
          width: 7.w,
        ),
        const Spacer(),
        SizedBox(
          height: 5.h,
          child: currentPage < 2
              ? TextButton(
                  onPressed: () {
                    // Navigator.pushAndRemoveUntil(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => const SignInScreen()),
                    //   (Route<dynamic> route) =>
                    //       false, // Removes all previous routes
                    // );
                  },
                  child: Text(Button.skip,
                      style: TextStyle(
                          fontSize: 17.sp,
                          color: black,
                          fontWeight: FontWeight.bold)))
              : SizedBox.shrink(),
        )
      ],
    ),
  );
}

Widget getAppbar({
  bool? isBackPressShow,
  Function? onBackPress,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      if (isBackPressShow == true) backPress(onBackPress),
      Spacer(),
      getLogo(),
    ],
  );
}

/*Debug*/
void printing() {
  print('print');
}
/*Debug*/

// getDrawer({required isDrawerOpen, required toggleDrawer}) {
//   return AnimatedPositioned(
//     duration: Duration(milliseconds: 300),
//     left: isDrawerOpen ? 0 : -250,
//     top: 0,
//     bottom: 0,
//     child: Container(
//       width: 250,
//       color: Colors.grey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 50),
//           ListTile(
//             title: Text("Home", style: TextStyle(color: Colors.white)),
//             leading: Icon(Icons.home, color: Colors.white),
//             onTap: toggleDrawer,
//           ),
//           ListTile(
//             title: Text("Profile", style: TextStyle(color: Colors.white)),
//             leading: Icon(Icons.person, color: Colors.white),
//             onTap: toggleDrawer,
//           ),
//           ListTile(
//             title: Text("Settings", style: TextStyle(color: Colors.white)),
//             leading: Icon(Icons.settings, color: Colors.white),
//             onTap: toggleDrawer,
//           ),
//         ],
//       ),
//     ),
//   );
// }

updatedAppbar({
  leftBtn,
  leftasset,
  required title,
  rightBtn,
  rightasset,
  isdrawer = false,
}) {
  return SafeArea(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        isdrawer
            ? IconButton(
                icon: SvgPicture.asset(
                  leftasset,
                  width: 3.w,
                  height: 3.h,
                ),
                onPressed: leftBtn,
              )
            : leftBtn != null
                ? SizedBox(
                    width: 8.5.w,
                    height: 4.h,
                    child: FloatingActionButton(
                      onPressed: leftBtn,
                      backgroundColor: primaryColor,
                      elevation: 0,
                      mini: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Icon(
                        Icons.chevron_left_rounded,
                        color: secondaryColor,
                      ),
                      // child: SvgPicture.asset(
                      //   Asset.arrowBack,
                      //   colorFilter: ColorFilter.mode(secondaryColor, BlendMode.srcIn),
                      //   height: 22,
                      //   fit: BoxFit.contain,
                      // ),
                    ),
                  )
                : getDynamicSizedBox(width: 13.5.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 17.sp,
            fontFamily: dM_sans_medium,
          ),
        ),
        rightBtn != null
            ? IconButton(
                onPressed: rightBtn,
                icon: SvgPicture.asset(
                  rightasset,
                  width: 3.w,
                  height: 3.h,
                ),
              )
            : getDynamicSizedBox(width: 13.5.w)
      ],
    ),
  );
}

homeAppbar(String title, Function onClick, Function cartOnClick, int budget) {
  return Padding(
    padding: EdgeInsets.only(left: 1.w, right: 2.w, top: 0.5.h),
    child: Row(
      children: [
        getLogo(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 1, left: 9, right: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: Device.screenType == ScreenType.mobile
                        ? 16.5.sp
                        : 15.sp,
                    color: isDarkMode() ? white : black,
                    fontFamily: fontBold,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            onClick();
          },
          child: Container(
            padding:
                const EdgeInsets.only(left: 2, right: 1, top: 2, bottom: 2),
            child: Icon(
              color: isDarkMode() ? white : primaryColor,
              Icons.search,
              size: Device.screenType == ScreenType.mobile ? 3.3.h : 4.h,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            cartOnClick();
          },
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    color: isDarkMode() ? white : primaryColor,
                    Icons.shopping_cart,
                    size: Device.screenType == ScreenType.mobile ? 3.3.h : 4.h,
                  )),
              Positioned(
                right: 3,
                top: 0.5,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: bottomNavBackground,
                    borderRadius: BorderRadius.circular(
                        Device.screenType == ScreenType.mobile ? 10 : 20),
                  ),
                  constraints: BoxConstraints(
                    minWidth:
                        Device.screenType == ScreenType.mobile ? 4.2.w : 3.5.w,
                    minHeight:
                        Device.screenType == ScreenType.mobile ? 0.3.h : 0.5.h,
                  ),
                  child: Text(
                    budget.toString(),
                    style: TextStyle(
                      color: isDarkMode() ? white : black,
                      fontSize:
                          Device.screenType == ScreenType.mobile ? 7.sp : 6.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

bool isSmallDevice(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  // Retrieve the screen height
  final screenHeight = mediaQuery.size.height;
  // Define the threshold height below which the device is considered small
  const smallDeviceHeightThreshold = 700.0;
  // Check if the device is small based on the screen height
  return screenHeight < smallDeviceHeightThreshold;
}

getSizedBox() {
  return SizedBox(
    height: 1.7.h,
  );
}

getDynamicSizedBox({height, width}) {
  return SizedBox(
    height: height ?? 0,
    width: width ?? 0,
  );
}

checkInternet() {
  return Scaffold(
      body: SizedBox(
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Asset.noInternet,
            height: 20.h,
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            textAlign: TextAlign.center,
            "Please Check Your\nInternet Connection.",
            style: TextStyle(
              color: Colors.red,
              fontFamily: fontBold,
              fontSize: Device.deviceType == DeviceType.web ? 10.sp : 18.sp,
            ),
          ),
        ],
      ),
    ),
  ));
}

getSizedBoxForDropDown() {
  return SizedBox(
    height: 0.90.h,
  );
}

getFilterToolbar(title,
    {Function? filterCallback,
    Function? searchClick,
    bool? isFilter,
    bool? isBackEnable,
    bool? isFromDialog}) {
  return Stack(
    children: [
      if (isBackEnable == true)
        Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: backPress(() {
              getx.Get.back();
            })),
      Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: fontBold,
              color: isDarkMode() ? white : headingTextColor,
              fontWeight: FontWeight.bold,
              fontSize: Device.screenType == ScreenType.mobile ? 18.sp : 16.sp),
        ),
      ),
      Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          child: Row(
            children: [
              isFilter == false
                  ? GestureDetector(
                      onTap: () {
                        searchClick!();
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 5.w),
                        child: Icon(
                          Icons.search,
                          size: 3.5.h,
                          color: isDarkMode() ? white : primaryColor,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        filterCallback!();
                      },
                      child: Container(
                          margin: EdgeInsets.only(right: 5.w),
                          child: Icon(
                              isFromDialog == true
                                  ? Icons.cancel
                                  : Icons.tune_rounded,
                              size: 3.2.h,
                              color: isDarkMode() ? white : primaryColor)))
            ],
          )),
    ],
  );
}

getdivider() {
  return Divider(
    height: 3.5.h,
    indent: 0.1.h,
    endIndent: 0.1.h,
    thickness: 1,
    color: primaryColor.withOpacity(0.5),
  );
}

getVerticalDivider() {
  return Container(
      decoration: BoxDecoration(
          color: lableColor.withOpacity(0.2),
          boxShadow: [
            BoxShadow(
                color: grey.withOpacity(0.2),
                blurRadius: 0.0,
                offset: const Offset(0, 1),
                spreadRadius: 0.0)
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(5.h),
          )),
      width: 0.2.w,
      height: 1.5.h);
}

getDividerForShowDialog() {
  return Divider(
      height: 0.5.h,
      indent: 0.1.h,
      endIndent: 0.1.h,
      thickness: 1,
      color: isDarkMode() ? white : primaryColor.withOpacity(0.5));
}

Widget backPress(callback) {
  return SizedBox(
    width: 32,
    height: 32,
    child: FloatingActionButton(
      onPressed: callback,
      backgroundColor: primaryColor,
      elevation: 0,
      mini: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: Icon(
        Icons.chevron_left_rounded,
        color: secondaryColor,
      ),
      // child: SvgPicture.asset(
      //   Asset.arrowBack,
      //   colorFilter: ColorFilter.mode(secondaryColor, BlendMode.srcIn),
      //   height: 22,
      //   fit: BoxFit.contain,
      // ),
    ),
  );

  // GestureDetector(
  //   onTap: () {
  //     callback();
  //   },
  //   child: Container(
  //     margin: EdgeInsets.only(
  //         left: Device.screenType == ScreenType.mobile ? 3.w : 2.w),
  //     decoration: BoxDecoration(
  //         color: white,
  //         borderRadius: const BorderRadius.all(Radius.circular(40))),
  //     child: Container(
  //       padding: const EdgeInsets.all(6),
  //       child: SvgPicture.asset(Asset.arrowBack,
  //           colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
  //           height: Device.screenType == ScreenType.mobile ? 3.h : 4.h,
  //           fit: BoxFit.contain),
  //     ),
  //   ),
  // );
}

Widget iosBackPress(callback) {
  return Container(
    margin: EdgeInsets.only(
        left: Device.screenType == ScreenType.mobile ? 3.w : 5.w),
    child: GestureDetector(
        onTap: () {
          callback();
        },
        child: Container(
            padding: const EdgeInsets.all(10),
            child: SvgPicture.asset(Asset.arrowBack,
                height: Device.screenType == ScreenType.mobile ? 4.h : 5.h))),
  );
}

Widget backButtonWidget(callback, {isWhiteText}) {
  return Container(
      margin: EdgeInsets.only(
          left: Device.screenType == ScreenType.mobile ? 5.w : 2.w),
      child: GestureDetector(
          onTap: () {
            callback();
          },
          child: SvgPicture.asset(Asset.arrowBack,
              // ignore: deprecated_member_use
              color: isDarkMode()
                  ? isWhiteText == true
                      ? black
                      : white
                  : isWhiteText == true
                      ? white
                      : black,
              height: Device.screenType == ScreenType.mobile ? 4.h : 5.h)));
}

Widget getLogoWithTitle() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
          margin: EdgeInsets.only(left: 1.w, right: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Image.asset(
            Asset.logo,
            height: 5.h,
          )),
      Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Image.asset(Asset.applogo, height: 4.h))
    ],
  );
}

getCommonToolbar(String title,
    {Function? onClick,
    Function? onFilterClick,
    bool showBackButton = true,
    bool isFilter = false,
    bool? isWhiteText,
    bool? isLogo,
    BuildContext? context}) {
  return Stack(
    children: [
      Positioned(
          left: 0,
          top: 0,
          child: showBackButton == true
              ? backButtonWidget(onClick, isWhiteText: isWhiteText)
              : Container()),
      Center(
        child: Text(title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: fontBold,
                color: isDarkMode()
                    ? isWhiteText == true
                        ? black
                        : white
                    : isWhiteText == true
                        ? white
                        : black,
                fontWeight: FontWeight.bold,
                fontSize: 20.sp)),
      ),
      if (isFilter == true)
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.only(
                right: Device.screenType == ScreenType.mobile ? 4.5.w : 4.6.w),
            child: InkWell(
                onTap: () {
                  onFilterClick!();
                },
                borderRadius: const BorderRadius.all(Radius.circular(24)),
                child: SvgPicture.asset(Asset.filter,
                    height: Device.screenType == ScreenType.mobile
                        ? isSmallDevice(context!)
                            ? 2.6.h
                            : 2.7.h
                        : 2.5.h,
                    color: isDarkMode() ? white : black)),
          ),
        ),
    ],
  );
}

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

getleftsidebackbtn(
    {required backFunction, title, istitle = true, isbussinessScreen = false}) {
  return Row(
    children: [
      GestureDetector(
        onTap: backFunction,
        child: Container(
            margin: isbussinessScreen
                ? EdgeInsets.only(top: 1.h, right: 5.w, bottom: 1.h)
                : EdgeInsets.only(top: 2.h, bottom: 2.h),
            // color: Colors.yellow,
            // padding: EdgeInsets.all(5),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: primaryColor),
            child: Padding(
              padding: EdgeInsets.all(2),
              child: SvgPicture.asset(
                Asset.arrowBack,
                colorFilter: ColorFilter.mode(white, BlendMode.srcIn),
                fit: BoxFit.contain,
              ),
            )),
      ),
      if (istitle == true) getDynamicSizedBox(width: 2.w),
      if (istitle == true)
        Text(
          title,
          style: TextStyle(fontFamily: dM_sans_bold, fontSize: 18.sp),
        )
    ],
  );
}

getLogoAppBar() {
  return Center(child: getLogo());
}

Widget getLogo() {
  return Container(
      // color: Colors.yellow,
      margin: EdgeInsets.only(right: 2.w),
      padding: const EdgeInsets.all(3),
      child: SvgPicture.asset(
        Asset.logo,
        height: 3.0.h,
        fit: BoxFit.cover,
      ));
}
