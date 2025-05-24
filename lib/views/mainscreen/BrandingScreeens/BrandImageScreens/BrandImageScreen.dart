import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/controller/BrandImageController.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;

class BrandImageScreen extends StatefulWidget {
  BrandImageScreen({required this.id, required this.title, super.key});
  // BusinessData item;
  String id;
  String title;

  @override
  State<BrandImageScreen> createState() => _BrandImageScreenState();
}

class _BrandImageScreenState extends State<BrandImageScreen> {
  var controller = Get.put(BrandImageController());

  @override
  void initState() {
    super.initState();
    getInitData();
    controller.fetchGalleryAlbums();
  }

  getInitData() {
    setState(() {
      controller.categoryId = widget.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    Statusbar().transparentStatusbarIsNormalScreen();
        final squareSize = math.min(80.w, 40.h);  // Responsive square size

    final stackWidth = squareSize;
    final stackHeight = squareSize;
    const imagePadding = 0.0; // Padding inside the image Container

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
              color: white,
              child: Column(
                children: [
                  getDynamicSizedBox(height: 4.h),
                  Container(
                      margin: EdgeInsets.only(left: 5.w),
                      child: getleftsidebackbtn(
                          title: widget.title,
                          backFunction: () {
                            Get.back(result: true);
                          })),
                  getDynamicSizedBox(height: 5.h),
                  SizedBox(
                    width: stackWidth,
                    height: stackHeight,
                    child: Stack(
                      clipBehavior: Clip.hardEdge,
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
                                border: Border.all(color: black, width: 0.5),
                                shape: BoxShape.rectangle),
                            child: 
                               ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child: _buildImageWidget(
                                  controller,
                                  stackWidth - 2 * imagePadding,
                                  stackHeight - 2 * imagePadding,
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
          Obx(() => controller.buildNavBar(context, controller)),
        ],
      ),
    );
  }
Widget _buildImageWidget(
    BrandImageController controller, double width, double height) {
  return Obx(() {
    Widget baseImage;

    if (controller.selectedImageUrl.value.isNotEmpty) {
      baseImage = CachedNetworkImage(
        imageUrl: controller.selectedImageUrl.value,
        fit: BoxFit.fill,
        width: width,
        height: height,
        placeholder: (context, url) => Image.asset(
          Asset.bussinessPlaceholder,
          fit: BoxFit.fill,
          width: width,
          height: height,
        ),
        errorWidget: (context, url, error) => Image.asset(
          Asset.bussinessPlaceholder,
          fit: BoxFit.fill,
          width: width,
          height: height,
        ),
      );
    } else if (controller.cachedThumbnail.value != null) {
      baseImage = Image.memory(
        controller.cachedThumbnail.value!,
        fit: BoxFit.fill,
        width: width,
        height: height,
      );
    } else if (controller.thumbnailFuture.value != null) {
      baseImage = FutureBuilder<Uint8List?>(
        future: controller.thumbnailFuture.value,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data != null) {
            controller.cachedThumbnail.value = snapshot.data;
            return Image.memory(
              snapshot.data!,
              fit: BoxFit.fill,
              width: width,
              height: height,
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      );
    } else {
      baseImage = Image.asset(
        Asset.bussinessPlaceholder,
        fit: BoxFit.fill,
        width: width,
        height: height,
      );
    }

    // Overlay image if secondaryImageUrl is present
    Widget overlayImage = controller.selectedFrameUrl.value.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: controller.selectedFrameUrl.value,
            width: width,
            height: height,
          )
        : const SizedBox.shrink(); // Empty widget if no secondary image

    return Stack(
      children: [
        baseImage,
        if (controller.selectedFrameUrl.value.isNotEmpty)
          Positioned.fill(child: overlayImage),
      ],
    );
  });
}


  // Widget _buildImageWidget(
  //     BrandImageController controller, double width, double height) {
  //   return Obx(() {
  //     if (controller.selectedImageUrl.value.isNotEmpty) {
  //       // Display the selected image
  //       return CachedNetworkImage(
  //         imageUrl: controller.selectedImageUrl.value,
  //         fit: BoxFit.fill,
  //         width: width,
  //         height: height,
  //         placeholder: (context, url) => Image.asset(
  //           Asset.bussinessPlaceholder,
  //           fit: BoxFit.fill,
  //           width: width,
  //           height: height,
  //         ),
  //         errorWidget: (context, url, error) => Image.asset(
  //           Asset.bussinessPlaceholder,
  //           fit: BoxFit.fill,
  //           width: width,
  //           height: height,
  //         ),
  //       );
  //     } else if (controller.cachedThumbnail.value != null) {
  //       return Image.memory(
  //         controller.cachedThumbnail.value!,
  //         fit: BoxFit.fill,
  //         width: width,
  //         height: height,
  //       );
  //     } else if (controller.thumbnailFuture.value != null) {
  //       return FutureBuilder<Uint8List?>(
  //         future: controller.thumbnailFuture.value,
  //         builder: (context, snapshot) {
  //           if (snapshot.connectionState == ConnectionState.done &&
  //               snapshot.hasData &&
  //               snapshot.data != null) {
  //             controller.cachedThumbnail.value =
  //                 snapshot.data; // Cache the result
  //             return Image.memory(
  //               snapshot.data!,
  //               fit: BoxFit.fill,
  //               width: width,
  //               height: height,
  //             );
  //           } else {
  //             return const Center(child: CircularProgressIndicator());
  //           }
  //         },
  //       );
  //     } else {
  //       return Image.asset(
  //         Asset.bussinessPlaceholder,
  //         fit: BoxFit.fill,
  //         width: width,
  //         height: height,
  //       );
  //     }
  //   });
  // }


}
