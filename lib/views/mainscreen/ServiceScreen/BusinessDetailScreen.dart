import 'package:animate_do/animate_do.dart';
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
import 'package:marquee/marquee.dart';
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
  String address = '';
  double? businessReviewsAvgRating = 0.0;
  @override
  void initState() {
    logcat("Item::", widget.item.toString());
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
    businessReviewsAvgRating = retrievedObject.businessReviewsAvgRating!;

    futureDelay(() {
      controller.getServiceList(context, 1, true,
          widget.item != null ? widget.item!.id : retrievedObject.id);
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
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        controller: scrollController,
        slivers: [
          Container(
            width: Device.width,
            decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
          ),
          SliverAppBar(
            expandedHeight: 27.h,
            centerTitle: true,
            clipBehavior: Clip.antiAlias,
            elevation: 0.2,
            floating: false,
            pinned: true,
            stretch: true,
            titleSpacing: 0,
            automaticallyImplyLeading: true,
            backgroundColor: showTitle == true ? primaryColor : white,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                percentage = ((constraints.maxHeight - kToolbarHeight) /
                        (27.h - kToolbarHeight))
                    .clamp(0.0, 1.0);
                showTitle = percentage! <= 0.5;
                return FlexibleSpaceBar(
                    centerTitle: true,
                    titlePadding: EdgeInsets.only(
                        top: isSmallDevice(context)
                            ? 6.3.h
                            : Device.screenType == sizer.ScreenType.mobile
                                ? 6.6.h
                                : 3.2.h,
                        left: 15.w,
                        right: 15.w),
                    title: showTitle
                        ? widget.item!.businessName.toString().length > 9
                            ? Marquee(
                                style: TextStyle(
                                  fontFamily: fontRegular,
                                  color: isDarkMode() ? white : white,
                                  fontSize: Device.screenType ==
                                          sizer.ScreenType.mobile
                                      ? 14.sp
                                      : 12.sp,
                                ),
                                text: widget.item!.businessName
                                    .toString()
                                    .length
                                    .toString(),
                                scrollAxis: Axis.horizontal,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                blankSpace: 20.0,
                                velocity: 20,
                                pauseAfterRound: const Duration(seconds: 1),
                                accelerationDuration:
                                    const Duration(seconds: 1),
                                accelerationCurve: Curves.linear,
                                decelerationDuration:
                                    const Duration(milliseconds: 500),
                                decelerationCurve: Curves.easeOut,
                              )
                            : Text(
                                "Product Detail",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: fontRegular,
                                  color: isDarkMode() ? white : white,
                                  fontSize: 12.sp,
                                ),
                              )
                        : null,
                    background: Container(
                        color: isDarkMode() ? darkBackgroundColor : transparent,
                        child: FadeInDown(
                            child: Container(
                                margin: EdgeInsets.only(bottom: 0.9.h),
                                decoration: BoxDecoration(
                                    boxShadow: isDarkMode()
                                        ? null
                                        : [
                                            BoxShadow(
                                                color: grey.withOpacity(0.5),
                                                blurRadius: 1,
                                                offset: const Offset(0, 3),
                                                spreadRadius: 0.2)
                                          ],
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(7.w),
                                        bottomRight: Radius.circular(7.w))),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(7.w),
                                      bottomRight: Radius.circular(7.w)),
                                  child: CachedNetworkImage(
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
                                )))));
              },
            ),
            leading: Builder(
              builder: (context) {
                return Container(
                  margin: EdgeInsets.only(
                      left: Device.screenType == sizer.ScreenType.mobile
                          ? 4.w
                          : 2.w),
                  child: GestureDetector(
                    onTap: () {
                      Get.back(result: true);
                    },
                    child: Container(
                      height: 1.5.h,
                      width: 1.5.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: inputBgColor,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          Asset.arrowBack,
                          colorFilter: ColorFilter.mode(black, BlendMode.srcIn),
                          height: 2.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    //  Container(
                    //     padding: EdgeInsets.all(
                    //         Device.screenType == sizer.ScreenType.mobile
                    //             ? 8
                    //             : 0),
                    //     child: SvgPicture.asset(
                    //       Asset.arrowBack,
                    //       // ignore: deprecated_member_use
                    //       color: black,
                    //       height: Device.screenType == sizer.ScreenType.mobile
                    //           ? 4.h
                    //           : 5.h,
                    //     )),
                  ),
                );
              },
            ),
            actions: [
              // Builder(
              //   builder: (context) {
              //     return Container(
              //         margin: EdgeInsets.only(
              //             right: SizerUtil.deviceType == DeviceType.mobile
              //                 ? 2.w
              //                 : 3.w),
              //         child: GetBuilder<ProductDetailScreenController>(
              //           builder: (controller) {
              //             return GestureDetector(
              //               onTap: () {
              //                 if (controller.isGuest!.value == true) {
              //                   getGuestUserAlertDialog(
              //                       context, ProductDetailScreenConstant.title);
              //                 } else {
              //                   addFavouriteAPI(
              //                       context,
              //                       controller.networkManager,
              //                       widget.fromFav != null &&
              //                               widget.fromFav == true
              //                           ? widget.data!.productId.toString()
              //                           : widget.data!.id.toString(),
              //                       '1', onClick: (isDone) {
              //                     controller.isFromFavApiCallSuccess!.value =
              //                         isDone;
              //                     setState(() {});
              //                   }, ProductDetailScreenConstant.title);
              //                 }
              //               },
              //               child: Obx(
              //                 () {
              //                   return Container(
              //                       padding: EdgeInsets.all(
              //                           SizerUtil.deviceType ==
              //                                   DeviceType.mobile
              //                               ? 10
              //                               : 0),
              //                       child: Icon(
              //                           controller.isLiked!.value == true
              //                               ? Icons.favorite_rounded
              //                               : Icons.favorite_border,
              //                           color: isDarkMode()
              //                               ? showTitle == true
              //                                   ? Color.lerp(black, white,
              //                                       percentage ?? 0.0)
              //                                   : black
              //                               : black,
              //                           size: 3.5.h));
              //                 },
              //               ),
              //             );
              //           },
              //         ));
              //   },
              // ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: 5.w,
                    right: 5.w,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                          RatingBar.builder(
                            initialRating:
                                (widget.item?.businessReviewsAvgRating ??
                                        businessReviewsAvgRating) ??
                                    0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 1,
                            itemSize: 4.w,
                            unratedColor: Colors.orange,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.orange,
                            ),
                            onRatingUpdate: (rating) {
                              logcat("RATING", rating);
                            },
                          ),
                          Padding(
                              padding:
                                  EdgeInsets.only(left: 0.5.w, right: 0.5.w),
                              child: Text(
                                widget.item != null &&
                                        widget.item!.businessReviewsAvgRating !=
                                            null
                                    ? widget.item!.businessReviewsAvgRating
                                        .toString()
                                    : businessReviewsAvgRating.toString(),
                                style: TextStyle(
                                    fontFamily: fontSemiBold,
                                    color: lableColor,
                                    fontSize: Device.screenType ==
                                            sizer.ScreenType.mobile
                                        ? 16.sp
                                        : 14.sp,
                                    height: 1.2),
                                maxLines: 1,
                              ))
                        ],
                      ),
                      // controller.getCategoryLable(widget.item.businessName),
                      getDynamicSizedBox(height: 1.h),
                      controller.getLableText(
                          widget.item != null ? widget.item!.email : email,
                          isMainTitle: false),
                      getDynamicSizedBox(height: 1.h),
                      controller.getLableText('Address : ', isMainTitle: false),
                      getDynamicSizedBox(height: 0.5.h),
                      controller.getCommonText(
                          widget.item != null ? widget.item!.address : address,
                          isHint: true),
                      getDynamicSizedBox(
                          height: Device.screenType == sizer.ScreenType.mobile
                              ? 1.h
                              : 0.8.h),
                      // controller.getLableText('Services List',
                      //     isMainTitle: false),
                      getHomeLable('Services List', () {
                        Get.to(ServiceScreen(
                          data:
                              widget.isFromProfile == true ? null : widget.item,
                          id: businessId,
                        ))!
                            .then((value) {});
                      }, isFromDetailScreen: true),
                      Obx(
                        () {
                          return controller.isBannerLoading.value
                              ? SizedBox(
                                  height: 22.h,
                                  child: const Center(
                                      child: CircularProgressIndicator(
                                          color: primaryColor)),
                                )
                              : controller.serviceList.isNotEmpty
                                  ? SizedBox(
                                      height: 20.h,
                                      child: ListView.builder(
                                          padding: EdgeInsets.only(
                                              left: 0.w, right: 1.w),
                                          physics:
                                              const BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          clipBehavior: Clip.antiAlias,
                                          itemBuilder: (context, index) {
                                            ServiceDataList data =
                                                controller.serviceList[index];
                                            return controller.getListItem(
                                                context, data);
                                          },
                                          itemCount:
                                              controller.serviceList.length),
                                    )
                                  : Container();
                        },
                      ),
                      getDynamicSizedBox(height: 1.h),
                    ],
                  ),
                ),
                getDynamicSizedBox(height: 3.h),
              ],
            ),
          )
        ],
      ),
    );
  }
}
