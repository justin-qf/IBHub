import 'package:flutter/material.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:sizer/sizer.dart';

class OtpInput extends StatefulWidget {
  final TextEditingController controller;
  final bool autoFocus;
  final FocusNode node;

  const OtpInput(this.controller, this.autoFocus, this.node, {super.key});

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  @override
  Widget build(BuildContext context) {
    widget.node.addListener(() {
      setState(() {});
      setState(() {});
    });
    widget.controller.addListener(() {
      setState(() {});
    });

    return SizedBox(
      width: 15.w,
      child: TextFormField(
        cursorColor: Colors.black,
        controller: widget.controller,
        autofocus: widget.autoFocus,
        cursorWidth: 0.8,
        focusNode: widget.node,
        maxLength: 1,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        onChanged: (value) {
          if (value.trim().length == 1) {
            setState(() {});
            FocusScope.of(context).nextFocus();
          } else {
            setState(() {});
            //FocusScope.of(context).previousFocus();
          }
        },
        style: TextStyle(
          fontFamily: fontBold,
          fontSize: Device.screenType == ScreenType.mobile ? 22.sp : 16.sp,
          color: widget.node.hasFocus ? black : primaryColor,
        ),
        decoration: InputDecoration(
            counterText: '',
            hintStyle: const TextStyle(
              fontFamily: fontRegular,
            ),
            contentPadding:
                EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  Device.screenType == ScreenType.mobile ? 3.w : 2.w),
              borderSide: BorderSide(
                color: widget.controller.text.toString().isEmpty
                    ? inputBorderColor
                    : primaryColor,
                width: 0.4.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  Device.screenType == ScreenType.mobile ? 3.w : 2.w),
              borderSide: BorderSide(
                  color: widget.node.hasFocus ? inputBorderColor : Colors.grey,
                  width: 0.4.w),
            ),
            alignLabelWithHint: true),
      ),
    );
  }
}
