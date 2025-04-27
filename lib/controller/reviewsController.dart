import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
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
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/models/login_model.dart';
import 'package:ibh/models/reviewModel.dart';
import 'package:ibh/models/sign_in_form_validation.dart';
import 'package:ibh/preference/UserPreference.dart';
import 'package:ibh/utils/log.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:sizer/sizer.dart' as sizer;
import '../utils/enum.dart';
import 'internet_controller.dart';

class ReviewsScreenController extends GetxController {
  Rx<ScreenState> state = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  final InternetController networkManager = Get.find<InternetController>();
  var currentPage = 0;
  bool isReviewvisible = true;
  late TextEditingController commentctr;
  double userRating = 3.5;
  late FocusNode commentNode;
  var commentModel = ValidationModel(null, null, isValidate: false).obs;
  RxBool isFormInvalidate = false.obs;
  final ScrollController scrollController = ScrollController();
  RxList reviewList = [].obs;
  RxString nextPageURL = "".obs;
  RxBool isLoading = false.obs;
  RxString fomatedDate = "".obs;
  bool isFetchingMore = false;

  @override
  void onInit() {
    commentctr = TextEditingController();
    commentNode = FocusNode();
    super.onInit();
  }

  void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void addReviewAPI(context, businessId) async {
    var loadingIndicator = LoadingProgressDialog();
    loadingIndicator.show(context, '');
    try {
      if (networkManager.connectionType.value == 0) {
        loadingIndicator.hide(context);
        showDialogForScreen(
            context, ReviewsScreenConstant.title, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }

      logcat('ReviewPassingData', {
        // "business_id": getUserData!.id.toString().trim(),
        "business_id": businessId,
        "rating": userRating.toString(),
        "review": commentctr.text.toString().trim(),
      });

      var response = await Repository.post({
        "business_id": businessId,
        "rating": userRating.toString(),
        "review": commentctr.text.toString().trim(),
      }, ApiUrl.addReview, allowHeader: true);
      loadingIndicator.hide(context);
      var data = jsonDecode(response.body);
      logcat("tag", data);
      if (response.statusCode == 200) {
        if (data['success'] == true) {
          showDialogForScreen(
              context, ReviewsScreenConstant.title, data['message'],
              callback: () {
            commentctr.text = "";
            isFormInvalidate.value = false;
            getReviewList(context, 1, true);
            update();
          });
        } else {
          showDialogForScreen(
              context, ReviewsScreenConstant.title, data['message'],
              callback: () {
            commentctr.text = "";
            isFormInvalidate.value = false;
            update();
          });
        }
      } else {
        showDialogForScreen(
            context, ReviewsScreenConstant.title, data['message'] ?? "",
            callback: () {});
      }
    } catch (e) {
      logcat("Exception", e);
      showDialogForScreen(
          context, ReviewsScreenConstant.title, ServerError.servererror,
          callback: () {});
    }
  }

  void validateComment(String? val) {
    commentModel.update((model) {
      if (val == null || val.toString().trim().isEmpty) {
        model!.error = "Enter Password";
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });
    enableSignUpButton();
  }

  void enableSignUpButton() {
    if (commentModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else {
      isFormInvalidate.value = true;
    }
  }

  getFilterUi() {
    return GestureDetector(
      onTap: () {
        // Get.to(const FilterScreen());
      },
      child: Container(
          width: 30.w,
          height: 5.5.h,
          decoration: BoxDecoration(
            color: white,
            boxShadow: [
              BoxShadow(
                  // ignore: deprecated_member_use
                  color: grey.withOpacity(0.8),
                  blurRadius: 2.0,
                  offset: const Offset(0, 1),
                  spreadRadius: 3.0)
            ],
            borderRadius: BorderRadius.circular(
                Device.screenType == sizer.ScreenType.mobile ? 10.w : 2.2.w),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Filter",
                style: TextStyle(
                  color: black,
                  fontWeight: FontWeight.w400,
                  fontSize: Device.screenType == sizer.ScreenType.mobile
                      ? 14.sp
                      : 13.sp,
                ),
              ),
              getDynamicSizedBox(width: 0.5.w),
              Icon(
                Icons.tune_rounded,
                size: 3.h,
                color: black,
              )
            ],
          )),
    );
  }


  Widget getText(title, TextStyle? style) {
    return Padding(
      padding: EdgeInsets.only(left: 0.5.w, right: 0.5.w),
      child: Text(
        title,
        style: style,
      ),
    );
  }

  getListItem(BuildContext context, ReviewData data, int index) {
    // DateTime dateTime = DateTime.parse(data.createdAt);
    String formattedDate = DateFormat('dd-MM-yyyy').format(data.createdAt);
    return Wrap(
      children: [
        Container(
          width: Device.width,
          margin: EdgeInsets.only(bottom: 1.5.h, right: 3.w, left: 3.w),
          padding:
              EdgeInsets.only(left: 1.w, right: 1.w, top: 0.5.h, bottom: 1.h),
          decoration: BoxDecoration(
            //color: grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(1.7.h),
            border: Border.all(
              color: grey, // Border color
              width: 0.5, // Border width
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 0.2.h, left: 1.5.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1.7.h),
                      border: Border.all(
                        // ignore: deprecated_member_use
                        color: grey.withOpacity(0.8), // Border color
                        width: 0.5, // Border width
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        height: 7.h,
                        width: 18.w,
                        imageUrl: data.user.visitingCardUrl,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        ),
                        errorWidget: (context, url, error) => SvgPicture.asset(
                          Asset.profile,
                          fit: BoxFit.cover,
                          // ignore: deprecated_member_use
                          color: black,
                          height: 7.h,
                          width: 7.h,
                        ),
                      ),
                    ),
                  ),
                  getDynamicSizedBox(width: 2.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 62.w,
                          child: Text(data.user.name,
                              maxLines: 2,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontFamily: fontMedium,
                                fontWeight: FontWeight.w900,
                                fontSize: 16.sp,
                              )),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RatingBar.builder(
                              initialRating: double.parse(data.rating),
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 4.w,
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.orange,
                              ),
                              onRatingUpdate: (rating) {
                                logcat("RATING", rating);
                              },
                            ),
                            getDynamicSizedBox(width: 0.6.w),
                            Text(data.rating,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: fontBold,
                                  fontSize: 14.sp,
                                )),
                            const Spacer(),
                            Text(formattedDate,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: fontBold,
                                  fontSize: 14.sp,
                                )),
                            getDynamicSizedBox(width: 1.w)
                          ],
                        ),
                        //getDynamicSizedBox(height: 1.0.h),
                      ],
                    ),
                  ),
                ],
              ),
              ClipRRect(
                  borderRadius: BorderRadius.circular(
                      Device.screenType == sizer.ScreenType.mobile
                          ? 4.w
                          : 2.2.w),
                  child: Padding(
                    padding: EdgeInsets.only(left: 2.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        getDynamicSizedBox(height: 0.5.h),
                        getDivider(),
                        getDynamicSizedBox(height: 0.8.h),
                        Text(data.review.toString(),
                            maxLines: 5,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: black,
                              fontFamily: fontBold,
                              fontWeight: FontWeight.w500,
                              fontSize: 15.sp,
                            )),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  getListItems(BuildContext context, ReviewData data, int index) {
    var name = '';
    return FadeInUp(
      child: Wrap(
        children: [
          Stack(
            children: [
              Container(
                  width: Device.width,
                  margin: EdgeInsets.only(
                      top: 3.h, left: 3.w, right: 3.w, bottom: 2.0.h),
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    //color: grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(1.7.h),
                    border: Border.all(
                      color: grey, // Border color
                      width: 0.5, // Border width
                    ),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          Device.screenType == sizer.ScreenType.mobile
                              ? 4.w
                              : 2.2.w),
                      child: Padding(
                        padding: EdgeInsets.only(left: 1.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                getDynamicSizedBox(width: 20.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(name,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontFamily: fontMedium,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 15.sp,
                                              )),
                                          const Spacer(),
                                          Text(data.review,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontFamily: fontBold,
                                                fontSize: 12.sp,
                                              )),
                                          getDynamicSizedBox(width: 0.6.w),
                                        ],
                                      ),
                                      getDynamicSizedBox(height: 0.6.h),
                                      //getDynamicSizedBox(height: 1.0.h),
                                      // getDivider()
                                    ],
                                  ),
                                )
                              ],
                            ),
                            RatingBar.builder(
                              initialRating: double.parse(data.rating),
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 3.5.w,
                              // itemPadding:
                              //     const EdgeInsets.symmetric(horizontal: 5.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.orange,
                              ),
                              onRatingUpdate: (rating) {
                                logcat("RATING", rating);
                              },
                            ),
                            getDynamicSizedBox(height: 0.6.h),
                            SizedBox(
                              width: 53.w,
                              child: Text(data.review.toString(),
                                  maxLines: 3,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: lableColor,
                                    fontFamily: fontBold,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp,
                                  )),
                            ),
                            getDynamicSizedBox(height: 0.6.h),
                          ],
                        ),
                      ))),
              Positioned(
                left: 9.w,
                child: FadeInDown(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      height: 7.h,
                      imageUrl: ApiUrl.imageUrl,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(color: primaryColor),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        Asset.productPlaceholder,
                        height: 7.h,
                        width: 7.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  getReviewList(context, currentPage, bool hideloading,
      {bool? isRefress}) async {

    if (hideloading == false) {
      state.value = ScreenState.apiLoading;
    }

    try {
      if (networkManager.connectionType.value == 0) {
        showDialogForScreen(
            context, ReviewsScreenConstant.title, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }

      var pageURL = '${ApiUrl.reviewList}?page=$currentPage';
      logcat("URL", pageURL.toString());
      var response = await Repository.get({}, pageURL, allowHeader: true);
 
      Statusbar().transparentStatusbarIsNormalScreen();
      // loadingIndicator.hide(context);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (data['success'] == true) {
          state.value = ScreenState.apiSuccess;
          message.value = '';
          isLoading.value = false;
          update();
          var responseData = ReviewModel.fromJson(data);
          if (isRefress == true && reviewList.isNotEmpty) {
            reviewList.clear();
          }
          if (responseData.data.data.isNotEmpty) {
            reviewList.addAll(responseData.data.data);
            reviewList.refresh();
            update();
          }
          // responseData.data.nextPageUrl != 'null' &&
          if (responseData.data.nextPageUrl != null) {
            nextPageURL.value = responseData.data.nextPageUrl.toString();
            update();
          } else {
            nextPageURL.value = "";
            update();
          }
          update();
        } else {
          isLoading.value = false;
          message.value = data['message'];
          state.value = ScreenState.apiError;
          showDialogForScreen(
              context, ReviewsScreenConstant.title, data['message'].toString(),
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        isLoading.value = false;
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(
            context, ReviewsScreenConstant.title, data['message'].toString(),
            callback: () {});
      }
    } catch (e) {
      // if (hideloading != true) {
      //   loadingIndicator.hide(context);
      // }
      isLoading.value = false;
      state.value = ScreenState.apiError;
      message.value = ServerError.servererror;
    }
  }
}
