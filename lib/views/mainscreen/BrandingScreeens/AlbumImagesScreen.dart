import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ibh/controller/brandEditingcontroller.dart';
import 'package:ibh/utils/log.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sizer/sizer.dart';

class AlbumImagesScreen extends StatelessWidget {
  final AssetPathEntity album;

  const AlbumImagesScreen({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    final Brandeditingcontroller controller = Get.find<Brandeditingcontroller>();
    final images = controller.albumImages[album] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(album.name),
        actions: [
          Obx(
            () => controller.selectedImages.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: Text(
                      '${controller.selectedImages.length} selected',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: images.isEmpty
          ? const Center(child: Text('No images in this album'))
          : GridView.builder(
              padding: EdgeInsets.all(10.w),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.0, // Square aspect ratio for images
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                final image = images[index];

                return Obx(
                  () => GestureDetector(
                    onTap: () {
                      controller.toggleImageSelection(image);
                      logcat('Print', 'Pressing image $index in album ${album.name}');
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 30.h, // Increased size to match album grid
                          width: 25.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: FutureBuilder<Uint8List?>(
                              future: image.thumbnailData,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                                  return Image.memory(
                                    snapshot.data!,
                                    fit: BoxFit.cover, // Changed to cover for better image display
                                  );
                                }
                                return const Center(child: CircularProgressIndicator());
                              },
                            ),
                          ),
                        ),
                        if (controller.selectedImages.contains(image))
                          Positioned(
                            top: 5,
                            right: 5,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}