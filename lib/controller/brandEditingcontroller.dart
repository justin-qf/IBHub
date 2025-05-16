import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/models/TextItemModel.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/log.dart';
import 'package:ibh/views/mainscreen/BrandingScreeens/ColorPickerWidget.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sizer/sizer.dart';

class Brandeditingcontroller extends GetxController {
  Rx<ScreenState> state = ScreenState.apiSuccess.obs;
  RxInt activeTab = 0.obs;

  // Image-related properties
  final RxList<AssetPathEntity> albums = <AssetPathEntity>[].obs;
  final RxMap<AssetPathEntity, List<AssetEntity>> albumImages =
      <AssetPathEntity, List<AssetEntity>>{}.obs;
  final RxBool isLoading = true.obs;
  final Rx<AssetEntity?> selectedImage = Rx<AssetEntity?>(null);
  final Rx<Future<Uint8List?>?> thumbnailFuture = Rx<Future<Uint8List?>?>(null);
  final Rx<Uint8List?> cachedThumbnail = Rx<Uint8List?>(null);

  List<Widget> screens(BuildContext context) => [
        Container(margin: EdgeInsets.all(10), child: getimageGridView()),
        Container(margin: EdgeInsets.all(10), child: footerWidget()),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            child: getFrameGridView()),
        Container(child: bgcolorPic(context: context)),
        Container(
            margin: EdgeInsets.all(10), child: gettextEditingWidget(context)),
        Container(
          margin: EdgeInsets.all(10),
          child: filterLogic(),
        )
      ];

  void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  // Filter-related logic
  Widget filterLogic() {
    return SizedBox.shrink(); // Placeholder as per original code
  }

  void toggleImageSelection(AssetEntity image) async {
    if (selectedImage.value == image) {
      selectedImage.value = null;
      thumbnailFuture.value = null;
      cachedThumbnail.value = null;
    } else {
      selectedImage.value = image;
      thumbnailFuture.value =
          image.thumbnailDataWithSize(ThumbnailSize(600, 600));
      final Uint8List? data = await thumbnailFuture.value;
      cachedThumbnail.value = data;
    }
  }

  Future<void> fetchGalleryAlbums() async {
    isLoading.value = true;
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!ps.hasAccess) {
      isLoading.value = false;
      String message = 'Gallery access permission denied';
      if (ps == PermissionState.limited) {
        message =
            'Limited gallery access granted. Some albums may not be available.';
      }
      logcat('Error', message);
      Get.snackbar('Error', message);
      return;
    }
    logcat('Info', 'Permission granted, fetching albums...');
    final List<AssetPathEntity> paths;
    try {
      paths = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        filterOption: FilterOptionGroup(
          imageOption: const FilterOption(
              sizeConstraint: SizeConstraint(ignoreSize: true)),
        ),
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        logcat('Error', 'Timeout fetching albums');
        throw Exception('Timeout fetching albums');
      });
    } catch (e) {
      isLoading.value = false;
      logcat('Error', 'Failed to fetch albums: $e');
      Get.snackbar('Error', 'Failed to fetch albums: $e');
      return;
    }
    if (paths.isEmpty) {
      isLoading.value = false;
      logcat('Error', 'No albums found');
      Get.snackbar('Error', 'No albums found');
      return;
    }
    logcat('Info', 'Found ${paths.length} albums');
    Map<AssetPathEntity, List<AssetEntity>> tempAlbumImages = {};
    for (var path in paths) {
      try {
        final List<AssetEntity> entities = await path
            .getAssetListPaged(page: 0, size: 10)
            .timeout(const Duration(seconds: 5), onTimeout: () {
          logcat('Error', 'Timeout fetching images for album: ${path.name}');
          return [];
        });
        if (entities.isNotEmpty) {
          tempAlbumImages[path] = entities;
          logcat('Info',
              'Fetched ${entities.length} images for album: ${path.name}');
        }
      } catch (e) {
        logcat('Error', 'Error fetching images for album ${path.name}: $e');
      }
    }
    albums.assignAll(tempAlbumImages.keys.toList());
    albumImages.assignAll(tempAlbumImages);
    isLoading.value = false;
    logcat('Info', 'Total albums fetched: ${albums.length}');
  }

  Widget buildGalleryItem({
    required Widget child,
    VoidCallback? onTap,
    String? title,
    String? subtitle,
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.only(top: 1.h),
                width: 5.w,
                height: 8.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: child,
                ),
              ),
              if (title != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                        color: white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
          if (isSelected)
            Positioned(
              top: 1.2.h,
              right: 0.3.w,
              child:
                  Icon(Icons.check_circle, color: Colors.blueAccent, size: 20),
            ),
        ],
      ),
    );
  }

  final Rx<AssetPathEntity?> selectedAlbum = Rx<AssetPathEntity?>(null);

  Widget getimageGridView() {
    return Obx(() {
      if (isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (selectedAlbum.value != null) {
        final images = albumImages[selectedAlbum.value!] ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  selectedAlbum.value = null;
                },
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 5,
                    childAspectRatio: 0.8),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final image = images[index];
                  final thumbnailFuture =
                      image.thumbnailDataWithSize(ThumbnailSize(400, 400));
                  return FutureBuilder<Uint8List?>(
                    future: thumbnailFuture,
                    builder: (context, snapshot) {
                      Widget thumbnail;
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        thumbnail =
                            Image.memory(snapshot.data!, fit: BoxFit.cover);
                      } else {
                        thumbnail = const Center(child: Icon(Icons.image));
                      }
                      return Obx(() {
                        final isSelected = selectedImage.value == image;
                        return buildGalleryItem(
                          isSelected: isSelected,
                          onTap: () {
                            toggleImageSelection(image);
                          },
                          child: thumbnail,
                        );
                      });
                    },
                  );
                },
              ),
            ),
          ],
        );
      }
      if (albums.isEmpty) {
        return const Center(child: Text('No albums found'));
      }
      return GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          childAspectRatio: 0.7,
        ),
        itemCount: albums.length,
        itemBuilder: (BuildContext context, int index) {
          final album = albums[index];
          final images = albumImages[album] ?? [];
          return buildGalleryItem(
            title: album.name,
            subtitle: '${images.length} images',
            onTap: () {
              selectedAlbum.value = album;
            },
            child: images.isNotEmpty
                ? FutureBuilder<Uint8List?>(
                    future: images.first.thumbnailData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.data != null) {
                        return Image.memory(snapshot.data!, fit: BoxFit.cover);
                      }
                      return const Center(
                          child: Icon(Icons.photo, color: Colors.grey));
                    },
                  )
                : const Center(child: Icon(Icons.photo, color: Colors.grey)),
          );
        },
      );
    });
  }

  Widget getFrameGridView() {
    return SizedBox(
      height: 20.h,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              logcat('Print', 'Pressing');
            },
            child: Container(
              decoration: BoxDecoration(
                color: white,
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(Asset.bussinessPlaceholder,
                      fit: BoxFit.contain)),
            ),
          );
        },
      ),
    );
  }

  Widget footerWidget() {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 1.h),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            logcat('Print', 'Pressing');
          },
          child: Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: white, borderRadius: BorderRadius.circular(10)),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(Asset.bussinessPlaceholder,
                    fit: BoxFit.contain)),
          ),
        );
      },
    );
  }

  // Text-related properties
  RxDouble textfontSize = 16.sp.obs;
  RxBool isTextBold = false.obs;
  RxBool isTextItalic = false.obs;
  RxBool isTextAlignLeft = false.obs;
  RxBool isTextAlignCenter = true.obs;
  RxBool isTextAlignRight = false.obs;
  var currentTextColor = Rx<Color>(Colors.black);
  var hexTextCode = "".obs;

  Color get hexTextColor => hexTextToColor(hexTextCode.value);

  Color hexTextToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  var textItems = <TextItem>[].obs;
  final RxInt selectedTextIndex = (-1).obs;

  void addTextItem(String content) {
    textItems.add(TextItem(
      x: 50,
      y: 100,
      text: content,
      size: textfontSize.value,
      align: isTextAlignLeft.value
          ? Alignment.centerLeft
          : isTextAlignCenter.value
              ? Alignment.center
              : Alignment.centerRight,
      color:
          hexTextCode.value.isNotEmpty ? hexTextColor : currentTextColor.value,
      bold: isTextBold.value,
      italic: isTextItalic.value,
    ));
    selectedTextIndex.value = textItems.length - 1;
  }

  void toggleBold() {
    isTextBold.value = !isTextBold.value;
    if (selectedTextIndex.value != -1) {
      textItems[selectedTextIndex.value].isBold.value = isTextBold.value;
    }
  }

  void toggleItalic() {
    isTextItalic.value = !isTextItalic.value;
    if (selectedTextIndex.value != -1) {
      textItems[selectedTextIndex.value].isItalic.value = isTextItalic.value;
    }
  }

  void setAlignment(Alignment alignment) {
    isTextAlignLeft.value = alignment == Alignment.centerLeft;
    isTextAlignCenter.value = alignment == Alignment.center;
    isTextAlignRight.value = alignment == Alignment.centerRight;
    if (selectedTextIndex.value != -1) {
      textItems[selectedTextIndex.value].alignment.value = alignment;
    }
  }

  TextAlign getTextAlignFromAlignment(Alignment alignment) {
    if (alignment == Alignment.centerLeft) return TextAlign.left;
    if (alignment == Alignment.center) return TextAlign.center;
    if (alignment == Alignment.centerRight) return TextAlign.right;
    return TextAlign.center;
  }

  void showTextEditor(BuildContext context) {
    String newText = "";
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (val) => newText = val,
                    maxLines: null,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    decoration: const InputDecoration(
                      hintText: "Type your text...",
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (newText.trim().isNotEmpty) {
                        addTextItem(newText.trim());
                      }
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: white,
                      foregroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    child: const Text("Add Text"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void pickTextColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.color_lens, color: currentTextColor.value),
            SizedBox(width: 10),
            Text(
              'Pick Text Color',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: currentTextColor.value),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(),
            ColorPicker(
              pickerColor: currentTextColor.value,
              onColorChanged: (color) {
                currentTextColor.value = color;
                hexTextCode.value = '';
                if (selectedTextIndex.value != -1) {
                  textItems[selectedTextIndex.value].textColor.value = color;
                }
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.7,
              enableAlpha: false,
              labelTypes: const [
                ColorLabelType.hex,
                ColorLabelType.rgb,
                ColorLabelType.hsv,
                ColorLabelType.hsl
              ],
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            icon: Icon(Icons.check, color: currentTextColor.value),
            label:
                Text('Apply', style: TextStyle(color: currentTextColor.value)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget gettextEditingWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                logcat('Print', 'Pressing');
                showTextEditor(context);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: white, borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(5),
                child: Icon(Icons.add),
              ),
            ),
            getDynamicSizedBox(width: 2.w),
            GestureDetector(
              onTap: () {
                toggleBold();
                logcat('Print', 'Pressing');
              },
              child: Container(
                decoration: BoxDecoration(
                    color: isTextBold.value ? lightGrey : white,
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(5),
                child: Icon(Icons.format_bold),
              ),
            ),
            getDynamicSizedBox(width: 2.w),
            GestureDetector(
              onTap: () {
                toggleItalic();
                logcat('Print', 'Pressing');
              },
              child: Container(
                decoration: BoxDecoration(
                    color: isTextItalic.value ? lightGrey : white,
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(5),
                child: Icon(Icons.format_italic),
              ),
            ),
            getDynamicSizedBox(width: 2.w),
            GestureDetector(
              onTap: () {
                if (selectedTextIndex.value != -1) {
                  textItems.removeAt(selectedTextIndex.value);
                  selectedTextIndex.value = -1;
                }
                logcat('Print', 'Pressing');
              },
              child: Container(
                decoration: BoxDecoration(
                    color: white, borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(5),
                child: Icon(Icons.delete),
              ),
            ),
            getDynamicSizedBox(width: 10.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 40.w,
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      color: white, borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    onSubmitted: (value) {
                      try {
                        String hex = value.replaceAll('#', '');
                        if (hex.length == 6 || hex.length == 8) {
                          hexTextCode.value = '#${hex.toUpperCase()}';
                          if (selectedTextIndex.value != -1) {
                            textItems[selectedTextIndex.value].textColor.value =
                                hexTextColor;
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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          pickTextColor(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              right: 1.w, top: 0.5.h, bottom: 0.5.h),
                          padding: EdgeInsets.all(2),
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
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: white, borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () => setAlignment(Alignment.centerLeft),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color:
                                    isTextAlignLeft.value ? lightGrey : white),
                            padding: EdgeInsets.all(2),
                            child: Icon(Icons.format_align_left),
                          )),
                      GestureDetector(
                          onTap: () => setAlignment(Alignment.center),
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: isTextAlignCenter.value
                                    ? lightGrey
                                    : white),
                            child: Icon(Icons.format_align_center),
                          )),
                      GestureDetector(
                          onTap: () => setAlignment(Alignment.centerRight),
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color:
                                    isTextAlignRight.value ? lightGrey : white),
                            child: Icon(Icons.format_align_right),
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
              value: selectedTextIndex.value != -1
                  ? textItems[selectedTextIndex.value].fontSize.value
                  : textfontSize.value,
              min: 8.sp,
              max: 32.sp,
              activeColor: primaryColor,
              inactiveColor: white,
              onChanged: (value) {
                if (selectedTextIndex.value != -1) {
                  textItems[selectedTextIndex.value].fontSize.value = value;
                } else {
                  textfontSize.value = value;
                }
              },
            ))
      ],
    );
  }

  // Background-related code
  var showBorder = false.obs;
  var hexBgCode = "".obs;
  Color get hexBgColor => hexBgToColor(hexBgCode.value);
  Color hexBgToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  var currentBGColor = Rx<Color>(Colors.red);
  RxDouble borderSize = 2.sp.obs;

  Widget bgcolorPic({context}) {
    return Container(
      padding: const EdgeInsets.all(2),
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ColorPickerWidget(hexBgCode: hexBgCode),
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
                                hexBgCode.value = '#${hex.toUpperCase()}';
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
                              value: showBorder.value,
                              onChanged: (value) {
                                showBorder.value = value!;
                                if (showBorder.value == false) {
                                  borderSize.value = 2.sp;
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
            Obx(() => showBorder.value == true
                ? Slider(
                    value: borderSize.value,
                    min: 2.sp,
                    max: 32.sp,
                    activeColor: primaryColor,
                    inactiveColor: white,
                    onChanged: (value) {
                      borderSize.value = value;
                    },
                  )
                : SizedBox.shrink())
          ],
        ),
      ),
    );
  }

  void _updateTab(int index) {
    activeTab.value = index;
  }

  Widget buildNavBar(BuildContext context) {
    return Column(
      children: [
        Obx(() => Container(
              height: 25.h,
              width: Device.width,
              decoration: BoxDecoration(color: grey),
              child: screens(context)[activeTab.value],
            )),
        Container(
          width: double.infinity,
          color: primaryColor,
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavButton(
                    icon: Icons.image,
                    label: "Images",
                    index: 0,
                    onTap: () => _updateTab(0)),
                _buildNavButton(
                    icon: Icons.border_bottom,
                    label: "Footer",
                    index: 1,
                    onTap: () => _updateTab(1)),
                _buildNavButton(
                    icon: Icons.image,
                    label: "Frames",
                    index: 2,
                    onTap: () => _updateTab(2)),
                _buildNavButton(
                    icon: Icons.wallpaper,
                    label: "Backgrounds",
                    index: 3,
                    onTap: () => _updateTab(3)),
                _buildNavButton(
                    icon: Icons.text_fields,
                    label: "Text",
                    index: 4,
                    onTap: () {
                      _updateTab(4);
                      print("Open Text Editor");
                    }),
                _buildNavButton(
                    icon: Icons.edit,
                    label: "Edit",
                    index: 5,
                    onTap: () {
                      _updateTab(5);
                      print("Open Text Editor");
                    }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required int index,
    required VoidCallback onTap,
  }) {
    final isActive = activeTab.value == index;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 17.sp, color: isActive ? Colors.yellow : Colors.white),
            Text(
              label,
              style: TextStyle(
                fontSize: 15.sp,
                color: isActive ? Colors.yellow : Colors.white,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void clampTextPosition(TextItem item, double stackWidth, double stackHeight) {
    const minWidth = 10.0;
    const extraPadding = 10.0;
    item.posX.value =
        item.posX.value.clamp(0.0, stackWidth - minWidth - extraPadding);
    item.posY.value = item.posY.value.clamp(0.0, stackHeight - minWidth);
  }
}
