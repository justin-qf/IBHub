import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/apiOtherStates.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/category_controller.dart';
import 'package:ibh/models/categoryListModel.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/helper.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sizer/sizer.dart';
import 'package:sizer/sizer.dart' as sizer;

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  var controller = Get.put(CategoryController());

  @override
  void initState() {
    controller.getCategoryList(context, 1, false, isFirstTime: true);
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
              // ignore: use_build_context_synchronously
              .getCategoryList(context, controller.currentPage, true,
                  isFirstTime: false)
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
  void dispose() {
    controller.currentPage = 1;
    controller.categoryList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Statusbar().transparentStatusbarIsNormalScreen();
    return CustomParentScaffold(
      onWillPop: () async {
        return true;
      },
      onTap: () {
        hideKeyboard(context);
      },
      isExtendBodyScreen: true,
      body: Container(
        color: transparent,
        child: Column(
          children: [
            getDynamicSizedBox(height: 5.h),
            getCommonToolbar(CategoryScreenViewConst.category,
                showBackButton: true, onClick: () {
              Get.back();
            }),
            Expanded(
              child: SmartRefresher(
                controller: controller.refreshController,
                enablePullDown: true,
                enablePullUp: false,
                header: const WaterDropMaterialHeader(
                    backgroundColor: primaryColor, color: white),
                onRefresh: () async {
                  futureDelay(() {
                    controller.getCategoryList(
                        context, controller.currentPage, false,
                        isFirstTime: true);
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
                                    controller, controller.categoryList, () {
                                  controller.getCategoryList(
                                      context, controller.currentPage, true);
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
              ),
            ),
            // Expanded(
            //   child: Obx(() {
            //     switch (controller.state.value) {
            //       case ScreenState.apiLoading:
            //       case ScreenState.noNetwork:
            //       case ScreenState.noDataFound:
            //       case ScreenState.apiError:
            //         return apiOtherStates(controller.state.value, controller,
            //             controller.categoryList, () {
            //           controller.getCategoryList(
            //               context, controller.currentPage, true);
            //         });
            //       case ScreenState.apiSuccess:
            //         return apiSuccess(controller.state.value);
            //       // ignore: unreachable_switch_default
            //       default:
            //         Container();
            //     }
            //     return Container();
            //   }),
            // )
          ],
        ),
      ),
    );
  }

  Widget apiSuccess(ScreenState state) {
    if (controller.state.value == ScreenState.apiSuccess &&
        controller.categoryList.isNotEmpty) {
      return MasonryGridView.count(
        controller: controller.scrollController,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 2.h, left: 5.w, right: 5.w, top: 2.h),
        crossAxisCount: Device.screenType == sizer.ScreenType.mobile ? 2 : 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 4,
        shrinkWrap: true,
        itemCount: controller.categoryList.length +
            (controller.nextPageURL.value.isNotEmpty ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < controller.categoryList.length) {
            CategoryListData data = controller.categoryList[index];
            return controller.getOldListItem(data);
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
      return noDataFoundWidget();
    }
  }
}
