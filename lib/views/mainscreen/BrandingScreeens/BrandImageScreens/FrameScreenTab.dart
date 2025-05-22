import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/apiOtherStates.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/controller/BrandImageController.dart';
import 'package:ibh/controller/frame_controller.dart';
import 'package:ibh/models/frameModel.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/helper.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sizer/sizer.dart';

class FrameScreenTab extends StatefulWidget {
  FrameScreenTab({required this.controller, super.key});

  BrandImageController controller;
  // String categoryId;

  @override
  State<FrameScreenTab> createState() => _FrameScreenTabState();
}

class _FrameScreenTabState extends State<FrameScreenTab> {
  var controller = Get.put(FrameController());

  @override
  void initState() {
    // futureDelay(() {
    //   controller.currentPage = 1;
    //   controller.getFrameList(context, controller.currentPage, false,
    //       isFirstTime: true, categoryId: widget.controller.categoryId);
    // }, milliseconds: true);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.currentPage = 1;
      await controller.getFrameList(context, controller.currentPage, false,
          isFirstTime: true, categoryId: widget.controller.categoryId);
    });
    controller.refreshController.refreshCompleted();
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
        const Duration(seconds: 1),
        () {
          controller
              // ignore: use_build_context_synchronously
              .getFrameList(context, controller.currentPage, true,
                  isFirstTime: false, categoryId: widget.controller.categoryId)
              .whenComplete(() {
            if (mounted) {
              setState(() => controller.isFetchingMore = false);
              controller.refreshController.refreshCompleted();
            }
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      physics: const BouncingScrollPhysics(),
      controller: controller.refreshController,
      enablePullDown: true,
      enablePullUp: false,
      header: const WaterDropMaterialHeader(
          backgroundColor: primaryColor, color: white),
      onRefresh: () async {
        controller.currentPage = 1;
        futureDelay(() {
          controller.getFrameList(context, controller.currentPage, false,
              isFirstTime: true, categoryId: widget.controller.categoryId);
        }, isOneSecond: false);
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
                  return SizedBox(
                      height: Device.height / 3,
                      child: apiOtherStates(controller.state.value, controller,
                          controller.frameImageList, () {
                        controller.currentPage = 1;
                        futureDelay(() {
                          controller.getFrameList(
                              context, controller.currentPage, false,
                              isFirstTime: true,
                              categoryId: widget.controller.categoryId);
                        }, isOneSecond: false);
                        controller.refreshController.refreshCompleted();
                      }));
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
    );
  }

  Widget apiSuccess(ScreenState state) {
    if (controller.state.value == ScreenState.apiSuccess &&
        controller.frameImageList.isNotEmpty) {
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 5.h, left: 5.w, right: 5.w, top: 1.h),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 5,
            childAspectRatio: 0.7),
        shrinkWrap: true,
        itemCount: controller.frameImageList.length +
            (controller.nextPageURL.value.isNotEmpty ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < controller.frameImageList.length) {
            FramesData frameData = controller.frameImageList[index];
            return controller.getListItem(context, widget.controller,
                data: frameData);
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
    } else {
      return noDataFoundWidgetResponsive();
    }
  }
}
