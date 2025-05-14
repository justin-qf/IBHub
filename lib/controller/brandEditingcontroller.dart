import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
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
        Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            child: getFrameGridView()),
        Container(
            // margin: EdgeInsets.symmetric(horizontal: 4.w),
            child: bgcolorPic(context: context)),
        Container(
            margin: EdgeInsets.all(10), child: gettextEditingWidget(context)),
      ];

  void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
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

//image page
  Widget getimageGridView() {
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

  RxDouble fontSize = 16.sp.obs;
  gettextEditingWidget(context) {
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
                logcat('Print', 'Pressing');
              },
              child: Container(
                decoration: BoxDecoration(
                    color: white, borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(5),
                child: Icon(Icons.format_bold),
              ),
            ),
            getDynamicSizedBox(width: 2.w),
            GestureDetector(
              onTap: () {
                logcat('Print', 'Pressing');
              },
              child: Container(
                decoration: BoxDecoration(
                    color: white, borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(5),
                child: Icon(Icons.format_italic),
              ),
            ),
            getDynamicSizedBox(width: 2.w),
            GestureDetector(
              onTap: () {
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
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Hax Code',
                        style: TextStyle(fontFamily: dM_sans_medium),
                      )
                    ],
                  ),
                ),
                getDynamicSizedBox(height: 2.h),
                Container(
                  width: 40.w,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: white, borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            print('Tap');
                          },
                          child: Icon(
                            Icons.format_align_left,
                          )),
                      GestureDetector(
                          onTap: () {
                            print('Tap');
                          },
                          child: Icon(
                            Icons.format_align_center,
                          )),
                      GestureDetector(
                          onTap: () {
                            print('Tap');
                          },
                          child: Icon(
                            Icons.format_align_right,
                          )),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
        getDynamicSizedBox(height: 1.h),
        Container(
          margin: EdgeInsets.only(left: 6.w),
          child: Text(
            'Font Size',
            style: TextStyle(
                fontSize: 18.sp, color: white, fontFamily: dM_sans_semiBold),
          ),
        ),
        Obx(() => Slider(
              value: fontSize.value,
              min: 8,
              max: 32,
              activeColor: primaryColor,
              inactiveColor: white,
              onChanged: (value) {
                fontSize.value = value;
              },
            ))
      ],
    );
  }

//footer page

  Widget footerWidget() {
    return Container(
      child: Text('data'),
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
          // Color Picker Inline (Direct)
          // Container(
          //   width: 40.w,
          //   height: 50.h, // Increased height to fit color picker
          //   margin:
          //       EdgeInsets.only(left: 5.w, right: 3.w, top: 3.h, bottom: 3.h),
          //   decoration: BoxDecoration(
          //     color: _currentColor,
          //     borderRadius: BorderRadius.circular(10),
          //     border: _showBorder
          //         ? Border.all(color: Colors.pink, width: 1.w)
          //         : null,
          //   ),
          //   child: SingleChildScrollView(
          //     child: ColorPicker(
          //       pickerColor: _currentColor,
          //       onColorChanged: (color) {
          //         _currentColor = color;
          //       },
          //       pickerAreaHeightPercent: 0.5,
          //       displayThumbColor: true,
          //       enableAlpha: false,
          //     ),
          //   ),
          // ),

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
                        // Invalid hex code input
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
                  height: 7.h,
                  width: 40.w,
                  child: CheckboxListTile(
                    value: _showBorder,
                    onChanged: (value) {
                      _showBorder = value!;
                    },
                    title: Text(
                      'Image Border',
                      style: TextStyle(fontSize: 16.sp, color: Colors.white),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    visualDensity: VisualDensity(horizontal: -4),
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
