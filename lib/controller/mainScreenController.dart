import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/models/login_model.dart';
import 'package:ibh/preference/UserPreference.dart';
import 'package:ibh/views/Profile/updateprofilescreen.dart';
import 'package:sizer/sizer.dart';
import '../utils/enum.dart';
import 'internet_controller.dart';

class MainScreenController extends GetxController {
  var currentPage = 1;

  RxInt currentTreeView = 2.obs;

  RxBool isExpanded = false.obs;
  RxBool isTreeModeVertical = true.obs;

  RxBool accessToDrawer = false.obs;
  DateTime selectedValue = DateTime.now();

  RxString picDate = "".obs;
  RxList treeList = [].obs;
  final GlobalKey<ScaffoldState> key = GlobalKey();

  changeIndex(int index) async {
    currentPage = index;
    update();
  }

  void updateDate(date) {
    picDate.value = date;
    update();
  }

  Rx<ScreenState> state = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  final InternetController etworkManager = Get.find<InternetController>();

  void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  RxString name = "".obs;
  RxString bussiness = "".obs;
  RxString phone = "".obs;
  RxString address = "".obs;
  RxString city = "".obs;
  RxString states = "".obs;
  RxString pincode = "".obs;
  RxString visitingCardUrl = "".obs;

  getProfileData() async {
    state.value = ScreenState.apiLoading;
    User? retrievedObject = await UserPreferences().getSignInInfo();
    name.value = retrievedObject!.name??'';
    bussiness.value = retrievedObject.businessName??'';
    phone.value = retrievedObject.phone??'';
    address.value = retrievedObject.address??'';
    city.value = retrievedObject.city.toString();
    states.value = retrievedObject.state.toString();
    pincode.value = retrievedObject.pincode.toString();
    visitingCardUrl.value = retrievedObject.visitingCardUrl??'';
    update();
    state.value = ScreenState.apiSuccess;
  }

  // void getTimerPopup(BuildContext context) {
  //   Future.delayed(const Duration(seconds: 10), () {
  //     if (!context.mounted) return;
  //     // Check if ANY of the fields are empty
  //     if (address.value.isEmpty ||
  //         city.value.isEmpty ||
  //         states.value.isEmpty ||
  //         pincode.value.isEmpty ||
  //         visitingCardUrl.value.isEmpty ||
  //         name.value.isEmpty ||
  //         bussiness.value.isEmpty ||
  //         phone.value.isEmpty) {
  //       showBottomSheetPopup(context);
  //     }
  //   });
  // }

  // void showUpdatePopup(BuildContext context) {
  //   Future.delayed(const Duration(seconds: 10), () {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Dialog(
  //           shape: RoundedRectangleBorder(
  //             borderRadius:
  //                 BorderRadius.circular(2.0.w), // Responsive border radius
  //           ),
  //           child: Container(
  //             padding: EdgeInsets.all(4.0.w), // Responsive padding
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(2.0.w),
  //             ),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 // Placeholder for the celebratory character image
  //                 Image.asset(
  //                   Asset.applogo,
  //                   height: 20.0.h, // 25% of screen height
  //                   width: 20.0.w, // 25% of screen width
  //                 ),
  //                 SizedBox(height: 2.0.h), // Responsive spacing
  //                 // Generic title
  //                 Text(
  //                   'Exciting Update Available!',
  //                   style: TextStyle(
  //                     fontFamily: dM_sans_medium,
  //                     fontSize: 18.0.sp, // Responsive font size
  //                     fontWeight: FontWeight.bold,
  //                     color: primaryColor,
  //                   ),
  //                 ),
  //                 SizedBox(height: 1.5.h), // Responsive spacing
  //                 // Generic description
  //                 Text(
  //                   'A new version is here!\nEnjoy fresh features and improvements.',
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                     fontFamily: dM_sans_medium,
  //                     fontSize: 14.0.sp, // Responsive font size
  //                     color: primaryColor,
  //                   ),
  //                 ),
  //                 SizedBox(height: 2.0.h), // Responsive spacing
  //                 // Update App button
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop(); // Close the dialog
  //                     // Add your update logic here
  //                   },
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: primaryColor,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(1.5.w),
  //                     ),
  //                     padding: EdgeInsets.symmetric(
  //                       horizontal: 8.0.w,
  //                       vertical: 1.5.h,
  //                     ),
  //                   ),
  //                   child: Text(
  //                     'UPDATE APP',
  //                     style: TextStyle(
  //                       fontFamily: dM_sans_medium,
  //                       fontSize: 14.0.sp, // Responsive font size
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     );
  //   });
  // }

  void showBottomSheetPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          width: Device.width,
          padding: EdgeInsets.all(10),
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
                        Get.to(Updateprofilescreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            primaryColor, // your custom green color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        MainScreenConstant.addButton,
                        style: const TextStyle(color: Colors.white),
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
}
