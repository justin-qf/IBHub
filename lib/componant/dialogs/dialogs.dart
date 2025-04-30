import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:ibh/componant/input/form_inputs.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/utils/helper.dart';
import 'package:ibh/views/Profile/updateprofilescreen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import '../../configs/colors_constant.dart';
import '../../configs/font_constant.dart';
import '../../configs/string_constant.dart';
import '../toolbar/toolbar.dart';

Widget getRadioButton(
    {label,
    firstText,
    secondText,
    isrequired = false,
    enableFunction,
    groupvalue,
    isSelected,
    onChanged,
    required unfocused,
    notifyListeners}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      getLable(label, isRequired: isrequired),
      getDynamicSizedBox(width: 1.w),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Radio(
                value: firstText,
                groupValue: groupvalue,
                onChanged: (value) {
                  unfocused();
                  onChanged(value!);

                  isSelected = false;

                  enableFunction(groupvalue);
                  notifyListeners();
                },
              ),
              GestureDetector(
                onTap: () {
                  unfocused();
                  onChanged(firstText);

                  isSelected = false;
                  enableFunction(groupvalue);
                  notifyListeners();
                },
                child: Text(
                  firstText,
                  style: TextStyle(fontFamily: dM_sans_regular),
                ),
              ),
              Radio(
                value: secondText,
                groupValue: groupvalue,
                onChanged: (value) {
                  unfocused();
                  onChanged(value!);
                  isSelected = false;
                  enableFunction(groupvalue);
                  notifyListeners();
                },
              ),
              GestureDetector(
                onTap: () {
                  unfocused();
                  onChanged(secondText);
                  isSelected = false;
                  enableFunction(groupvalue);
                  notifyListeners();
                },
                child: Text(
                  secondText,
                  style: TextStyle(fontFamily: dM_sans_regular),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

fetchSelectionPopup<T>(
  BuildContext context, {
  required list,
  required controller,
  required title,
  Function? function,
  required searchCtr,
  required searchNode,
  required filterFunction,
  required String Function(T) getTitle,
  Function(T)? onSelected, // ✅ New callback
}) {
  String selecteddata = controller.text; // Get currently selected city

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    )),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: dM_sans_medium,
                        fontSize: 18.sp,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(Icons.close, size: 22.sp, weight: 600.sp))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: getReactiveFormField(
                    node: searchNode,
                    controller: searchCtr,
                    hintLabel: HomeScreenconst.search,
                    onChanged: (val) {
                      filterFunction(val!);

                      setState(() {});
                    },
                    inputType: TextInputType.text,
                    isBorderSideEnable: false,
                    // wantSuffix: true,
                    // isMick: true,
                    formType: FieldType.search),
              ),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    var data = list[index];
                    String displayData = getTitle(data);
                    return ListTile(
                      title: Text(
                        displayData,
                        style: TextStyle(
                            color: displayData == selecteddata
                                ? primaryColor
                                : black),
                      ),
                      trailing: displayData == selecteddata
                          ? Icon(Icons.check,
                              color: primaryColor) // Show checkmark
                          : null,
                      onTap: () {
                        setState(() {
                          selecteddata = displayData;
                        });

                        controller.text = displayData;
                        if (function != null) {
                          function();
                        }

                        if (onSelected != null) {
                          onSelected(data);
                        }
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

void showSelectionPopup(
  BuildContext context, {
  required list,
  required controller,
  required title,
  Function? function,
  required searchCtr,
  required searchNode,
  required filterFunction,
  isCityData,
}) {
  String selecteddata = controller.text; // Get currently selected city

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    )),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: dM_sans_medium,
                        fontSize: 18.sp,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close, size: 22.sp, weight: 600.sp))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: getReactiveFormField(
                    node: searchNode,
                    controller: searchCtr,
                    hintLabel: HomeScreenconst.search,
                    onChanged: (val) {
                      filterFunction(val!);

                      setState(() {});
                    },
                    inputType: TextInputType.text,
                    isBorderSideEnable: false,
                    // wantSuffix: true,
                    // isMick: true,
                    formType: FieldType.search),
              ),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    // ignore: prefer_typing_uninitialized_variables
                    var data;
                    if (isCityData == true) {
                      data = list[index];
                    } else {
                      data = list[index].title;
                    }
                    return ListTile(
                      title: Text(
                        data,
                        style: TextStyle(
                            color: data == selecteddata ? primaryColor : black),
                      ),
                      trailing: data == selecteddata
                          ? Icon(Icons.check,
                              color: primaryColor) // Show checkmark
                          : null,
                      onTap: () {
                        setState(() {
                          selecteddata = data;
                        });
                        controller.text = data;
                        if (function != null) {
                          function();
                        }
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

void showMessage(
    {required BuildContext context,
    Function? callback,
    String? title,
    String? message,
    String? positiveButton,
    bool? isFromLogin,
    String? negativeButton}) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(
                title!,
                style: TextStyle(
                  fontFamily: fontBold,
                  fontSize:
                      Device.screenType == ScreenType.mobile ? 18.sp : 12.sp,
                ),
              ),
              content: Text(
                message!,
                style: const TextStyle(fontFamily: fontRegular),
              ),
              actions: [
                if (negativeButton != null && negativeButton.isNotEmpty)
                  CupertinoDialogAction(
                      child: Text(
                        negativeButton,
                        style: TextStyle(
                            fontSize: Device.screenType == ScreenType.mobile
                                ? 17.sp
                                : 16.sp,
                            fontFamily: fontMedium,
                            color: isDarkMode() ? white : black),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                if (positiveButton != null && positiveButton.isNotEmpty)
                  CupertinoDialogAction(
                      child: Text(
                        positiveButton,
                        style: TextStyle(
                            fontSize: Device.screenType == ScreenType.mobile
                                ? 17.sp
                                : 16.sp,
                            fontFamily: fontMedium,
                            color: isDarkMode()
                                ? isFromLogin == true
                                    ? white
                                    : white
                                : black),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        callback!();
                      })
              ]));
}

showDialogForScreen(context, String title, String message,
    {Function? callback, bool? isFromLogin}) {
  showMessage(
      context: context,
      callback: () {
        if (callback != null) {
          callback();
        }
        return true;
      },
      isFromLogin: isFromLogin,
      message: message,
      title: title,
      negativeButton: '',
      positiveButton: Button.continues);
}

void showShareMessage(
    BuildContext context, Function shareCallback, String title) {
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text(
              title,
              style: const TextStyle(
                fontFamily: fontMedium,
              ),
            ),
            content: const Text(
              "Do you want to share?",
              style: TextStyle(
                fontFamily: fontRegular,
              ),
            ),
            actions: [
              CupertinoDialogAction(
                  child: const Text(
                    "Cancel",
                    style:
                        TextStyle(fontFamily: fontRegular, color: Colors.grey),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              CupertinoDialogAction(
                  child: const Text(
                    "Share",
                    style:
                        TextStyle(fontFamily: fontMedium, color: primaryColor),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    shareCallback();
                  })
            ],
          ));
}

void showDropdownMessages(double insetPaddingVertical, BuildContext context,
    Widget content, String title) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              backgroundColor:
                  // ignore: deprecated_member_use
                  isDarkMode() ? darkBackgroundColor.withOpacity(0.9) : white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              title: Padding(
                padding: EdgeInsets.only(
                    left: Device.screenType == ScreenType.mobile ? 0.w : 2.9.w),
                child: Text(
                  title,
                  style: TextStyle(
                      fontFamily: fontMedium,
                      fontSize: Device.screenType == ScreenType.mobile
                          ? 20.sp
                          : 15.sp),
                ),
              ),
              // insetPadding: EdgeInsets.symmetric(
              //     vertical:
              //         Device.screenType == ScreenType.mobile ? 10.h : 20.h,
              //     horizontal:
              //         Device.screenType == ScreenType.mobile ? 4.h : 7.h),
              insetPadding: Device.screenType == ScreenType.mobile
                  ? EdgeInsets.symmetric(
                      horizontal: 5.h,
                    )
                  : EdgeInsets.symmetric(
                      vertical: insetPaddingVertical,
                      horizontal: 9.h,
                    ),
              contentPadding: EdgeInsets.only(
                  left: Device.screenType == ScreenType.mobile ? 6.7.w : 6.w,
                  top: 0.5.h,
                  right: Device.screenType == ScreenType.mobile ? 6.7.w : 6.w),
              content: content);
        });
      });
}

void showBottomSheetPopup(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isDismissible: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Container(
        width: Device.width,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            getDynamicSizedBox(height: 2.h),
            Text(
              MainScreenConstant.incompleteProfile,
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: dM_sans_semiBold),
            ),
            getDynamicSizedBox(height: 2.h),
            Text(
              MainScreenConstant.updatePrompt,
              style: TextStyle(fontFamily: dM_sans_medium, fontSize: 18.sp),
              textAlign: TextAlign.center,
            ),
            getDynamicSizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      MainScreenConstant.cancelButton,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                getDynamicSizedBox(width: 2.h),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      Get.to(const Updateprofilescreen());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor, // your custom green color
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      MainScreenConstant.addButton,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

void showShareSheetPopup(BuildContext context, {rightbtn, leftbtn}) {
  showModalBottomSheet(
    context: context,
    isDismissible: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Container(
        width: Device.width,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            getDynamicSizedBox(height: 2.h),
            Text(
              BussinessDetail.howContact,
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: dM_sans_semiBold),
            ),
            getDynamicSizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                      leftbtn();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      BussinessDetail.call,
                      style: TextStyle(
                          fontFamily: dM_sans_medium, color: Colors.black),
                    ),
                  ),
                ),
                getDynamicSizedBox(width: 2.h),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      rightbtn();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor, // your custom green color
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      BussinessDetail.wht,
                      style: TextStyle(
                          fontFamily: dM_sans_medium, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Future showDropDownDialog(BuildContext context, Widget content, String title) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: const Color(0XFFe3ecf3),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: Padding(
              padding: EdgeInsets.only(
                  left: Device.screenType == ScreenType.mobile ? 0.w : 2.9.w),
              child: Text(
                title,
                style: TextStyle(fontFamily: fontMedium, fontSize: 20.sp),
              ),
            ),
            contentPadding:
                EdgeInsets.only(left: 6.7.w, top: 0.5.h, right: 6.7.w),
            content: content);
      });
}

void showDropdownMessage(
  BuildContext context,
  Widget content,
  String title, {
  Function? onClick,
  Function? refreshClick,
  RxList<dynamic>? isShowLoading,
}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            titlePadding: EdgeInsets.zero,
            title: Padding(
              padding: EdgeInsets.only(
                  left: Device.screenType == ScreenType.mobile ? 0.w : 2.9.w),
              child: Stack(
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                        left: Device.screenType == ScreenType.mobile
                            ? 7.w
                            : 2.9.w,
                        right: 10.w,
                        top: 3.h,
                      ),
                      child: Obx(() {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                  fontFamily: fontMedium, fontSize: 20.sp),
                            ),
                            getDynamicSizedBox(width: 2.w),
                            if (isShowLoading!.isEmpty)
                              GestureDetector(
                                onTap: () {
                                  if (refreshClick != null) {
                                    refreshClick();
                                  }
                                },
                                child: Icon(
                                  Icons.refresh_rounded,
                                  color: black,
                                  size: Device.screenType == ScreenType.mobile
                                      ? 24.sp
                                      : 30.sp,
                                ),
                              ),
                          ],
                        );
                      })),
                  Positioned(
                    top: 1.h,
                    right: 2.5.w,
                    child: GestureDetector(
                      onTap: () {
                        if (onClick != null) {
                          onClick();
                        }
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.cancel,
                        color: black,
                        size: Device.screenType == ScreenType.mobile
                            ? 24.sp
                            : 30.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            contentPadding:
                EdgeInsets.only(left: 6.7.w, top: 0.5.h, right: 6.7.w),
            content: content,
          );
        });
      });
}

Widget setDropDownContent(RxList<dynamic> list, Widget content,
    {Widget? searchcontent,
    bool isApiIsLoading = false,
    TextEditingController? controller}) {
  return SizedBox(
      height: Device.screenType == ScreenType.mobile
          ? Device.height / 2
          : Device.height / 1.9,
      width: Device.width,
      child: Column(
        children: [
          getDividerForShowDialog(),
          searchcontent ?? Container(),
          if (list.isEmpty && isApiIsLoading == false)
            Expanded(
              child: Center(
                  child: Text(
                controller != null && controller.text.isNotEmpty
                    ? AlertDialogList.searchlist
                    : AlertDialogList.emptylist,
                style: TextStyle(fontSize: 4.5.w, fontFamily: fontMedium),
              )),
            )
          else if (isApiIsLoading == true)
            Expanded(
              child: Center(
                  child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: LoadingAnimationWidget.discreteCircle(
                      color: primaryColor, size: 35),
                  // Image.asset(
                  //   "assets/gif/loading.gif",
                  //   width: 50,
                  //   height: 50,
                  // ),
                ),
              )),
            ),
          if (list.isNotEmpty) Expanded(child: content),
          getDynamicSizedBox(height: 1.0.h)
        ],
      ));
}

Future<Object?> selectImageFromCameraOrGallery(BuildContext context,
    {Function? cameraClick, Function? galleryClick}) {
  return showGeneralDialog(
      // ignore: deprecated_member_use
      barrierColor: black.withOpacity(isDarkMode() ? 0.4 : 0.6),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
            scale: a1.value,
            child: Opacity(
                opacity: a1.value,
                child: CupertinoAlertDialog(
                    title: Text(
                      AlertDialogList.photo,
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: isDarkMode() ? white : black,
                          fontFamily: fontMedium,
                          fontWeight: FontWeight.bold),
                    ),
                    content: Text(
                      AlertDialogList.selectPhotoFrom,
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: isDarkMode() ? white : black,
                          fontFamily: fontBold),
                    ),
                    actions: [
                      CupertinoDialogAction(
                          onPressed: () {
                            cameraClick!();
                            Navigator.pop(context);
                          },
                          isDefaultAction: true,
                          isDestructiveAction: true,
                          child: Text(AlertDialogList.camera,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: isDarkMode() ? white : black,
                                  fontFamily: fontRegular,
                                  fontSize:
                                      Device.screenType == ScreenType.mobile
                                          ? 16.sp
                                          : 11.sp))),
                      CupertinoDialogAction(
                          onPressed: () {
                            galleryClick!();
                            Navigator.pop(context);
                          },
                          isDefaultAction: true,
                          isDestructiveAction: true,
                          child: Text(
                            AlertDialogList.gallery,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: isDarkMode() ? white : black,
                                fontFamily: fontRegular,
                                fontSize: Device.screenType == ScreenType.mobile
                                    ? 16.sp
                                    : 11.sp),
                          ))
                    ])));
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      });
}

Future commonDetailsDialog(BuildContext context, String title,
    {Widget? contain, bool? isDescription, isfromService = false}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          backgroundColor: isDarkMode() ? darkGrey : white,
          insetPadding: EdgeInsets.symmetric(
              vertical: isDescription == true
                  ? Device.screenType == ScreenType.mobile
                      ? 15.h
                      : 12.h
                  : Device.screenType == ScreenType.mobile
                      ? isfromService
                          ? 20.h
                          : 22.h
                      : 20.h,
              horizontal: Device.screenType == ScreenType.mobile ? 4.h : 6.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0.0,
          content:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 3.h,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    SizedBox(
                        width: isSmallDevice(context) ? 65.w : 60.w,
                        child: Device.screenType == ScreenType.mobile
                            ? getText(title)
                            : getText(title)),
                    const Spacer(),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          // color: Colors.yellow,
                          padding: isSmallDevice(context)
                              ? EdgeInsets.only(
                                  left: 0.1.w, right: 0.1.w, top: 0.2.h)
                              : EdgeInsets.only(
                                  left: 1.w, right: 1.w, top: 0.3.h),
                          // margin: EdgeInsets.only(
                          //     top: 0.5.h, left: 1.w, right: 1.w, bottom: 1.h),
                          child: Icon(
                            Icons.cancel,
                            size: Device.screenType == ScreenType.mobile
                                ? 24.0
                                : 28.0,
                            color: isDarkMode() ? white : black,
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
            getDynamicSizedBox(height: 1.h),
            getDivider(),
            getDynamicSizedBox(height: 1.h),
            contain ?? Container()
          ]));
    },
  );
}

// getMarquee(String title) {
//   return Marquee(
//       style: TextStyle(
//           fontFamily: fontRegular,
//           color: isDarkMode() ? white : black,
//           fontSize: Device.screenType == ScreenType.mobile ? 15.sp : 8.sp,
//           fontWeight: FontWeight.w900),
//       text: title,
//       scrollAxis: Axis.horizontal, // Use Axis.vertical for vertical scrolling
//       crossAxisAlignment: CrossAxisAlignment.start, // Adjust as needed
//       blankSpace: 20.0, // Adjust the space between text repetitions
//       velocity: 50.0, // Adjust the scrolling speed
//       pauseAfterRound:
//           const Duration(seconds: 1), // Time to pause after each scroll
//       startPadding: 2.w, // Adjust the initial padding
//       accelerationDuration:
//           const Duration(seconds: 1), // Duration for acceleration
//       accelerationCurve: Curves.linear, // Acceleration curve
//       decelerationDuration:
//           const Duration(milliseconds: 500), // Duration for deceleration
//       decelerationCurve: Curves.easeOut // Deceleration curve
//       );
// }

getText(String title) {
  return Text(title,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontFamily: fontRegular,
          color: isDarkMode() ? white : black,
          fontSize: Device.screenType == ScreenType.mobile ? 18.sp : 8.sp,
          fontWeight: FontWeight.w900));
}

Widget setDropDownTestContent(RxList<dynamic> list, Widget content,
    {Widget? searchcontent}) {
  return SizedBox(
      height: Device.screenType == ScreenType.mobile
          ? Device.height / 2
          : Device.height / 1.9, // Change as per your requirement
      width: Device.screenType == ScreenType.mobile
          ? Device.width
          : Device.width / 1.5, // Change as per your requirement
      child: Column(
        children: [
          getDividerForShowDialog(),
          searchcontent ?? Container(),
          if (list.isEmpty)
            Expanded(
              child: Center(
                  child: Text(
                "Empty List",
                style: TextStyle(
                    fontSize:
                        Device.screenType == ScreenType.mobile ? 12.sp : 12.sp,
                    fontFamily: fontMedium,
                    color: isDarkMode() ? white : black),
              )),
            ),
          list.isNotEmpty ? Expanded(child: content) : Container(),
          SizedBox(height: 1.0.h)
        ],
      ));
}

Future<Object?> showRequestCatDialod(context, text) {
  return showGeneralDialog(
    barrierLabel: "showMore",
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 700),
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return Align(
        alignment: Alignment.center,
        child: Container(
            height: Device.height / 2.5,
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7),
            margin: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
            child: SizedBox.expand(
                child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                        padding: EdgeInsets.only(
                            top: 1.h, bottom: 1.h, left: 5.w, right: 5.w),
                        child: Column(children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              Center(
                                child: Text('Description',
                                    style: TextStyle(
                                        fontSize: 2.5.h,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: fontRegular,
                                        color: black)),
                              ),
                              const Spacer(),
                              GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Stack(children: [
                                    Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(6),
                                          child: Icon(Icons.cancel,
                                              color: primaryColor, size: 22.sp),
                                        )),
                                  ]))
                            ],
                          ),
                          Divider(height: 1.h),
                          SizedBox(height: 1.h),
                          Expanded(
                              child: SingleChildScrollView(
                            child: Text(text,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 2.h,
                                  fontFamily: fontBold,
                                )),
                          ))
                        ]))))),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(anim1),
          child: child);
    },
  );
}
