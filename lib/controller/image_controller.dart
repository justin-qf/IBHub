import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/Repository.dart';
import 'package:ibh/componant/dialogs/dialogs.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/configs/apicall_constant.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/BrandImageController.dart';
import 'package:ibh/controller/internet_controller.dart';
import 'package:ibh/models/imageModel.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/log.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sizer/sizer.dart';
import 'package:sizer/sizer.dart' as sizer;

class ImageController extends GetxController {
  final InternetController networkManager = Get.find<InternetController>();
  Rx<ScreenState> state = ScreenState.apiLoading.obs;
  RxString mobile = "".obs;
  RxString message = "".obs;
  var currentPage = 1;
  RxString nextPageURL = "".obs;
  final ScrollController scrollController = ScrollController();
  bool isFetchingMore = false;
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  late TextEditingController searchCtr = TextEditingController();
  RxList postImageList = [].obs;
  bool isSearch = false;
  var selectedLanguageCode = 'en'.obs; // default is English
  List<String> selectedChips = [];
  final List<String> chipLabels = ['English', 'Gujarati', 'Hindi'];
  final Map<String, String> labelToCode = {
    'English': 'en',
    'Gujarati': 'gu',
    'Hindi': 'hi',
  };

  getPostList(context, currentPage, bool hideloading,
      {bool? isFirstTime = false,
      String? selectedLabel = "",
      String categoryId = ""}) async {
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

      var pageURL = '${ApiUrl.getImageList}?page=$currentPage';
      var response = await Repository.postApi(
          {'category_id':int.parse(categoryId), "language": selectedLabel??''}, pageURL,
          allowHeader: true);

      logcat("PassingData::",
          {'category_id': categoryId, "language": selectedLabel});

      logcat("RESPONSE::", response.body);
      var responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseData['success'] == true) {
          state.value = ScreenState.apiSuccess;
          message.value = '';
          var categoryData = ImageModel.fromJson(responseData);
          if (isFirstTime == true && postImageList.isNotEmpty) {
            currentPage = 1;
            postImageList.clear();
          }
          if (categoryData.data.data.isNotEmpty) {
            postImageList.addAll(categoryData.data.data);
            postImageList.refresh();
            update();
          } else {
            postImageList.clear();
          }
          // categoryData.data.nextPageUrl != 'null' ||
          if (categoryData.data.nextPageUrl != null) {
            nextPageURL.value = categoryData.data.nextPageUrl.toString();
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
              context, 'Category Screen', responseData['message'],
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(context, 'Category Screen',
            responseData['message'] ?? ServerError.servererror,
            callback: () {});
      }
    } catch (e) {
      currentPage = 1;
      logcat("Ecxeption", e);
      state.value = ScreenState.apiError;
      // message.value = ServerError.servererror;
      // showDialogForScreen(
      //     context, CategoryScreenConstant.title, ServerError.servererror,
      //     callback: () {});
    }
  }

  // getListItem(CategoryListData data) {
  //   return Wrap(
  //     children: [
  //       GestureDetector(
  //         onTap: () {},
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.circular(
  //               Device.screenType == sizer.ScreenType.mobile ? 4.w : 2.2.w),
  //           child: Container(
  //             width: 45.w,
  //             margin: EdgeInsets.only(right: 2.w),
  //             padding: EdgeInsets.all(
  //               1.w,
  //             ),
  //             decoration: BoxDecoration(
  //               border: Border.all(
  //                 color: grey, // Border color
  //                 width: 0.5, // Border width
  //               ),
  //               color: white,
  //               borderRadius: BorderRadius.circular(
  //                   Device.screenType == sizer.ScreenType.mobile ? 4.w : 2.2.w),
  //             ),
  //             child: Stack(children: [
  //               // Background Image
  //               SizedBox(
  //                 width: double.infinity,
  //                 child: ClipRRect(
  //                   borderRadius: BorderRadius.circular(
  //                       Device.screenType == sizer.ScreenType.mobile
  //                           ? 3.5.w
  //                           : 2.5.w),
  //                   child: CachedNetworkImage(
  //                     fit: BoxFit.cover,
  //                     height: 18.h,
  //                     imageUrl: ApiUrl.imageUrl,
  //                     placeholder: (context, url) => const Center(
  //                       child: CircularProgressIndicator(color: primaryColor),
  //                     ),
  //                     errorWidget: (context, url, error) => Image.asset(
  //                       Asset.placeholder,
  //                       height: 10.h,
  //                       fit: BoxFit.cover,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               // Fog Shadow
  //               Positioned.fill(
  //                 child: ClipRRect(
  //                   borderRadius: BorderRadius.circular(
  //                       Device.screenType == sizer.ScreenType.mobile
  //                           ? 3.5.w
  //                           : 2.5.w),
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                       gradient: LinearGradient(
  //                         begin: Alignment.bottomCenter,
  //                         end: Alignment.topCenter,
  //                         // ignore: deprecated_member_use
  //                         colors: [black.withOpacity(0.6), transparent],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               // Title at Bottom Center
  //               Positioned(
  //                 bottom: 0,
  //                 left: 0,
  //                 right: 0,
  //                 child: Container(
  //                   padding:
  //                       EdgeInsets.only(left: 2.w, right: 2.w, bottom: 0.5.h),
  //                   child: Text(
  //                     data.name,
  //                     style: TextStyle(
  //                         fontFamily: dM_sans_semiBold,
  //                         fontWeight: FontWeight.w500,
  //                         color: white,
  //                         fontSize: Device.screenType == sizer.ScreenType.mobile
  //                             ? 12.sp
  //                             : 7.sp,
  //                         height: 1.2),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 ),
  //               ),
  //             ]),
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }

  getListItem(BuildContext context, BrandImageController controller,
      {required ImageData data}) {
    return GestureDetector(
      onTap: () {
        controller.setSelectedImage(data.imgPath);
        // Get.to(CategoryBusinessScreen(data))!.then((value) {});
      },
      child: Container(
        width: 5.w,
        height: 5.h,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // Shadow color
              spreadRadius: 1, // Spread radius
              blurRadius: 5, // Blur radius
              offset: const Offset(0, 3), // Position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: black),
                  borderRadius: BorderRadius.circular(10)),
              height: 8.h,
              width: Device.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: data.imgPath,
                  placeholder: (context, url) => Image.asset(
                    Asset.bussinessPlaceholder,
                    height: 9.h,
                    fit: BoxFit.contain,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    Asset.bussinessPlaceholder,
                    height: 9.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            getDynamicSizedBox(height: 1.3.h),
            Center(
              child: Text(data.title,
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontFamily: dM_sans_semiBold,
                      fontWeight: FontWeight.w500,
                      color: black,
                      fontSize: Device.screenType == sizer.ScreenType.mobile
                          ? 13.sp
                          : 12.sp,
                      height: 1.2)),
            ),
          ],
        ),
      ),
    );
  }

  // getServiceDetails(BuildContext context, CategoryListData data) {
  //   return commonDetailsDialog(
  //     context,
  //     "Category Details",
  //     isDescription: false,
  //     contain: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //       if (data.thumbnail.isNotEmpty)
  //         getImageView(data.thumbnail.isNotEmpty && data.thumbnail.isNotEmpty
  //             ? data.thumbnail
  //             : ""),
  //       getDynamicSizedBox(height: data.thumbnail.isNotEmpty ? 1.h : 0.0),
  //       getPartyDetailRow(
  //           context, 'Category:', data.name.capitalize.toString()),
  //       getDynamicSizedBox(height: data.thumbnail.isNotEmpty ? 1.h : 0.0),
  //       getPartyDetailRow(
  //           context, 'Description:', data.description.capitalize.toString(),
  //           isAddress: true),
  //     ]),
  //   );
  // }
}
