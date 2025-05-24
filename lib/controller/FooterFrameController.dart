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
import 'package:ibh/models/brandModel.dart';
import 'package:ibh/models/businessListModel.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/helper.dart';
import 'package:ibh/utils/log.dart';
import 'package:ibh/views/mainscreen/BrandingScreeens/BrandEditingScreen.dart';
import 'package:ibh/views/mainscreen/BrandingScreeens/BrandImageScreens/BrandImageScreen.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sizer/sizer.dart';
import 'package:sizer/sizer.dart' as sizer;

class BrandingScreencontroller extends GetxController {
  Rx<ScreenState> state = ScreenState.apiSuccess.obs;
  RxList searchList = [].obs;
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  var isBusinessLoading = false.obs;
  var currentPage = 0;
  RxList<BrandDetailData> categoryTypes = <BrandDetailData>[].obs;
  RxString message = "".obs;
  InternetController networkManager = Get.find<InternetController>();
  final ScrollController scrollController = ScrollController();
  bool isFetchingMore = false;

  getDailyListItems(BuildContext context, BusinessData item,
      {dailyImg, dailyName}) {
    return GestureDetector(
        onTap: () {
          Get.to(const Brandeditingscreen())!.then((value) {});
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
                      child: Container(
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
                ])));
  }
}
