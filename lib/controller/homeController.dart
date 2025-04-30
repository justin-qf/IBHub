import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/Repository.dart';
import 'package:ibh/componant/dialogs/dialogs.dart';
import 'package:ibh/componant/dialogs/loading_indicator.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/configs/apicall_constant.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/models/businessListModel.dart';
import 'package:ibh/models/ServiceListModel.dart';
import 'package:ibh/models/categoryListModel.dart';
import 'package:ibh/models/categotyModel.dart';
import 'package:ibh/utils/helper.dart';
import 'package:ibh/utils/log.dart';
import 'package:ibh/views/mainscreen/HomeScreen/CategoryBusinessScreen.dart';
import 'package:ibh/views/mainscreen/ServiceScreen/BusinessDetailScreen.dart';
import 'package:marquee/marquee.dart';
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
                        color: grey, // Border color
                        width: 0.5, // Border width
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          height: 7.h,
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
                  ),
                  getDynamicSizedBox(height: 1.h),
                  item.name.length > 9
                      ? Expanded(
                          child: Marquee(
                              style: TextStyle(
                                fontFamily: dM_sans_regular,
                                color: black,
                                fontSize:
                                    Device.screenType == sizer.ScreenType.mobile
                                        ? 14.sp
                                        : 9.sp,
                              ),
                              text: item.name,
                              scrollAxis: Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              blankSpace:
                                  20.0, // Adjust the space between text repetitions
                              velocity: 50.0, // Adjust the scrolling speed
                              pauseAfterRound: const Duration(
                                  seconds:
                                      1), // Time to pause after each scroll
                              startPadding: 10.0, // Adjust the initial padding
                              accelerationDuration: const Duration(
                                  seconds: 1), // Duration for acceleration
                              accelerationCurve:
                                  Curves.linear, // Acceleration curve
                              decelerationDuration: const Duration(
                                  milliseconds:
                                      500), // Duration for deceleration
                              decelerationCurve: Curves.easeOut),
                        )
                      : Text(
                          item.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: dM_sans_regular,
                              color: black,
                              fontSize:
                                  Device.screenType == sizer.ScreenType.mobile
                                      ? 12.sp
                                      : 9.sp),
                        )
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
    try {
      if (networkManager.connectionType.value == 0) {
        showDialogForScreen(
            context, HomeScreenconst.title, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }
      var response =
          await Repository.get({}, ApiUrl.getCategories, allowHeader: true);
      logcat("RESPONSE::", response.body);
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
          showDialogForScreen(
              context, HomeScreenconst.title, responseData['message'],
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        message.value =
            responseData['message'] ?? APIResponseHandleText.serverError;
        // showDialogForScreen(context, HomeScreenconst.title,
        //     responseData['message'] ?? ServerError.servererror,
        //     callback: () {});
      }
    } catch (e) {
      logcat("Ecxeption", e);
      state.value = ScreenState.apiError;
      message.value = ServerError.servererror;
      showDialogForScreen(
          context, HomeScreenconst.title, ServerError.servererror,
          callback: () {});
    }
  }

  RxList serviceList = [].obs;
  getServiceList(context, currentPage, bool hideloading) async {
    var loadingIndicator = LoadingProgressDialog();

    if (hideloading == true) {
      state.value = ScreenState.apiLoading;
    } else {
      loadingIndicator.show(context, '');
      update();
    }
    try {
      if (networkManager.connectionType.value == 0) {
        showDialogForScreen(
            context, CategoryScreenConstant.title, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }

      var pageURL = '${ApiUrl.getServiceList}?page=$currentPage';
      var response = await Repository.get({}, pageURL, allowHeader: true);
      if (hideloading != true) {
        loadingIndicator.hide(context);
      }
      logcat("RESPONSE::", response.body);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          state.value = ScreenState.apiSuccess;
          message.value = '';
          var serviceListData = ServiceListModel.fromJson(responseData);
          if (serviceListData.data.data.isNotEmpty) {
            serviceList.addAll(serviceListData.data.data);
            serviceList.refresh();
            update();
          }
          if (serviceListData.data.nextPageUrl != 'null' ||
              serviceListData.data.nextPageUrl != null) {
            nextPageURL.value = serviceListData.data.nextPageUrl.toString();
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
          showDialogForScreen(
              context, CategoryScreenConstant.title, responseData['message'],
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(
            context, CategoryScreenConstant.title, ServerError.servererror,
            callback: () {});
      }
    } catch (e) {
      logcat("Ecxeption", e);
      state.value = ScreenState.apiError;
      message.value = ServerError.servererror;
      if (hideloading != true) {
        loadingIndicator.hide(context);
      }
      showDialogForScreen(
          context, CategoryScreenConstant.title, ServerError.servererror,
          callback: () {});
    }
  }

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
    try {
      if (networkManager.connectionType.value == 0) {
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
      logcat("RESPONSE::", response.body);
      var responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseData['success'] == true) {
          state.value = ScreenState.apiSuccess;
          message.value = '';
          if (isFirstTime == true && businessList.isNotEmpty) {
            businessList.clear();
          }
          var businessListData = BusinessModel.fromJson(responseData);
          if (businessListData.data.data.isNotEmpty) {
            businessList.addAll(businessListData.data.data);
            businessList.refresh();
            update();
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
          showDialogForScreen(
              context, CategoryScreenConstant.title, responseData['message'],
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(context, HomeScreenconst.title,
            responseData['message'] ?? ServerError.servererror,
            callback: () {});
      }
    } catch (e) {
      logcat("Ecxeption", e);
      state.value = ScreenState.apiError;
      message.value = ServerError.servererror;
      // showDialogForScreen(
      //     context, CategoryScreenConstant.title, ServerError.servererror,
      //     callback: () {});
    }
  }

  getBusinessListItem(BuildContext context, BusinessData item) {
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
          ))!
              .then((value) {
            currentPage = 1;
            futureDelay(() {
              getBusinessList(context, currentPage, false, isFirstTime: true);
            }, isOneSecond: false);
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: black.withOpacity(0.2),
                spreadRadius: 0.1,
                blurRadius: 5,
                offset: const Offset(0.5, 0.5)),
          ],
        ),
        margin: EdgeInsets.only(left: 3.w, right: 3.w, bottom: 2.h),
        child: Padding(
          padding:
              EdgeInsets.only(left: 2.w, right: 2.w, top: 0.2.h, bottom: 0.2.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                margin: EdgeInsets.only(top: 0.5.h, bottom: 0.5.h),
                width: 25.w,
                height: 11.h,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey.withOpacity(0.8),
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
                    placeholder: (context, url) => Image.asset(
                      Asset.bussinessPlaceholder,
                      // width: 3.w,
                    ),
                    // const Center(
                    //     child: CircularProgressIndicator(color: primaryColor)),

                    errorWidget: (context, url, error) => Image.asset(
                        Asset.placeholder,
                        height: 10.h,
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              getDynamicSizedBox(width: 2.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.businessName,
                        maxLines: 1,
                        style: TextStyle(
                            fontFamily: dM_sans_semiBold,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 15.sp,
                            color: black,
                            fontWeight: FontWeight.w900)),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     Text(item.businessName,
                    //         style: TextStyle(
                    //             fontFamily: dM_sans_semiBold,
                    //             fontSize: 15.sp,
                    //             color: black,
                    //             fontWeight: FontWeight.w900)),
                    //     const Spacer(),
                    //     RatingBar.builder(
                    //       initialRating: item.businessReviewsAvgRating ?? 0.0,
                    //       minRating: 1,
                    //       direction: Axis.horizontal,
                    //       allowHalfRating: true,
                    //       itemCount: 1,
                    //       itemSize: 3.5.w,
                    //       unratedColor: Colors.orange,
                    //       itemBuilder: (context, _) => const Icon(
                    //         Icons.star,
                    //         color: Colors.orange,
                    //       ),
                    //       onRatingUpdate: (rating) {
                    //         logcat("RATING", rating);
                    //       },
                    //     ),
                    //     getText(
                    //       item.businessReviewsAvgRating != null
                    //           ? (item.businessReviewsAvgRating ?? 0.0)
                    //               .toStringAsFixed(1)
                    //           : '0.0',
                    //       TextStyle(
                    //           fontFamily: fontSemiBold,
                    //           color: lableColor,
                    //           fontSize:
                    //               Device.screenType == sizer.ScreenType.mobile
                    //                   ? 14.sp
                    //                   : 7.sp,
                    //           height: 1.2),
                    //     ),
                    //   ],
                    // ),
                    getDynamicSizedBox(height: 1.h),
                    Text(item.name,
                        style: TextStyle(
                            fontFamily: dM_sans_regular,
                            fontSize: 14.sp,
                            color: black,
                            fontWeight: FontWeight.w500)),
                    getDynamicSizedBox(height: 1.h),
                    Text(
                        item.address.isNotEmpty
                            ? item.address
                            : item.city != null
                                ? item.city!.city
                                : item.phone,
                        maxLines: 2,
                        style: TextStyle(
                            fontFamily: dM_sans_regular,
                            fontSize: 14.sp,
                            color: black,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
