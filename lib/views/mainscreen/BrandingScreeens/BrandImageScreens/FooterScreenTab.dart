import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/controller/BrandImageController.dart';
import 'package:ibh/utils/log.dart';
import 'package:sizer/sizer.dart';

class FooterScreenTab extends StatefulWidget {
  FooterScreenTab({required this.controller, super.key});

  BrandImageController controller;

  @override
  State<FooterScreenTab> createState() => _FooterScreenTabState();
}

class _FooterScreenTabState extends State<FooterScreenTab> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (widget.controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 1.h, left: 3.w, right: 3.w),
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, crossAxisSpacing: 5, mainAxisSpacing: 2),
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              logcat('Print', 'Pressing');
            },
            child: Container(
              margin: EdgeInsets.only(top: 2.h),
              width: 5.w,
              height: 6.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child:
                    Image.asset(Asset.bussinessPlaceholder, fit: BoxFit.cover),
              ),
            ),
          );
        },
      );
    });
  }
}
