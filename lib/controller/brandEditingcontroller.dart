import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/log.dart';
import 'package:sizer/sizer.dart';

class Brandeditingcontroller extends GetxController {
  Rx<ScreenState> state = ScreenState.apiSuccess.obs;
  RxInt activeTab = 0.obs;

  // Optional: Define screens for each tab
  List<Widget> screens(BuildContext context) => [
        Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            child: getimageGridView()),
        Container(child: Text("Frames Page")),
        Container(child: Text("Backgrounds Page")),
        Container(
            // margin: EdgeInsets.symmetric(horizontal: 4.w),
            child: bgcolorPic(context: context)),
        Container(child: Text("Text Page")),
      ];

  void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

//image page
  static Widget getimageGridView() {
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
                borderRadius: BorderRadius.circular(10),
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

//background page

  bool _showBorder = true;
  String _hexCode = "#FFFFFF";
  Color _currentColor = Colors.red;

  Widget bgcolorPic({context}) {
    return Container(
      padding: const EdgeInsets.all(2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Color Preview Box

          GestureDetector(
            onTap: () {
              // Show color picker dialog
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Pick a color'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: _currentColor,
                        onColorChanged: (color) {
                          _currentColor = color;
                        },
                        pickerAreaHeightPercent: 0.8,
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const Text('Got it'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              width: 40.w,
              height: 30.h,
              margin:
                  EdgeInsets.only(left: 5.w, right: 3.w, top: 3.h, bottom: 3.h),
              decoration: BoxDecoration(
                color: _currentColor,
                borderRadius: BorderRadius.circular(10),
                border: _showBorder
                    ? Border.all(color: Colors.pink, width: 1.w)
                    : null,
              ),
              child: const Center(
                child: Icon(Icons.color_lens, color: Colors.white),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          // Control Panel
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 6.h,
                  width: 35.w,
                  padding: EdgeInsets.only(top: 0.h, right: 2.w, left: 2.w),
                  child: TextField(
                    onChanged: (value) {
                      _hexCode = value;
                      try {
                        _currentColor =
                            Color(int.parse(value, radix: 16) + 0xFF000000);
                      } catch (_) {
                        // Invalid hex
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
                SizedBox(height: 2.h),
                Container(
                  color: Colors.yellow,
                  height: 7.h,
                  child: CheckboxListTile(
                    value: _showBorder,
                    onChanged: (value) {
                      _showBorder = value!;
                    },
                    title: Text(
                      'Image Border',
                      style: TextStyle(fontSize: 16.sp),
                    ),

                    controlAffinity: ListTileControlAffinity.leading,

                    visualDensity: VisualDensity(horizontal: -4),
                    // Adjust the padding of title and subtitle
                  ),
                )
              ],
            ),
          )
        ],
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
              child: screens(
                  context)[activeTab.value], // <-- dynamic screen content
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
