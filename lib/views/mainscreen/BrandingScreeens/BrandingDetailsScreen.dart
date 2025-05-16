import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ibh/api_handle/apiOtherStates.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/componant/widgets/search_chat_widgets.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/controller/brandingdetailsscreencontroller.dart';
import 'package:ibh/models/businessListModel.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/helper.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class Brandingdetailsscreen extends StatefulWidget {
  int count;
  Brandingdetailsscreen({super.key, required this.count});

  @override
  State<Brandingdetailsscreen> createState() => _BrandingdetailsscreenState();
}

class _BrandingdetailsscreenState extends State<Brandingdetailsscreen> {
  var controller = Get.put(Brandingdetailsscreencontroller());
  bool showText = false;

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
          // controller
          //     .getBusinessList(context, controller.currentPage, true,
          //         isFirstTime: false, categoryId: widget.item.id.toString())
          //     .whenComplete(() {
          //   if (mounted) {
          //     setState(() => controller.isFetchingMore = false);
          //   }
          // });
        },
      );
    }
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
        body: Column(
          children: [
            getDynamicSizedBox(height: 4.h),
            Container(
                margin: EdgeInsets.only(left: 5.w),
                child: getleftsidebackbtn(
                  title: widget.count == 1
                      ? 'Daily Images'
                      : widget.count == 2
                          ? 'Festivals Images'
                          : widget.count == 3
                              ? 'Bussiness Images'
                              : 'Images',
                  backFunction: () {
                    Get.back(result: true);
                  },
                )),
            setSearchBars(context, controller.searchCtr, 'Search Here',
                onCancleClick: () {
              controller.isSearch = false;
              controller.searchCtr.text = '';
              setState(() {});
            }, onClearClick: () {
              if (controller.searchCtr.text.isNotEmpty) {
                futureDelay(() {
                  hideKeyboard(context);
                  controller.currentPage = 1;
                  futureDelay(() {
                    // controller.getCategoryList(
                    //     context, controller.currentPage, false,
                    //     search: controller.searchCtr.text.toString(),
                    //     isFirstTime: true);
                  }, milliseconds: true);
                });
              }
              controller.searchCtr.text = '';
              setState(() {});
            }, isCancle: false, isFromCategoryList: true),
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
                    // controller.getBusinessList(context, 1, false,
                    //     keyword: controller.searchCtr.text.toString(),
                    //     categoryId: widget.item.id.toString(),
                    //     isFirstTime: true);
                  }, milliseconds: true);
                  controller.refreshController.refreshCompleted();
                },
                child: CustomScrollView(
                  controller: controller.scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Obx(() {
                        switch (controller.state.value) {
                          case ScreenState.apiLoading:
                          case ScreenState.noNetwork:
                          case ScreenState.noDataFound:
                          case ScreenState.apiError:
                            return Text('data');
                          //  SizedBox(
                          //     height: Device.height / 1.5,
                          //     child: apiOtherStates(controller.state.value,
                          //         controller, controller.categoryList, () {
                          //       controller.currentPage = 1;
                          //       futureDelay(() {
                          //         controller.getBusinessList(
                          //             context, 1, false,
                          //             keyword: controller.searchCtr.text
                          //                 .toString(),
                          //             categoryId: widget.item.id.toString(),
                          //             isFirstTime: true);
                          //       }, isOneSecond: false);
                          //       controller.refreshController
                          //           .refreshCompleted();
                          //     }));
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
        ));
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
            return controller.getBusinessListItem(
              context, data,

              // widget.item.id.toString()
            );
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
