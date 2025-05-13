import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/models/businessListModel.dart';
import 'package:ibh/utils/enum.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sizer/sizer.dart';
import 'package:sizer/sizer.dart' as sizer;

class Brandingdetailsscreencontroller extends GetxController {
  Rx<ScreenState> state = ScreenState.apiSuccess.obs;

  RxList searchList = [].obs;

  late TextEditingController searchCtr = TextEditingController();
  bool isSearch = false;
  var currentPage = 0;

  final ScrollController scrollController = ScrollController();

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  RxString nextPageURL = "".obs;
  bool isFetchingMore = false;

  RxList businessList = [].obs;

  void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  void onInit() {
    searchCtr = TextEditingController();

    super.onInit();
  }

  getBusinessListItem(BuildContext context, BusinessData item) {
    // print('item;${item.isEmailVerified}');
    return GestureDetector(
      onTap: () async {
        // bool isEmpty = await isAnyFieldEmpty();
        // if (isEmpty) {
        //   // ignore: use_build_context_synchronously
        //   showBottomSheetPopup(context);
        // } else {
        //   Get.to(BusinessDetailScreen(
        //     item: item,
        //     isFromProfile: false,
        //   ));
        // }
        // Get.to(BusinessDetailScreen(
        //   item: item,
        //   isFromProfile: false,
        // ));
      },
      child: Container(
        // height: 4.h,
        width: 37.w,
        decoration: BoxDecoration(
          color: white,
          // border: Border.all(color: primaryColor),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                // ignore: deprecated_member_use
                color: black.withOpacity(0.2),
                spreadRadius: 0.1,
                blurRadius: 2,
                offset: const Offset(0, 0)),
          ],
        ),
        margin: EdgeInsets.only(left: 1.w, right: 1.w, bottom: 0.h),
        // padding:
        // EdgeInsets.only(left: 1.w, top: 0.5.h, bottom: 0.h, right: 1.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  // padding: const EdgeInsets.all(2),
                  // margin: EdgeInsets.only(top: 0.h, bottom: 0.5.h),
                  width: Device.width,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: white,
                    boxShadow: [
                      BoxShadow(
                          // ignore: deprecated_member_use
                          color: black.withOpacity(0.2),
                          spreadRadius: 0.1,
                          blurRadius: 5,
                          offset: const Offset(0, 0)),
                    ],
                    // border: Border(
                    //     bottom: BorderSide(
                    //         color: primaryColor,
                    //         width: 0.3.w)), // border color and width
                    borderRadius: BorderRadius.circular(
                        Device.screenType == sizer.ScreenType.mobile
                            ? 2.5.w
                            : 2.5.w),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      fit: BoxFit.contain,
                      height: 1.h,
                      imageUrl: item.visitingCardUrl,
                      placeholder: (context, url) => Center(
                        child: Image.asset(Asset.itemPlaceholder,
                            height: 12.h, width: 25.w, fit: BoxFit.cover),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                          Asset.itemPlaceholder,
                          height: 12.h,
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
                Positioned(
                  top: 0.5.h,
                  right: 1.w,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: white,
                    ),
                    child: SvgPicture.asset(
                      Asset.badge,
                      color: blue,
                    ),
                  ),
                ),
                // item.isEmailVerified
                //     ?

                // : SizedBox.shrink()
              ],
            ),
            // getDynamicSizedBox(height: 1.w),

            Expanded(
              child: Center(
                child: Container(
                  // height: 3.h,
                  padding: EdgeInsets.symmetric(horizontal: 2.w),

                  // height: 4.h,
                  width: Device.screenType == sizer.ScreenType.mobile
                      ? 58.w
                      : 65.w,
                  child: Text(
                      // 'asdaiyutasypudsgsaudgasgasdadsdjhdgasbaosdoasasddahshdadakdshddlkd',

                      item.businessName,
                      maxLines: 1,
                      style: TextStyle(
                          fontFamily: dM_sans_semiBold,
                          fontSize: 14.sp,
                          height: 1.2,
                          overflow: TextOverflow.ellipsis,
                          color: black,
                          fontWeight: FontWeight.w900)),
                ),
              ),
            ),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     SizedBox(
            //       // height: 4.h,
            //       width: Device.screenType == sizer.ScreenType.mobile
            //           ? 58.w
            //           : 65.w,
            //       child: Text(
            //           // 'asdaiyutasypudsgsaudgasgasdadsdjhdgasbaosdoasasddahshdadakdshddlkd',

            //           item.businessName,
            //           maxLines: 2,
            //           style: TextStyle(
            //               fontFamily: dM_sans_medium,
            //               fontSize: 14.sp,
            //               height: 1,
            //               overflow: TextOverflow.ellipsis,
            //               color: black,
            //               fontWeight: FontWeight.w900)),
            //     ),
            //     // getDynamicSizedBox(height: 1.h),
            //     // SizedBox(
            //     //   // height: 2.h,
            //     //   width: Device.screenType == sizer.ScreenType.mobile
            //     //       ? 58.w
            //     //       : 70.w,
            //     //   child: Text(item.name,
            //     //       maxLines: 1,
            //     //       style: TextStyle(
            //     //           height: 1.1,
            //     //           fontFamily: dM_sans_semiBold,
            //     //           fontSize: 14.sp,
            //     //           color: black,
            //     //           fontWeight: FontWeight.w500)),
            //     // ),
            //     // getDynamicSizedBox(height: 1.h),
            //     // SizedBox(
            //     //   // height: 4.h,
            //     //   width: Device.screenType == sizer.ScreenType.mobile
            //     //       ? 58.w
            //     //       : 65.w,
            //     //   child: Text(
            //     //       // 'asdaiyutasypudsgsaudgasgasdadsdjhdgasbaosdoas',

            //     //       item.address.isNotEmpty
            //     //           ? item.address
            //     //           : item.city != null
            //     //               ? item.city!.city
            //     //               : item.phone,
            //     //       maxLines: 2,
            //     //       style: TextStyle(
            //     //           height: 1.1,
            //     //           fontFamily: dM_sans_semiBold,
            //     //           fontSize: 14.sp,
            //     //           color: black,
            //     //           fontWeight: FontWeight.w500)),
            //     // ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
