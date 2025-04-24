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
import 'package:ibh/models/categotyModel.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/views/mainscreen/HomeScreen/CategoryScreen.dart';
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
    controller.getCategoryList(context);
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
                      padding: EdgeInsets.only(bottom: 10.h),
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
            setSearchBar(context, controller.searchCtr, 'home',
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
            // Obx(
            //   () {
            //     return controller.trendingItemList.isNotEmpty
            //         ? SizedBox(
            //             height: 24.6.h,
            //             child: ListView.builder(
            //                 padding: EdgeInsets.only(left: 2.w, right: 1.w),
            //                 physics: const BouncingScrollPhysics(),
            //                 scrollDirection: Axis.horizontal,
            //                 clipBehavior: Clip.antiAlias,
            //                 itemBuilder: (context, index) {
            //                   CommonProductList data =
            //                       controller.trendingItemList[index];
            //                   return controller.getListItem(context, data,
            //                       () async {
            //                     controller.getTotalProductInCart();
            //                   }, controller.isGuest, () async {});
            //                 },
            //                 itemCount: controller.trendingItemList.length),
            //           )
            //         : Container();
            //   },
            // )
          ]);
    } else {
      return noDataFoundWidget();
    }
  }
}
