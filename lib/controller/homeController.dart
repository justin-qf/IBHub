import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/Repository.dart';
import 'package:ibh/api_handle/apiCallingFormate.dart';
import 'package:ibh/componant/dialogs/dialogs.dart';
import 'package:ibh/componant/dialogs/loading_indicator.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/apicall_constant.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/models/appUpdateModel.dart';
import 'package:ibh/models/businessListModel.dart';
import 'package:ibh/models/ServiceListModel.dart';
import 'package:ibh/models/categoryListModel.dart';
import 'package:ibh/models/categotyModel.dart';
import 'package:ibh/models/login_model.dart';
import 'package:ibh/preference/UserPreference.dart';
import 'package:ibh/utils/helper.dart';
import 'package:ibh/utils/log.dart';
import 'package:ibh/views/mainscreen/HomeScreen/CategoryBusinessScreen.dart';
import 'package:ibh/views/mainscreen/ServiceScreen/BusinessDetailScreen.dart';
import 'package:ibh/views/sigin_signup/signinScreen.dart';
import 'package:marquee/marquee.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sizer/sizer.dart';
import 'package:sizer/sizer.dart' as sizer;
import '../utils/enum.dart';
import 'internet_controller.dart';

class HomeScreenController extends GetxController {
  Rx<ScreenState> state = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  InternetController networkManager = Get.find<InternetController>();
  var pageController = PageController();
  var currentPage = 1;
  late Timer? timer =
      Timer.periodic(const Duration(seconds: 10), (Timer timer) {});
  late TextEditingController searchCtr;
  bool isSearch = false;
  final ScrollController scrollController = ScrollController();
  RxBool showGNav = true.obs;
  RxList categoryList = [].obs;
  RxString nextPageURL = "".obs;
  bool isFetchingMore = false;
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  var isBusinessLoading = false.obs;
  var isCategoryLoading = false.obs;

  @override
  void dispose() {
    //scrollController.dispose();
    super.dispose();
  }

  disposePageController() {
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }
    pageController.dispose();
  }

  @override
  void onInit() {
    searchCtr = TextEditingController();
    super.onInit();
    getProfileData();
  }

  RxBool isUserVerified = false.obs;

  getProfileData() async {
    User? retrievedObject = await UserPreferences().getSignInInfo();

    if (retrievedObject != null) {
      isUserVerified.value = retrievedObject.isVerified ?? false;
    }
  }

  void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  getCategoryListItem(BuildContext context, CategoryListData item) {
    return GestureDetector(
        onTap: () {
          Get.to(CategoryBusinessScreen(item))!.then((value) {});
        },
        child: Container(
            width: 8.h,
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
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        height: 7.7.h,
                        width: 7.h,
                        imageUrl: item.thumbnail,
                        placeholder: (context, url) => Container(
                          padding: const EdgeInsets.all(4),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(
                                Asset.bussinessPlaceholder,
                                // width: 3.w,
                              )),
                        ),
                        //  Center(
                        //   child: Image.asset(
                        //     Asset.placeholder,
                        //     height: 7.h,
                        //     fit: BoxFit.cover,
                        //   ),
                        // CircularProgressIndicator(color: primaryColor),
                        errorWidget: (context, url, error) => Image.asset(
                          Asset.placeholder,
                          height: 7.h,
                          fit: BoxFit.cover,
                        ),
                        imageBuilder: (context, imageProvider) {
                          return Image(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                  getDynamicSizedBox(height: 1.h),
                  Expanded(
                    child: Text(
                      item.name,
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

  Widget getText(title, TextStyle? style, {bool? isFromBlogList}) {
    return Padding(
        padding: EdgeInsets.only(left: 0.5.w, right: 0.5.w),
        child: Text(
          title,
          style: style,
          maxLines: isFromBlogList == true ? 2 : 1,
        ));
  }

  void getCategoryList(context) async {
    // state.value = ScreenState.apiLoading;
    isCategoryLoading(true);
    try {
      if (networkManager.connectionType.value == 0) {
        isCategoryLoading(false);
        // showDialogForScreen(context, 'Home Screen', Connection.noConnection,
        //     callback: () {
        //   Get.back();
        // });
        return;
      }
      var response =
          await Repository.get({}, ApiUrl.getCategories, allowHeader: true);
      isCategoryLoading(false);
      logcat("CATEGORY_RESPONSE::", response.body);
      var responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseData['success'] == true) {
          state.value = ScreenState.apiSuccess;
          message.value = '';
          var categoryData = CategoryModel.fromJson(responseData);
          categoryList.clear();
          if (categoryData.data.isNotEmpty) {
            categoryList.addAll(categoryData.data);
            update();
          }
        } else {
          message.value = responseData['message'];
          showDialogForScreen(context, 'Home Screen', responseData['message'],
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        // message.value =
        //     responseData['message'] ?? APIResponseHandleText.serverError;
        // showDialogForScreen(context, HomeScreenconst.title,
        //     responseData['message'] ?? ServerError.servererror,
        //     callback: () {});
      }
    } catch (e) {
      logcat("Ecxeption", e);
      state.value = ScreenState.apiError;
      isCategoryLoading(false);
      // message.value = ServerError.servererror;
      // showDialogForScreen(
      //     context, HomeScreenconst.title, ServerError.servererror,
      //     callback: () {});
    }
  }

  // RxList serviceList = [].obs;
  // getServiceList(context, currentPage, bool hideloading) async {
  //   var loadingIndicator = LoadingProgressDialog();

  //   if (hideloading == true) {
  //     state.value = ScreenState.apiLoading;
  //   } else {
  //     loadingIndicator.show(context, '');
  //     update();
  //   }
  //   try {
  //     if (networkManager.connectionType.value == 0) {
  //       showDialogForScreen(
  //           context, CategoryScreenConstant.title, Connection.noConnection,
  //           callback: () {
  //         Get.back();
  //       });
  //       return;
  //     }

  //     var pageURL = '${ApiUrl.getServiceList}?page=$currentPage';
  //     var response = await Repository.get({}, pageURL, allowHeader: true);
  //     if (hideloading != true) {
  //       loadingIndicator.hide(context);
  //     }
  //     logcat("RESPONSE::", response.body);
  //     if (response.statusCode == 200) {
  //       var responseData = jsonDecode(response.body);
  //       if (responseData['success'] == true) {
  //         state.value = ScreenState.apiSuccess;
  //         message.value = '';
  //         var serviceListData = ServiceListModel.fromJson(responseData);
  //         if (serviceListData.data.data.isNotEmpty) {
  //           serviceList.addAll(serviceListData.data.data);
  //           serviceList.refresh();
  //           update();
  //         }
  //         if (serviceListData.data.nextPageUrl != 'null' ||
  //             serviceListData.data.nextPageUrl != null) {
  //           nextPageURL.value = serviceListData.data.nextPageUrl.toString();
  //           logcat("nextPageURL-1", nextPageURL.value.toString());
  //           update();
  //         } else {
  //           nextPageURL.value = "";
  //           logcat("nextPageURL-2", nextPageURL.value.toString());
  //           update();
  //         }
  //         logcat("nextPageURL", nextPageURL.value.toString());
  //       } else {
  //         message.value = responseData['message'];
  //         showDialogForScreen(
  //             context, CategoryScreenConstant.title, responseData['message'],
  //             callback: () {});
  //       }
  //     } else {
  //       state.value = ScreenState.apiError;
  //       message.value = APIResponseHandleText.serverError;
  //       showDialogForScreen(
  //           context, CategoryScreenConstant.title, ServerError.servererror,
  //           callback: () {});
  //     }
  //   } catch (e) {
  //     logcat("Ecxeption", e);
  //     state.value = ScreenState.apiError;
  //     message.value = ServerError.servererror;
  //     if (hideloading != true) {
  //       loadingIndicator.hide(context);
  //     }
  //     showDialogForScreen(
  //         context, CategoryScreenConstant.title, ServerError.servererror,
  //         callback: () {});
  //   }
  // }

  RxList businessList = [].obs;
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
        showDialogForScreen(
            context, HomeScreenconst.title, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }

      var pageURL = '${ApiUrl.businessesList}?page=$currentPage';
      var response = await Repository.post({}, pageURL, allowHeader: true);
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

  void getUpdateApi(context, bool isLoading) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version; // e.g. "1.0.0"
    // var loadingIndicator = LoadingProgressDialogs();
    commonGetApiCallFormate(context,
        title: HomeScreenconst.title,
        // apiEndPoint: "${ApiUrl.getCity}/" + cityID,
        apiEndPoint: ApiUrl.appUpdate,
        allowHeader: true, apisLoading: (isTrue) {
      if (isLoading == true) {
        // if (isTrue) {
        //   loadingIndicator.show(context, '');
        // } else {
        //   loadingIndicator.hide(context);
        // }
      }
      logcat("IsAppUpdate:", isTrue.toString());
      update();
    }, onResponse: (response) {
      var appUpdateModel = AppUpdateModel.fromJson(response);
      String serverVersion = appUpdateModel.data.version.toString();
      logcat("AppUpdate", jsonEncode(appUpdateModel));
      logcat("AppVersion", serverVersion.toString());
      logcat("currentVersion", currentVersion.toString());
      logcat("isForcefully", appUpdateModel.data.isForcefullyUpdate.toString());
      if (isNewVersionAvailable(currentVersion, serverVersion)) {
        const url =
            'https://play.google.com/store/apps/details?id=com.app.medicalhistory';
        bool isForcefully =
            appUpdateModel.data.isForcefullyUpdate == 1 ? true : false;
        showUpdatePopup(context, url ?? appUpdateModel.data.appUrl.toString(),
            appUpdateModel.data.description, isForcefully);
      }
      update();
    }, networkManager: networkManager);
  }

  getBusinessListItem(BuildContext context, BusinessData item) {
    print('item;${item.isEmailVerified}');
    return GestureDetector(
      onTap: () async {
        bool isEmpty = await isAnyFieldEmpty();
        if (isEmpty) {
          // ignore: use_build_context_synchronously
          showBottomSheetPopup(context);
        } else {
          Get.to(BusinessDetailScreen(
            item: item,
            isFromProfile: false,
          ));
        }
        // Get.to(BusinessDetailScreen(
        //   item: item,
        //   isFromProfile: false,
        // ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                // ignore: deprecated_member_use
                color: black.withOpacity(0.2),
                spreadRadius: 0.1,
                blurRadius: 5,
                offset: const Offset(0.5, 0.5)),
          ],
        ),
        margin: EdgeInsets.only(left: 3.w, right: 3.w, bottom: 2.h),
        padding: EdgeInsets.only(left: 2.w, top: 1.h, bottom: 1.h, right: 2.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  // padding: const EdgeInsets.all(2),
                  margin: EdgeInsets.only(top: 0.5.h, bottom: 0.5.h),
                  width: 25.w,
                  height: 11.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: primaryColor,
                        width: 1), // border color and width
                    borderRadius: BorderRadius.circular(
                        Device.screenType == sizer.ScreenType.mobile
                            ? 3.5.w
                            : 2.5.w),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        Device.screenType == sizer.ScreenType.mobile
                            ? 3.5.w
                            : 2.5.w),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      height: 18.h,
                      imageUrl: item.visitingCardUrl,
                      placeholder: (context, url) => Center(
                        child: Image.asset(Asset.itemPlaceholder,
                            height: 10.h, fit: BoxFit.cover),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                          Asset.itemPlaceholder,
                          height: 10.h,
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
                Positioned(
                    top: 0.2.h,
                    right: -2,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: white,
                      ),
                      child: SvgPicture.asset(
                        Asset.badge,
                        color: blue,
                      ),
                    )),
                // item.isEmailVerified
                //     ?

                // : SizedBox.shrink()
              ],
            ),
            getDynamicSizedBox(width: 2.w),
            Expanded(
              child: Container(
                height: 11.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      // height: 4.h,
                      width: Device.screenType == sizer.ScreenType.mobile
                          ? 58.w
                          : 65.w,
                      child: Text(
                          // 'asdaiyutasypudsgsaudgasgasdadsdjhdgasbaosdoas',

                          item.businessName,
                          maxLines: 2,
                          style: TextStyle(
                              fontFamily: dM_sans_semiBold,
                              fontSize: 15.sp,
                              height: 1.1,
                              overflow: TextOverflow.ellipsis,
                              color: black,
                              fontWeight: FontWeight.w900)),
                    ),
                    getDynamicSizedBox(height: 1.h),
                    SizedBox(
                      // height: 2.h,
                      width: Device.screenType == sizer.ScreenType.mobile
                          ? 58.w
                          : 70.w,
                      child: Text(item.name,
                          maxLines: 1,
                          style: TextStyle(
                              height: 1.1,
                              fontFamily: dM_sans_semiBold,
                              fontSize: 14.sp,
                              color: black,
                              fontWeight: FontWeight.w500)),
                    ),
                    getDynamicSizedBox(height: 1.h),
                    SizedBox(
                      // height: 4.h,
                      width: Device.screenType == sizer.ScreenType.mobile
                          ? 58.w
                          : 65.w,
                      child: Text(
                          // 'asdaiyutasypudsgsaudgasgasdadsdjhdgasbaosdoas',

                          item.address.isNotEmpty
                              ? item.address
                              : item.city != null
                                  ? item.city!.city
                                  : item.phone,
                          maxLines: 2,
                          style: TextStyle(
                              height: 1.1,
                              fontFamily: dM_sans_semiBold,
                              fontSize: 14.sp,
                              color: black,
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Widget getBusinessListItem(BuildContext context, BusinessData item) {
//     return GestureDetector(
//       onTap: () async {
//         bool isEmpty = await isAnyFieldEmpty();
//         if (isEmpty) {
//           showBottomSheetPopup(context);
//         } else {
//           Get.to(BusinessDetailScreen(
//             item: item,
//             isFromProfile: false,
//           ));
//         }
//       },
//       child: Container(
//         margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
//         padding: EdgeInsets.all(3.w),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 3,
//               offset: Offset(0, 0),
//             ),
//           ],
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Visiting Card Image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(11),
//               child: CachedNetworkImage(
//                 imageUrl: item.visitingCardUrl,
//                 width: 18.w,
//                 height: 18.w,
//                 fit: BoxFit.cover,
//                 placeholder: (context, url) => Container(
//                   width: 18.w,
//                   height: 18.w,
//                   alignment: Alignment.center,
//                   child: CircularProgressIndicator(strokeWidth: 2),
//                 ),
//                 errorWidget: (context, url, error) => Image.asset(
//                   Asset.placeholder,
//                   width: 18.w,
//                   height: 18.w,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             SizedBox(width: 4.w),

//             // Text Info with Heart Icon
//             Expanded(
//               child: Stack(
//                 children: [
//                   Padding(
//                     padding:
//                         EdgeInsets.only(right: 6.w), // Leave space for heart
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Business Name
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Icon(Icons.business, size: 16, color: primaryColor),
//                             SizedBox(width: 1.w),
//                             Expanded(
//                               child: Text(
//                                 item.businessName,
//                                 style: TextStyle(
//                                   fontSize: 15.sp,
//                                   fontFamily: dM_sans_semiBold,
//                                   fontWeight: FontWeight.w700,
//                                   color: primaryColor,
//                                 ),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 0.5.h),

//                         // Owner Name
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Icon(Icons.person, size: 16, color: primaryColor),
//                             SizedBox(width: 1.w),
//                             Expanded(
//                               child: Text(
//                                 item.name,
//                                 style: TextStyle(
//                                   fontSize: 13.5.sp,
//                                   fontFamily: dM_sans_semiBold,
//                                   color: primaryColor,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 0.5.h),

//                         // Address
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Icon(Icons.location_on,
//                                 size: 16, color: primaryColor),
//                             SizedBox(width: 1.w),
//                             Expanded(
//                               child: Text(
//                                 item.address.isNotEmpty
//                                     ? item.address
//                                     : item.city?.city ?? item.phone,
//                                 style: TextStyle(
//                                   fontSize: 13.5.sp,
//                                   fontFamily: dM_sans_semiBold,
//                                   color: primaryColor,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Heart Icon (top-right corner)
//                   Positioned(
//                     top: 0,
//                     right: 0,
//                     child: GestureDetector(
//                       onTap: () {
//                         // TODO: Add your favorite toggle logic here
//                       },
//                       child: Icon(
//                         Icons
//                             .favorite_border, // Replace with Icons.favorite if active
//                         color: Colors.grey,
//                         size: 22.sp,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
  // getBusinessListItem(BuildContext context, BusinessData item) {
  //   return GestureDetector(
  //     onTap: () async {
  //       bool isEmpty = await isAnyFieldEmpty();
  //       if (isEmpty) {
  //         // ignore: use_build_context_synchronously
  //         showBottomSheetPopup(context);
  //       } else {
  //         Get.to(BusinessDetailScreen(
  //           item: item,
  //           isFromProfile: false,
  //         ))!
  //             .then((value) {
  //           currentPage = 1;
  //           futureDelay(() {
  //             getBusinessList(context, currentPage, false, isFirstTime: true);
  //           }, isOneSecond: false);
  //         });
  //       }
  //     },
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: white,
  //         borderRadius: const BorderRadius.all(Radius.circular(10)),
  //         boxShadow: [
  //           BoxShadow(
  //               color: black.withOpacity(0.2),
  //               spreadRadius: 0.1,
  //               blurRadius: 5,
  //               offset: const Offset(0.5, 0.5)),
  //         ],
  //       ),
  //       margin: EdgeInsets.only(left: 3.w, right: 3.w, bottom: 2.h),
  //       child: Padding(
  //         padding:
  //             EdgeInsets.only(left: 2.w, right: 2.w, top: 0.2.h, bottom: 0.2.h),
  //         child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(2),
  //               margin: EdgeInsets.only(top: 0.5.h, bottom: 0.5.h),
  //               width: 25.w,
  //               height: 11.h,
  //               decoration: BoxDecoration(
  //                 border: Border.all(
  //                     color: primaryColor, width: 1), // border color and width
  //                 borderRadius: BorderRadius.circular(
  //                     Device.screenType == sizer.ScreenType.mobile
  //                         ? 3.5.w
  //                         : 2.5.w),
  //               ),
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(
  //                     Device.screenType == sizer.ScreenType.mobile
  //                         ? 3.5.w
  //                         : 2.5.w),
  //                 child: CachedNetworkImage(
  //                   fit: BoxFit.cover,
  //                   height: 18.h,
  //                   imageUrl: item.visitingCardUrl,
  //                   placeholder: (context, url) => Image.asset(
  //                     Asset.bussinessPlaceholder,
  //                     // width: 3.w,
  //                   ),
  //                   // const Center(
  //                   //     child: CircularProgressIndicator(color: primaryColor)),
  //                   errorWidget: (context, url, error) => Image.asset(
  //                       Asset.bussinessPlaceholder,
  //                       height: 10.h,
  //                       fit: BoxFit.cover),
  //                 ),
  //               ),
  //             ),
  //             getDynamicSizedBox(width: 2.w),
  //             Expanded(
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(item.businessName,
  //                       maxLines: 1,
  //                       style: TextStyle(
  //                           fontFamily: dM_sans_semiBold,
  //                           overflow: TextOverflow.ellipsis,
  //                           fontSize: 15.sp,
  //                           color: black,
  //                           fontWeight: FontWeight.w900)),
  //                   // Row(
  //                   //   mainAxisAlignment: MainAxisAlignment.center,
  //                   //   crossAxisAlignment: CrossAxisAlignment.center,
  //                   //   children: [
  //                   //     Text(item.businessName,
  //                   //         style: TextStyle(
  //                   //             fontFamily: dM_sans_semiBold,
  //                   //             fontSize: 15.sp,
  //                   //             color: black,
  //                   //             fontWeight: FontWeight.w900)),
  //                   //     const Spacer(),
  //                   //     RatingBar.builder(
  //                   //       initialRating: item.businessReviewsAvgRating ?? 0.0,
  //                   //       minRating: 1,
  //                   //       direction: Axis.horizontal,
  //                   //       allowHalfRating: true,
  //                   //       itemCount: 1,
  //                   //       itemSize: 3.5.w,
  //                   //       unratedColor: Colors.orange,
  //                   //       itemBuilder: (context, _) => const Icon(
  //                   //         Icons.star,
  //                   //         color: Colors.orange,
  //                   //       ),
  //                   //       onRatingUpdate: (rating) {
  //                   //         logcat("RATING", rating);
  //                   //       },
  //                   //     ),
  //                   //     getText(
  //                   //       item.businessReviewsAvgRating != null
  //                   //           ? (item.businessReviewsAvgRating ?? 0.0)
  //                   //               .toStringAsFixed(1)
  //                   //           : '0.0',
  //                   //       TextStyle(
  //                   //           fontFamily: fontSemiBold,
  //                   //           color: lableColor,
  //                   //           fontSize:
  //                   //               Device.screenType == sizer.ScreenType.mobile
  //                   //                   ? 14.sp
  //                   //                   : 7.sp,
  //                   //           height: 1.2),
  //                   //     ),
  //                   //   ],
  //                   // ),
  //                   getDynamicSizedBox(height: 1.h),
  //                   Text(item.name,
  //                       style: TextStyle(
  //                           fontFamily: dM_sans_semiBold,
  //                           fontSize: 14.sp,
  //                           color: black,
  //                           fontWeight: FontWeight.w500)),
  //                   getDynamicSizedBox(height: 1.h),
  //                   Text(
  //                       item.address.isNotEmpty
  //                           ? item.address
  //                           : item.city != null
  //                               ? item.city!.city
  //                               : item.phone,
  //                       maxLines: 2,
  //                       style: TextStyle(
  //                           fontFamily: dM_sans_semiBold,
  //                           fontSize: 14.sp,
  //                           color: black,
  //                           fontWeight: FontWeight.w500)),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
