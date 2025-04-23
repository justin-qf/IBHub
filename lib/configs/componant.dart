import 'package:flutter/material.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:sizer/sizer.dart';

void navigateAndRemove(context, widget) => Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(builder: (context) => widget), (route) => false);

void navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

Widget login(context) => Text('Login',
    style: TextStyle(
        color: white, fontSize: 36.0.sp, fontWeight: FontWeight.w700));

Widget askToCreate(context) => Text("Don't have an account?",
    style: TextStyle(color: black, fontSize: 14.0.sp));

Widget defaultButton({required Function() onPressed, Widget? child}) =>
    MaterialButton(
        onPressed: onPressed,
        highlightColor: Colors.orange,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        padding: EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 7.5.h),
        color: Colors.orange,
        child: child);

Widget logo = Row(
  children: [
    Icon(Icons.shopping_bag, color: Colors.orange, size: 28.0.sp),
    Text('BuyMe',
        style: TextStyle(fontSize: 24.0.sp, fontWeight: FontWeight.w500)),
  ],
);

Widget loading = SizedBox(
  width: 35.0.sp,
  height: 35.0.sp,
  child: const CircularProgressIndicator(color: Colors.orange),
);
