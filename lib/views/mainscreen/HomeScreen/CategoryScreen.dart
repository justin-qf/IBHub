import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/apiOtherStates.dart';
import 'package:ibh/componant/button/form_button.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/category_controller.dart';
import 'package:ibh/models/categoryListModel.dart';
import 'package:ibh/utils/enum.dart';
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
    controller.getCategoryList(context, 0, true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Statusbar().transparentStatusbarIsNormalScreen();
    return CustomParentScaffold(
      onWillPop: () async {
        return true;
      },
      onTap: () {
        controller.hideKeyboard(context);
      },
      isExtendBodyScreen: true,
      body: Container(
        color: transparent,
        child: Column(
          children: [
            getDynamicSizedBox(height: 5.h),
            getCommonToolbar("Category", showBackButton: true, onClick: () {
              Get.back();
            }),
            Expanded(
              child: Obx(() {
                switch (controller.state.value) {
                  case ScreenState.apiLoading:
                  case ScreenState.noNetwork:
                  case ScreenState.noDataFound:
                  case ScreenState.apiError:
                    return apiOtherStates(controller.state.value, controller,
                        controller.categoryList, () {
                      controller.getCategoryList(
                          context, controller.currentPage, true);
                    });
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
    );
  }

  Widget apiSuccess(ScreenState state) {
    if (controller.state.value == ScreenState.apiSuccess &&
        controller.categoryList.isNotEmpty) {
      return Container();
      // return MasonryGridView.count(
      //   physics: const BouncingScrollPhysics(),
      //   padding: EdgeInsets.only(bottom: 2.h, left: 5.w, right: 5.w, top: 2.h),
      //   crossAxisCount: Device.screenType == sizer.ScreenType.mobile ? 2 : 3,
      //   mainAxisSpacing: 10,
      //   crossAxisSpacing: 4,
      //   itemBuilder: (context, index) {
      //     CategoryListData data = controller.categoryList[index];
      //     return Column(
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         controller.getOldListItem(data),
      //         index == controller.categoryList.length - 1 &&
      //                 controller.nextPageURL.value.isNotEmpty
      //             ? getMiniButton(
      //                 () {
      //                   controller.currentPage++;
      //                   controller.getCategoryList(
      //                       context, controller.currentPage, false);
      //                   setState(() {});
      //                 },
      //                 Common.viewMore,
      //               )
      //             : Container()
      //       ],
      //     );
      //   },
      //   itemCount: controller.categoryList.length,
      // );
    } else {
      return noDataFoundWidget();
    }
  }
}
