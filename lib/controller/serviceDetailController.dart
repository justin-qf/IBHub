import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/Repository.dart';
import 'package:ibh/componant/dialogs/customDialog.dart';
import 'package:ibh/componant/dialogs/dialogs.dart';
import 'package:ibh/componant/dialogs/loading_indicator.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/apicall_constant.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/models/ServiceListModel.dart';
import 'package:ibh/utils/log.dart';
import 'package:ibh/views/mainscreen/ServiceScreen/AddServiceScreen.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart' as sizer;
import 'package:sizer/sizer.dart';
import '../utils/enum.dart';
import 'internet_controller.dart';

class ServiceDetailScreenController extends GetxController {
  Rx<ScreenState> state = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  final InternetController networkManager = Get.find<InternetController>();
  var pageController = PageController();
  var currentPage = 0;
  var quantity = 0;
  late Timer? timer =
      Timer.periodic(const Duration(seconds: 3), (Timer timer) {});
  RxBool? isFromFavApiCallSuccess = false.obs;
  late TabController tabController;
  int selectedTabIndex = 0;

  disposePageController() {
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }
    pageController.dispose();
  }

  void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  Rx<Color> bgColor = Rx<Color>(Colors.white); // Background color

// Function to calculate the contrast color (black or white)
  // Color getContrastColor(Color color) {
  //   double brightness =
  //       (color.red * 299 + color.green * 587 + color.blue * 114) / 1000;
  //   return brightness > 128 ? Colors.black : Colors.white;
  // }

// Function to get the dominant color from an image and set the contrast color

  RxBool isLoadingPalette = false.obs; // Add loading state

  Future<void> getImageColor({required String url}) async {
    try {
      isLoadingPalette.value = true; // Start loading
      final PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(
        NetworkImage(url),
      );

      // Set the background color
      bgColor.value = paletteGenerator.dominantColor?.color ?? Colors.white;
    } finally {
      isLoadingPalette.value = false; // Stop loading
    }
  }

  Widget getText(title, TextStyle? style) {
    return Padding(
      padding: EdgeInsets.only(left: 0.5.w, right: 0.5.w),
      child: Text(
        title,
        style: style,
        softWrap: true,
        maxLines: 2,
      ),
    );
  }

  Widget getLableText(text, {isMainTitle}) {
    return Text(text,
        //textAlign: TextAlign.center,
        style: TextStyle(
          color: black,
          fontFamily: isMainTitle == true ? fontBold : null,
          fontWeight: isMainTitle == true ? FontWeight.w900 : FontWeight.w500,
          fontSize: isMainTitle == true
              ? Device.screenType == sizer.ScreenType.mobile
                  ? 18.sp
                  : 14.sp
              : Device.screenType == sizer.ScreenType.mobile
                  ? 16.sp
                  : 14.sp,
        ));
  }

  getCategoryLable(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F2FF), // light blue background
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: black, // blue text
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget getCommonText(title, {bool? isHint}) {
    return Text(
      title,
      textAlign: TextAlign.justify,
      style: isHint == true
          ? TextStyle(
              fontFamily: dM_sans_medium,
              color: grey,
              fontSize: 16.sp,
            )
          : TextStyle(
              fontFamily: dM_sans_medium,
              color: black,
              fontSize:
                  Device.screenType == sizer.ScreenType.mobile ? 16.sp : 7.sp,
            ),
    );
  }

  Widget getTexts(title) {
    return Expanded(
      child: Text(
        title,
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontFamily: dM_sans_medium,
          color: black,
          height: 1.3,
          fontSize: Device.screenType == sizer.ScreenType.mobile ? 16.sp : 7.sp,
        ),
      ),
    );
  }

  Widget getColorText(title, {bool? isReviews}) {
    return Text(title,
        style: TextStyle(
          //fontFamily: fontBold,
          fontWeight: FontWeight.w400,
          color: isReviews == true ? primaryColor : Colors.green,
          fontSize: Device.screenType == sizer.ScreenType.mobile ? 10.sp : 7.sp,
        ));
  }

  RxList serviceList = [].obs;
  RxString nextPageURL = "".obs;
  var isServiceLoading = false.obs;
  getServiceList(context, currentPage, bool hideloading, businessId,
      {bool? isFirstTime = false}) async {
    var loadingIndicator = LoadingProgressDialog();
    // if (hideloading == true) {
    //   state.value = ScreenState.apiLoading;
    // } else {
    //   loadingIndicator.show(context, '');
    //   update();
    // }
    if (hideloading == false) {
      state.value = ScreenState.apiLoading;
    }
    isServiceLoading(true);
    try {
      if (networkManager.connectionType.value == 0) {
        showDialogForScreen(
            context, CategoryScreenConstant.title, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }

      // var pageURL = '${ApiUrl.getServiceList}/1?page=$currentPage';
      var pageURL = '${ApiUrl.getServiceList}/${businessId}?page=$currentPage';
      var response = await Repository.get({}, pageURL, allowHeader: true);
      // if (hideloading != true) {
      //   loadingIndicator.hide(context);
      // }
      logcat("RESPONSE::", response.body);
      isServiceLoading(false);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          state.value = ScreenState.apiSuccess;
          message.value = '';
          var serviceListData = ServiceListModel.fromJson(responseData);
          if (isFirstTime == true && serviceList.isNotEmpty) {
            serviceList.clear();
          }
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
      isServiceLoading(false);
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

  RxInt bussinessID = 0.obs;

  getServiceListItem(BuildContext context, ServiceDataList item,
      {isFromProfile = false}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
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
            padding: EdgeInsets.only(
                left: 2.w, right: 2.w, top: 0.2.h, bottom: 0.2.h),
            margin: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 2.h),
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
                          child:
                              CircularProgressIndicator(color: primaryColor)),
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
                              fontFamily: fontRegular,
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
                                  fontSize: Device.screenType ==
                                          sizer.ScreenType.mobile
                                      ? 15.sp
                                      : 12.sp,
                                  fontFamily: fontBold,
                                  color: grey),
                              lessStyle: TextStyle(
                                  fontFamily: fontMedium,
                                  fontSize: Device.screenType ==
                                          sizer.ScreenType.mobile
                                      ? 15.sp
                                      : 12.sp),
                              moreStyle: TextStyle(
                                  fontFamily: fontMedium,
                                  fontSize: Device.screenType ==
                                          sizer.ScreenType.mobile
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
        isFromProfile
            ? Positioned(
                top: 1.h,
                right: 7.w,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        print('goto add service screen');
                        Get.to(AddServicescreen(
                          item: item,
                          isFromHomeScreen: true,
                        ))?.then((value) {
                          if (value == true) {
                            if (!context.mounted) return;
                            getServiceList(context, 1, true, bussinessID.value,
                                isFirstTime: true);
                          }
                        });
                      },
                      child: Icon(
                        Icons.edit,
                        size: 20.sp,
                      ),
                    ),
                    getDynamicSizedBox(height: 5.h),
                    GestureDetector(
                      onTap: () async {
                        final isDeleted = await deleteDialogs(
                          context,
                          function: () {
                            deleteService(context);
                          },
                        );
                        // if (isDeleted == true) {
                        //   if (!context.mounted) return;

                        // }
                      },
                      child: Icon(
                        Icons.delete,
                        size: 20.sp,
                        color: red,
                      ),
                    ),
                  ],
                ),

                // Text(
                //   'Edit',
                //   style: TextStyle(
                //       fontFamily: dM_sans_semiBold,
                //       fontSize: 15.8.sp,
                //       color: black,
                //       fontWeight: FontWeight.w900),
                // ),
              )
            : SizedBox()
      ],
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

  deleteService(context) async {
    var loadingIndicator = LoadingProgressDialogs();
    loadingIndicator.show(context, '');
// try {
    if (networkManager.connectionType.value == 0) {
      loadingIndicator.hide(context);
      showDialogForScreen(context, AddServiceScreenViewConst.serviceScr,
          Connection.noConnection, callback: () {
        Get.back();
      });
      return;
    }
    print('my bussines id + ${bussinessID}');
    var response = await Repository.delete(
        '${ApiUrl.deleteService}$bussinessID',
        allowHeader: true);

    loadingIndicator.hide(context);
    var result = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (result['success'] == true) {
        showDialogForScreen(
            context, AddServiceScreenViewConst.serviceScr, result['message'],
            callback: () {
          getServiceList(context, 1, true, bussinessID.value,
              isFirstTime: true);
          // Get.back(result: true); // Go back and pass result true
        });
      } else {
        showDialogForScreen(
            context, AddServiceScreenViewConst.serviceScr, result['message'],
            callback: () {});
      }
    } else {
      showDialogForScreen(
          context, AddServiceScreenViewConst.serviceScr, result['message'],
          callback: () {});
    }
    // }

    // catch (e) {
    //   loadingIndicator.hide(context);
    //   logcat("Delete Service Exception", e.toString());
    //   showDialogForScreen(
    //       context, AddServiceScreenViewConst.serviceScr, Connection.servererror,
    //       callback: () {});
    // }
  }

  getListItem(BuildContext context, ServiceDataList item) {
    logcat("onCLick", "DONe");
    return GestureDetector(
      onTap: () {
        logcat("onCLick", "DONe");
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
}
