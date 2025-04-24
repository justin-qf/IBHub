import 'dart:async';
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
import 'package:ibh/models/categotyModel.dart';
import 'package:ibh/utils/log.dart';
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
  var currentPage = 0;
  late Timer? timer =
      Timer.periodic(const Duration(seconds: 10), (Timer timer) {});
  late TextEditingController searchCtr;
  bool isSearch = false;
  // Use a Map to store the quantity for each product ID
  final ScrollController scrollController = ScrollController();
  RxBool showGNav = true.obs;
  RxList categoryList = [].obs;

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

  getCategoryListItem(BuildContext context, CategoryData item) {
    return GestureDetector(
        onTap: () {
          // Get.to(SubCategoryScreen(
          //   categoryId: item.id.toString(),
          // ))!
          //     .then((value) {
          //   getHome(context);
          //   getTotalProductInCart();
          // });
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
                          imageUrl: ApiUrl.imageUrl,
                          placeholder: (context, url) => const Center(
                            child:
                                CircularProgressIndicator(color: primaryColor),
                          ),
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
                                fontFamily: fontRegular,
                                color: black,
                                fontSize:
                                    Device.screenType == sizer.ScreenType.mobile
                                        ? 14.sp
                                        : 9.sp,
                              ),
                              text: item.name,
                              scrollAxis: Axis
                                  .horizontal, // Use Axis.vertical for vertical scrolling
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, // Adjust as needed
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
                              fontFamily: fontRegular,
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
    state.value = ScreenState.apiLoading;
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
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
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
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(
            context, HomeScreenconst.title, ServerError.servererror,
            callback: () {});
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
}
