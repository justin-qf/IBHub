import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/apiOtherStates.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/controller/favouriteController.dart';
import 'package:ibh/models/businessListModel.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/helper.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sizer/sizer.dart';
import 'package:sizer/sizer.dart' as sizer;

// ignore: must_be_immutable
class FavouriteScreen extends StatefulWidget {
  FavouriteScreen(this.callBack, {super.key});
  Function callBack;

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  var controller = Get.put(FavouriteController());
  bool showText = false;
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => showText = true);
    });
    controller.isSearch = false;
    futureDelay(() {
      controller.currentPage = 1;
      controller.getFavouriteList(context, 1, false, isFirstTime: true);
    }, isOneSecond: false);
    controller.scrollController.addListener(scrollListener);
    super.initState();
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
        Duration.zero,
        () {
          controller
              .getFavouriteList(context, controller.currentPage, true,
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
  void dispose() {
    controller.currentPage = 1;
    controller.searchCtr.text = '';
    controller.isFilterApplied.value = false;
    controller.businessList.clear();
    super.dispose();
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
        child: Column(children: [
          getDynamicSizedBox(height: 4.h),
          getCommonToolbar("Favourite", showBackButton: false),
          // Obx(() {
          //   return setSearchBars(
          //       context, controller.searchCtr, SearchScreenConstant.title,
          //       onCancleClick: () {
          //         controller.isSearch = false;
          //         controller.searchCtr.text = '';
          //         setState(() {});
          //       },
          //       onClearClick: () {
          //         if (controller.searchCtr.text.isNotEmpty) {
          //           futureDelay(() {
          //             controller.currentPage = 1;
          //             logcat("clear", "DONE");
          //             futureDelay(() {
          //               controller.getFavouriteList(
          //                   context, controller.currentPage, false,
          //                   keyword: controller.searchCtr.text.toString(),
          //                   isFirstTime: true);
          //             }, isOneSecond: false);
          //           });
          //         }
          //         controller.searchCtr.text = '';
          //         setState(() {});
          //       },
          //       isCancle: false,
          //       onFilterClick: () {
          //         controller.showBottomSheetDialog(
          //             context, );
          //       },
          //       isFilterApplied: controller.isFilterApplied.value);
          // }),
          getDynamicSizedBox(height: 2.h),
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
                  controller.getFavouriteList(
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
                              controller.getFavouriteList(
                                context,
                                1,
                                false,
                                isFirstTime: true,
                              );
                              controller.refreshController.refreshCompleted();
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
          // Expanded(
          //     child: Container(
          //         margin: EdgeInsets.only(left: 2.w, right: 2.w),
          //         child: Stack(children: [
          //           Obx(() {
          //             switch (controller.state.value) {
          //               case ScreenState.apiLoading:
          //               case ScreenState.noNetwork:
          //               case ScreenState.noDataFound:
          //               case ScreenState.apiError:
          //                 return SizedBox(
          //                   height: Device.height / 1.5,
          //                   child: apiOtherStates(controller.state.value,
          //                       controller, controller.searchList, () {
          //                     // controller.getSearchList(context,
          //                     //     controller.searchCtr.text.toString());
          //                   }),
          //                 );
          //               case ScreenState.apiSuccess:
          //                 return apiSuccess(controller.state.value);
          //               default:
          //                 Container();
          //             }
          //             return Container();
          //           }),
          //         ]))),
        ]),
      ),
    );
  }

  Widget apiSuccess(ScreenState state) {
    if (state == ScreenState.apiSuccess && controller.businessList.isNotEmpty) {
      return ListView.builder(
        controller: controller.scrollController,
        physics: const BouncingScrollPhysics(),
        padding:
            EdgeInsets.only(left: 1.w, right: 1.w, top: 0.5.h, bottom: 12.h),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        clipBehavior: Clip.antiAlias,
        itemCount: controller.businessList.length +
            (controller.nextPageURL.value.isNotEmpty ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < controller.businessList.length) {
            BusinessData data = controller.businessList[index];
            return controller.getBusinessListItem(context, data);
          } else if (controller.isFetchingMore) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: const CircularProgressIndicator(color: primaryColor),
              ),
            );
          } else {
            return Container();
          }
        },
      );
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
      return showText ? getEmptyUi() : showLoader();
    }
  }
}
