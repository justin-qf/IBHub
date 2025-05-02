import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ibh/componant/dialogs/customDialog.dart';
import 'package:ibh/api_handle/CommonApiStructure.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/controller/serviceDetailController.dart';
import 'package:ibh/models/ServiceListModel.dart';
import 'package:ibh/models/businessListModel.dart';
import 'package:ibh/models/login_model.dart';
import 'package:ibh/preference/UserPreference.dart';
import 'package:ibh/utils/helper.dart';
import 'package:ibh/utils/log.dart';
import 'package:ibh/views/mainscreen/ServiceScreen/AddServiceScreen.dart';
import 'package:ibh/views/mainscreen/ServiceScreen/ServiceScreen.dart';
import 'package:sizer/sizer.dart' as sizer;
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class BusinessDetailScreen extends StatefulWidget {
  BusinessDetailScreen(
      {required this.item,
      required this.isFromProfile,
      this.isFromFav,
      super.key});
  BusinessData? item;
  bool? isFromProfile;
  bool? isFromFav = false;

  @override
  State<BusinessDetailScreen> createState() => _BusinessDetailScreenState();
}

class _BusinessDetailScreenState extends State<BusinessDetailScreen> {
  var controller = Get.put(ServiceDetailScreenController());
  bool showTitle = false;
  double? percentage;
  String businessName = '';
  String businessId = '';
  String thumbnail = '';
  String email = '';
  String phone = '';
  String address = '';
  String city = '';
  String state = '';
  String pincode = '';
  double? businessReviewsAvgRating = 0.0;

  @override
  void initState() {
    getUserData();
    controller.scrollController.addListener(scrollListener);
    setState(() {});
    super.initState();
  }

  void scrollListener() {
    if (controller.scrollController.position.pixels ==
            controller.scrollController.position.maxScrollExtent &&
        controller.nextPageURL.value.isNotEmpty &&
        !controller.isFetchingMore.value) {
      if (!mounted) return;
      setState(() => controller.isFetchingMore.value = true);
      controller.currentPage++;
      Future.delayed(
        Duration.zero,
        () {
          controller
              .getServiceList(context, controller.currentPage, true,
                  controller.bussinessID.value,
                  isFromLoadMore: true)
              .whenComplete(() {
            if (mounted) {
              // controller.isFetchingMore.value = false;
              setState(() => controller.isFetchingMore.value = false);
            }
          });
        },
      );
    }
  }

  int idUsedinCtr = 0;

  getUserData() async {
    User? retrievedObject = await UserPreferences().getSignInInfo();
    if (retrievedObject == null) {
      // You could show an error, fallback, or early return
      print("Retrieved user is null");
      return;
    }
    businessName = retrievedObject!.businessName ?? '';
    thumbnail = retrievedObject.visitingCardUrl ?? '';
    email = retrievedObject.email ?? '';
    address = retrievedObject.address ?? '';
    city = retrievedObject.city!.city.toString();
    state = retrievedObject.state!.name.toString();
    businessId = retrievedObject.id.toString();
    phone = retrievedObject.phone.toString();
    pincode = retrievedObject.pincode.toString();
    businessReviewsAvgRating = retrievedObject.businessReviewsAvgRating != null
        ? retrievedObject.businessReviewsAvgRating!
        : 0.0;
    // final idUsedinCtr =
    //     widget.item != null ? widget.item!.id : retrievedObject.id;

    idUsedinCtr = widget.item != null
        ? (widget.isFromFav == true
            ? int.tryParse(widget.item!.businessId) ?? 0
            : widget.item!.id ?? 0)
        : retrievedObject.id ?? 0;

    print('id used in ctr:${idUsedinCtr.toString()}');
    controller.bussinessID(idUsedinCtr);
    controller.getImageColor(
        url: widget.item != null ? widget.item!.visitingCardUrl : thumbnail);
    if (widget.item != null && widget.item!.isFavorite == true) {
      controller.isFavourite.value = widget.item!.isFavorite;
    } else {
      controller.isFavourite.value = false;
    }
    logcat("ISFav::", controller.isFavourite.value);
    futureDelay(() {
      controller.getServiceList(context, 1, true, idUsedinCtr,
          isFirstTime: true);
    }, isOneSecond: false);
    setState(() {});
  }

  @override
  void dispose() {
    businessId = "";
    controller.serviceList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Statusbar().trasparentStatusbar();
    return CustomParentScaffold(
        bottomNavigationBar: widget.isFromProfile!
            ? Container(
                width: 7.h,
                height: 7.h,
                margin: EdgeInsets.only(bottom: 2.h, right: 1.0.w),
                child: getFloatingActionButton(onClick: () {
                  Get.to(AddServicescreen())?.then((value) {
                    if (value == true) {
                      controller.getServiceList(
                          context,
                          1,
                          true,
                          widget.item != null
                              ? widget.isFromFav == true
                                  ? int.parse(widget.item!.businessId)
                                  : widget.item!.id
                              : businessId,
                          isFirstTime: true);
                    }
                  });
                }))
            : null,
        isExtendBodyScreen: true,
        onWillPop: () async {
          return true;
        },
        onTap: () {
          hideKeyboard(context);
        },
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 4.h),
                    width: Device.width,
                    height: isSmallDevice(context) ? 31.h : 30.h,
                    decoration: BoxDecoration(
                      color: controller.bgColor.value,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 4.w, top: 2.h),
                          child: getleftsidebackbtn(
                            isbussinessScreen: true,
                            istitle: false,
                            backFunction: () {
                              Get.back(result: true);
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: 2.w, right: 2.w, bottom: 4.h),
                          child: controller.isLoadingPalette.value
                              ? SizedBox(
                                  height: 14.h,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                        color: primaryColor),
                                  ),
                                )
                              : CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  height: 14.h,
                                  imageUrl: widget.item != null
                                      ? widget.item!.visitingCardUrl
                                      : thumbnail,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                        color: primaryColor),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    Asset.placeholder,
                                    height: 9.h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  widget.isFromProfile == false
                      ? Positioned(
                          top: 6.5.h,
                          right: 6.w,
                          child: Obx(() {
                            return GestureDetector(
                                onTap: () {
                                  logcat("FavIDDDD", jsonEncode(widget.item));
                                  logcat("FavIDs", widget.item!.id.toString());
                                  controller.isFavourite.value == true
                                      ? removeFavouriteAPI(
                                          context,
                                          controller.networkManager,
                                          widget.item != null
                                              ? widget.isFromFav == true
                                                  ? widget.item!.businessId
                                                  : widget.item!.id.toString()
                                              : businessId,
                                          "Business Detail")
                                      : addFavouriteAPI(
                                          context,
                                          controller.networkManager,
                                          widget.item != null
                                              ? widget.isFromFav == true
                                                  ? widget.item!.businessId
                                                  : widget.item!.id.toString()
                                              : businessId,
                                          "Business Detail");
                                  // controller.getIsProductAddToFav(
                                  //     controller.isFavourite.value);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  child: controller.isFavourite.value == true
                                      ? SvgPicture.asset(Asset.heart2)
                                      : SvgPicture.asset(Asset.heart),
                                ));
                          }))
                      : SizedBox.shrink()
                ],
              ),
            ),
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getDynamicSizedBox(height: 1.h),
                      SizedBox(
                        width: 70.w,
                        child: controller.getLableText(
                            widget.item != null
                                ? widget.item!.businessName
                                : businessName,
                            isMainTitle: true),
                      ),
                      // controller.getCategoryLable(widget.item.businessName),
                      getDynamicSizedBox(height: 1.h),
                      GestureDetector(
                        onTap: () {
                          lanchEmail(
                              widget.item != null ? widget.item!.email : email);
                        },
                        child: Row(
                          children: [
                            Container(
                                width: 6.w,
                                height: 3.h,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: primaryColor),
                                // padding: EdgeInsets.all(2),
                                child: Icon(
                                  Icons.email,
                                  size: 15.sp,
                                  color: white,
                                )),
                            getDynamicSizedBox(width: 1.w),
                            controller.getLableText(
                                widget.item != null
                                    ? widget.item!.email
                                    : email,
                                isMainTitle: false),
                          ],
                        ),
                      ),
                      getDynamicSizedBox(height: 1.h),
                      GestureDetector(
                        onTap: () {
                          launchPhoneCall(
                              widget.item != null ? widget.item!.phone : phone);
                          // showShareSheetPopup(context, rightbtn: () {
                          //   launchWhatsApp(
                          //       context,
                          //       widget.item != null
                          //           ? widget.item!.phone
                          //           : phone);
                          // }, leftbtn: () {
                          //   launchPhoneCall(widget.item != null
                          //       ? widget.item!.phone
                          //       : phone);
                          // });
                        },
                        child: Row(
                          children: [
                            Container(
                                width: 6.w,
                                height: 3.h,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: primaryColor),
                                // padding: EdgeInsets.all(2),
                                child: Icon(
                                  Icons.call,
                                  size: 15.sp,
                                  color: white,
                                )),
                            getDynamicSizedBox(width: 1.w),
                            controller.getLableText(
                                widget.item != null
                                    ? widget.item!.phone
                                    : phone,
                                isMainTitle: false)
                          ],
                        ),
                      ),
                      getDynamicSizedBox(height: 1.h),
                      // if (widget.item != null && widget.item!.address.isNotEmpty)
                      //   controller.getLableText('Address : ', isMainTitle: false),
                      if ((widget.item != null &&
                              widget.item!.address.isNotEmpty) ||
                          (widget.item == null && address.isNotEmpty))
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                width: 6.w,
                                height: 3.h,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: primaryColor),
                                // padding: EdgeInsets.all(2),
                                child: Icon(
                                  Icons.location_on,
                                  size: 15.sp,
                                  color: white,
                                )),
                            // Icon(Icons.location_on, size: 18.sp),
                            getDynamicSizedBox(width: 1.w),
                            controller.getTexts(
                              widget.item != null
                                  ? '${widget.item!.address}, ${widget.item!.city!.city}, ${widget.item!.state!.name}, ${widget.item!.pincode.toString()}'
                                  : '$address, $city, $state, $pincode ',
                            )
                          ],
                        ),
                      getDynamicSizedBox(
                          height: Device.screenType == sizer.ScreenType.mobile
                              ? widget.item != null &&
                                      widget.item!.address.isNotEmpty
                                  ? 1.h
                                  : 0.0
                              : 0.8.h),
                      getDynamicSizedBox(
                          height: Device.screenType == sizer.ScreenType.mobile
                              ? 1.h
                              : 0.8.h),
                      // controller.getLableText('Services List',
                      //     isMainTitle: false),

                      Obx(() => controller.serviceList.isNotEmpty
                          ? getHomeLable('Services List', () {
                              Get.to(ServiceScreen(
                                data: widget.isFromProfile == true
                                    ? null
                                    : widget.item,
                                id: businessId,
                              ))!
                                  .then((value) {});
                            }, isFromDetailScreen: true, isShowSeeMore: false)
                          : const SizedBox.shrink()),
                      // getHomeLable('Services List', () {
                      //   Get.to(ServiceScreen(
                      //     data: widget.isFromProfile == true ? null : widget.item,
                      //     id: businessId,
                      //   ))!
                      //       .then((value) {});
                      // }, isFromDetailScreen: true),
                    ],
                  ),
                ),
                Positioned(
                  right: 6.w,
                  top: 1.5.h,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          shareBusinessDetailsOnWhatsApp(
                              context: context,
                              businessName: widget.item != null
                                  ? widget.item!.businessName
                                  : businessName,
                              address: widget.item != null
                                  ? widget.item!.address.toString()
                                  : address,
                              email: widget.item != null
                                  ? widget.item!.email
                                  : email,
                              phoneNumber: widget.item != null
                                  ? widget.item!.phone
                                  : phone);
                        },
                        child: Container(
                            height: 4.h,
                            width: 10.w,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: primaryColor),
                            padding: EdgeInsets.all(7),
                            child: SvgPicture.asset(Asset.whatsapp2,
                                height: 2.h,
                                width: 2.w,
                                colorFilter:
                                    ColorFilter.mode(white, BlendMode.srcIn))),
                      ),
                      getDynamicSizedBox(width: 1.h),
                      GestureDetector(
                        onTap: () {
                          print('Share pdf');

                          pdfPopupDialogs(
                            // ignore: use_build_context_synchronously
                            context,
                            function: (String val) async {
                              logcat("SelectedValue::", val);
                              controller.getpdfFromApi(context,
                                  theme: val, id: idUsedinCtr);
                            },
                          );
                        },
                        child: Container(
                          height: 4.h,
                          width: 10.w,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: primaryColor),
                          padding: EdgeInsets.all(1),
                          child: Icon(
                            Icons.share,
                            color: white,
                            size: 17.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: controller.scrollController,
                padding: EdgeInsets.only(bottom: 5.h),
                physics: const BouncingScrollPhysics(),
                child: Obx(
                  () {
                    return controller.isServiceLoading.value
                        ? SizedBox(
                            height: 22.h,
                            child: const Center(
                                child: CircularProgressIndicator(
                                    color: primaryColor)),
                          )
                        : controller.serviceList.isNotEmpty
                            ? ListView.builder(
                                padding: EdgeInsets.only(top: 1.h, bottom: 5.h),
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                clipBehavior: Clip.antiAlias,
                                itemCount: controller.serviceList.length +
                                    (controller.nextPageURL.value.isNotEmpty
                                        ? 1
                                        : 0),
                                itemBuilder: (context, index) {
                                  if (index < controller.serviceList.length) {
                                    ServiceDataList data =
                                        controller.serviceList[index];
                                    return controller.getServiceListItem(
                                        isFromProfile: widget.isFromProfile,
                                        context,
                                        data);
                                  } else if (controller.isFetchingMore.value) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2.h),
                                      child: const Center(
                                        child: SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: CircularProgressIndicator(
                                              color: primaryColor),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              )
                            : controller.serviceList.isEmpty
                                ? SizedBox(
                                    height: 22.h,
                                    child: Center(
                                        child: getEmptyUi(isservice: true)),
                                  )
                                : controller.isFetchingMore.value
                                    ? Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 2.h),
                                        child: const Center(
                                          child: SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: CircularProgressIndicator(
                                                color: primaryColor),
                                          ),
                                        ),
                                      )
                                    : Container();
                  },
                ),
              ),
            ),
            getDynamicSizedBox(height: 1.h),
          ],
        ));
  }
}
