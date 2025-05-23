import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ibh/componant/button/form_button.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/preference/UserPreference.dart';
import 'package:ibh/utils/helper.dart';

import 'package:sizer/sizer.dart' as sizer;
import 'package:get/get.dart' as getx;

// ignore: must_be_immutable
class CustomCartItemDetailDialog extends StatelessWidget {
  CustomCartItemDetailDialog(
      this.imageUrl, this.title, this.price, this.description,
      {super.key});
  String imageUrl;
  String title;
  String price;
  String description;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0.0,
      backgroundColor: transparent,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
              margin: EdgeInsets.only(top: 10.h),
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: isDarkMode()
                      ? null
                      : [
                          BoxShadow(
                              color: grey.withOpacity(0.2),
                              blurRadius: 10.0,
                              offset: const Offset(0, 1),
                              spreadRadius: 3.0)
                        ]),
              padding:
                  EdgeInsets.only(top: 3.h, bottom: 2.h, left: 4.w, right: 4.w),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getDynamicSizedBox(height: 4.h),
                    Text('Product Name: $title',
                        maxLines: 3,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 15.sp,
                            color: black,
                            fontWeight: FontWeight.bold)),
                    getDynamicSizedBox(height: 0.7.h),
                    getRichText(
                        'Price: ', '${IndiaRupeeConstant.inrCode}$price'),
                    getDynamicSizedBox(height: 0.5.h),
                    getRichText('Description: ', description),
                    getDynamicSizedBox(height: 2.h),
                    Container(
                        margin: EdgeInsets.only(
                          left: 5.w,
                          right: 5.w,
                        ),
                        child: FadeInUp(
                          from: 50,
                          child: getSecondaryFormButton(() {
                            Navigator.of(context).pop();
                          }, Button.continues,
                              isvalidate: true, isFromDialog: true),
                        ))
                  ])),
          Positioned(
            child: FadeInDown(
              from: 50,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: grey,
                      width: 0.8,
                    ),
                    borderRadius: BorderRadius.circular(
                        sizer.Device.screenType == sizer.ScreenType.mobile
                            ? 3.w
                            : 2.2.w)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      sizer.Device.screenType == sizer.ScreenType.mobile
                          ? 3.w
                          : 2.2.w),
                  child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      height: 15.h,
                      width: 40.w,
                      imageUrl: imageUrl,
                      placeholder: (context, url) => const Center(
                          child:
                              CircularProgressIndicator(color: primaryColor)),
                      errorWidget: (context, url, error) => Image.asset(
                          Asset.productPlaceholder,
                          height: 11.h,
                          fit: BoxFit.cover),
                      imageBuilder: (context, imageProvider) => Image(
                          image: imageProvider,
                          height: 11.h,
                          fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomLoginAlertRoundedDialog extends StatelessWidget {
  CustomLoginAlertRoundedDialog(this.screenName, {super.key});
  String screenName;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0.0,
      backgroundColor: transparent,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
              margin: EdgeInsets.only(top: 10.h),
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: isDarkMode()
                      ? null
                      : [
                          BoxShadow(
                              color: grey.withOpacity(0.2),
                              blurRadius: 10.0,
                              offset: const Offset(0, 1),
                              spreadRadius: 3.0)
                        ]),
              padding:
                  EdgeInsets.only(top: 3.h, bottom: 2.h, left: 4.w, right: 4.w),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                getDynamicSizedBox(height: 4.h),
                Text(LoginConst.title,
                    style: TextStyle(
                        fontSize: 20.sp,
                        color: black,
                        fontWeight: FontWeight.bold)),
                getDynamicSizedBox(height: 2.h),
                Text(
                    textAlign: TextAlign.center,
                    LoginConst.subText,
                    style: TextStyle(
                        color: black, fontFamily: fontBold, fontSize: 11.5.sp)),
                getDynamicSizedBox(height: 4.h),
                Container(
                    margin: EdgeInsets.only(left: 5.w, right: 5.w),
                    child: FadeInUp(
                        from: 50,
                        child: getSecondaryFormButton(() {
                          getx.Get.back();
                        }, LoginConst.buttonLabel, isvalidate: true)))
              ])),
          Positioned(
            top: 1.5.h,
            child: FadeInDown(
              from: 50,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: SvgPicture.asset(Asset.alertLogin,
                    height: sizer.Device.screenType == sizer.ScreenType.mobile
                        ? 15.h
                        : 10.h),
              ),
            ),
          ),
          Positioned(
            top: 10.5.h,
            right: 2.w,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Align(
                alignment: Alignment.topRight,
                child: FadeInDown(
                  from: 50,
                  child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(Icons.clear_outlined,
                          color: white,
                          size:
                              sizer.Device.screenType == sizer.ScreenType.mobile
                                  ? 3.h
                                  : 5.h)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<Object?> popupDialogs(
    BuildContext context, title, subString, Function onClick) {
  return showGeneralDialog(
      barrierColor: black.withOpacity(0.6),
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOut.transform(a1.value);
        return Transform.translate(
            offset: Offset(0, (1 - curvedValue) * 400),
            child: Opacity(
                opacity: a1.value,
                child: CupertinoAlertDialog(
                    title: Text(title,
                        style: TextStyle(
                            fontSize: 13.sp,
                            color: isDarkMode() ? white : black,
                            fontFamily: fontMedium,
                            fontWeight: FontWeight.bold)),
                    content: Text(subString,
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: isDarkMode() ? white : black,
                            fontFamily: fontBold)),
                    actions: [
                      CupertinoDialogAction(
                          onPressed: () {
                            onClick();
                            Navigator.pop(context);
                            // if (isFromPayment != true) {
                            //   UserPreferences().logout();
                            //   Get.offAll(const LoginScreen());
                            // }
                          },
                          isDefaultAction: true,
                          isDestructiveAction: true,
                          child: Text(Logout.yes,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: isDarkMode() ? white : black,
                                  fontFamily: fontBold,
                                  fontWeight: FontWeight.bold)))
                    ])));
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      });
}

Future<Object?> commonDialog(BuildContext context,
    {bool? isFromAddOrder,
    bool? isFromCancleOrder,
    Function? onDiscard,
    Function? onSave}) {
  return showGeneralDialog(
      barrierColor: black.withOpacity(0.6),
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOut.transform(a1.value);
        return Transform.translate(
          offset: Offset(0, (1 - curvedValue) * 400),
          child: Opacity(
              opacity: a1.value,
              child: CupertinoAlertDialog(
                  title: Text(
                      isFromAddOrder == true ? Common.alert : Logout.title,
                      style: TextStyle(
                          fontSize: 18,
                          color: isDarkMode() ? white : black,
                          fontFamily: fontBold,
                          fontWeight: FontWeight.bold)),
                  content: Text(Logout.heading,
                      style: TextStyle(
                          fontSize: 13,
                          color: isDarkMode() ? white : black,
                          fontFamily: fontMedium)),
                  actions: [
                    CupertinoDialogAction(
                        onPressed: () {
                          Navigator.pop(context);
                          if (onDiscard != null) {
                            onDiscard();
                            return;
                          }
                        },
                        isDefaultAction: true,
                        isDestructiveAction: true,
                        child: Text(
                            isFromAddOrder == true ? Button.discard : Logout.no,
                            style: TextStyle(
                                fontSize: 15,
                                color: isDarkMode() ? white : black,
                                fontFamily: fontBold,
                                fontWeight: FontWeight.bold))),
                    CupertinoDialogAction(
                        onPressed: () {
                          Navigator.pop(context);
                          if (onSave != null) {
                            onSave();
                            return;
                          } else {
                            UserPreferences().logout();
                            // Get.offAll(const LoginScreen());
                          }
                        },
                        isDefaultAction: true,
                        isDestructiveAction: true,
                        child: Text(
                            isFromAddOrder == true ? Button.save : Logout.yes,
                            style: TextStyle(
                                fontSize: 15,
                                color: isDarkMode() ? white : black,
                                fontFamily: fontBold,
                                fontWeight: FontWeight.bold)))
                  ])),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      });
}
