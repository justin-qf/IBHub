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
import 'package:ibh/controller/searchController.dart';
import 'package:ibh/models/businessListModel.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/helper.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sizer/sizer.dart';
import 'package:sizer/sizer.dart' as sizer;

// ignore: must_be_immutable
class SearchScreen extends StatefulWidget {
  SearchScreen(this.callBack, {super.key});
  Function callBack;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var controller = Get.put(SearchScreenController());
  bool showText = false;

  // @override
  // void initState() {
  //   Future.delayed(const Duration(seconds: 2), () {
  //     setState(() => showText = true);
  //   });
  //   controller.isSearch = false;
  //   futureDelay(() {
  //     controller.currentPage = 1;
  //     controller.getStateApi(context, "");
  //     controller.getCategoryApi(context);
  //     controller.getBusinessList(context, controller.currentPage, false,
  //         isFirstTime: true);
  //   }, isOneSecond: true);
  //   controller.scrollController.addListener(scrollListener);

  //   super.initState();
  // }

  @override
  void initState() {
    super.initState();

    controller.isSearch = false;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.currentPage = 1;
      await controller.getStateApi(context, "");
      // ignore: use_build_context_synchronously
      await controller.getCategoryApi(context);
      // ignore: use_build_context_synchronously
      await controller.getBusinessList(context, controller.currentPage, false,
          isFirstTime: true);
    });

    controller.scrollController.addListener(scrollListener);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => showText = true);
      }
    });
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
      isNormalScreen: true,
      body: Container(
        color: transparent,
        child: Stack(
          children: [
            Column(children: [
              getDynamicSizedBox(height: 4.h),
              getCommonToolbar("Search", showBackButton: false),
              Obx(() {
                return setSearchBars(
                    context, controller.searchCtr, SearchScreenConstant.title,
                    onCancleClick: () {
                      controller.isSearch = false;
                      controller.searchCtr.text = '';
                      setState(() {});
                    },
                    onClearClick: () {
                      if (controller.searchCtr.text.isNotEmpty) {
                        futureDelay(() {
                          controller.hideKeyboard(context);
                          controller.currentPage = 1;
                          futureDelay(() {
                            controller.getBusinessList(
                                context, controller.currentPage, false,
                                keyword: controller.searchCtr.text.toString(),
                                isFirstTime: true);
                          }, milliseconds: true);
                        });
                      }
                      controller.searchCtr.text = '';
                      setState(() {});
                    },
                    isCancle: false,
                    onFilterClick: () {
                      controller.showBottomSheetDialog(context);
                    },
                    isFilterApplied: controller.isFilterApplied.value);
              }),
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
                    futureDelay(() {
                      controller.currentPage = 1;
                      controller.getBusinessList(context, 1, false,
                          isFirstTime: true);
                    }, milliseconds: true);
                    controller.refreshController.refreshCompleted();
                    setState(() {
                      controller.searchCtr.text = "";
                    });
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
                                    futureDelay(() {
                                      controller.currentPage = 1;
                                      controller.getBusinessList(
                                          context, 1, false,
                                          keyword: controller
                                                  .searchCtr.text.isNotEmpty
                                              ? controller.searchCtr.text
                                                  .toString()
                                              : '',
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
          ],
        ),
      ),
    );
  }

  Widget apiSuccess(ScreenState state) {
    if (state == ScreenState.apiSuccess && controller.businessList.isNotEmpty) {
      return 
      
      ListView.builder(
        // controller: controller.scrollController,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(left: 1.w, right: 1.w, top: 1.h, bottom: 3.h),
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
