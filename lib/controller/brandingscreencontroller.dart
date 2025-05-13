import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/Repository.dart';
import 'package:ibh/componant/dialogs/dialogs.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/configs/apicall_constant.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/internet_controller.dart';
import 'package:ibh/models/businessListModel.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/helper.dart';
import 'package:ibh/utils/log.dart';
import 'package:ibh/views/mainscreen/BrandingScreeens/BrandEditingScreen.dart';
import 'package:ibh/views/mainscreen/BrandingScreeens/BrandingDetailsScreen.dart';
import 'package:ibh/views/mainscreen/ServiceScreen/BusinessDetailScreen.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sizer/sizer.dart';
import 'package:sizer/sizer.dart' as sizer;

class Brandingscreencontroller extends GetxController {
  Rx<ScreenState> state = ScreenState.apiSuccess.obs;

  RxList searchList = [].obs;

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  var isBusinessLoading = false.obs;
  var currentPage = 0;
  RxList businessList = [].obs;
  bool isFetchingfestivalMore = false;
  RxString message = "".obs;
  InternetController networkManager = Get.find<InternetController>();

  void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  var dailyImages = [
    Asset.d1,
    Asset.d2,
    Asset.d3,
    Asset.d4,
    Asset.d5,
    Asset.d6
  ];

  var dailyNames = [
    "Monday Motivation",
    "Tuesday Tip",
    "Wisdom Wednesday",
    "Thoughtful Thursday",
    "Feel Good Friday",
    "Weekend Inspiration",
  ];

  var festivalImages = [
    Asset.f1,
    Asset.f2,
    Asset.f3,
    Asset.f4,
    Asset.f1,
    Asset.f2
  ];

  var festivalNames = [
    "Incredible India – Symbol of Heritage", // Colorful Taj Mahal
    "Christmas – Joy and Giving", // Merry Christmas
    "Diwali – Festival of Lights", // Dipavali
    "Holi – Festival of Colors", // Holi
    "Incredible India – Symbol of Heritage", // Repeated Taj Mahal
    "Christmas – Joy and Giving", // Repeated Christmas
  ];
  RxString nextPageURL = "".obs;

  final RxList<String> bussinessList = [
    Asset.b1,
    Asset.b2,
    Asset.b3,
    Asset.b4,
    Asset.b1,
    Asset.b2,
  ].obs;
  getDailyListItem(BuildContext context, BusinessData item,
      {dailyImg, dailyName}) {
    return GestureDetector(
        onTap: () {
          Get.to(Brandeditingscreen())!.then((value) {});
        },
        child: Container(
            // color: Colors.yellow,
            width: isSmallDevice(context) ? 18.w : 22.w,
            height: 30.h,
            margin: EdgeInsets.only(
                right:
                    Device.screenType == sizer.ScreenType.mobile ? 3.w : 2.w),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: white,
                      border: Border.all(
                        color: primaryColor, // Border color
                        // Border width
                      ),
                    ),
                    child: ClipOval(
                      child:

                          //     Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: 1.w),
                          //   child:

                          //   ClipOval(
                          //     child: Image.asset(
                          //       assetImage,
                          //       fit: BoxFit.cover,
                          //       height: 10.h,
                          //       width: isSmallDevice(context) ? 8.w : 12.w,
                          //     ),
                          //   ),
                          // )

                          Container(
                        height: 10.h,
                        width: isSmallDevice(context) ? 8.w : 12.w,
                        padding: const EdgeInsets.all(4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            dailyImg, // Your local asset path
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // CachedNetworkImage(
                      //   fit: BoxFit.cover,
                      //   height: 10.h,
                      //   width: isSmallDevice(context) ? 8.w : 12.w,
                      //   imageUrl: tempdataLink,
                      //   placeholder: (context, url) => Container(
                      //     padding: const EdgeInsets.all(4),
                      //     child: ClipRRect(
                      //         borderRadius: BorderRadius.circular(50),
                      //         child: Image.asset(
                      //           Asset.bussinessPlaceholder,
                      //           // width: 3.w,
                      //         )),
                      //   ),
                      //   //  Center(
                      //   //   child: Image.asset(
                      //   //     Asset.placeholder,
                      //   //     height: 7.h,
                      //   //     fit: BoxFit.cover,
                      //   //   ),
                      //   // CircularProgressIndicator(color: primaryColor),
                      //   errorWidget: (context, url, error) => Image.asset(
                      //     Asset.placeholder,
                      //     height: 7.h,
                      //     fit: BoxFit.cover,
                      //   ),
                      //   imageBuilder: (context, imageProvider) {
                      //     return Image(
                      //       image: imageProvider,
                      //       fit: BoxFit.cover,
                      //     );
                      //   },
                      // ),
                    ),
                  ),
                  getDynamicSizedBox(height: 1.h),
                  Expanded(
                    child: Text(
                      dailyName,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      maxLines: 2, // Allows text to go to a second line
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: dM_sans_medium,
                        color: black,
                        fontSize: Device.screenType == sizer.ScreenType.mobile
                            ? 13.sp
                            : 10.sp,
                      ),
                    ),
                  )
                  // item.name.length > 9
                  //     ? Expanded(
                  //         child: Marquee(
                  //             style: TextStyle(
                  //               fontFamily: dM_sans_regular,
                  //               color: black,
                  //               fontSize:
                  //                   Device.screenType == sizer.ScreenType.mobile
                  //                       ? 14.sp
                  //                       : 9.sp,
                  //             ),
                  //             text: item.name,
                  //             scrollAxis: Axis.horizontal,
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             blankSpace:
                  //                 20.0, // Adjust the space between text repetitions
                  //             velocity: 50.0, // Adjust the scrolling speed
                  //             pauseAfterRound: const Duration(
                  //                 seconds:
                  //                     1), // Time to pause after each scroll
                  //             startPadding: 10.0, // Adjust the initial padding
                  //             accelerationDuration: const Duration(
                  //                 seconds: 1), // Duration for acceleration
                  //             accelerationCurve:
                  //                 Curves.linear, // Acceleration curve
                  //             decelerationDuration: const Duration(
                  //                 milliseconds:
                  //                     500), // Duration for deceleration
                  //             decelerationCurve: Curves.easeOut),
                  //       )
                  //     : Text(
                  //         item.name,
                  //         textAlign: TextAlign.center,
                  //         style: TextStyle(
                  //             fontFamily: dM_sans_regular,
                  //             color: black,
                  //             fontSize:
                  //                 Device.screenType == sizer.ScreenType.mobile
                  //                     ? 12.sp
                  //                     : 9.sp),
                  //       )
                ])));
  }

  getFestivalListItem(BuildContext context, BusinessData item,
      {festivalImg, festivalName}) {
    // print('item;${item.isEmailVerified}');
    return GestureDetector(
      onTap: () async {
        Get.to(Brandeditingscreen())!.then((value) {});
        // Get.to(Brandingdetailsscreen(
        //   count: 2,
        // ));
        // bool isEmpty = await isAnyFieldEmpty();
        // if (isEmpty) {
        //   // ignore: use_build_context_synchronously
        //   showBottomSheetPopup(context);
        // } else {
        //   Get.to(BusinessDetailScreen(
        //     item: item,
        //     isFromProfile: false,
        //   ));
        // }
        // Get.to(BusinessDetailScreen(
        //   item: item,
        //   isFromProfile: false,
        // ));
      },
      child: Container(
        // height: 4.h,
        width: 37.w,
        decoration: BoxDecoration(
          color: white,
          // border: Border.all(color: primaryColor),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                // ignore: deprecated_member_use
                color: black.withOpacity(0.2),
                spreadRadius: 0.1,
                blurRadius: 2,
                offset: const Offset(0, 0)),
          ],
        ),
        margin: EdgeInsets.only(left: 1.w, right: 1.w, bottom: 0.h),
        // padding:
        // EdgeInsets.only(left: 1.w, top: 0.5.h, bottom: 0.h, right: 1.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  // padding: const EdgeInsets.all(2),
                  // margin: EdgeInsets.only(top: 0.h, bottom: 0.5.h),
                  width: Device.width,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: white,
                    boxShadow: [
                      BoxShadow(
                          // ignore: deprecated_member_use
                          color: black.withOpacity(0.2),
                          spreadRadius: 0.1,
                          blurRadius: 5,
                          offset: const Offset(0, 0)),
                    ],
                    // border: Border(
                    //     bottom: BorderSide(
                    //         color: primaryColor,
                    //         width: 0.3.w)), // border color and width
                    borderRadius: BorderRadius.circular(
                        Device.screenType == sizer.ScreenType.mobile
                            ? 2.5.w
                            : 2.5.w),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      festivalImg, // Your local asset path
                      fit: BoxFit.cover,
                    ),

                    // Container(
                    //   height: 10.h,
                    //   width: isSmallDevice(context) ? 8.w : 12.w,
                    //   padding: const EdgeInsets.all(4),
                    //   child: ClipRRect(
                    //     borderRadius: BorderRadius.circular(50),
                    //     child:
                    //   ),
                    // ),

                    //  CachedNetworkImage(
                    //   fit: BoxFit.contain,
                    //   height: 1.h,
                    //   imageUrl: item.visitingCardUrl,
                    //   placeholder: (context, url) => Center(
                    //     child: Image.asset(Asset.itemPlaceholder,
                    //         height: 12.h, width: 25.w, fit: BoxFit.cover),
                    //   ),
                    //   errorWidget: (context, url, error) => Image.asset(
                    //       Asset.itemPlaceholder,
                    //       height: 12.h,
                    //       fit: BoxFit.cover),
                    // ),
                  ),
                ),
                Positioned(
                  top: 0.5.h,
                  right: 1.w,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: white,
                    ),
                    child: SvgPicture.asset(
                      Asset.badge,
                      color: blue,
                    ),
                  ),
                ),
                // item.isEmailVerified
                //     ?

                // : SizedBox.shrink()
              ],
            ),
            // getDynamicSizedBox(height: 1.w),

            Expanded(
              child: Center(
                child: Container(
                  // height: 3.h,
                  padding: EdgeInsets.symmetric(horizontal: 2.w),

                  // height: 4.h,
                  width: Device.screenType == sizer.ScreenType.mobile
                      ? 58.w
                      : 65.w,
                  child: Text(
                      // 'asdaiyutasypudsgsaudgasgasdadsdjhdgasbaosdoasasddahshdadakdshddlkd',
                      festivalName,
                      // item.businessName,
                      maxLines: 1,
                      style: TextStyle(
                          fontFamily: dM_sans_semiBold,
                          fontSize: 14.sp,
                          height: 1.2,
                          overflow: TextOverflow.ellipsis,
                          color: black,
                          fontWeight: FontWeight.w900)),
                ),
              ),
            ),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     SizedBox(
            //       // height: 4.h,
            //       width: Device.screenType == sizer.ScreenType.mobile
            //           ? 58.w
            //           : 65.w,
            //       child: Text(
            //           // 'asdaiyutasypudsgsaudgasgasdadsdjhdgasbaosdoasasddahshdadakdshddlkd',

            //           item.businessName,
            //           maxLines: 2,
            //           style: TextStyle(
            //               fontFamily: dM_sans_medium,
            //               fontSize: 14.sp,
            //               height: 1,
            //               overflow: TextOverflow.ellipsis,
            //               color: black,
            //               fontWeight: FontWeight.w900)),
            //     ),
            //     // getDynamicSizedBox(height: 1.h),
            //     // SizedBox(
            //     //   // height: 2.h,
            //     //   width: Device.screenType == sizer.ScreenType.mobile
            //     //       ? 58.w
            //     //       : 70.w,
            //     //   child: Text(item.name,
            //     //       maxLines: 1,
            //     //       style: TextStyle(
            //     //           height: 1.1,
            //     //           fontFamily: dM_sans_semiBold,
            //     //           fontSize: 14.sp,
            //     //           color: black,
            //     //           fontWeight: FontWeight.w500)),
            //     // ),
            //     // getDynamicSizedBox(height: 1.h),
            //     // SizedBox(
            //     //   // height: 4.h,
            //     //   width: Device.screenType == sizer.ScreenType.mobile
            //     //       ? 58.w
            //     //       : 65.w,
            //     //   child: Text(
            //     //       // 'asdaiyutasypudsgsaudgasgasdadsdjhdgasbaosdoas',

            //     //       item.address.isNotEmpty
            //     //           ? item.address
            //     //           : item.city != null
            //     //               ? item.city!.city
            //     //               : item.phone,
            //     //       maxLines: 2,
            //     //       style: TextStyle(
            //     //           height: 1.1,
            //     //           fontFamily: dM_sans_semiBold,
            //     //           fontSize: 14.sp,
            //     //           color: black,
            //     //           fontWeight: FontWeight.w500)),
            //     // ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  getBusinessListItem(BuildContext context, BusinessData item) {
    // print('item;${item.isEmailVerified}');
    return GestureDetector(
      onTap: () async {
        Get.to(Brandeditingscreen())!.then((value) {});
        // bool isEmpty = await isAnyFieldEmpty();
        // if (isEmpty) {
        //   // ignore: use_build_context_synchronously
        //   showBottomSheetPopup(context);
        // } else {
        //   Get.to(BusinessDetailScreen(
        //     item: item,
        //     isFromProfile: false,
        //   ));
        // }
        // Get.to(BusinessDetailScreen(
        //   item: item,
        //   isFromProfile: false,
        // ));
      },
      child: Container(
        // height: 4.h,
        width: 37.w,
        decoration: BoxDecoration(
          color: white,
          // border: Border.all(color: primaryColor),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                // ignore: deprecated_member_use
                color: black.withOpacity(0.2),
                spreadRadius: 0.1,
                blurRadius: 2,
                offset: const Offset(0, 0)),
          ],
        ),
        margin: EdgeInsets.only(left: 1.w, right: 1.w, bottom: 0.h),
        // padding:
        // EdgeInsets.only(left: 1.w, top: 0.5.h, bottom: 0.h, right: 1.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  // padding: const EdgeInsets.all(2),
                  // margin: EdgeInsets.only(top: 0.h, bottom: 0.5.h),
                  width: Device.width,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: white,
                    boxShadow: [
                      BoxShadow(
                          // ignore: deprecated_member_use
                          color: black.withOpacity(0.2),
                          spreadRadius: 0.1,
                          blurRadius: 5,
                          offset: const Offset(0, 0)),
                    ],
                    // border: Border(
                    //     bottom: BorderSide(
                    //         color: primaryColor,
                    //         width: 0.3.w)), // border color and width
                    borderRadius: BorderRadius.circular(
                        Device.screenType == sizer.ScreenType.mobile
                            ? 2.5.w
                            : 2.5.w),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      fit: BoxFit.contain,
                      height: 1.h,
                      imageUrl: item.visitingCardUrl,
                      placeholder: (context, url) => Center(
                        child: Image.asset(Asset.itemPlaceholder,
                            height: 12.h, width: 25.w, fit: BoxFit.cover),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                          Asset.itemPlaceholder,
                          height: 12.h,
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
                Positioned(
                  top: 0.5.h,
                  right: 1.w,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: white,
                    ),
                    child: SvgPicture.asset(
                      Asset.badge,
                      color: blue,
                    ),
                  ),
                ),
                // item.isEmailVerified
                //     ?

                // : SizedBox.shrink()
              ],
            ),
            // getDynamicSizedBox(height: 1.w),

            Expanded(
              child: Center(
                child: Container(
                  // height: 3.h,
                  padding: EdgeInsets.symmetric(horizontal: 2.w),

                  // height: 4.h,
                  width: Device.screenType == sizer.ScreenType.mobile
                      ? 58.w
                      : 65.w,
                  child: Text(
                      // 'asdaiyutasypudsgsaudgasgasdadsdjhdgasbaosdoasasddahshdadakdshddlkd',

                      item.businessName,
                      maxLines: 1,
                      style: TextStyle(
                          fontFamily: dM_sans_semiBold,
                          fontSize: 14.sp,
                          height: 1.2,
                          overflow: TextOverflow.ellipsis,
                          color: black,
                          fontWeight: FontWeight.w900)),
                ),
              ),
            ),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     SizedBox(
            //       // height: 4.h,
            //       width: Device.screenType == sizer.ScreenType.mobile
            //           ? 58.w
            //           : 65.w,
            //       child: Text(
            //           // 'asdaiyutasypudsgsaudgasgasdadsdjhdgasbaosdoasasddahshdadakdshddlkd',

            //           item.businessName,
            //           maxLines: 2,
            //           style: TextStyle(
            //               fontFamily: dM_sans_medium,
            //               fontSize: 14.sp,
            //               height: 1,
            //               overflow: TextOverflow.ellipsis,
            //               color: black,
            //               fontWeight: FontWeight.w900)),
            //     ),
            //     // getDynamicSizedBox(height: 1.h),
            //     // SizedBox(
            //     //   // height: 2.h,
            //     //   width: Device.screenType == sizer.ScreenType.mobile
            //     //       ? 58.w
            //     //       : 70.w,
            //     //   child: Text(item.name,
            //     //       maxLines: 1,
            //     //       style: TextStyle(
            //     //           height: 1.1,
            //     //           fontFamily: dM_sans_semiBold,
            //     //           fontSize: 14.sp,
            //     //           color: black,
            //     //           fontWeight: FontWeight.w500)),
            //     // ),
            //     // getDynamicSizedBox(height: 1.h),
            //     // SizedBox(
            //     //   // height: 4.h,
            //     //   width: Device.screenType == sizer.ScreenType.mobile
            //     //       ? 58.w
            //     //       : 65.w,
            //     //   child: Text(
            //     //       // 'asdaiyutasypudsgsaudgasgasdadsdjhdgasbaosdoas',

            //     //       item.address.isNotEmpty
            //     //           ? item.address
            //     //           : item.city != null
            //     //               ? item.city!.city
            //     //               : item.phone,
            //     //       maxLines: 2,
            //     //       style: TextStyle(
            //     //           height: 1.1,
            //     //           fontFamily: dM_sans_semiBold,
            //     //           fontSize: 14.sp,
            //     //           color: black,
            //     //           fontWeight: FontWeight.w500)),
            //     // ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  getBusinessList(context, currentPage, bool hideloading,
      {bool? isFirstTime = false}) async {
    // var loadingIndicator = LoadingProgressDialog();

    // if (hideloading == true) {
    //   state.value = ScreenState.apiLoading;
    // } else {
    //   loadingIndicator.show(context, '');
    //   update();
    // }
    if (hideloading == false) {
      state.value = ScreenState.apiLoading;
    }
    if (isFirstTime == true) {
      isBusinessLoading(true);
    }
    try {
      if (networkManager.connectionType.value == 0) {
        if (isFirstTime == true) {
          isBusinessLoading(false);
        }
        showDialogForScreen(context, 'Branding Screen', Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }

      var pageURL = '${ApiUrl.businessesList}?page=$currentPage';
      var response = await Repository.post({}, pageURL, allowHeader: true);
      ;
      // if (hideloading != true) {
      //   loadingIndicator.hide(context);
      // }
      if (isFirstTime == true) {
        isBusinessLoading(false);
      }
      logcat("RESPONSE::", response.body);
      var responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseData['success'] == true) {
          state.value = ScreenState.apiSuccess;
          message.value = '';
          if (isFirstTime == true && businessList.isNotEmpty) {
            currentPage = 1;
            businessList.clear();
          }
          var businessListData = BusinessModel.fromJson(responseData);
          if (businessListData.data.data.isNotEmpty) {
            businessList.addAll(businessListData.data.data);
            businessList.refresh();
            update();
          } else {
            businessList.clear();
          }
          if (businessListData.data.nextPageUrl != null) {
            nextPageURL.value = businessListData.data.nextPageUrl.toString();
            logcat("nextPageURL-1", nextPageURL.value.toString());
            update();
          } else {
            nextPageURL.value = "";
            logcat("nextPageURL-2", nextPageURL.value.toString());
            update();
          }
          logcat("nextPageURL", nextPageURL.value.toString());
        } else {
          message.value = responseData['message'];
          showDialogForScreen(context, 'Home Screen', responseData['message'],
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(context, 'Home Screen',
            responseData['message'] ?? ServerError.servererror, callback: () {
          getUnauthenticatedUser(
              context, responseData['message'], "Unauthenticated user");
        });
      }
    } catch (e) {
      logcat("Ecxeption", e);
      if (isFirstTime == true) {
        isBusinessLoading(false);
      }
      state.value = ScreenState.apiError;
      // message.value = ServerError.servererror;
      // showDialogForScreen(
      //     context, CategoryScreenConstant.title, ServerError.servererror,
      //     callback: () {});
    }
  }

  // double getWidth(BuildContext context) => MediaQuery.of(context).size.width;

  // Widget getDigitalCardLayout(context) {
  //   return Container(
  //     // digital card
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.all(Radius.circular(7)),
  //         border: Border(
  //             top: BorderSide(color: secondaryColor, width: 1),
  //             right: BorderSide(color: secondaryColor, width: 1),
  //             left: BorderSide(color: secondaryColor, width: 1),
  //             bottom: BorderSide(color: secondaryColor, width: 1)),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.grey.withOpacity(0.2),
  //             spreadRadius: 3,
  //             blurRadius: 7,
  //             offset: Offset(0, 5),
  //           ),
  //         ],
  //         color: Colors.white),
  //     margin: EdgeInsets.only(top: 2.h, left: 2.w, right: 2.w, bottom: 2.h),
  //     width: getWidth(context),
  //     padding: EdgeInsets.only(left: 15, top: 7, bottom: 7, right: 15),
  //     height: 80,
  //     child: Stack(
  //       children: [
  //         Container(
  //           margin: EdgeInsets.only(left: 15),
  //           child: SvgPicture.asset(
  //             "assets/wallet.svg",
  //             width: 60,
  //             height: 60,
  //           ),
  //         ),
  //         Container(
  //           margin: EdgeInsets.only(left: 100, top: 8),
  //           child: Text(
  //             "Create A Digital Business Card.",
  //             style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: primaryColor),
  //           ),
  //         ),
  //         Container(
  //           width: double.maxFinite,
  //           margin: EdgeInsets.only(left: 100, top: 28),
  //           child: Text(
  //             "Looking for business card for your brand? Tap on banner to create your brand digital card",
  //             style: TextStyle(
  //               fontSize: 12,
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
}
