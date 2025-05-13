import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/utils/enum.dart';
import 'package:sizer/sizer.dart';

class Brandeditingcontroller extends GetxController {
  Rx<ScreenState> state = ScreenState.apiSuccess.obs;
  RxInt activeTab = 0.obs;

  // Optional: Define screens for each tab
  final List<Widget> screens = [
    Container(child: Text("Image Page")),
    Container(child: Text("Footer Page")),
    Container(child: Text("Frames Page")),
    Container(child: Text("Backgrounds Page")),
    Container(child: Text("Text Page")),
  ];

  

  void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
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
              child: screens[activeTab.value], // <-- dynamic screen content
            )),
        Container(
          width: double.infinity,
          color: primaryColor,
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavButton(
                icon: Icons.image,
                label: "Images",
                index: 0,
                onTap: () => _updateTab(0),
              ),
              _buildNavButton(
                icon: Icons.border_bottom,
                label: "Footer",
                index: 1,
                onTap: () => _updateTab(1),
              ),
              _buildNavButton(
                icon: Icons.image,
                label: "Frames",
                index: 2,
                onTap: () => _updateTab(2),
              ),
              _buildNavButton(
                icon: Icons.wallpaper,
                label: "Backgrounds",
                index: 3,
                onTap: () => _updateTab(3),
              ),
              _buildNavButton(
                icon: Icons.text_fields,
                label: "Text",
                index: 4,
                onTap: () {
                  _updateTab(4);
                  // Replace with actual TextEditor call
                  print("Open Text Editor");
                },
              ),
            ],
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
            Icon(
              icon,
              size: 17.sp,
              color: isActive ? Colors.yellow : Colors.white,
            ),
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
}
