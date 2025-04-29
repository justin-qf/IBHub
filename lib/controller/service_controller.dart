import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/Repository.dart';
import 'package:ibh/componant/dialogs/dialogs.dart';
import 'package:ibh/componant/dialogs/loading_indicator.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/apicall_constant.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/internet_controller.dart';
import 'package:ibh/models/ServiceListModel.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/log.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';
import 'package:sizer/sizer.dart' as sizer;

class ServiceController extends GetxController {
  final InternetController networkManager = Get.find<InternetController>();
  Rx<ScreenState> state = ScreenState.apiLoading.obs;
  RxString mobile = "".obs;
  RxString message = "".obs;
  var currentPage = 1;
  RxString nextPageURL = "".obs;
  final ScrollController scrollController = ScrollController();
  bool isFetchingMore = false;

  RxList serviceList = [].obs;
  getServiceList(context, currentPage, bool hideloading, businessId,
      {bool? isFirstTime = false}) async {
    var loadingIndicator = LoadingProgressDialog();

    if (hideloading == false) {
      state.value = ScreenState.apiLoading;
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

      var pageURL = '${ApiUrl.getServiceList}/${businessId}?page=$currentPage';
      var response = await Repository.get({}, pageURL, allowHeader: true);

      logcat("RESPONSE::", response.body);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          state.value = ScreenState.apiSuccess;
          message.value = '';
          // serviceList.clear();
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

  getServiceListItem(BuildContext context, ServiceDataList item) {
    return GestureDetector(
      onTap: () {
        getServiceDetails(context, item);
        // Get.to(BusinessDetailScreen(item: item));
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
                height: 12.h,
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
                    imageUrl: item.thumbnail,
                    placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(color: primaryColor)),
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
                    Text(item.categoryName,
                        style: TextStyle(
                            fontFamily: dM_sans_semiBold,
                            fontSize: 15.8.sp,
                            color: black,
                            fontWeight: FontWeight.w900)),
                    getDynamicSizedBox(height: 1.h),
                    Text(item.categoryName,
                        style: TextStyle(
                            fontFamily: dM_sans_regular,
                            fontSize: 15.sp,
                            color: black,
                            fontWeight: FontWeight.w500)),
                    getDynamicSizedBox(height: 1.h),
                    AbsorbPointer(
                        absorbing: true,
                        child: ReadMoreText(item.description,
                            textAlign: TextAlign.start,
                            trimLines: 2, callback: (val) {
                          logcat("ONTAP", val.toString());
                        },
                            colorClickableText: primaryColor,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: '...Show more',
                            trimExpandedText: '',
                            delimiter: ' ',
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize:
                                    Device.screenType == sizer.ScreenType.mobile
                                        ? 15.sp
                                        : 12.sp,
                                fontFamily: dM_sans_bold,
                                color: grey),
                            lessStyle: TextStyle(
                                fontFamily: dM_sans_medium,
                                fontSize:
                                    Device.screenType == sizer.ScreenType.mobile
                                        ? 15.sp
                                        : 12.sp),
                            moreStyle: TextStyle(
                                fontFamily: dM_sans_medium,
                                fontSize:
                                    Device.screenType == sizer.ScreenType.mobile
                                        ? 15.sp
                                        : 12.sp,
                                color: primaryColor))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getListItem(BuildContext context, ServiceDataList item) {
    return GestureDetector(
      onTap: () {
        // Get.to(BusinessDetailScreen(item: item));
      },
      child: Container(
        height: 19.h,
        width: 32.w,
        margin: EdgeInsets.only(
          top: 1.h,
          left: Device.screenType == sizer.ScreenType.mobile ? 1.w : 0.5.w,
          right: Device.screenType == sizer.ScreenType.mobile ? 2.w : 1.0.w,
        ),
        padding: EdgeInsets.all(
            Device.screenType == sizer.ScreenType.mobile ? 1.1.w : 1.0.w),
        decoration: BoxDecoration(
          color: white,
          border: Border.all(
            color: primaryColor.withOpacity(0.8),
          ),
          borderRadius: BorderRadius.circular(
              Device.screenType == sizer.ScreenType.mobile ? 4.w : 2.2.w),
        ),
        child: GestureDetector(
          onTap: () {
            // Get.to(BusinessDetailScreen(item: item));
          },
          child: Column(children: [
            Container(
              height: 14.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: white,
                border: Border.all(
                  color: primaryColor.withOpacity(0.6),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: item.thumbnail.toString().isNotEmpty
                    ? ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: item.thumbnail,
                          placeholder: (context, url) => const Center(
                            child:
                                CircularProgressIndicator(color: primaryColor),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            Asset.placeholder,
                            height: 9.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Image.asset(
                        Asset.placeholder,
                        height: 9.h,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            getDynamicSizedBox(height: 0.5.h),
            SizedBox(
              height: 3.h,
              child: Text(
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                item.categoryName.toString(),
                style: TextStyle(fontSize: 16.sp),
              ),
            )
          ]),
        ),
      ),
    );
  }

  getServiceDetails(BuildContext context, ServiceDataList data) {
    return commonDetailsDialog(
      context,
      "Service Details",
      isDescription: false,
      contain: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        if (data.thumbnail.isNotEmpty)
          getImageView(data.thumbnail.isNotEmpty && data.thumbnail.isNotEmpty
              ? data.thumbnail
              : ""),
        getDynamicSizedBox(height: data.thumbnail.isNotEmpty ? 1.h : 0.0),
        getPartyDetailRow('Category:', data.categoryName.capitalize.toString()),
        getDynamicSizedBox(height: data.serviceTitle.isNotEmpty ? 1.h : 0.0),
        getPartyDetailRow('Service:', data.serviceTitle.capitalize.toString()),
        // getDynamicSizedBox(height: data.keywords.isNotEmpty ? 1.h : 0.0),
        // getPartyDetailRow('Keyword:', data.keywords.capitalize.toString()),
        getDynamicSizedBox(
            height: data.description.toString().isNotEmpty ? 0.5.h : 0.0),
        if (data.description.toString().isNotEmpty)
          getPartyDetailRow('Description:', data.description, isAddress: true),
      ]),
    );
  }
}
