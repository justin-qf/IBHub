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
import 'package:ibh/models/statusCheckModel.dart';
import 'package:ibh/models/pdfModel.dart';
import 'package:ibh/utils/helper.dart';
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
  var currentPage = 1;
  var quantity = 0;
  late Timer? timer =
      Timer.periodic(const Duration(seconds: 3), (Timer timer) {});
  RxBool? isFromFavApiCallSuccess = false.obs;
  late TabController tabController;
  int selectedTabIndex = 0;
  final ScrollController scrollController = ScrollController();
  RxBool isFetchingMore = false.obs;

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

  RxBool isFavourite = false.obs;

  // toggleFavourite() {
  //   isFavourite.value = !isFavourite.value;
  // }

  getIsProductAddToFav(bool isAddedToFav) {
    isFavourite.value = isAddedToFav;
    update();
  }

  // getIsProductAddedToFav(String productId) async {
  //   isFavourite!.value = await UserPreferences.isFavorite(productId);
  //   update();
  // }

  Rx<Color> bgColor = Rx<Color>(Colors.white); // Background color

  RxBool isLoadingPalette = false.obs; // Add loading state

  Future<void> getImageColor({required String url}) async {
    try {
      isLoadingPalette.value = true; // Start loading
      final PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(
        NetworkImage(url),
      );

      // Set the background color
      Color dominantColor =
          paletteGenerator.dominantColor?.color ?? Colors.white;

      Color contrastColor = _getComplementaryColor(dominantColor);

      bgColor.value = contrastColor;
    } finally {
      isLoadingPalette.value = false; // Stop loading
    }
  }

  Color _getComplementaryColor(Color color) {
    // Convert RGB to HSL
    HSLColor hslColor = HSLColor.fromColor(color);

    // Shift hue by 180 degrees to get the complementary color
    double complementaryHue = (hslColor.hue + 180) % 360;

    // Create the complementary color with the same saturation and lightness initially
    HSLColor complementaryColor = hslColor.withHue(complementaryHue);

    // If the complementary color is too dark (lightness < 0.3), adjust it
    if (complementaryColor.lightness < 0.3) {
      complementaryColor =
          complementaryColor.withLightness(0.5); // Set to a medium lightness
    }

    // Ensure the color is vibrant by boosting saturation if needed
    complementaryColor = complementaryColor.withSaturation(
      complementaryColor.saturation.clamp(0.7, 1.0), // Ensure vibrant color
    );

    return complementaryColor.toColor();
  }
  // Color _getComplementaryColor(Color color) {
  //   // Convert RGB to HSL
  //   HSLColor hslColor = HSLColor.fromColor(color);

  //   // Shift hue by 180 degrees to get the complementary color
  //   double complementaryHue = (hslColor.hue + 180) % 360;

  //   // Keep saturation and lightness the same for vibrant contrast
  //   return hslColor.withHue(complementaryHue).toColor();
  // }
  // Helper function to calculate a contrasting color
  // Color _getContrastColor(Color color) {
  //   // Calculate luminance (perceived brightness)
  //   double luminance =
  //       (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;

  //   // If the color is dark (low luminance), return a light color (e.g., white)
  //   // If the color is light (high luminance), return a dark color (e.g., black)
  //   return luminance > 0.5 ? Colors.black : Colors.white;
  // }

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

  RxString pdflink = "".obs;
  RxString pdfname = "".obs;
  void getpdfFromApi(BuildContext context,
      {required id, required theme}) async {
    var loadingIndicator = LoadingProgressDialogs();
    loadingIndicator.show(context, '');
    pdflink.value = '';
    pdfname.value = '';
    try {
      if (networkManager.connectionType.value == 0) {
        loadingIndicator.hide(context);
        showDialogForScreen(context, "Profile", Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }

      var response = await Repository.post(
        {
          "id": id,
          "theme": theme,
        },
        ApiUrl.pdfDownload,
        allowHeader: true,
      );
      // ignore: use_build_context_synchronously
      loadingIndicator.hide(context);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var responseDetail = PdfData.fromJson(data);
        logcat("responseData::", jsonEncode(responseDetail));
        if (responseDetail.success == true) {
          pdflink.value = responseDetail.data.url;
          pdfname.value = extractPdfNameFromUrl(responseDetail.data.url);
          logcat("url::", pdflink.value.toString());
          logcat("pdfname::", pdfname.value.toString());
          loadingIndicator.show(context, '');
          final filePath = await downloadPDF(pdflink.value, pdfname.value);
          loadingIndicator.hide(context);
          if (filePath != null) {
            sharefPopupDialogs(
              context,
              isFromEditProfile: false,
              function: () {
                sharePDF(filePath);
              },
            );
          }
          update();
        } else {
          state.value = ScreenState.apiError;
          // ignore: use_build_context_synchronously
          showDialogForScreen(context, "Profile", data['message'],
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        showDialogForScreen(
            // ignore: use_build_context_synchronously
            context,
            "Profile",
            data['message'] ?? "Server Error",
            callback: () {});
      }
    } catch (e) {
      state.value = ScreenState.apiError;
      // ignore: use_build_context_synchronously
      loadingIndicator.hide(context);
      logcat("Error::", e.toString());
    }
  }

  Widget getLableText(text, {isMainTitle}) {
    return Text(text,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: black,
          fontFamily: isMainTitle == true ? dM_sans_semiBold : dM_sans_semiBold,
          // fontWeight: isMainTitle == true ? FontWeight.w500 : FontWeight.w500,
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
        textAlign: TextAlign.left,
        style: TextStyle(
          fontFamily: dM_sans_semiBold,
          color: primaryColor,
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
      {bool? isFirstTime = false, bool? isFromLoadMore = false}) async {
    var loadingIndicator = LoadingProgressDialog();
    // if (hideloading == true) {
    //   state.value = ScreenState.apiLoading;
    // } else {
    //   loadingIndicator.show(context, '');
    //   update();
    // }
    logcat("getServiceList::", hideloading.toString());

    if (hideloading == false) {
      state.value = ScreenState.apiLoading;
    }
    if (isFromLoadMore == false) {
      isServiceLoading(true);
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

      // var pageURL = '${ApiUrl.getServiceList}/1?page=$currentPage';
      var pageURL = '${ApiUrl.getServiceList}/${businessId}?page=$currentPage';
      var response = await Repository.get({}, pageURL, allowHeader: true);
      // if (hideloading != true) {
      //   loadingIndicator.hide(context);
      // }
      logcat("RESPONSE::", response.body);
      if (isFromLoadMore == false) {
        isServiceLoading(false);
      }
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
          } else {
            serviceList.clear();
          }
          // serviceListData.data.nextPageUrl != 'null' ||
          if (serviceListData.data.nextPageUrl != null) {
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
      // showDialogForScreen(
      //     context, CategoryScreenConstant.title, ServerError.servererror,
      //     callback: () {});
    }
  }

  RxInt bussinessID = 0.obs;

  // RxBool isActive = false.obs;

  toggleActiveStatus(
    BuildContext context, {
    required statusID,
    required serviceId,
  }) {
    changeStatusAPI(context, networkManager, statusID, serviceId, 'Service',
        onSuccess: () {});
  }

  void changeStatusAPI(
    context,
    InternetController networkManager,
    String status,
    String serviceId,
    String screenName, {
    Function? onSuccess,
    Function? onFailure,
  }) async {
    var loadingIndicator = LoadingProgressDialogs();
    loadingIndicator.show(context, 'Changing status...');
    try {
      // Check for network connection
      if (networkManager.connectionType.value == 0) {
        loadingIndicator.hide(context);
        showDialogForScreen(context, screenName, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }

      print('status id: $status');

      // Make the PUT request
      var response = await Repository.put(
        {
          "status": status.trim(),
        },
        '${ApiUrl.changeStatus}/$serviceId',
        allowHeader: true,
      );

      loadingIndicator.hide(context);
      final decodedJson = jsonDecode(response.body);
      StatusCheck data = StatusCheck.fromJson(decodedJson);
      logcat("Change Status Response", data.toString());

      if (response.statusCode == 200) {
        if (data.success == true) {
          final isActive = data.data?.isActive == '1';

          futureDelay(() {
            getServiceList(context, 1, true, bussinessID, isFirstTime: true);
          }, isOneSecond: false);

          // showCustomToast(
          //     context, isActive ? 'Service is Active' : 'Service is InActive');
        } else {
          showDialogForScreen(
              context, screenName, data.message ?? 'Unknown error occurred.',
              callback: () {});
          // showCustomToast(context, data.message ?? 'Something went wrong.');
        }
      } else {
        showDialogForScreen(
            context, screenName, data.message ?? 'Unknown error occurred.',
            callback: () {});
      }
    } catch (e) {
      logcat("Exception", e.toString());
      showDialogForScreen(context, screenName, ServerError.servererror,
          callback: () {});
    } finally {
      loadingIndicator.hide(context);
    }
  }

  getServiceListItem(BuildContext context, ServiceDataList item,
      {isFromProfile = false}) {
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
              getServiceDetails(context, item);
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
                  imageUrl: item.thumbnail,
                  placeholder: (context, url) =>
                      Image.asset(Asset.bussinessPlaceholder),

                  // Center(child: Icon(Icons.business_outlined)

                  // CircularProgressIndicator(color: primaryColor),
                  errorWidget: (context, url, error) => Image.asset(
                      Asset.placeholder,
                      height: 10.h,
                      fit: BoxFit.cover),
                ),

                //  Icon(Icons.business_outlined)

                //  CachedNetworkImage(
                //   fit: BoxFit.cover,
                //   height: 18.h,
                //   imageUrl: item.thumbnail,
                //   placeholder: (context, url) =>
                //       const Center(child: Icon(Icons.business_outlined)

                //           // CircularProgressIndicator(color: primaryColor),

                //           ),
                //   errorWidget: (context, url, error) => Image.asset(
                //       Asset.placeholder,
                //       height: 10.h,
                //       fit: BoxFit.cover),
                // ),
              ),
            ),
          ),
          getDynamicSizedBox(width: 2.w),
          GestureDetector(
            onTap: () {
              getServiceDetails(context, item);
            },
            child: SizedBox(
              // color: Colors.yellow,
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
                          item.serviceTitle,
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
                        child: Text(item.categoryName,
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
          isFromProfile
              ? Column(
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
                      child: Container(
                        margin: EdgeInsets.all(3),
                        child: Icon(
                          Icons.edit,
                          size: 18.sp,
                        ),
                      ),
                    ),
                    getDynamicSizedBox(
                        height: isSmallDevice(context) ? 0.h : 0.3.h),
                    GestureDetector(
                      onTap: () async {
                        await deleteDialogs(
                          context,
                          function: () {
                            deleteService(context, item.id);
                          },
                        );
                        // if (isDeleted == true) {
                        //   if (!context.mounted) return;

                        // }
                      },
                      child: Container(
                        margin: EdgeInsets.all(3),
                        child: Icon(
                          Icons.delete,
                          size: 18.sp,
                          color: red,
                        ),
                      ),
                    ),
                    Obx(() {
                      return Container(
                        height: 3.h,
                        // color: Colors.yellow,
                        width: 10.w,
                        child: Transform.scale(
                          scale: 3.sp,
                          child: SwitchListTile(
                            activeColor: primaryColor,
                            dense: true,
                            value: item.isActive.value == 1,
                            onChanged: (value) {
                              int newStatus = item.isActive.value == 0 ? 1 : 0;

                              toggleActiveStatus(
                                context,
                                statusID: newStatus.toString(),
                                serviceId: item.id.toString(),
                              );
                              // update();
                            },
                          ),
                        ),
                      );
                    })
                  ],
                )
              : SizedBox.shrink()
        ],
      ),
    );

    // GestureDetector(
    //   onTap: () {
    //     getServiceDetails(context, item);
    //     // Get.to(BusinessDetailScreen(item: item));
    //   },
    //   child:

    //   // Stack(
    //   //   clipBehavior: Clip.none,
    //   //   children: [
    //   //     Container(
    //   //       decoration: BoxDecoration(
    //   //         color: white,
    //   //         borderRadius: const BorderRadius.all(Radius.circular(10)),
    //   //         boxShadow: [
    //   //           BoxShadow(
    //   //               color: black.withOpacity(0.2),
    //   //               spreadRadius: 0.1,
    //   //               blurRadius: 5,
    //   //               offset: const Offset(0.5, 0.5)),
    //   //         ],
    //   //       ),
    //   //       padding:
    //   //           EdgeInsets.only(left: 2.w, right: 2.w, top: 1.h, bottom: 1.h),
    //   //       margin: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 2.h),
    //   //       child: Row(
    //   //         crossAxisAlignment: CrossAxisAlignment.start,
    //   //         children: [
    //   //           Container(
    //   //             // padding: const EdgeInsets.all(2),
    //   //             margin: EdgeInsets.only(top: 0.5.h, bottom: 0.5.h),
    //   //             width: 25.w,
    //   //             height: 12.h,
    //   //             decoration: BoxDecoration(
    //   //               border: Border.all(
    //   //                   color: primaryColor,
    //   //                   width: 1), // border color and width
    //   //               borderRadius: BorderRadius.circular(
    //   //                   Device.screenType == sizer.ScreenType.mobile
    //   //                       ? 3.6.w
    //   //                       : 2.5.w),
    //   //             ),
    //   //             child: ClipRRect(
    //   //               borderRadius: BorderRadius.circular(
    //   //                   Device.screenType == sizer.ScreenType.mobile
    //   //                       ? 3.5.w
    //   //                       : 2.5.w),
    //   //               child: CachedNetworkImage(
    //   //                 fit: BoxFit.contain,
    //   //                 height: 17.h,
    //   //                 imageUrl: item.thumbnail,
    //   //                 placeholder: (context, url) =>
    //   //                     Image.asset(Asset.bussinessPlaceholder),

    //   //                 // Center(child: Icon(Icons.business_outlined)

    //   //                 // CircularProgressIndicator(color: primaryColor),
    //   //                 errorWidget: (context, url, error) => Image.asset(
    //   //                     Asset.placeholder,
    //   //                     height: 10.h,
    //   //                     fit: BoxFit.cover),
    //   //               ),

    //   //               //  Icon(Icons.business_outlined)

    //   //               //  CachedNetworkImage(
    //   //               //   fit: BoxFit.cover,
    //   //               //   height: 18.h,
    //   //               //   imageUrl: item.thumbnail,
    //   //               //   placeholder: (context, url) =>
    //   //               //       const Center(child: Icon(Icons.business_outlined)

    //   //               //           // CircularProgressIndicator(color: primaryColor),

    //   //               //           ),
    //   //               //   errorWidget: (context, url, error) => Image.asset(
    //   //               //       Asset.placeholder,
    //   //               //       height: 10.h,
    //   //               //       fit: BoxFit.cover),
    //   //               // ),
    //   //             ),
    //   //           ),
    //   //           getDynamicSizedBox(width: 2.w),
    //   //           Expanded(
    //   //             child: SizedBox(
    //   //               // color: Colors.yellow,
    //   //               height: 13.h,
    //   //               child: Column(
    //   //                 mainAxisAlignment: MainAxisAlignment.start,
    //   //                 crossAxisAlignment: CrossAxisAlignment.start,
    //   //                 children: [
    //   //                   getDynamicSizedBox(height: 0.5.h),
    //   //                   SizedBox(
    //   //                       width: 50.w,
    //   //                       // height: 2.h,
    //   //                       child: Text(
    //   //                           // 'dasgasdogasdhsad;asdhkadhasddastdlkjgagakldfgad',
    //   //                           maxLines: 1,
    //   //                           item.serviceTitle,
    //   //                           style: TextStyle(
    //   //                               overflow: TextOverflow.ellipsis,
    //   //                               fontFamily: dM_sans_semiBold,
    //   //                               fontSize: 15.sp,
    //   //                               color: black,
    //   //                               fontWeight: FontWeight.w900))),
    //   //                   getDynamicSizedBox(height: 0.2.h),
    //   //                   Row(
    //   //                     children: [
    //   //                       Icon(
    //   //                         Icons.folder,
    //   //                         size: 18.sp,
    //   //                       ),
    //   //                       getDynamicSizedBox(width: 0.5.w),
    //   //                       SizedBox(
    //   //                         width: 50.w,
    //   //                         child: Text(item.categoryName,
    //   //                             maxLines: 1,
    //   //                             style: TextStyle(
    //   //                                 fontFamily: dM_sans_semiBold,
    //   //                                 fontSize: 14.sp,
    //   //                                 color: black,
    //   //                                 fontWeight: FontWeight.w500)),
    //   //                       ),
    //   //                     ],
    //   //                   ),
    //   //                   getDynamicSizedBox(height: 0.2.h),
    //   //                   Row(
    //   //                     mainAxisAlignment: MainAxisAlignment.start,
    //   //                     children: [
    //   //                       // if (item.description.isNotEmpty)
    //   //                       //   Icon(
    //   //                       //     Icons.description,
    //   //                       //     size: 18.sp,
    //   //                       //   ),
    //   //                       getDynamicSizedBox(width: 0.5.w),
    //   //                       SizedBox(
    //   //                         width: 50.w,
    //   //                         child: AbsorbPointer(
    //   //                             absorbing: true,
    //   //                             child: ReadMoreText(item.description,
    //   //                                 textAlign: TextAlign.start,
    //   //                                 trimLines: 3, callback: (val) {
    //   //                               logcat("ONTAP", val.toString());
    //   //                             },
    //   //                                 colorClickableText: primaryColor,
    //   //                                 trimMode: TrimMode.Line,
    //   //                                 trimCollapsedText: '...Show more',
    //   //                                 trimExpandedText: '',
    //   //                                 delimiter: ' ',
    //   //                                 style: TextStyle(
    //   //                                     overflow: TextOverflow.ellipsis,
    //   //                                     fontSize: Device.screenType ==
    //   //                                             sizer.ScreenType.mobile
    //   //                                         ? 14.sp
    //   //                                         : 12.sp,
    //   //                                     fontWeight: FontWeight.w100,
    //   //                                     fontFamily: dM_sans_semiBold,
    //   //                                     color: primaryColor),
    //   //                                 lessStyle: TextStyle(
    //   //                                     fontFamily: dM_sans_semiBold,
    //   //                                     fontSize: Device.screenType ==
    //   //                                             sizer.ScreenType.mobile
    //   //                                         ? 14.sp
    //   //                                         : 12.sp),
    //   //                                 moreStyle: TextStyle(
    //   //                                     fontFamily: dM_sans_semiBold,
    //   //                                     fontSize: Device.screenType ==
    //   //                                             sizer.ScreenType.mobile
    //   //                                         ? 14.sp
    //   //                                         : 12.sp,
    //   //                                     color: primaryColor))),
    //   //                       ),
    //   //                     ],
    //   //                   ),
    //   //                 ],
    //   //               ),
    //   //             ),
    //   //           ),
    //   //         ],
    //   //       ),
    //   //     ),
    //   //     isFromProfile
    //   //         ? Positioned(
    //   //             top: 0.2.h,
    //   //             right: 5.w,
    //   //             child: Column(
    //   //               children: [
    //   //                 GestureDetector(
    //   //                   onTap: () {
    //   //                     print('goto add service screen');
    //   //                     Get.to(AddServicescreen(
    //   //                       item: item,
    //   //                       isFromHomeScreen: true,
    //   //                     ))?.then((value) {
    //   //                       if (value == true) {
    //   //                         if (!context.mounted) return;
    //   //                         getServiceList(
    //   //                             context, 1, true, bussinessID.value,
    //   //                             isFirstTime: true);
    //   //                       }
    //   //                     });
    //   //                   },
    //   //                   child: Container(
    //   //                     margin: EdgeInsets.all(3),
    //   //                     child: Icon(
    //   //                       Icons.edit,
    //   //                       size: 18.sp,
    //   //                     ),
    //   //                   ),
    //   //                 ),
    //   //                 getDynamicSizedBox(
    //   //                     height: isSmallDevice(context) ? 0.h : 0.3.h),
    //   //                 GestureDetector(
    //   //                   onTap: () async {
    //   //                     await deleteDialogs(
    //   //                       context,
    //   //                       function: () {
    //   //                         deleteService(context, item.id);
    //   //                       },
    //   //                     );
    //   //                     // if (isDeleted == true) {
    //   //                     //   if (!context.mounted) return;

    //   //                     // }
    //   //                   },
    //   //                   child: Container(
    //   //                     margin: EdgeInsets.all(3),
    //   //                     child: Icon(
    //   //                       Icons.delete,
    //   //                       size: 18.sp,
    //   //                       color: red,
    //   //                     ),
    //   //                   ),
    //   //                 ),
    //   //                 Obx(() {
    //   //                   return Container(
    //   //                     height: 3.h,
    //   //                     // color: Colors.yellow,
    //   //                     width: 10.w,
    //   //                     child: Transform.scale(
    //   //                       scale: 3.sp,
    //   //                       child: SwitchListTile(
    //   //                         activeColor: primaryColor,
    //   //                         dense: true,
    //   //                         value: item.isActive.value == 1,
    //   //                         onChanged: (value) {
    //   //                           int newStatus =
    //   //                               item.isActive.value == 0 ? 1 : 0;

    //   //                           toggleActiveStatus(
    //   //                             context,
    //   //                             statusID: newStatus.toString(),
    //   //                             serviceId: item.id.toString(),
    //   //                           );
    //   //                           // update();
    //   //                         },
    //   //                       ),
    //   //                     ),
    //   //                   );
    //   //                 })
    //   //               ],
    //   //             ),

    //   //             // Text(
    //   //             //   'Edit',
    //   //             //   style: TextStyle(
    //   //             //       fontFamily: dM_sans_semiBold,
    //   //             //       fontSize: 15.8.sp,
    //   //             //       color: black,
    //   //             //       fontWeight: FontWeight.w900),
    //   //             // ),
    //   //           )
    //   //         : SizedBox.shrink(),
    //   //   ],
    //   // )
    // );
  }

  getServiceDetails(BuildContext context, ServiceDataList data) {
    return commonDetailsDialog(
      context,
      "Service Details",
      isDescription: false,
      isfromService: true,
      contain: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data.thumbnail.isNotEmpty)
              getImageView(
                  data.thumbnail.isNotEmpty && data.thumbnail.isNotEmpty
                      ? data.thumbnail
                      : ""),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getDynamicSizedBox(
                          height: data.thumbnail.isNotEmpty ? 1.h : 0.0),
                      getPartyDetailRow(context, 'Category:',
                          data.categoryName.capitalize.toString()),
                      // getDynamicSizedBox(height: data.serviceTitle.isNotEmpty ? 1.h : 0.0),
                      getPartyDetailRow(context, 'Service:',
                          data.serviceTitle.capitalize.toString()),
                      // getDynamicSizedBox(height: data.keywords.isNotEmpty ? 1.h : 0.0),
                      // getPartyDetailRow('Keyword:', data.keywords.capitalize.toString()),
                      // getDynamicSizedBox(
                      //     height: data.description.toString().isNotEmpty ? 0.5.h : 0.0),
                      if (data.description.toString().isNotEmpty)
                        getPartyDetailRow(
                            context, 'Description:', data.description,
                            isAddress: true),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  deleteService(context, id) async {
    var loadingIndicator = LoadingProgressDialogs();
    loadingIndicator.show(context, '');
    try {
      if (networkManager.connectionType.value == 0) {
        loadingIndicator.hide(context);
        showDialogForScreen(context, AddServiceScreenViewConst.serviceScr,
            Connection.noConnection, callback: () {
          Get.back();
        });
        return;
      }
      print('my category id + ${id}');
      var response = await Repository.delete('${ApiUrl.deleteService}$id',
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
    } catch (e) {
      loadingIndicator.hide(context);
      logcat("Delete Service Exception", e.toString());
      showDialogForScreen(
          context, AddServiceScreenViewConst.serviceScr, Connection.servererror,
          callback: () {});
    }
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
