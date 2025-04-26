import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/apiOtherStates.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/controller/service_controller.dart';
import 'package:ibh/models/ServiceListModel.dart';
import 'package:ibh/models/businessListModel.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/helper.dart';
import 'package:ibh/views/mainscreen/ServiceScreen/AddServiceScreen.dart';
import 'package:sizer/sizer.dart' as sizer;
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class ServiceScreen extends StatefulWidget {
  ServiceScreen({required this.data, this.id, super.key});
  BusinessData? data;
  String? id;

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  var controller = Get.put(ServiceController());
  @override
  void initState() {
    controller.getServiceList(
        context, 1, false, widget.data != null ? widget.data!.id : widget.id);
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
              .getServiceList(context, controller.currentPage, true,
                  widget.data != null ? widget.data!.id : widget.id)
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
    controller.serviceList.clear();
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
      bottomNavigationBar: widget.data == null
          ? Container(
              width: 7.h,
              height: 7.h,
              margin: EdgeInsets.only(bottom: 2.h, right: 1.0.w),
              child: getFloatingActionButton(onClick: () {
                Get.to(AddServicescreen())?.then((value) {
                  if (value == true) {
                    controller.getServiceList(context, 1, false,
                        widget.data != null ? widget.data!.id : widget.id);
                  }
                });
              }))
          : null,
      isExtendBodyScreen: true,
      body: Container(
        color: transparent,
        child: Column(
          children: [
            getDynamicSizedBox(height: 5.h),
           Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child:  getleftsidebackbtn(
              title: 'Services',
              backFunction: () {
                Get.back(result: true);
              },
            ),
           ),
            // getCommonToolbar("Service", showBackButton: true, onClick: () {
            //   Get.back();
            // }),
            Expanded(
              child: Obx(() {
                switch (controller.state.value) {
                  case ScreenState.apiLoading:
                  case ScreenState.noNetwork:
                  case ScreenState.noDataFound:
                  case ScreenState.apiError:
                    return apiOtherStates(controller.state.value, controller,
                        controller.serviceList, () {
                      controller.getServiceList(
                          context,
                          controller.currentPage,
                          true,
                          widget.data != null ? widget.data!.id : widget.id);
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
        controller.serviceList.isNotEmpty) {
      // return ListView.builder(
      //   controller: controller.scrollController,
      //   padding: EdgeInsets.only(left: 1.w, right: 1.w, top: 2.h),
      //   physics: const BouncingScrollPhysics(),
      //   scrollDirection: Axis.vertical,
      //   shrinkWrap: true,
      //   clipBehavior: Clip.antiAlias,
      //   itemCount: controller.serviceList.length +
      //       (controller.nextPageURL.value.isNotEmpty ? 1 : 0),
      //   itemBuilder: (context, index) {
      //     if (index < controller.serviceList.length) {
      //       ServiceDataList data = controller.serviceList[index];
      //       return controller.getListItem(context, data);
      //     } else if (controller.isFetchingMore) {
      //       return Center(
      //           child: Padding(
      //               padding: EdgeInsets.symmetric(vertical: 2.h),
      //               child:
      //                   const CircularProgressIndicator(color: primaryColor)));
      //     } else {
      //       return Container();
      //     }
      //   },
      // );
      return MasonryGridView.count(
        controller: controller.scrollController,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 2.h, left: 5.w, right: 5.w, top: 1.h),
        crossAxisCount: Device.screenType == sizer.ScreenType.mobile ? 2 : 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 4,
        itemCount: controller.serviceList.length +
            (controller.nextPageURL.value.isNotEmpty ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < controller.serviceList.length) {
            ServiceDataList data = controller.serviceList[index];
            return controller.getListItem(context, data);
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
