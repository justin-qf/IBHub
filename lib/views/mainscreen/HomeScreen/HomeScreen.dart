import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/apiOtherStates.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/componant/widgets/search_chat_widgets.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/homeController.dart';
import 'package:ibh/models/businessListModel.dart';
import 'package:ibh/models/categotyModel.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/helper.dart';
import 'package:ibh/views/mainscreen/HomeScreen/CategoryScreen.dart';
import 'package:ibh/views/mainscreen/ServiceScreen/AddServiceScreen.dart';
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
    controller.pageController =
        PageController(initialPage: controller.currentPage);
    controller.scrollController.addListener(scrollListener);
    futureDelay(() {
      controller.getCategoryList(context);
      controller.getBusinessList(context, 0, true);
    },isOneSecond: false);
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
              .getBusinessList(context, controller.currentPage, true)
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
        SystemNavigator.pop();
        return false;
      },
      body: Container(
        color: white,
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  getCommonToolbar("Dashboard", showBackButton: false),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: controller.scrollController,
                      padding: EdgeInsets.only(bottom: 1.h),
                      physics: const BouncingScrollPhysics(),
                      child: Obx(() {
                        switch (controller.state.value) {
                          case ScreenState.apiLoading:
                          case ScreenState.noNetwork:
                          case ScreenState.noDataFound:
                          case ScreenState.apiError:
                            return SizedBox(
                              height: Device.height / 1.3,
                              child: apiOtherStates(controller.state.value,
                                  controller, controller.categoryList, () {}),
                            );
                          case ScreenState.apiSuccess:
                            return apiSuccess(controller.state.value);
                          default:
                            Container();
                        }
                        return Container();
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget apiSuccess(ScreenState state) {
    if (state == ScreenState.apiSuccess) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getDynamicSizedBox(height: 1.h),
            setSearchBars(context, controller.searchCtr, 'home',
                onCancleClick: () {
              controller.searchCtr.text = '';
              setState(() {
                controller.isSearch = false;
              });
            }, onClearClick: () {
              controller.searchCtr.text = '';
              setState(() {});
            }),
            getDynamicSizedBox(height: 2.h),
            getHomeLable(DashboardText.categoryTitle, () {
              Get.to(const CategoryScreen())!.then((value) {});
            }),
            getDynamicSizedBox(height: 1.h),
            SizedBox(
                height:
                    Device.screenType == sizer.ScreenType.mobile ? 13.h : 13.h,
                child: Obx(() {
                  return controller.categoryList.isNotEmpty
                      ? ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.only(
                              left: 5.w, right: 1.w, top: 0.5.h),
                          shrinkWrap: false,
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.antiAlias,
                          itemBuilder: (context, index) {
                            CategoryData data = controller.categoryList[index];
                            return controller.getCategoryListItem(
                                context, data);
                          },
                          itemCount: controller.categoryList.length)
                      : Container();
                })),
            getDynamicSizedBox(height: 1.h),
            getHomeLable(DashboardText.buisinessTitle, () {
              Get.to(const AddServicescreen())!.then((value) {});
            }, isShowSeeMore: false),
            Obx(
              () {
                return controller.businessList.isNotEmpty
                    ? SizedBox(
                        height: Device.height / 1,
                        child: ListView.builder(
                          controller: controller.scrollController,
                          padding:
                              EdgeInsets.only(left: 1.w, right: 1.w, top: 2.h),
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          clipBehavior: Clip.antiAlias,
                          itemCount: controller.businessList.length +
                              (controller.nextPageURL.value.isNotEmpty ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index < controller.businessList.length) {
                              BusinessData data =
                                  controller.businessList[index];
                              return controller.getBusinessListItem(
                                  context, data);
                            } else if (controller.isFetchingMore) {
                              return Center(
                                  child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2.h),
                                      child: const CircularProgressIndicator(
                                          color: primaryColor)));
                            } else {
                              return Container();
                            }
                          },
                        ),
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
