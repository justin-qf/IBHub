import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/componant/dialogs/dialogs.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/controller/UpdatedProfileController.dart';
import 'package:ibh/controller/updateProfileController.dart';
import 'package:ibh/utils/helper.dart';
import 'package:ibh/views/Profile/UpdateBusinessProfilescreen.dart';
import 'package:ibh/views/Profile/UpdateDocumentScreen.dart';
import 'package:sizer/sizer.dart';
import 'package:sizer/sizer.dart' as sizer;

// ignore: must_be_immutable
class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<UpdateProfile>
    with TickerProviderStateMixin {
  // final controller = Get.put(UpdatedProfileController());
  final Updateprofilecontroller ctr = Get.put(Updateprofilecontroller());
  String name = '';
  String number = '';
  RxInt selectedTabIndex = 0.obs;

  @override
  void initState() {
    ctr.tabController = TabController(
        vsync: this, length: 2, initialIndex: selectedTabIndex.value);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(se)
    Statusbar().trasparentStatusbar();
    return CustomParentScaffold(
      isExtendBodyScreen: true,
      // resizeToAvoidBottomInset: false,
      isNormalScreen: true,
      onWillPop: () async {
        return true;
      },
      onTap: () {
        hideKeyboard(context);
      },
      body: Scaffold(
        backgroundColor: transparent,
        body: Container(
          margin: EdgeInsets.only(
              left: Device.screenType == sizer.ScreenType.mobile ? 1.5.w : 1.w,
              right: Device.screenType == sizer.ScreenType.mobile ? 1.5.w : 1.w,
              top: 1.h),
          child: Column(
            children: [
              Column(
                children: [
                  getDynamicSizedBox(height: 3.h),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.w),
                    child: getleftsidebackbtn(
                      title: 'Edit Profile',
                      backFunction: () {
                        Get.back(result: true);
                      },
                    ),
                  ),
                  getDynamicSizedBox(height: 1.h),
                  Center(
                    child: GestureDetector(
                      child: Obx(() {
                        return ctr.getImage();
                      }),
                      onTap: () async {
                        selectImageFromCameraOrGallery(context,
                            cameraClick: () {
                          ctr.actionClickUploadImageFromCamera(context,
                              isCamera: true);
                        }, galleryClick: () {
                          ctr.actionClickUploadImageFromCamera(context,
                              isCamera: false);
                        });
                        setState(() {});
                      },
                    ),
                  ),
                  getLable('Logo', isRequired: false),
                ],
              ),
              getListViewItem()
            ],
          ),
        ),
      ),
    );
  }

  getListViewItem() {
    return Expanded(
      child: DefaultTabController(
          length: 2,
          child: Column(children: [
            SizedBox(
              height: 2.h,
            ),

            getProfileTabbar(
                controller: ctr.tabController,
                tabs: ctr.tabtitles.map((title) => Tab(text: title)).toList()),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     getTab("Business", 30, 0),
            //     getTab("Documents", 30, 1),
            //   ],
            // ),

            getDynamicSizedBox(height: 1.h),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: ctr.tabController,
                children: [
                  const UpdateBusinessProfileScreen(
                    index: 0,
                  ),
                  UpdateDocumentScreen(
                    index: 1,
                  )
                ],
              ),
            ),
          ])),
    );
  }

  // getTab(str, pad, index) {
  //   return GestureDetector(
  //     // duration: const Duration(milliseconds: 200),
  //     onTap: (() {
  //       controller.currentPage = index;
  //       selectedTabIndex = index;
  //       controller.tabController.index = index;
  //       setState(() {});
  //     }),
  //     child: AnimatedContainer(
  //       width: Device.screenType == sizer.ScreenType.mobile ? 25.w : 20.w,
  //       duration: const Duration(milliseconds: 300),
  //       margin: EdgeInsets.symmetric(
  //         horizontal: Device.screenType == sizer.ScreenType.mobile ? 8 : 20,
  //       ),
  //       padding: EdgeInsets.only(
  //           top: Device.screenType == sizer.ScreenType.mobile ? 11 : 1.h,
  //           bottom: Device.screenType == sizer.ScreenType.mobile ? 11 : 1.h),
  //       alignment: Alignment.center,
  //       decoration: BoxDecoration(
  //           color: selectedTabIndex == index
  //               ? isDarkMode()
  //                   ? white
  //                   : black
  //               : isDarkMode()
  //                   ? black
  //                   : white,
  //           border: Border.all(color: isDarkMode() ? white : transparent),
  //           boxShadow: [
  //             BoxShadow(
  //                 color: isDarkMode()
  //                     ? white.withOpacity(0.2)
  //                     : black.withOpacity(0.2),
  //                 spreadRadius: 0.1,
  //                 blurRadius: 10,
  //                 offset: const Offset(0.5, 0.5)),
  //           ],
  //           borderRadius: BorderRadius.circular(50)),
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Text(str,
  //               style: TextStyle(
  //                   fontSize: Device.screenType == sizer.ScreenType.mobile
  //                       ? 15.sp
  //                       : 12.sp,
  //                   fontFamily: fontMedium,
  //                   fontWeight: FontWeight.w700,
  //                   color: selectedTabIndex == index
  //                       ? isDarkMode()
  //                           ? black
  //                           : white
  //                       : isDarkMode()
  //                           ? white
  //                           : Colors.grey[850])),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
