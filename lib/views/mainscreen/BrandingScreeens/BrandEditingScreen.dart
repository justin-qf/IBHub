import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
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
      isNormalScreen: true,
      isExtendBodyScreen: true,
      // resizeToAvoidBottomInset: true,
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
                // Container(
                //   width: 40.w,
                //   height: 40.h, // Increased height to fit color picker
                //   margin: EdgeInsets.only(
                //       left: 5.w, right: 3.w, top: 3.h, bottom: 3.h),
                //   decoration: BoxDecoration(
                //     color: _currentColor,
                //     borderRadius: BorderRadius.circular(10),
                //     border: _showBorder
                //         ? Border.all(color: Colors.pink, width: 1.w)
                //         : null,
                //   ),
                //   child: SingleChildScrollView(
                //     child: ColorPicker(
                //       pickerColor: _currentColor,
                //       onColorChanged: (color) {
                //         _currentColor = color;
                //       },
                //       pickerAreaHeightPercent: 0.5,
                //       displayThumbColor: true,
                //       enableAlpha: false,
                //     ),
                //   ),
                // ),
                Stack(
                  children: [
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
                        shape: BoxShape.rectangle,
                      ),
                      child: Obx(
                        () => Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: controller.showBorder.value
                                    ? primaryColor
                                    : white),
                            shape: BoxShape.rectangle,
                          ),
                          child: Image.asset(Asset.bussinessPlaceholder,
                              fit: BoxFit.contain),
                        ),
                      ),
                    ),
                    Obx(() => Positioned(
                          left: controller.textPosX.value,
                          top: controller.textPosY.value,
                          child: GestureDetector(
                            onPanUpdate: (details) {
                              controller.textPosX.value += details.delta.dx;
                              controller.textPosY.value += details.delta.dy;
                            },
                            child: Text(
                              'Sample Text',
                              style: TextStyle(
                                fontStyle: controller.isTextItalic.value
                                    ? FontStyle.italic
                                    : null,
                                fontWeight: controller.isTextBold.value
                                    ? FontWeight.bold
                                    : null,
                                color: controller.hexTextCode.value.isNotEmpty
                                    ? Color(controller.hexTextColor
                                        .value) // Use hex color if available
                                    : controller.currentTextColor.value,
                                fontFamily: dM_sans_regular,
                                fontSize: controller.textfontSize.value,
                              ),
                            ),
                          ),
                        )),
                  ],
                ),

                getDynamicSizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => Container(
                        width: 10.w,
                        height: 5.h,
                        color: controller.currentBGColor.value,
                      ),
                    ),
                    getDynamicSizedBox(width: 2.w),
                    Obx(
                      () => Container(
                        width: 10.w,
                        height: 5.h,
                        color: Color(controller.hexBgColor.value),
                      ),
                    ),
                  ],
                ),

                // Obx(
                //   () => Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Container(
                //         margin: EdgeInsets.only(top: 1.h),
                //         padding: EdgeInsets.all(2),
                //         decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(10),
                //             border: Border.all(color: black)),
                //         child: Text(
                //           'TextRGBColor',
                //           style: TextStyle(
                //               fontStyle: controller.isTextItalic.value
                //                   ? FontStyle.italic
                //                   : null,
                //               fontWeight: controller.isTextBold.value
                //                   ? FontWeight.bold
                //                   : null,
                //               // fontWeight: FontWeight.bold,
                //               color: controller.currentTextColor.value),
                //         ),
                //       ),
                //       getDynamicSizedBox(width: 1.w),
                //       Container(
                //         margin: EdgeInsets.only(top: 1.h),
                //         padding: EdgeInsets.all(2),
                //         decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(10),
                //             border: Border.all(color: black)),
                //         child: Text(
                //           'TextHexColor',
                //           style: TextStyle(
                //               fontWeight: FontWeight.bold,
                //               color: Color(controller.hexTextColor.value)),
                //         ),
                //       )
                //     ],
                //   ),
                // ),
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
