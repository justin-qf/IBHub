import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/controller/serviceDetailController.dart';
import 'package:ibh/models/ServiceListModel.dart';
import 'package:ibh/models/businessListModel.dart';
import 'package:ibh/models/login_model.dart';
import 'package:ibh/preference/UserPreference.dart';
import 'package:ibh/utils/helper.dart';
import 'package:ibh/utils/log.dart';
import 'package:ibh/views/mainscreen/ServiceScreen/ServiceScreen.dart';
import 'package:sizer/sizer.dart' as sizer;
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class BusinessDetailScreen extends StatefulWidget {
  BusinessDetailScreen(
      {required this.item, required this.isFromProfile, super.key});
  BusinessData? item;
  bool? isFromProfile;

  @override
  State<BusinessDetailScreen> createState() => _BusinessDetailScreenState();
}

class _BusinessDetailScreenState extends State<BusinessDetailScreen> {
  var controller = Get.put(ServiceDetailScreenController());
  bool showTitle = false;
  double? percentage;
  final ScrollController scrollController = ScrollController();

  String businessName = '';
  String businessId = '';
  String thumbnail = '';
  String email = '';
  String phone = '';
  String address = '';
  double? businessReviewsAvgRating = 0.0;
  @override
  void initState() {
    getUserData();

    super.initState();
  }

  getUserData() async {
    User? retrievedObject = await UserPreferences().getSignInInfo();

    businessName = retrievedObject!.businessName;
    thumbnail = retrievedObject.visitingCardUrl;
    email = retrievedObject.email;
    address = retrievedObject.address;
    businessId = retrievedObject.id.toString();
    phone = retrievedObject.phone.toString();
    businessReviewsAvgRating = retrievedObject.businessReviewsAvgRating!;

    final idUsedinCtr =
        widget.item != null ? widget.item!.id : retrievedObject.id;
    controller.bussinessID(idUsedinCtr);

    futureDelay(() {
      controller.getServiceList(context, 1, true, idUsedinCtr);
    }, isOneSecond: true);

    setState(() {});
  }

  @override
  void dispose() {
    businessId = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Statusbar().trasparentStatusbar();
    return CustomParentScaffold(
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
            Container(
              padding: EdgeInsets.only(top: 4.h),
              width: Device.width,
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 2.w),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: 15.w,
                        height: 7.h,
                        child: FloatingActionButton(
                          onPressed: () {
                            Get.back(result: true);
                          },
                          backgroundColor: inputBgColor,
                          elevation: 0,
                          mini: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: SvgPicture.asset(
                            Asset.arrowBack,
                            colorFilter:
                                ColorFilter.mode(black, BlendMode.srcIn),
                            height: 24,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: 2.w, right: 2.w, bottom: 4.h),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      height: 14.h,
                      imageUrl: widget.item != null
                          ? widget.item!.visitingCardUrl
                          : thumbnail,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(color: primaryColor),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        Asset.placeholder,
                        height: 9.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getDynamicSizedBox(height: 1.h),
                  Row(
                    children: [
                      controller.getLableText(
                          widget.item != null
                              ? widget.item!.businessName
                              : businessName,
                          isMainTitle: true),
                      const Spacer(),
                    ],
                  ),
                  // controller.getCategoryLable(widget.item.businessName),
                  getDynamicSizedBox(height: 1.h),
                  controller.getLableText(
                      widget.item != null ? widget.item!.email : email,
                      isMainTitle: false),
                  getDynamicSizedBox(height: 1.h),
                  GestureDetector(
                    onTap: () {
                      launchPhoneCall(
                          widget.item != null ? widget.item!.phone : phone);
                    },
                    child: controller.getLableText(
                        widget.item != null ? widget.item!.phone : phone,
                        isMainTitle: false),
                  ),
                  getDynamicSizedBox(height: 1.h),
                  if (widget.item != null && widget.item!.address.isNotEmpty)
                    controller.getLableText('Address : ', isMainTitle: false),
                  getDynamicSizedBox(height: 0.5.h),
                  if (widget.item != null && widget.item!.address.isNotEmpty)
                    controller.getCommonText(
                        widget.item != null
                            ? widget.item!.address.toString()
                            : address,
                        isHint: false),
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
                        }, isFromDetailScreen: true)
                      : SizedBox.shrink()),
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
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
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
                                padding: EdgeInsets.only(top: 1.h),
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                clipBehavior: Clip.antiAlias,
                                itemBuilder: (context, index) {
                                  ServiceDataList data =
                                      controller.serviceList[index];
                                  return controller.getServiceListItem(
                                      isFromProfile: widget.isFromProfile,
                                      context,
                                      data);
                                },
                                itemCount: controller.serviceList.length)
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
