import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/apiOtherStates.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/componant/widgets/search_chat_widgets.dart';
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
    futureDelay(() {
      controller.currentPage = 1;
      controller.getCategoryList(context, controller.currentPage, false,
          isFirstTime: true);
    }, milliseconds: true);
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
        const Duration(milliseconds: 200),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            getDynamicSizedBox(height: 4.h),
            Container(
                margin: EdgeInsets.only(left: 5.w),
                child: getleftsidebackbtn(
                  title: CategoryScreenViewConst.title,
                  backFunction: () {
                    Get.back(result: true);
                  },
                )),
            setSearchBars(
                context, controller.searchCtr, CategoryScreenViewConst.title,
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
                    controller.getCategoryList(
                        context, controller.currentPage, false,
                        search: controller.searchCtr.text.toString(),
                        isFirstTime: true);
                  }, milliseconds: true);
                });
              }
              controller.searchCtr.text = '';
              setState(() {});
            }, isCancle: false, isFromCategoryList: true),
            getDynamicSizedBox(height: 1.h),
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
                    controller.getCategoryList(
                        context, controller.currentPage, false,
                        isFirstTime: true);
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
                                height: Device.height / 1.5,
                                child: apiOtherStates(controller.state.value,
                                    controller, controller.categoryList, () {
                                  controller.currentPage = 1;
                                  futureDelay(() {
                                    controller.getCategoryList(
                                        context, controller.currentPage, false,
                                        isFirstTime: true);
                                  }, isOneSecond: false);
                                  controller.refreshController
                                      .refreshCompleted();
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
          ],
        ),
      ),
    );
  }

  Widget apiSuccess(ScreenState state) {
    if (controller.state.value == ScreenState.apiSuccess &&
        controller.categoryList.isNotEmpty) {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                Device.screenType == sizer.ScreenType.mobile ? 2 : 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 8,
            childAspectRatio: 1.4),
        // controller: controller.scrollController,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 5.h, left: 5.w, right: 5.w, top: 1.h),

        shrinkWrap: true,
        itemCount: controller.categoryList.length +
            (controller.nextPageURL.value.isNotEmpty ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < controller.categoryList.length) {
            CategoryListData data = controller.categoryList[index];
            return controller.getOldListItem(context, data: data);
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
