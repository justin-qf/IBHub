import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/apiOtherStates.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/brandingScreencontroller.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/helper.dart';
import 'package:ibh/views/mainscreen/BrandingScreeens/BrandSeeAllScreen.dart';
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
  var controller = Get.put(BrandingScreencontroller());

  @override
  void initState() {
    super.initState();
    controller.state.value = ScreenState.apiLoading;
    futureDelay(() {
      controller.getBrandingImageList(context, controller.currentPage, false,
          isFirstTime: true);
    }, milliseconds: true);
    controller.refreshController.refreshCompleted();
    controller.scrollController.addListener(scrollListener);
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
              .getBrandingImageList(context, controller.currentPage, true,
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
              getCommonToolbar(BottomConstant.branding, showBackButton: false),
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
                      controller.getBrandingImageList(
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
                                  controller.getBrandingImageList(
                                    context,
                                    controller.currentPage,
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
    if (state == ScreenState.apiSuccess) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            // itemCount: controller.categoryTypes.length,
            itemCount: controller.categoryTypes.length +
                (controller.nextPageURL.value.isNotEmpty ? 1 : 0),
            padding: const EdgeInsets.all(0),
            itemBuilder: (context, index) {
              if (index < controller.categoryTypes.length) {
                final categoryType = controller.categoryTypes[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getDynamicSizedBox(height: 1.5.h),
                    getHomeLable(categoryType.title, () {
                      Get.to(BrandSeeAllScreen(
                        imageCategoryTypeId: categoryType.id.toString(),
                        title: categoryType.title,
                      ))!
                          .then((value) {
                        futureDelay(() {
                          controller.currentPage = 1;
                          controller.getBrandingImageList(
                              context, controller.currentPage, false,
                              isFirstTime: true);
                        }, isOneSecond: false);
                      });
                    }, isFromDetailScreen: false),
                    getDynamicSizedBox(height: 1.h),
                    if (categoryType.title == 'Business')
                      controller.businessCategoryWidget(categoryType.category)
                    else if (categoryType.title == 'Daily Images')
                      controller.getDailyListItem(categoryType.category)
                    else
                      controller.businessCategoryWidget(categoryType.category)
                  ],
                );
              } else if (controller.isFetchingMore) {
                return Center(
                  child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child:
                          const CircularProgressIndicator(color: primaryColor)),
                );
              } else {
                return Container();
              }
              // final categoryType = controller.categoryTypes[index];
              // return Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     getDynamicSizedBox(height: 1.h),
              //     getHomeLable(categoryType.title, () {
              //       // Get.to(const CategoryScreen())!.then((value) {
              //       //   futureDelay(() {
              //       //     controller.currentPage = 1;
              //       //     controller.getBusinessList(context, 1, false,
              //       //         isFirstTime: true);
              //       //   }, isOneSecond: false);
              //       // });
              //     }),
              //     getDynamicSizedBox(height: 1.h),
              //     if (categoryType.title == 'Business')
              //       controller.businessCategoryWidget(categoryType.category)
              //     else if (categoryType.title == 'Daily Images')
              //       controller.getDailyListItem(categoryType.category)
              //     else
              //       controller.businessCategoryWidget(categoryType.category)
              //   ],
              // );
            },
          ),
        ],
      );
    } else {
      return noDataFoundWidget();
    }
  }
}
