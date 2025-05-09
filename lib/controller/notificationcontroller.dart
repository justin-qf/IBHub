import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/Repository.dart';
import 'package:ibh/api_handle/apiCallingFormate.dart';
import 'package:ibh/componant/dialogs/customDialog.dart';
import 'package:ibh/componant/dialogs/dialogs.dart';
import 'package:ibh/componant/dialogs/loading_indicator.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/configs/apicall_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/internet_controller.dart';
import 'package:ibh/models/notificationModel.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/log.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';
import 'package:sizer/sizer.dart' as sizer;

class Notificationcontroller extends GetxController {
  final InternetController networkManager = Get.find<InternetController>();

  Rx<ScreenState> state = ScreenState.apiLoading.obs;

  RxList<NotificationDataMessages> notificationDataMessages =
      <NotificationDataMessages>[].obs;
  RxBool isNotificationApiCallLoading = false.obs;
  RxString nextPageURL = "".obs;
  bool isFetchingMore = false;
  var currentPage = 0;
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController scrollController = ScrollController();
  RxString message = "".obs;

  getnotificationAPi(BuildContext context, currentPage, bool hideloading,
      {bool? isFirstTime = false}) async {
    if (hideloading == false) {
      state.value = ScreenState.apiLoading;
    }

    try {
      if (networkManager.connectionType.value == 0) {
        showDialogForScreen(context, 'Notification', Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }

      var pageURL = '${ApiUrl.notification}?page=$currentPage';

      var response = await Repository.get({}, pageURL, allowHeader: true);

      var responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData['success'] == true) {
          state.value = ScreenState.apiSuccess;
          message.value = '';

          var notificationList = NotificationApi.fromJson(responseData);
          if (isFirstTime == true && notificationDataMessages.isNotEmpty) {
            currentPage = 1;
            notificationDataMessages.clear();
          }

          if (notificationList.data!.data!.isNotEmpty) {
            notificationDataMessages.addAll(notificationList.data!.data!);
            notificationDataMessages.refresh();
            update();
          } else {
            notificationDataMessages.clear();
          }
          if (notificationList.data!.nextPageUrl != null) {
            nextPageURL.value = notificationList.data!.nextPageUrl.toString();
            update();
          } else {
            nextPageURL.value = "";
            update();
          }
        } else {
          message.value = responseData['message'];
          showDialogForScreen(context, 'Favourite Screen',
              responseData['message'] ?? ServerError.servererror,
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(context, 'Favourite Screen',
            responseData['message'] ?? ServerError.servererror,
            callback: () {});
      }
    } catch (e) {
      state.value = ScreenState.apiError;
    }
    // commonGetApiCallFormate(context,
    //     title: 'Notifications',
    //     apiEndPoint: ApiUrl.notification,
    //     allowHeader: true, apisLoading: (istrue) {
    //   isNotificationApiCallLoading.value = istrue;
    // }, onResponse: (response) {
    //   var data = NotificationApi.fromJson(response);
    //   notificationDataMessages.value = data.data!.data!;

    //   logcat("Notification_Response", jsonEncode(notificationDataMessages));

    //   update();
    // }, networkManager: networkManager);
  }

  // notificationList(BuildContext context, NotificationDataMessages item) {
  //   return Container(
  //     height: 15.5.h,
  //     decoration: BoxDecoration(
  //         color: white,
  //         borderRadius: BorderRadius.circular(10),
  //         boxShadow: [
  //           BoxShadow(
  //               color: primaryColor.withOpacity(0.2),
  //               blurRadius: 10.0,
  //               offset: const Offset(0, 1),
  //               spreadRadius: 1.0)
  //         ]),
  //     margin: EdgeInsets.only(left: 2.w, right: 2.w, bottom: 2.h),
  //     child: Padding(
  //         padding: EdgeInsets.all(15),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   item.title!,
  //                   style: TextStyle(
  //                     fontSize: 17.sp,
  //                     fontFamily: dM_sans_semiBold,
  //                     color: primaryColor,
  //                   ),
  //                 ),
  //                 GestureDetector(
  //                   onTap: () async {
  //                     await deleteDialogs(
  //                       context,
  //                       function: () {
  //                         deleteNotification(context, item.id);
  //                       },
  //                     );
  //                     // if (isDeleted == true) {
  //                     //   if (!context.mounted) return;

  //                     // }
  //                   },
  //                   child: Container(
  //                     margin: EdgeInsets.all(3),
  //                     child: Icon(
  //                       Icons.delete,
  //                       size: 18.sp,
  //                       color: red,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             getDynamicSizedBox(height: 1.h),
  //             Text(
  //               maxLines: 3,
  //               item.message!,
  //               style: TextStyle(
  //                 overflow: TextOverflow.ellipsis,
  //                 fontFamily: dM_sans_medium,
  //               ),
  //             ),
  //           ],
  //         )),
  //   );
  // }
  Widget notificationList(BuildContext context, NotificationDataMessages item) {
    return Container(
      // Remove fixed height to allow dynamic sizing
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.2),
            blurRadius: 5.0,
            offset: const Offset(0, 0),
            // spreadRadius: 0.2,
          ),
        ],
      ),
      margin: EdgeInsets.only(left: 2.w, right: 2.w, bottom: 2.h),
      child: Padding(
        padding:
            EdgeInsets.only(left: 3.w, right: 3.w, top: 0.5.h, bottom: 0.5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.title ?? '',
                    style: TextStyle(
                      fontSize: 16.5.sp,
                      fontFamily: dM_sans_semiBold,
                      color: primaryColor,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await deleteDialogs(
                      context,
                      function: () {
                        deleteNotification(context, item.id);
                      },
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(3),
                    child: Icon(
                      Icons.delete,
                      size: 19.sp,
                      color: red,
                    ),
                  ),
                ),
              ],
            ),
            getDynamicSizedBox(height: 0.2.h),
            SizedBox(
              width: double.infinity, // Ensure full width for text
              child: ReadMoreText(
                item.message ?? '',
                textAlign: TextAlign.start,
                trimLines: 3,
                callback: (val) {
                  logcat("ReadMore", "Expanded: $val");
                },
                colorClickableText: primaryColor,
                trimMode: TrimMode.Line,
                trimCollapsedText: '...Show more',
                trimExpandedText: ' Show less',
                delimiter: ' ',
                style: TextStyle(
                  fontSize: Device.screenType == sizer.ScreenType.mobile
                      ? 15.sp
                      : 12.sp,
                  fontWeight: FontWeight.w100,
                  fontFamily: dM_sans_medium,
                  color: black, // Match original Text style
                ),
                moreStyle: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontFamily: dM_sans_semiBold,
                  fontSize: Device.screenType == sizer.ScreenType.mobile
                      ? 15.sp
                      : 12.sp,
                  color: primaryColor,
                ),
                lessStyle: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontFamily: dM_sans_semiBold,
                  fontSize: Device.screenType == sizer.ScreenType.mobile
                      ? 15.sp
                      : 12.sp,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  deleteNotification(context, id) async {
    var loadingIndicator = LoadingProgressDialogs();
    loadingIndicator.show(context, '');
    try {
      if (networkManager.connectionType.value == 0) {
        loadingIndicator.hide(context);
        showDialogForScreen(
            context, 'Notifications Screen', Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }
      // print('my category id + ${id}');
      var response = await Repository.delete('${ApiUrl.notificationDelete}$id',
          allowHeader: true);

      loadingIndicator.hide(context);
      var result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (result['success'] == true) {
          showDialogForScreen(
              context, 'Notifications Screen', result['message'], callback: () {
            currentPage = 1;
            getnotificationAPi(context, 1, true, isFirstTime: true);

            print('current page is: + ${currentPage}');
            // Get.back(result: true); // Go back and pass result true
          });
        } else {
          showDialogForScreen(
              context, 'Notifications Screen', result['message'],
              callback: () {});
        }
      } else {
        showDialogForScreen(context, 'Notifications Screen', result['message'],
            callback: () {});
      }
    } catch (e) {
      loadingIndicator.hide(context);
      logcat("Delete Service Exception", e.toString());
      showDialogForScreen(
          context, 'Notifications Screen', Connection.servererror,
          callback: () {});
    }
  }
}
