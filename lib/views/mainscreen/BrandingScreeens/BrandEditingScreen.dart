import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/controller/brandEditingcontroller.dart';
import 'package:sizer/sizer.dart';

class Brandeditingscreen extends StatefulWidget {
  const Brandeditingscreen({super.key});

  @override
  State<Brandeditingscreen> createState() => _BrandeditingscreenState();
}

class _BrandeditingscreenState extends State<Brandeditingscreen> {
  var controller = Get.put(Brandeditingcontroller());

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
      body: Column(
        children: [
          Container(
            height: 63.5.h,
            color: transparent,
            child: Column(
              children: [
                getDynamicSizedBox(height: 4.h),
                Container(
                  margin: EdgeInsets.only(left: 5.w),
                  child: getleftsidebackbtn(
                    title: 'Customize Your Brand',
                    backFunction: () {
                      Get.back(result: true);
                    },
                  ),
                ),
                getDynamicSizedBox(height: 5.h),
                Container(
                  height: 35.h,
                  width: 70.w,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: white,
                      boxShadow: [
                        BoxShadow(
                            color: black.withOpacity(0.1),
                            blurRadius: 5.0,
                            offset: Offset(0, 0))
                      ],
                      border: Border.all(color: grey),
                      shape: BoxShape.rectangle),
                  child: Container(
                    // height: 20.h,
                    // width: 55.w,
                    decoration: BoxDecoration(
                      border: Border.all(color: grey),
                      shape: BoxShape.rectangle,
                    ),
                    child: Image.asset(Asset.bussinessPlaceholder,
                        fit: BoxFit.contain),
                  ),
                ),

                // Expanded(
                //     child:
                //         Obx(() => controller.screens[controller.activeTab.value])),
              ],
            ),
          ),
          Obx(() {
            return controller.buildNavBar(context);
          })
        ],
      ),
    );
  }
}
