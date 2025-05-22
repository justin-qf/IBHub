import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/Repository.dart';
import 'package:ibh/componant/dialogs/customDialog.dart';
import 'package:ibh/componant/dialogs/dialogs.dart';
import 'package:ibh/componant/dialogs/loading_indicator.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/configs/apicall_constant.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/internet_controller.dart';
import 'package:ibh/models/productModel.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/log.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';
import 'package:sizer/sizer.dart' as sizer;

class ProductController extends GetxController {
  final InternetController networkManager = Get.find<InternetController>();
  Rx<ScreenState> state = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  var currentPage = 1;
  RxString nextPageURL = "".obs;
  final ScrollController scrollController = ScrollController();
  bool isFetchingMore = false;
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  late TextEditingController searchCtr = TextEditingController();
  RxList productList = [].obs;
  bool isSearch = false;

  getProductList(context, currentPage, bool hideloading,
      {bool? isFirstTime = false, String? search = ""}) async {
    if (hideloading == false) {
      state.value = ScreenState.apiLoading;
    }
    try {
      if (networkManager.connectionType.value == 0) {
        showDialogForScreen(
            context, ProductScreenConst.title, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }

      var pageURL = '${ApiUrl.product}?page=$currentPage';
      // var response =
      //     await Repository.post({'search': search}, pageURL, allowHeader: true);
      var response = await Repository.get({}, pageURL, allowHeader: true);

      logcat("RESPONSE::", response.body);
      var responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseData['success'] == true) {
          state.value = ScreenState.apiSuccess;
          message.value = '';
          var productData = ProductModel.fromJson(responseData);
          if (isFirstTime == true && productList.isNotEmpty) {
            currentPage = 1;
            productList.clear();
          }
          if (productData.data.data.isNotEmpty) {
            productList.addAll(productData.data.data);
            productList.refresh();
            update();
          } else {
            productList.clear();
          }
          if (productData.data.nextPageUrl != null) {
            nextPageURL.value = productData.data.nextPageUrl.toString();
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
              context, ProductScreenConst.title, responseData['message'],
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(context, ProductScreenConst.title,
            responseData['message'] ?? ServerError.servererror,
            callback: () {});
      }
    } catch (e) {
      currentPage = 1;
      logcat("Ecxeption", e);
      state.value = ScreenState.apiError;
      // message.value = ServerError.servererror;
    }
  }

  deleteProduct(context, id) async {
    var loadingIndicator = LoadingProgressDialogs();
    loadingIndicator.show(context, '');
    try {
      if (networkManager.connectionType.value == 0) {
        loadingIndicator.hide(context);
        showDialogForScreen(
            context, ProductScreenConst.title, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }
      // print('my category id + ${id}');
      var response = await Repository.delete('${ApiUrl.deleteProduct}$id',
          allowHeader: true);

      loadingIndicator.hide(context);
      var result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (result['success'] == true) {
          showDialogForScreen(
              context, ProductScreenConst.title, result['message'],
              callback: () {
            currentPage = 1;
            getProductList(context, currentPage, false, isFirstTime: true);
          });
        } else {
          showDialogForScreen(
              context, ProductScreenConst.title, result['message'],
              callback: () {});
        }
      } else {
        showDialogForScreen(
            context, ProductScreenConst.title, result['message'],
            callback: () {});
      }
    } catch (e) {
      loadingIndicator.hide(context);
      logcat("Delete Service Exception", e.toString());
      showDialogForScreen(
          context, ProductScreenConst.title, Connection.servererror,
          callback: () {});
    }
  }

  void changeStatusAPI(context, String status, String productId) async {
    var loadingIndicator = LoadingProgressDialogs();
    loadingIndicator.show(context, 'Changing status...');
    try {
      // Check for network connection
      if (networkManager.connectionType.value == 0) {
        loadingIndicator.hide(context);
        showDialogForScreen(
            context, ProductScreenConst.title, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }

      var response = await Repository.put(
          {"status": status.trim()}, '${ApiUrl.changeProductStatus}/$productId',
          allowHeader: true);

      loadingIndicator.hide(context);
      var result = jsonDecode(response.body);
      logcat("statusCode::", response.statusCode.toString());
      if (response.statusCode == 200) {
        if (result['success'] == true) {
          currentPage = 1;
          getProductList(context, currentPage, false, isFirstTime: true);
        } else {
          showDialogForScreen(context, ProductScreenConst.title,
              result['message'] ?? 'Unknown error occurred.',
              callback: () {});
        }
      } else {
        showDialogForScreen(context, ProductScreenConst.title,
            result['message'] ?? 'Unknown error occurred.',
            callback: () {});
      }
    } catch (e) {
      logcat("Exception", e.toString());
      showDialogForScreen(
          context, ProductScreenConst.title, ServerError.servererror,
          callback: () {});
    } finally {
      loadingIndicator.hide(context);
    }
  }

  getProductItem(BuildContext context, ProductListData data) {
    return GestureDetector(
      onTap: () {
        // Get.to(CategoryBusinessScreen(data))!.then((value) {});
      },
      child: Container(
        height: 25.h,
        width: 3.w,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: white,
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
              height: 20.h,
              width: Device.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: data.images[0],
                  placeholder: (context, url) => Image.asset(
                    Asset.bussinessPlaceholder,
                    height: 15.h,
                    fit: BoxFit.contain,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                      Asset.bussinessPlaceholder,
                      height: 15.h,
                      fit: BoxFit.contain),
                ),
              ),
            ),
            getDynamicSizedBox(height: 1.3.h),
            Center(
              child: Text(data.name.capitalize.toString(),
                  maxLines: 1,
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontFamily: dM_sans_semiBold,
                      fontWeight: FontWeight.w500,
                      color: black,
                      fontSize: Device.screenType == sizer.ScreenType.mobile
                          ? 15.sp
                          : 12.sp,
                      height: 1.2)),
            ),
          ],
        ),
      ),
    );
  }

  getProductListItem(BuildContext context, ProductListData item) {
    return Container(
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
      padding: EdgeInsets.only(left: 2.w, right: 2.w, top: 1.h, bottom: 1.h),
      margin: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              // getServiceDetails(context, item);
            },
            child: Container(
              // padding: const EdgeInsets.all(2),
              margin: EdgeInsets.only(top: 0.5.h, bottom: 0.5.h),
              width: 25.w,
              height: 12.h,
              decoration: BoxDecoration(
                border: Border.all(
                    color: primaryColor, width: 1), // border color and width
                borderRadius: BorderRadius.circular(
                    Device.screenType == sizer.ScreenType.mobile
                        ? 3.6.w
                        : 2.5.w),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    Device.screenType == sizer.ScreenType.mobile
                        ? 3.5.w
                        : 2.5.w),
                child: CachedNetworkImage(
                  fit: BoxFit.contain,
                  height: 17.h,
                  imageUrl: item.images[0],
                  placeholder: (context, url) =>
                      Image.asset(Asset.bussinessPlaceholder),
                  errorWidget: (context, url, error) => Image.asset(
                      Asset.placeholder,
                      height: 10.h,
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          getDynamicSizedBox(width: 2.w),
          GestureDetector(
            onTap: () {
              // getServiceDetails(context, item);
            },
            child: Container(
              padding: const EdgeInsets.all(0),
              color: white,
              height: 13.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getDynamicSizedBox(height: 0.5.h),
                  SizedBox(
                      width: 45.w,
                      // height: 2.h,
                      child: Text(
                          // 'dasgasdogasdhsad;asdhkadhasddastdlkjgagakldfgad',
                          maxLines: 1,
                          item.name,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontFamily: dM_sans_semiBold,
                              fontSize: 15.sp,
                              color: black,
                              fontWeight: FontWeight.w900))),
                  getDynamicSizedBox(height: 0.2.h),
                  Row(
                    children: [
                      Icon(
                        Icons.folder,
                        size: 18.sp,
                      ),
                      getDynamicSizedBox(width: 0.5.w),
                      SizedBox(
                        width: 45.w,
                        child: Text(item.category.name,
                            maxLines: 1,
                            style: TextStyle(
                                fontFamily: dM_sans_semiBold,
                                fontSize: 14.sp,
                                color: black,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                  getDynamicSizedBox(height: 0.2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // if (item.description.isNotEmpty)
                      //   Icon(
                      //     Icons.description,
                      //     size: 18.sp,
                      //   ),
                      getDynamicSizedBox(width: 0.5.w),
                      SizedBox(
                        width: 45.w,
                        child: AbsorbPointer(
                            absorbing: true,
                            child: ReadMoreText(item.description,
                                textAlign: TextAlign.start,
                                trimLines: 3, callback: (val) {
                              logcat("ONTAP", val.toString());
                            },
                                colorClickableText: primaryColor,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: '...Show more',
                                trimExpandedText: '',
                                delimiter: ' ',
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: Device.screenType ==
                                            sizer.ScreenType.mobile
                                        ? 14.sp
                                        : 12.sp,
                                    fontWeight: FontWeight.w100,
                                    fontFamily: dM_sans_semiBold,
                                    color: primaryColor),
                                lessStyle: TextStyle(
                                    fontFamily: dM_sans_semiBold,
                                    fontSize: Device.screenType ==
                                            sizer.ScreenType.mobile
                                        ? 14.sp
                                        : 12.sp),
                                moreStyle: TextStyle(
                                    fontFamily: dM_sans_semiBold,
                                    fontSize: Device.screenType ==
                                            sizer.ScreenType.mobile
                                        ? 14.sp
                                        : 12.sp,
                                    color: primaryColor))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  // print('goto add service screen');
                  // Get.to(AddServicescreen(
                  //   item: item,
                  //   isFromHomeScreen: true,
                  // ))?.then((value) {
                  //   if (value == true) {
                  //     if (!context.mounted) return;
                  //     getServiceList(context, 1, true, bussinessID.value,
                  //         isFirstTime: true);
                  //   }
                  // });
                },
                child: Container(
                  margin: const EdgeInsets.all(3),
                  child: Icon(
                    Icons.edit,
                    size: 18.sp,
                  ),
                ),
              ),
              getDynamicSizedBox(height: isSmallDevice(context) ? 0.h : 0.3.h),
              GestureDetector(
                onTap: () async {
                  await deleteDialogs(
                    context,
                    isFromProduct: true,
                    function: () {
                      deleteProduct(context, item.id);
                    },
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(3),
                  child: Icon(
                    Icons.delete,
                    size: 18.sp,
                    color: red,
                  ),
                ),
              ),
              SizedBox(
                height: 3.h,
                width: 10.w,
                child: Transform.scale(
                  scale: 3.sp,
                  child: SwitchListTile(
                    activeColor: primaryColor,
                    dense: true,
                    // value: item.isActive.value == 1,
                    value: item.status,
                    onChanged: (value) {
                      bool newStatus = item.status == true ? true : false;
                      changeStatusAPI(context, "1", item.id.toString());
                      update();
                    },
                  ),
                ),
              )
              // Obx(() {
              //   return SizedBox(
              //     height: 3.h,
              //     width: 10.w,
              //     child: Transform.scale(
              //       scale: 3.sp,
              //       child: SwitchListTile(
              //         activeColor: primaryColor,
              //         dense: true,
              //         // value: item.isActive.value == 1,
              //         value: true,
              //         onChanged: (value) {
              //           // int newStatus = item.isActive.value == 0 ? 1 : 0;
              //           // toggleActiveStatus(
              //           //   context,
              //           //   statusID: newStatus.toString(),
              //           //   serviceId: item.id.toString(),
              //           // );
              //           // update();
              //         },
              //       ),
              //     ),
              //   );
              // })
            ],
          )
        ],
      ),
    );
  }
}
