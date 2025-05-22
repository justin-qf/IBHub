import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/controller/brandEditingcontroller.dart';
import 'package:ibh/utils/log.dart';
import 'package:sizer/sizer.dart';

class Brandeditingscreen extends StatefulWidget {
  const Brandeditingscreen({super.key});

  @override
  State<Brandeditingscreen> createState() => _BrandeditingscreenState();
}

class _BrandeditingscreenState extends State<Brandeditingscreen> {
  var controller = Get.put(Brandeditingcontroller());

  @override
  void initState() {
    super.initState();
    controller.fetchGalleryAlbums();
  }

  @override
  Widget build(BuildContext context) {
    Statusbar().transparentStatusbarIsNormalScreen();
    final stackWidth = 70.w;
    final stackHeight = 35.h;
    final imagePadding = 5.0;

    return CustomParentScaffold(
      onWillPop: () async {
        Get.back(result: true);
        return false;
      },
      onTap: () {
        controller.hideKeyboard(context);
        controller.selectedTextIndex.value = -1;
      },
      isNormalScreen: true,
      isExtendBodyScreen: true,
      body: Column(
        children: [
          Container(
            height: 63.5.h,
            color: Colors.transparent,
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
                      isShare: true,
                      shareCallBack: () {
                        logcat('Printing', 'Data');
                        controller.captureAndSaveImage();
                      }),
                ),
                getDynamicSizedBox(height: 5.h),
                SizedBox(
                  width: stackWidth,
                  height: stackHeight,
                  child: Obx(() {
                    final borderWidth = controller.borderSize.value;
                    return Container(
                      padding: EdgeInsets.all(imagePadding),
                      decoration: BoxDecoration(
                        color: white,
                        boxShadow: [
                          BoxShadow(
                              color: black.withOpacity(0.1),
                              blurRadius: 5.0,
                              offset: Offset(0, 0))
                        ],
                        border: Border.all(color: grey, width: 1),
                        shape: BoxShape.rectangle,
                      ),
                      child: RepaintBoundary(
                        key: controller.repaintBoundaryKey,
                        child: Stack(
                          clipBehavior: Clip.hardEdge,
                          children: [
                            // Inner Container with border and image
                            Container(
                              width: stackWidth -
                                  2 * imagePadding +
                                  2 * borderWidth,
                              height: stackHeight -
                                  2 * imagePadding +
                                  2 * borderWidth,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: borderWidth,
                                  color: controller.showBorder.value
                                      ? controller.hexBgCode.value.isNotEmpty
                                          ? Color(controller.hexBgColor.value)
                                          : controller.currentBGColor.value
                                      : Colors.white,
                                ),
                                shape: BoxShape.rectangle,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child: _buildImageWidget(
                                  controller,
                                  stackWidth - 2 * imagePadding,
                                  stackHeight - 2 * imagePadding,
                                ),
                              ),
                            ),
                            // Text items on top
                            ...controller.textItems
                                .asMap()
                                .entries
                                .map((entry) {
                              final index = entry.key;
                              final item = entry.value;
                              final maxWidth = (stackWidth -
                                      2 * imagePadding +
                                      2 * borderWidth) -
                                  item.posX.value -
                                  10;
                              return Positioned(
                                left: item.posX.value,
                                top: item.posY.value,
                                child: GestureDetector(
                                  onTap: () {
                                    controller.selectedTextIndex.value = index;
                                    controller.textfontSize.value =
                                        item.fontSize.value;
                                    controller.isTextBold.value =
                                        item.isBold.value;
                                    controller.isTextItalic.value =
                                        item.isItalic.value;
                                    controller.currentTextColor.value =
                                        item.textColor.value;
                                    controller.isTextAlignLeft.value =
                                        item.alignment.value ==
                                            Alignment.centerLeft;
                                    controller.isTextAlignCenter.value =
                                        item.alignment.value ==
                                            Alignment.center;
                                    controller.isTextAlignRight.value =
                                        item.alignment.value ==
                                            Alignment.centerRight;
                                  },
                                  onDoubleTap: () {
                                    controller.showTextEditor(context,
                                        isdoubleTap: true, index: index);
                                  },
                                  onPanUpdate: (details) {
                                    item.posX.value += details.delta.dx;
                                    item.posY.value += details.delta.dy;
                                    // Adjust clamping for inner container bounds
                                    controller.clampTextPosition(
                                        item,
                                        stackWidth - 2 * imagePadding,
                                        stackHeight - 2 * imagePadding);
                                  },
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: maxWidth > 10 ? maxWidth : 10,
                                      minWidth: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      border:
                                          controller.selectedTextIndex.value ==
                                                  index
                                              ? Border.all(
                                                  color: Colors.blue, width: 2)
                                              : null,
                                    ),
                                    padding: EdgeInsets.all(2),
                                    child: Text(
                                      item.content.value,
                                      textAlign:
                                          controller.getTextAlignFromAlignment(
                                              item.alignment.value),
                                      softWrap: true,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontStyle: item.isItalic.value
                                            ? FontStyle.italic
                                            : FontStyle.normal,
                                        fontWeight: item.isBold.value
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: item.textColor.value,
                                        fontFamily: dM_sans_regular,
                                        fontSize: item.fontSize.value,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            Positioned(
                              child: Container(
                                height: Device.height,
                                width: Device.width,
                                // color: Colors.yellow,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      Asset.applogo,
                                      height: 10.h,
                                      width: 10.w,
                                    ),
                                    getDynamicSizedBox(height: 1.2.h),
                                    
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                getDynamicSizedBox(height: 2.h),
              ],
            ),
          ),
          Obx(() => controller.buildNavBar(context)),
        ],
      ),
    );
  }

  Widget _buildImageWidget(
      Brandeditingcontroller controller, double width, double height) {
    return Obx(() {
      if (controller.cachedThumbnail.value != null) {
        return Opacity(
          opacity: controller.imageOpacity.value.clamp(0.0, 1.0),
          child: Image.memory(
            controller.cachedThumbnail.value!,
            fit: BoxFit.fill,
            width: width,
            height: height,
            filterQuality: FilterQuality.high, // Balance quality and speed
          ),
        );
      } else if (controller.thumbnailFuture.value == null) {
        return Opacity(
          opacity: controller.imageOpacity.value.clamp(0.0, 1.0),
          child: Image.asset(
            Asset.bussinessPlaceholder,
            fit: BoxFit.fill,
            width: width,
            height: height,
            filterQuality: FilterQuality.high,
          ),
        );
      } else {
        return FutureBuilder<Uint8List?>(
          future: controller.thumbnailFuture.value,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                snapshot.data != null) {
              controller.cachedThumbnail.value = snapshot.data;
              controller.highResThumbnail.value = snapshot.data;
              return Opacity(
                opacity: controller.imageOpacity.value.clamp(0.0, 1.0),
                child: Image.memory(
                  snapshot.data!,
                  fit: BoxFit.fill,
                  width: width,
                  height: height,
                  filterQuality: FilterQuality.medium,
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      }
    });
  }
  // Widget _buildImageWidget(

  //     Brandeditingcontroller controller, double width, double height) {
  //   return Obx(() {
  //     if (controller.cachedThumbnail.value != null) {
  //       return Opacity(
  //         opacity: controller.imageOpacity.value.clamp(0.0, 1.0),
  //         child: Image.memory(
  //           controller.cachedThumbnail.value!,
  //           fit: BoxFit.fill,
  //           width: width,
  //           height: height,
  //         ),
  //       );
  //     } else if (controller.thumbnailFuture.value == null) {
  //       return Opacity(
  //         opacity: controller.imageOpacity.value.clamp(0.0, 1.0),
  //         child: Image.asset(
  //           Asset.bussinessPlaceholder,
  //           fit: BoxFit.fill,
  //           width: width,
  //           height: height,
  //         ),
  //       );
  //     } else {
  //       return FutureBuilder<Uint8List?>(
  //         future: controller.thumbnailFuture.value,
  //         builder: (context, snapshot) {
  //           if (snapshot.connectionState == ConnectionState.done &&
  //               snapshot.hasData &&
  //               snapshot.data != null) {
  //             controller.cachedThumbnail.value = snapshot.data;
  //             return Opacity(
  //               opacity: controller.imageOpacity.value.clamp(0.0, 1.0),
  //               child: Image.memory(
  //                 snapshot.data!,
  //                 fit: BoxFit.fill,
  //                 width: width,
  //                 height: height,
  //               ),
  //             );
  //           } else {
  //             return Center(
  //               child: CircularProgressIndicator(),
  //             );
  //           }
  //         },
  //       );
  //     }
  //   });
  // }
}
