import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/controller/BrandImageController.dart';
import 'package:ibh/utils/log.dart';
import 'package:ibh/views/mainscreen/BrandingScreeens/ColorPickerWidget.dart';
import 'package:sizer/sizer.dart';

class TextEditScreenTab extends StatefulWidget {
  TextEditScreenTab({required this.controller, super.key});

  BrandImageController controller;

  @override
  State<TextEditScreenTab> createState() => _TextEditScreenTabState();
}

class _TextEditScreenTabState extends State<TextEditScreenTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  logcat('Print', 'Pressing');
                  widget.controller.showTextEditor(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: white, borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(5),
                  child: const Icon(Icons.add),
                ),
              ),
              getDynamicSizedBox(width: 2.w),
              GestureDetector(
                onTap: () {
                  widget.controller.toggleBold();
                  logcat('Print', 'Pressing');
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: widget.controller.isTextBold.value
                          ? lightGrey
                          : white,
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(5),
                  child: const Icon(Icons.format_bold),
                ),
              ),
              getDynamicSizedBox(width: 2.w),
              GestureDetector(
                onTap: () {
                  widget.controller.toggleItalic();
                  logcat('Print', 'Pressing');
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: widget.controller.isTextItalic.value
                          ? lightGrey
                          : white,
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(5),
                  child: const Icon(Icons.format_italic),
                ),
              ),
              getDynamicSizedBox(width: 2.w),
              GestureDetector(
                onTap: () {
                  if (widget.controller.selectedTextIndex.value != -1) {
                    widget.controller.textItems
                        .removeAt(widget.controller.selectedTextIndex.value);
                    widget.controller.selectedTextIndex.value = -1;
                  }
                  logcat('Print', 'Pressing');
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: white, borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(5),
                  child: const Icon(Icons.delete),
                ),
              ),
              getDynamicSizedBox(width: 10.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 40.w,
                    padding: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                        color: white, borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      onSubmitted: (value) {
                        try {
                          String hex = value.replaceAll('#', '');
                          if (hex.length == 6 || hex.length == 8) {
                            widget.controller.hexTextCode.value =
                                '#${hex.toUpperCase()}';
                            if (widget.controller.selectedTextIndex.value !=
                                -1) {
                              widget
                                  .controller
                                  .textItems[
                                      widget.controller.selectedTextIndex.value]
                                  .textColor
                                  .value = widget.controller.hexTextColor;
                            }
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
                      decoration: InputDecoration(
                        labelText: 'Hex Code',
                        filled: true,
                        isDense: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 1.w),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            widget.controller.pickTextColor(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                right: 1.w, top: 0.5.h, bottom: 0.5.h),
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(color: primaryColor)),
                            child: CustomPaint(
                              size: Size(3.w, 2.h),
                              painter: GradientPainter(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  getDynamicSizedBox(height: 1.h),
                  Container(
                    width: 40.w,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: white, borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () => widget.controller
                                .setAlignment(Alignment.centerLeft),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: widget.controller.isTextAlignLeft.value
                                      ? lightGrey
                                      : white),
                              padding: const EdgeInsets.all(2),
                              child: const Icon(Icons.format_align_left),
                            )),
                        GestureDetector(
                            onTap: () => widget.controller
                                .setAlignment(Alignment.center),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color:
                                      widget.controller.isTextAlignCenter.value
                                          ? lightGrey
                                          : white),
                              child: const Icon(Icons.format_align_center),
                            )),
                        GestureDetector(
                            onTap: () => widget.controller
                                .setAlignment(Alignment.centerRight),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color:
                                      widget.controller.isTextAlignRight.value
                                          ? lightGrey
                                          : white),
                              child: const Icon(Icons.format_align_right),
                            )),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 6.w),
            child: Text(
              'Font Size',
              style: TextStyle(
                  fontSize: 18.sp, color: white, fontFamily: dM_sans_semiBold),
            ),
          ),
          Obx(() => Slider(
                value: widget.controller.selectedTextIndex.value != -1
                    ? widget
                        .controller
                        .textItems[widget.controller.selectedTextIndex.value]
                        .fontSize
                        .value
                    : widget.controller.textfontSize.value,
                min: 8.sp,
                max: 32.sp,
                activeColor: primaryColor,
                inactiveColor: white,
                onChanged: (value) {
                  if (widget.controller.selectedTextIndex.value != -1) {
                    widget
                        .controller
                        .textItems[widget.controller.selectedTextIndex.value]
                        .fontSize
                        .value = value;
                  } else {
                    widget.controller.textfontSize.value = value;
                  }
                },
              ))
        ],
      ),
    );
  }
}
