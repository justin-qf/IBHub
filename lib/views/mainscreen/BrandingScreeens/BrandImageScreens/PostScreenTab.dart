import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/apiOtherStates.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/controller/BrandImageController.dart';
import 'package:ibh/controller/image_controller.dart';
import 'package:ibh/models/imageModel.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/helper.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sizer/sizer.dart';
import 'package:sizer/sizer.dart' as sizer;

class PostScreenTab extends StatefulWidget {
  PostScreenTab({required this.controller, super.key});

  BrandImageController controller;

  @override
  State<PostScreenTab> createState() => _PostScreenTabState();
}

class _PostScreenTabState extends State<PostScreenTab> {
  var controller = Get.put(ImageController());

  @override
  void initState() {
    futureDelay(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.currentPage = 1;
      await controller.getPostList(context, controller.currentPage, false,
          isFirstTime: true, categoryId: widget.controller.categoryId);
    });
    controller.refreshController.refreshCompleted();
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
        const Duration(seconds: 1),
        () {
          controller
              // ignore: use_build_context_synchronously
              .getPostList(context, controller.currentPage, true,
                  isFirstTime: false, categoryId: widget.controller.categoryId)
              .whenComplete(() {
            if (mounted) {
              setState(() => controller.isFetchingMore = false);
              controller.refreshController.refreshCompleted();
            }
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 3.5.w, right: 2.w, top: 0.9.h),
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: controller.chipLabels.map((label) {
                  final isSelected =
                      controller.selectedLanguageCode.value == label;
                  return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(
                          label,
                          style: TextStyle(
                            color: isSelected ? white : black,
                            fontSize: 14.sp,
                            fontFamily: fontBold,
                          ),
                        ),
                        selected: isSelected,
                        backgroundColor: white,
                        selectedColor: primaryColor,
                        showCheckmark: false,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              controller.selectedLanguageCode.value = label;
                              final selectedCode =
                                  controller.labelToCode[label] ?? "en";
                              // Call your API
                              controller.currentPage = 1;
                              controller.getPostList(
                                  context, controller.currentPage, false,
                                  isFirstTime: true,
                                  selectedLabel: selectedCode,
                                  categoryId: widget.controller.categoryId);
                            }
                          });
                        },
                      ));
                }).toList(),
              )),
        ),
        Expanded(
          child: SmartRefresher(
            physics: const BouncingScrollPhysics(),
            controller: controller.refreshController,
            enablePullDown: true,
            enablePullUp: false,
            header: const WaterDropMaterialHeader(
                backgroundColor: primaryColor, color: white),
            onRefresh: () async {
              controller.currentPage = 1;
              futureDelay(() {
                controller.getPostList(context, controller.currentPage, false,
                    isFirstTime: true,
                    categoryId: widget.controller.categoryId);
              }, isOneSecond: false);
              controller.refreshController.refreshCompleted();
            },
            child: CustomScrollView(
              controller: controller.scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Obx(() {
                    switch (controller.state.value) {
                      case ScreenState.apiLoading:
                      case ScreenState.noNetwork:
                      case ScreenState.noDataFound:
                      case ScreenState.apiError:
                        return SizedBox(
                            height: Device.height / 3,
                            child: apiOtherStates(controller.state.value,
                                controller, controller.postImageList, () {
                              controller.currentPage = 1;
                              futureDelay(() {
                                controller.getPostList(
                                    context, controller.currentPage, false,
                                    isFirstTime: true,
                                    categoryId: widget.controller.categoryId);
                              }, isOneSecond: false);
                              controller.refreshController.refreshCompleted();
                            }));
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
        ),
      ],
    );

    // return Obx(() {
    // if (widget.controller.isLoading.value) {
    //   return const Center(child: CircularProgressIndicator());
    // }
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     // 🔼 Always visible chips
    //     Padding(
    //       padding: EdgeInsets.only(left: 3.5.w, right: 2.w, top: 0.9.h),
    //       child: SingleChildScrollView(
    //         scrollDirection: Axis.horizontal,
    //         child: Row(
    //           children: widget.controller.chipLabels.map((label) {
    //             final isSelected =
    //                 widget.controller.selectedChips.contains(label);
    //             return Padding(
    //               padding: const EdgeInsets.only(right: 8.0),
    //               child: FilterChip(
    //                 label: Text(
    //                   label,
    //                   style: TextStyle(
    //                     color: isSelected ? white : black,
    //                     fontSize: 14.sp,
    //                     fontFamily: fontBold,
    //                   ),
    //                 ),
    //                 selected: isSelected,
    //                 backgroundColor: white,
    //                 selectedColor: primaryColor,
    //                 showCheckmark: false,
    //                 shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(50),
    //                 ),
    //                 onSelected: (bool selected) {
    //                   setState(() {
    //                     selected
    //                         ? widget.controller.selectedChips.add(label)
    //                         : widget.controller.selectedChips.remove(label);
    //                   });
    //                 },
    //               ),
    //             );
    //           }).toList(),
    //         ),
    //       ),
    //     ),

    //     // 🔽 Below chips: selected album view or album grid
    //     Expanded(
    //       child: widget.controller.selectedAlbum.value != null
    //           ? _buildImageGridView()
    //           : _buildAlbumGridView(),
    //     ),
    //   ],
    // );
    // });
  }

  Widget apiSuccess(ScreenState state) {
    if (controller.state.value == ScreenState.apiSuccess &&
        controller.postImageList.isNotEmpty) {
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 5.h, left: 5.w, right: 5.w, top: 1.h),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 5,
            childAspectRatio: 0.7),
        shrinkWrap: true,
        itemCount: controller.postImageList.length +
            (controller.nextPageURL.value.isNotEmpty ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < controller.postImageList.length) {
            ImageData data = controller.postImageList[index];
            return controller.getListItem(context, widget.controller,
                data: data);
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
      return noDataFoundWidgetResponsive(isFromImageTab: true);
    }
  }

  Widget _buildImageGridView() {
    final images =
        widget.controller.albumImages[widget.controller.selectedAlbum.value!] ??
            [];
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              widget.controller.selectedAlbum.value = null;
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
              childAspectRatio: 0.8,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              final image = images[index];
              final thumbnailFuture =
                  image.thumbnailDataWithSize(const ThumbnailSize(400, 400));
              return FutureBuilder<Uint8List?>(
                future: thumbnailFuture,
                builder: (context, snapshot) {
                  Widget thumbnail =
                      snapshot.connectionState == ConnectionState.done &&
                              snapshot.hasData
                          ? Image.memory(snapshot.data!, fit: BoxFit.cover)
                          : const Center(child: Icon(Icons.image));
                  return Obx(() {
                    final isSelected =
                        widget.controller.selectedImage.value == image;
                    return widget.controller.buildGalleryItem(
                      isSelected: isSelected,
                      onTap: () {
                        widget.controller.toggleImageSelection(image);
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

  Widget _buildAlbumGridView() {
    if (widget.controller.albums.isEmpty) {
      return const Center(child: Text('No albums found'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 0,
        mainAxisExtent: 90.0,
        childAspectRatio: 0.8,
      ),
      itemCount: widget.controller.albums.length,
      itemBuilder: (context, index) {
        final album = widget.controller.albums[index];
        final images = widget.controller.albumImages[album] ?? [];
        return widget.controller.buildGalleryItem(
          title: album.name,
          subtitle: '${images.length} images',
          onTap: () {
            widget.controller.selectedAlbum.value = album;
          },
          child: images.isNotEmpty
              ? FutureBuilder<Uint8List?>(
                  future: images.first.thumbnailData,
                  builder: (context, snapshot) {
                    return snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData
                        ? Image.memory(snapshot.data!, fit: BoxFit.cover)
                        : const Center(
                            child: Icon(Icons.photo, color: primaryColor));
                  },
                )
              : const Center(child: Icon(Icons.photo, color: primaryColor)),
        );
      },
    );
  }
}
