import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
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

  // getItemListItem(CommonProductList data, BuildContext context) {
  //   return GestureDetector(
  //     onTap: () async {
  //       Get.to(
  //         ProductDetailScreen(
  //           'SameProduct',
  //           data: data,
  //         ),
  //         preventDuplicates: false,
  //         transition: Transition.fadeIn,
  //         curve: Curves.easeInOut,
  //       );
  //     },
  //     child: Wrap(
  //       children: [
  //         FadeInUp(
  //           child: Container(
  //               width: 50.w,
  //               height: SizerUtil.deviceType == DeviceType.mobile ? null : 20.h,
  //               margin: EdgeInsets.only(right: 4.5.w),
  //               // padding: EdgeInsets.only(
  //               //     left: 5.w, right: 5.w, top: 5.w, bottom: 10.w),
  //               decoration: BoxDecoration(
  //                 border: isDarkMode()
  //                     ? null
  //                     : Border.all(
  //                         color: grey, // Border color
  //                         width: 0.5, // Border width
  //                       ),
  //                 color: isDarkMode() ? itemDarkBackgroundColor : white,
  //                 borderRadius: BorderRadius.circular(
  //                     SizerUtil.deviceType == DeviceType.mobile ? 4.w : 2.2.w),
  //               ),
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(
  //                     SizerUtil.deviceType == DeviceType.mobile ? 4.w : 2.2.w),
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Container(
  //                       width: SizerUtil.width,
  //                       decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(
  //                               SizerUtil.deviceType == DeviceType.mobile
  //                                   ? 3.5.w
  //                                   : 2.5.w),
  //                           border: Border.all(
  //                             color: grey, // Border color
  //                             width: isDarkMode() ? 1 : 0.2, // Border width
  //                           )),
  //                       child: ClipRRect(
  //                         borderRadius: BorderRadius.circular(
  //                             SizerUtil.deviceType == DeviceType.mobile
  //                                 ? 3.5.w
  //                                 : 2.5.w),
  //                         child: CachedNetworkImage(
  //                           fit: BoxFit.cover,
  //                           height: 12.h,
  //                           imageUrl: ApiUrl.imageUrl + data.images[0],
  //                           placeholder: (context, url) => const Center(
  //                             child: CircularProgressIndicator(
  //                                 color: primaryColor),
  //                           ),
  //                           errorWidget: (context, url, error) => Image.asset(
  //                             Asset.productPlaceholder,
  //                             height: 9.h,
  //                             fit: BoxFit.contain,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: SizerUtil.deviceType == DeviceType.mobile
  //                           ? 1.0.h
  //                           : 0.5.h,
  //                     ),
  //                     Container(
  //                       margin: EdgeInsets.only(left: 1.w, right: 1.w),
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           getText(
  //                             data.name,
  //                             TextStyle(
  //                                 fontFamily: fontSemiBold,
  //                                 color: isDarkMode() ? black : black,
  //                                 fontSize:
  //                                     SizerUtil.deviceType == DeviceType.mobile
  //                                         ? 12.sp
  //                                         : 7.sp,
  //                                 height: 1.2),
  //                           ),
  //                           getDynamicSizedBox(
  //                             height: 0.5.h,
  //                           ),
  //                           Row(
  //                             children: [
  //                               getText(
  //                                 '${IndiaRupeeConstant.inrCode}${data.price}',
  //                                 TextStyle(
  //                                     fontFamily: fontBold,
  //                                     color: primaryColor,
  //                                     fontSize: SizerUtil.deviceType ==
  //                                             DeviceType.mobile
  //                                         ? 12.sp
  //                                         : 7.sp,
  //                                     height: 1.2),
  //                               ),
  //                               const Spacer(),
  //                               Row(
  //                                 crossAxisAlignment: CrossAxisAlignment.center,
  //                                 mainAxisAlignment: MainAxisAlignment.start,
  //                                 children: [
  //                                   RatingBar.builder(
  //                                     initialRating: 3.5,
  //                                     minRating: 1,
  //                                     direction: Axis.horizontal,
  //                                     allowHalfRating: true,
  //                                     itemCount: 1,
  //                                     itemSize: 3.5.w,
  //                                     itemBuilder: (context, _) => const Icon(
  //                                       Icons.star,
  //                                       color: Colors.orange,
  //                                     ),
  //                                     onRatingUpdate: (rating) {
  //                                       logcat("RATING", rating);
  //                                     },
  //                                   ),
  //                                   getText(
  //                                     "3.5",
  //                                     TextStyle(
  //                                         fontFamily: fontSemiBold,
  //                                         color: lableColor,
  //                                         fontWeight: isDarkMode()
  //                                             ? FontWeight.w600
  //                                             : null,
  //                                         fontSize: SizerUtil.deviceType ==
  //                                                 DeviceType.mobile
  //                                             ? 9.sp
  //                                             : 7.sp,
  //                                         height: 1.2),
  //                                   ),
  //                                   // const Spacer(),
  //                                   // GestureDetector(
  //                                   //   onTap: () {
  //                                   //     data.isSelected.value =
  //                                   //         !data.isSelected.value;
  //                                   //     update();
  //                                   //   },
  //                                   //   child: Icon(
  //                                   //     data.isSelected.value
  //                                   //         ? Icons.favorite_rounded
  //                                   //         : Icons.favorite_border,
  //                                   //     size: 3.h,
  //                                   //     color: primaryColor,
  //                                   //   ),
  //                                   // )
  //                                 ],
  //                               ),
  //                             ],
  //                           ),
  //                           getDynamicSizedBox(
  //                             height: 0.5.h,
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               )),
  //         ),
  //       ],
  //     ),
  //   );
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
              //fontFamily: fontRegular,
              color: grey,
              fontSize: 16.sp,
            )
          : TextStyle(
              //fontFamily: fontBold,
              color: black,
              fontSize:
                  Device.screenType == sizer.ScreenType.mobile ? 16.sp : 7.sp,
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
}
