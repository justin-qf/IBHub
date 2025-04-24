import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/utils/helper.dart';
import 'package:sizer/sizer.dart';

class Viewservicescreen extends StatefulWidget {
  const Viewservicescreen({super.key});

  @override
  State<Viewservicescreen> createState() => _ViewservicescreenState();
}

class _ViewservicescreenState extends State<Viewservicescreen> {
  @override
  Widget build(BuildContext context) {
    Statusbar().trasparentStatusbar();
    return CustomParentScaffold(
      onWillPop: () async {
        Get.back(result: true);
        return true;
      },
      onTap: () {
        hideKeyboard(context);
      },
      isExtendBodyScreen: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // getDynamicSizedBox(height: 2.h),
          SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5.w),
              child: getleftsidebackbtn(
                title: 'Services',
                backFunction: () {
                  Get.back(result: true);
                },
              ),
            ),
          ),
          // getDynamicSizedBox(height: 2.h),
          Expanded(
            child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: white,
                    elevation: 0,
                    shadowColor: white,
                    margin: EdgeInsets.only(left: 5.w, right: 5.w,bottom: 2.h),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 4.w, right: 2.w, top: 2.h, bottom: 2.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              //  color: Colors.blue,
                              padding: EdgeInsets.all(5),
                              width: 25.w,
                              height: 12.h,
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 230, 225, 225),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Image.asset(Asset.placeholder)),
                          getDynamicSizedBox(width: 5.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Title Here',
                                style: TextStyle(
                                  fontFamily: dM_sans_semiBold,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
