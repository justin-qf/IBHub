import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/controller/brandEditingcontroller.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class ColorPickerWidget extends StatefulWidget {
  var hexBgCode = "".obs;
  ColorPickerWidget({super.key, required this.hexBgCode});

  @override
  _ColorPickerWidgetState createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  double _cursorX = 0;
  double _cursorY = 0;
  final Brandeditingcontroller controller = Get.find<Brandeditingcontroller>();

  Color _getColorAtPosition(double xPosition, double yPosition) {
    const colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.cyan,
      Colors.blue,
      Color(0xFFFF00FF),
    ];
    const segmentCount = 6;
    final segment = xPosition * segmentCount;
    final index = segment.floor();
    final fraction = segment - index;

    Color baseColor;
    if (index >= segmentCount) {
      baseColor = colors.last;
    } else {
      baseColor = Color.lerp(colors[index], colors[index + 1], fraction)!;
    }

    final brightness = 1.0 - yPosition;
    final hsvColor = HSVColor.fromColor(baseColor);
    final adjustedHsvColor = HSVColor.fromAHSV(
      hsvColor.alpha,
      hsvColor.hue,
      hsvColor.saturation,
      brightness.clamp(0.2, 1.0),
    );

    return adjustedHsvColor.toColor();
  }

  @override
  Widget build(BuildContext context) {
    double pickerWidth = 9.w;
    double pickerHeight = 2.h;
    const double cursorSize = 10;

    return Obx(() => Container(
          width: pickerWidth.w,
          height: pickerHeight.h,
          margin: EdgeInsets.only(left: 5.w, right: 3.w, top: 3.h, bottom: 0.h),
          decoration: BoxDecoration(
              color: controller.currentBGColor.value,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: white, width: 1.w)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GestureDetector(
              onPanStart: (details) {
                widget.hexBgCode.value = '';
                setState(() {
                  // Ensure cursor stays within the container bounds, accounting for cursor size
                  _cursorX = details.localPosition.dx
                      .clamp(cursorSize / 2, pickerWidth.w - cursorSize / 2);
                  _cursorY = details.localPosition.dy
                      .clamp(cursorSize / 2, pickerHeight.h - cursorSize / 2);

                  // Normalize the position for color calculation
                  double normalizedX = (_cursorX - cursorSize / 2) /
                      (pickerWidth.w - cursorSize);
                  double normalizedY = (_cursorY - cursorSize / 2) /
                      (pickerHeight.h - cursorSize);

                  Color selectedColor =
                      _getColorAtPosition(normalizedX, normalizedY);
                  controller.currentBGColor.value = selectedColor;
                  // controller.hexCode.value =
                  //     '#${selectedColor.value.toRadixString(16).substring(2).toUpperCase()}';
                });
              },
              onPanUpdate: (details) {
                setState(
                  () {
                    // Update cursor position with proper clamping, accounting for cursor size
                    _cursorX = (_cursorX + details.delta.dx)
                        .clamp(cursorSize / 2, pickerWidth.w - cursorSize / 2);
                    _cursorY = (_cursorY + details.delta.dy)
                        .clamp(cursorSize / 2, pickerHeight.h - cursorSize / 2);

                    // Normalize the position for color calculation
                    double normalizedX = (_cursorX - cursorSize / 2) /
                        (pickerWidth.w - cursorSize);
                    double normalizedY = (_cursorY - cursorSize / 2) /
                        (pickerHeight.h - cursorSize);

                    Color selectedColor =
                        _getColorAtPosition(normalizedX, normalizedY);
                    controller.currentBGColor.value = selectedColor;
                    // controller.hexCode.value =
                    //     '#${selectedColor.value.toRadixString(16).substring(2).toUpperCase()}';
                  },
                );
              },
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size(pickerWidth.w, pickerHeight.h),
                    painter: GradientPainter(),
                  ),
                  Positioned(
                    left: _cursorX - cursorSize / 2,
                    top: _cursorY - cursorSize / 2,
                    child: Container(
                      width: cursorSize,
                      height: cursorSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class GradientPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gradient = LinearGradient(
      colors: [
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.cyan,
        Colors.blue,
        Color(0xFFFF00FF),
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final brightnessGradient = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        Colors.black.withOpacity(0.8),
        Colors.transparent,
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final paint = Paint()..shader = gradient;
    final brightnessPaint = Paint()..shader = brightnessGradient;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), brightnessPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
