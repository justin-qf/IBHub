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
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/helper.dart';
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
  @override
  void initState() {
    controller.isSearch = false;
    // controller.getSearchList(context, controller.searchCtr.text.toString());
    super.initState();
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
        child: Stack(
          children: [
            Column(children: [
              getDynamicSizedBox(height: 4.h),
              getCommonToolbar("Search", showBackButton: false),
              setSearchBar(
                  context, controller.searchCtr, SearchScreenConstant.title,
                  onCancleClick: () {
                controller.isSearch = false;
                controller.searchCtr.text = '';
                setState(() {});
              }, onClearClick: () {
                if (controller.searchCtr.text.isNotEmpty) {
                  futureDelay(() {
                    // controller.getSearchList(context, "");
                  });
                }
                controller.searchCtr.text = '';
                setState(() {});
              }, isCancle: false),
              getDynamicSizedBox(height: 2.h),
              Expanded(
                  child: Container(
                      margin: EdgeInsets.only(left: 2.w, right: 2.w),
                      child: Stack(children: [
                        Obx(() {
                          switch (controller.state.value) {
                            case ScreenState.apiLoading:
                            case ScreenState.noNetwork:
                            case ScreenState.noDataFound:
                            case ScreenState.apiError:
                              return SizedBox(
                                height: Device.height / 1.5,
                                child: apiOtherStates(controller.state.value,
                                    controller, controller.searchList, () {
                                  // controller.getSearchList(context,
                                  //     controller.searchCtr.text.toString());
                                }),
                              );
                            case ScreenState.apiSuccess:
                              return apiSuccess(controller.state.value);
                            default:
                              Container();
                          }
                          return Container();
                        }),
                      ]))),
            ]),
            // Visibility(
            //   visible: false,
            //   child: Positioned(
            //       left: 0,
            //       bottom: 13.h,
            //       child: SizedBox(
            //         width: Device.width,
            //         child: Center(
            //           child: controller.getFilterUi(),
            //         ),
            //       )),
            // ),
          ],
        ),
      ),
    );
  }

  Widget apiSuccess(ScreenState state) {
    if (state == ScreenState.apiSuccess && controller.searchList.isNotEmpty) {
      return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(left: 2.w, right: 1.w, top: 0.5.h),
          shrinkWrap: false,
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.antiAlias,
          itemBuilder: (context, index) {
            return Container();
            // CommonProductList data = controller.searchList[index];
            // return controller.getItemListItem(context, data, false);
          },
          itemCount: controller.searchList.length);
      // return MasonryGridView.count(
      //   physics: const BouncingScrollPhysics(),
      //   padding: EdgeInsets.only(bottom: 3.h, top: 1.h, left: 2.w, right: 2.w),
      //   crossAxisCount: Device.screenType == sizer.ScreenType.mobile ? 2 : 3,
      //   mainAxisSpacing: 10,
      //   crossAxisSpacing: 4,
      //   itemBuilder: (context, index) {
      //     CommonProductList data = controller.searchList[index];
      //     return controller.getItemListItem(
      //         context, data, controller.isGuest!.value);
      //   },
      //   itemCount: controller.searchList.length,
      // );
    } else {
      return noDataFoundWidget();
    }
  }
}
