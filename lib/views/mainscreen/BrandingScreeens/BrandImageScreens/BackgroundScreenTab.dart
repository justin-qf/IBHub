import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/controller/BrandImageController.dart';
import 'package:ibh/views/mainscreen/BrandingScreeens/ColorPickerWidget.dart';
import 'package:sizer/sizer.dart';

class BackgroundScreenTab extends StatefulWidget {
  BackgroundScreenTab({required this.controller, super.key});

  BrandImageController controller;

  @override
  State<BackgroundScreenTab> createState() => _BackgroundScreenTabState();
}

class _BackgroundScreenTabState extends State<BackgroundScreenTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ColorPickerWidget(hexBgCode: widget.controller.hexBgCode),
                SizedBox(width: 3.w),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 6.h,
                        width: 35.w,
                        padding:
                            EdgeInsets.only(top: 0.h, right: 2.w, left: 2.w),
                        child: TextField(
                          onSubmitted: (value) {
                            try {
                              String hex = value.replaceAll('#', '');
                              if (hex.length == 6 || hex.length == 8) {
                                widget.controller.hexBgCode.value =
                                    '#${hex.toUpperCase()}';
                              } else {
                                Get.snackbar(
                                  "Invalid Hex",
                                  "Please enter a 6 or 8 character hex code (e.g. #FF5733)",
                                  backgroundColor: primaryColor,
                                  colorText: white,
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
                            } catch (e) {
                              Get.snackbar(
                                "Error",
                                "Invalid hex format. Please use #RRGGBB or #AARRGGBB",
                                backgroundColor: primaryColor,
                                colorText: white,
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: 'Hex Code',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Container(
                        height: 7.h,
                        width: 45.w,
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Row(
                          children: [
                            Checkbox(
                              value: widget.controller.showBorder.value,
                              onChanged: (value) {
                                widget.controller.showBorder.value = value!;
                                if (widget.controller.showBorder.value ==
                                    false) {
                                  widget.controller.borderSize.value = 2.sp;
                                }
                              },
                              activeColor: primaryColor,
                              checkColor: white,
                            ),
                            Expanded(
                              child: Text(
                                'Image Border',
                                style: TextStyle(
                                    fontSize: 16.sp, color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            Obx(() => widget.controller.showBorder.value == true
                ? Slider(
                    value: widget.controller.borderSize.value,
                    min: 2.sp,
                    max: 32.sp,
                    activeColor: primaryColor,
                    inactiveColor: white,
                    onChanged: (value) {
                      widget.controller.borderSize.value = value;
                    },
                  )
                : const SizedBox.shrink())
          ],
        ),
      ),
    );
  }
}
