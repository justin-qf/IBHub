import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/apiOtherStates.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/homeController.dart';
import 'package:ibh/models/businessListModel.dart';
import 'package:ibh/models/categoryListModel.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/helper.dart';
import 'package:ibh/views/Profile/UpdateProfile.dart';
import 'package:ibh/views/mainscreen/HomeScreen/CategoryScreen.dart';
import 'package:ibh/views/mainscreen/ServiceScreen/AddServiceScreen.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sizer/sizer.dart';
import 'package:sizer/sizer.dart' as sizer;
import '../../../../configs/colors_constant.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  HomeScreen(this.callBack, {super.key});
  Function callBack;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var controller = Get.put(HomeScreenController());

  @override
  void initState() {
    super.initState();
    controller.state.value = ScreenState.apiLoading;
    futureDelay(() {
      controller.getCategoryList(context);
      controller.getBusinessList(context, 1, false, isFirstTime: true);
      controller.getUpdateApi(context, false);
    }, isOneSecond: true);
    controller.pageController =
        PageController(initialPage: controller.currentPage);
    controller.scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    controller.currentPage = 1;
    controller.businessList.clear();
    controller.categoryList.clear();
    super.dispose();
  }

  void scrollListener() {
    if (controller.scrollController.position.pixels ==
            controller.scrollController.position.maxScrollExtent &&
        controller.nextPageURL.value.isNotEmpty &&
        !controller.isFetchingMore) {
      if (!mounted) return;
      setState(() => controller.isFetchingMore = true);
      controller.currentPage++;
      Future.delayed(
        const Duration(seconds: 1),
        () {
          controller.isBusinessLoading.value = false;
          controller
              .getBusinessList(context, controller.currentPage, true,
                  isFirstTime: false)
              .whenComplete(() {
            if (mounted) {
              setState(() => controller.isFetchingMore = false);
            }
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Statusbar().transparentStatusbarIsNormalScreen();
    return CustomParentScaffold(
      onWillPop: () async {
        getpopup(context,
            title: 'Exit App',
            message: 'Are you sure you want to quit the app?', function: () {
          exit(0);
        });
        return false;
      },
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                // getCommonToolbar(HomeScreenconst.dashboard,
                //     showBackButton: false),
                Expanded(
                  child: SmartRefresher(
                    physics: const BouncingScrollPhysics(),
                    controller: controller.refreshController,
                    enablePullDown: true,
                    enablePullUp: false,
                    header: const WaterDropMaterialHeader(
                        backgroundColor: primaryColor, color: white),
                    onRefresh: () async {
                      controller.currentPage = 1;
                      futureDelay(() {
                        controller.getCategoryList(context);
                        controller.getBusinessList(context, 1, false,
                            isFirstTime: true);
                      }, isOneSecond: false);
                      controller.refreshController.refreshCompleted();
                    },
                    child: CustomScrollView(
                      controller: controller.scrollController,
                      physics: const NeverScrollableScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Obx(() {
                            switch (controller.state.value) {
                              case ScreenState.apiLoading:
                              case ScreenState.noNetwork:
                              case ScreenState.noDataFound:
                              case ScreenState.apiError:
                                return SizedBox(
                                  height: Device.height / 1.3,
                                  child: apiOtherStates(controller.state.value,
                                      controller, controller.categoryList, () {
                                    controller.currentPage = 1;
                                    futureDelay(() {
                                      controller.getCategoryList(context);
                                      controller.getBusinessList(
                                          context, 1, false,
                                          isFirstTime: true);
                                    }, isOneSecond: false);
                                    controller.refreshController
                                        .refreshCompleted();
                                  }),
                                );
                              case ScreenState.apiSuccess:
                                return apiSuccess(controller.state.value);
                              default:
                                Container();
                            }
                            return Container();
                          }),
                        )
                      ],
                    ),
                  ),

                  //  SingleChildScrollView(
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   child:
                  // ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget apiSuccess(ScreenState state) {
    if (state == ScreenState.apiSuccess) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getDynamicSizedBox(height: 2.h),
            Container(
              margin: EdgeInsets.only(left: 5.w),
              child: SizedBox(
                  // color: Colors.yellow,
                  height: 5.h,
                  width: 18.w,
                  child: Image.asset(Asset.applogo)),
            ),
            getDynamicSizedBox(height: 2.h),
            getHomeLable(DashboardText.categoryTitle, () {
              Get.to(const CategoryScreen())!.then((value) {
                futureDelay(() {
                  controller.currentPage = 1;
                  controller.getBusinessList(context, 1, false,
                      isFirstTime: true);
                }, isOneSecond: false);
              });
            }),
            getDynamicSizedBox(height: 2.h),
            SizedBox(
                height: Device.screenType == sizer.ScreenType.mobile
                    ? isSmallDevice(context)
                        ? 16.h
                        : 15.h
                    : 20.h,
                child: Obx(() {
                  return controller.isCategoryLoading.value
                      ? SizedBox(
                          height: 12.h,
                          child: const Center(
                              child: CircularProgressIndicator(
                                  color: primaryColor)),
                        )
                      : controller.categoryList.isNotEmpty
                          ? ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.only(
                                  left: 5.w, right: 1.w, top: 0.5.h),
                              shrinkWrap: false,
                              scrollDirection: Axis.horizontal,
                              clipBehavior: Clip.antiAlias,
                              itemBuilder: (context, index) {
                                CategoryListData data =
                                    controller.categoryList[index];
                                return controller.getCategoryListItem(
                                    context, data);
                              },
                              itemCount: controller.categoryList.length)
                          : Container();
                })),
            if (controller.isUserVerified.value == false)
              getDynamicSizedBox(height: 3.h),
            !controller.isUserVerified.value
                ? GestureDetector(
                    onTap: () {
                      Get.to(UpdateProfile());
                    },
                    child: Container(
                      width: Device.width,
                      margin:
                          EdgeInsets.symmetric(vertical: 0.h, horizontal: 5.w),
                      padding:
                          EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: black, width: 1),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black12,
                        //     blurRadius: 6,
                        //     offset: Offset(0, 3),
                        //   ),
                        // ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.upload_file,
                              color: secondaryColor, size: 24.sp),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              'To get your business listed and verified,\nupload your docs now!',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontFamily: dM_sans_semiBold,
                                color: secondaryColor,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )

                //  Container(
                //     width: Device.width,
                //     padding:
                //         EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
                //     decoration: BoxDecoration(
                //         border: Border(
                //             top: BorderSide(color: black),
                //             bottom: BorderSide(color: black))),
                //     // height: 3.h, // Adjust height as needed
                //     child: Center(
                //       child: Text(
                //         textAlign: TextAlign.center,
                //         'To Get your business listed and verified.\nUpload your docs now!',
                //         style: TextStyle(
                //           fontSize: 15.sp,
                //           fontFamily: dM_sans_semiBold,
                //           color: secondaryColor,
                //         ),
                //       ),
                //     ),
                //   )

                // Padding(
                //     padding: EdgeInsets.symmetric(horizontal: 5.w),
                //     child: Text(
                //       '*To Get your business listed and verified. Upload your docs now!',
                //       style: TextStyle(
                //         fontSize: 15.sp,
                //         fontFamily: dM_sans_semiBold,
                //       ),
                //     ),
                //   )
                : SizedBox.shrink(),
            getDynamicSizedBox(height: 3.h),
            getHomeLable(DashboardText.buisinessTitle, () {
              Get.to(AddServicescreen())!.then((value) {});
            }, isShowSeeMore: false),
            getDynamicSizedBox(height: 3.h),
            Obx(
              () {
                return controller.isBusinessLoading.value
                    ? SizedBox(
                        height: 40.h,
                        child: const Center(
                            child:
                                CircularProgressIndicator(color: primaryColor)),
                      )
                    : controller.businessList.isNotEmpty
                        ? SingleChildScrollView(
                            // controller: controller.scrollController,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(bottom: 5.h),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 1.h,
                                        childAspectRatio: 1.5,
                                        crossAxisSpacing: 1.w),
                                padding: EdgeInsets.only(),
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                clipBehavior: Clip.antiAlias,
                                itemCount: controller.businessList.length +
                                    (controller.nextPageURL.value.isNotEmpty
                                        ? 1
                                        : 0),
                                itemBuilder: (context, index) {
                                  if (index < controller.businessList.length) {
                                    BusinessData data =
                                        controller.businessList[index];
                                    return controller.getBusinessListItem(
                                        context, data);
                                  } else if (controller.isFetchingMore) {
                                    return Center(
                                        child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.h),
                                            child:
                                                const CircularProgressIndicator(
                                                    color: primaryColor)));
                                  } else {
                                    return controller.isFetchingMore
                                        ? Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.h),
                                            child: const Center(
                                              child: SizedBox(
                                                height: 30,
                                                width: 30,
                                                child:
                                                    CircularProgressIndicator(
                                                        color: primaryColor),
                                              ),
                                            ),
                                          )
                                        : Container();
                                  }
                                },
                              ),
                            ),
                          )

                        // SizedBox(
                        //     height: Device.height,
                        //     child: SmartRefresher(
                        //       physics: const BouncingScrollPhysics(),
                        //       controller: controller.refreshController,
                        //       enablePullDown: true,
                        //       enablePullUp: false,
                        //       header: const WaterDropMaterialHeader(
                        //           backgroundColor: primaryColor, color: white),
                        //       onRefresh: () async {
                        //         futureDelay(() {
                        //           controller.currentPage = 1;
                        //           controller.getBusinessList(context, 1, false,
                        //               isFirstTime: true);
                        //         }, isOneSecond: false);
                        //         controller.refreshController.refreshCompleted();
                        //       },
                        //       child: SingleChildScrollView(
                        //         controller: controller.scrollController,
                        //         physics: const BouncingScrollPhysics(),
                        //         padding: EdgeInsets.only(bottom: 48.h),
                        //         child: ListView.builder(
                        //           padding: EdgeInsets.only(
                        //               left: 1.w, right: 1.w, top: 2.h),
                        //           physics: const NeverScrollableScrollPhysics(),
                        //           scrollDirection: Axis.vertical,
                        //           shrinkWrap: true,
                        //           clipBehavior: Clip.antiAlias,
                        //           itemCount: controller.businessList.length +
                        //               (controller.nextPageURL.value.isNotEmpty
                        //                   ? 1
                        //                   : 0),
                        //           itemBuilder: (context, index) {
                        //             if (index < controller.businessList.length) {
                        //               BusinessData data =
                        //                   controller.businessList[index];
                        //               return controller.getBusinessListItem(
                        //                   context, data);
                        //             } else if (controller.isFetchingMore) {
                        //               return Center(
                        //                   child: Padding(
                        //                       padding: EdgeInsets.symmetric(
                        //                           vertical: 2.h),
                        //                       child:
                        //                           const CircularProgressIndicator(
                        //                               color: primaryColor)));
                        //             } else {
                        //               return controller.isFetchingMore
                        //                   ? Padding(
                        //                       padding: EdgeInsets.symmetric(
                        //                           vertical: 2.h),
                        //                       child: const Center(
                        //                         child: SizedBox(
                        //                           height: 30,
                        //                           width: 30,
                        //                           child: CircularProgressIndicator(
                        //                               color: primaryColor),
                        //                         ),
                        //                       ),
                        //                     )
                        //                   : Container();
                        //             }
                        //           },
                        //         ),
                        //       ),
                        //     ),
                        //   )
                        // controller.businessList.isEmpty
                        //     ? Center(
                        //         child: Padding(
                        //             padding: EdgeInsets.symmetric(vertical: 2.h),
                        //             child: const CircularProgressIndicator(
                        //                 color: primaryColor)))
                        : controller.businessList.isEmpty
                            ? SizedBox(
                                height: 22.h,
                                child: Center(
                                    child: SizedBox(
                                  child: Center(
                                    child: Text(
                                      Common.businessdatanotfound,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: dM_sans_medium,
                                          fontSize: 16.sp),
                                    ),
                                  ),
                                )),
                              )
                            : Container();
              },
            )
          ]);
    } else {
      return noDataFoundWidget();
    }
  }
}
