import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/apiOtherStates.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/controller/brandingscreencontroller.dart';
import 'package:ibh/models/businessListModel.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/helper.dart';
import 'package:ibh/views/mainscreen/BrandingScreeens/BrandingDetailsScreen.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sizer/sizer.dart';
import 'package:sizer/sizer.dart' as sizer;

// ignore: must_be_immutable
class BrandingScreen extends StatefulWidget {
  BrandingScreen(this.callBack, {super.key});
  Function callBack;

  @override
  State<BrandingScreen> createState() => _BrandingScreenState();
}

class _BrandingScreenState extends State<BrandingScreen> {
  var controller = Get.put(Brandingscreencontroller());

  @override
  void initState() {
    super.initState();
    controller.state.value = ScreenState.apiLoading;
    futureDelay(() {
      controller.getBusinessList(context, 1, false, isFirstTime: true);
    }, isOneSecond: true);

    // controller.pageController =
    //     PageController(initialPage: controller.currentPage);
    // controller.scrollController.addListener(scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    Statusbar().transparentStatusbarIsNormalScreen();
    return CustomParentScaffold(
        onWillPop: () async {
          Get.back(result: true);
          return false;
        },
        onTap: () {
          controller.hideKeyboard(context);
        },
        isExtendBodyScreen: true,
        body: Container(
          color: transparent,
          child: Column(
            children: [
              getDynamicSizedBox(height: 4.h),
              getCommonToolbar("Branding", showBackButton: false),
              Expanded(
                child: SmartRefresher(
                  physics: const BouncingScrollPhysics(),
                  controller: controller.refreshController,
                  enablePullDown: true,
                  enablePullUp: false,
                  header: const WaterDropMaterialHeader(
                      backgroundColor: primaryColor, color: white),
                  onRefresh: () async {
                    futureDelay(() {
                      controller.currentPage = 1;
                      controller.getBusinessList(
                        context,
                        controller.currentPage,
                        false,
                        isFirstTime: true,
                      );
                    }, isOneSecond: false);
                    controller.refreshController.refreshCompleted();
                  },
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Obx(() {
                          switch (controller.state.value) {
                            case ScreenState.apiLoading:
                            case ScreenState.noNetwork:
                            case ScreenState.noDataFound:
                            case ScreenState.apiError:
                              return SizedBox(
                                height: Device.height / 1.5,
                                child: apiOtherStates(controller.state.value,
                                    controller, controller.searchList, () {
                                  controller.currentPage = 1;

                                  controller.getBusinessList(
                                    context,
                                    1,
                                    false,
                                    isFirstTime: true,
                                  );
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
              ),
            ],
          ),
        ));
  }

  Widget apiSuccess(ScreenState state) {
    if (state == ScreenState.apiSuccess

        // && controller.businessList.isNotEmpty

        ) {
      return Column(
        children: [
          getDynamicSizedBox(height: 3.h),
          // controller.getDigitalCardLayout(context),
          getHomeLable('Daily Images', () {
            Get.to(Brandingdetailsscreen(
              count: 1,
            ));
            // Get.to(const CategoryScreen())!.then((value) {
            //   futureDelay(() {
            //     controller.currentPage = 1;
            //     controller.getBusinessList(context, 1, false,
            //         isFirstTime: true);
            //   }, isOneSecond: false);
            // });
          }),
          getDynamicSizedBox(height: 2.h),
          Container(
              color: transparent,
              height: Device.screenType == sizer.ScreenType.mobile
                  ? isSmallDevice(context)
                      ? 15.h
                      : 18.h
                  : 20.h,
              child: Obx(() {
                final items = controller.businessList.take(6).toList();
                return controller.isBusinessLoading.value
                    ? SizedBox(
                        height: 12.h,
                        child: const Center(
                            child:
                                CircularProgressIndicator(color: primaryColor)),
                      )
                    : controller.businessList.isNotEmpty
                        ? ListView.builder(
                            // controller: controller.scrollController,
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.only(
                                bottom: 5.h, left: 2.w, right: 2.w, top: 1.h),

                            shrinkWrap: false,
                            scrollDirection: Axis.horizontal,
                            clipBehavior: Clip.antiAlias,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              if (index < controller.businessList.length) {
                                BusinessData data =
                                    controller.businessList[index];
                                return controller.getDailyListItem(
                                    dailyName: controller.dailyNames[index],
                                    dailyImg: controller.dailyImages[index],
                                    context,
                                    data);
                              } else if (controller.isFetchingfestivalMore) {
                                return Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.h),
                                    child: const CircularProgressIndicator(
                                        color: primaryColor),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          )
                        : Container();
              })),
          getDynamicSizedBox(height: 1.h),
          getSeeAll(
              title: 'Festivals Images',
              onCLick: () {
                Get.to(Brandingdetailsscreen(
                  count: 2,
                ));
                // Get.to(const CategoryScreen())!.then((value) {
                //   futureDelay(() {
                //     controller.currentPage = 1;
                //     controller.getBusinessList(context, 1, false,
                //         isFirstTime: true);
                //   }, isOneSecond: false);
                // });
              }),
          getDynamicSizedBox(height: 2.h),
          Container(
              color: transparent,
              // width: 10.w,
              height: Device.screenType == sizer.ScreenType.mobile
                  ? isSmallDevice(context)
                      ? 15.h
                      : 18.h
                  : 25.h,
              child: Obx(() {
                final items = controller.businessList.take(6).toList();
                return controller.isBusinessLoading.value
                    ? SizedBox(
                        height: 12.h,
                        child: const Center(
                            child:
                                CircularProgressIndicator(color: primaryColor)),
                      )
                    : controller.businessList.isNotEmpty
                        ? ListView.builder(
                            // controller: controller.scrollController,
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.only(
                                bottom: 2.h, left: 2.w, right: 2.w, top: 1.h),
                            shrinkWrap: false,
                            scrollDirection: Axis.horizontal,
                            clipBehavior: Clip.antiAlias,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              if (index < controller.businessList.length) {
                                BusinessData data =
                                    controller.businessList[index];
                                return controller.getFestivalListItem(
                                    festivalName:
                                        controller.festivalNames[index],
                                    festivalImg:
                                        controller.festivalImages[index],
                                    context,
                                    data);
                              } else if (controller.isFetchingfestivalMore) {
                                return Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.h),
                                    child: const CircularProgressIndicator(
                                        color: primaryColor),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          )
                        : Container();
              })),
          getDynamicSizedBox(height: 2.h),
          getHomeLable('Bussiness Images', () {
            Get.to(Brandingdetailsscreen(
              count: 3,
            ));
            // Get.to(const CategoryScreen())!.then((value) {
            //   futureDelay(() {
            //     controller.currentPage = 1;
            //     controller.getBusinessList(context, 1, false,
            //         isFirstTime: true);
            //   }, isOneSecond: false);
            // });
          }),
          getDynamicSizedBox(height: 2.h),
          Container(
              color: transparent,
              height: Device.screenType == sizer.ScreenType.mobile
                  ? isSmallDevice(context)
                      ? 15.h
                      : 18.h
                  : 25.h,
              child: Obx(() {
                final items = controller.businessList.take(6).toList();
                return controller.isBusinessLoading.value
                    ? SizedBox(
                        height: 12.h,
                        child: const Center(
                            child:
                                CircularProgressIndicator(color: primaryColor)),
                      )
                    : controller.businessList.isNotEmpty
                        ? ListView.builder(
                            // controller: controller.scrollController,
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.only(
                                bottom: 2.h, left: 2.w, right: 2.w, top: 1.h),
                            shrinkWrap: false,
                            scrollDirection: Axis.horizontal,
                            clipBehavior: Clip.antiAlias,

                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              if (index < controller.businessList.length) {
                                BusinessData data =
                                    controller.businessList[index];
                                return controller.getBusinessListItem(
                                    context, data);
                              } else if (controller.isFetchingfestivalMore) {
                                return Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.h),
                                    child: const CircularProgressIndicator(
                                        color: primaryColor),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          )
                        : Container();
              })),
        ],
      );

      // ListView.builder(
      //   controller: controller.scrollController,
      //   physics: const BouncingScrollPhysics(),
      //   padding:
      //       EdgeInsets.only(left: 1.w, right: 1.w, top: 0.5.h, bottom: 12.h),
      //   scrollDirection: Axis.vertical,
      //   shrinkWrap: true,
      //   clipBehavior: Clip.antiAlias,
      //   itemCount: controller.businessList.length +
      //       (controller.nextPageURL.value.isNotEmpty ? 1 : 0),
      //   itemBuilder: (context, index) {
      //     if (index < controller.businessList.length) {
      //       BusinessData data = controller.businessList[index];
      //       return controller.getBusinessListItem(context, data);
      //     } else if (controller.isFetchingMore) {
      //       return Center(
      //         child: Padding(
      //           padding: EdgeInsets.symmetric(vertical: 2.h),
      //           child: const CircularProgressIndicator(color: primaryColor),
      //         ),
      //       );
      //     } else {
      //       return Container();
      //     }
      //   },
      // );
      // return MasonryGridView.count(
      //   controller: controller.scrollController,
      //   physics: const BouncingScrollPhysics(),
      //   padding: EdgeInsets.only(bottom: 2.h, left: 5.w, right: 5.w, top: 2.h),
      //   crossAxisCount: Device.screenType == sizer.ScreenType.mobile ? 2 : 3,
      //   mainAxisSpacing: 10,
      //   crossAxisSpacing: 4,
      //   itemCount: controller.businessList.length +
      //       (controller.nextPageURL.value.isNotEmpty ? 1 : 0),
      //   itemBuilder: (context, index) {
      //     if (index < controller.businessList.length) {
      //       BusinessData data = controller.businessList[index];
      //       return controller.getBusinessListItem(context, data);
      //     } else if (controller.isFetchingMore) {
      //       return Center(
      //         child: Padding(a
      //           padding: EdgeInsets.symmetric(vertical: 2.h),
      //           child: const CircularProgressIndicator(color: primaryColor),
      //         ),
      //       );
      //     } else {
      //       return Container();
      //     }
      //   },
      // );
    } else {
      return noDataFoundWidget();
    }
  }
}
