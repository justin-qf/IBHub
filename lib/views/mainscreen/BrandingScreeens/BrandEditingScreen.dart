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
import 'package:sizer/sizer.dart';

// class Brandeditingscreen extends StatefulWidget {
//   const Brandeditingscreen({super.key});

//   @override
//   State<Brandeditingscreen> createState() => _BrandeditingscreenState();
// }

// class _BrandeditingscreenState extends State<Brandeditingscreen> {
//   var controller = Get.put(Brandeditingcontroller());

//   @override
//   void initState() {
//     super.initState();
//     controller.fetchGalleryAlbums();
//   }

  @override
  Widget build(BuildContext context) {
    Statusbar().transparentStatusbarIsNormalScreen();
    final stackWidth = 70.w;
    final stackHeight = 30.h;
    const imagePadding = 5.0; // Padding inside the image Container

    return CustomParentScaffold(
      onWillPop: () async {
        Get.back(result: true);
        return false;
      },
      onTap: () {
        controller.hideKeyboard(context);
        controller.selectedTextIndex.value = -1; // Deselect text on tap outside
      },
      isNormalScreen: true,
      isExtendBodyScreen: true,
      body: Column(
        children: [
          Expanded(
            child: Container(
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
                  SizedBox(
                    width: stackWidth,
                    height: stackHeight,
                    child: Stack(
                      clipBehavior: Clip.hardEdge, // Prevent overflow
                      children: [
                        Obx(() {
                          final borderWidth = controller.borderSize.value;
                          return Container(
                            padding: const EdgeInsets.all(imagePadding),
                            decoration: BoxDecoration(
                                color: white,
                                boxShadow: [
                                  BoxShadow(
                                      color: black.withOpacity(0.1),
                                      blurRadius: 5.0,
                                      offset: const Offset(0, 0))
                                ],
                                border: Border.all(color: grey, width: 1),
                                shape: BoxShape.rectangle),
                            child: Container(
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
                          );
                        }),
                        Obx(() => Stack(
                              clipBehavior: Clip.hardEdge,
                              children: controller.textItems
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                final index = entry.key;
                                final item = entry.value;
                                final maxWidth =
                                    stackWidth - item.posX.value - 10;
                                return Positioned(
                                  left: item.posX.value,
                                  top: item.posY.value,
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.selectedTextIndex.value =
                                          index;
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
                                    onPanUpdate: (details) {
                                      item.posX.value += details.delta.dx;
                                      item.posY.value += details.delta.dy;
                                      controller.clampTextPosition(
                                          item, stackWidth, stackHeight);
                                    },
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth: maxWidth > 10 ? maxWidth : 10,
                                        minWidth: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        border: controller
                                                    .selectedTextIndex.value ==
                                                index
                                            ? Border.all(
                                                color: Colors.blue, width: 2)
                                            : null,
                                      ),
                                      padding: const EdgeInsets.all(2),
                                      child: Text(
                                        item.content.value,
                                        textAlign: controller
                                            .getTextAlignFromAlignment(
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
                            )),
                      ],
                    ),
                  ),
                  getDynamicSizedBox(height: 2.h),
                ],
              ),
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
        return Image.memory(controller.cachedThumbnail.value!,
            fit: BoxFit.fill, width: width, height: height);
      } else if (controller.thumbnailFuture.value == null) {
        return Image.asset(Asset.bussinessPlaceholder,
            fit: BoxFit.fill, width: width, height: height);
      } else {
        return FutureBuilder<Uint8List?>(
          future: controller.thumbnailFuture.value,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                snapshot.data != null) {
              controller.cachedThumbnail.value =
                  snapshot.data; // Cache the result
              return Image.memory(snapshot.data!,
                  fit: BoxFit.fill, width: width, height: height);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      }
    });
  }
}
