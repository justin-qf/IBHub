import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/models/login_model.dart';
import 'package:ibh/preference/UserPreference.dart';
import 'package:ibh/views/Profile/updateprofilescreen.dart';
import '../utils/enum.dart';
import 'internet_controller.dart';

class MainScreenController extends GetxController {
  var currentPage = 0;

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

//   RxString address = "".obs;
//   RxString city = "".obs;
//   RxString state = "".obs;
//   RxString pincode = "".obs;
//   RxString visitingCardUrl = "".obs;




// getProfileData() async {
//     state.value = ScreenState.apiLoading;
//     User? retrievedObject = await UserPreferences().getSignInInfo();
//     userName.value = retrievedObject!.name;
//     email.value = retrievedObject.email;
//     number.value = retrievedObject.phone;
//     bussiness.value = retrievedObject.businessName;
//     profilePic.value = retrievedObject.visitingCardUrl;
//     // gender.value = retrievedObject.city;
//     // referCode!.value = retrievedObject.state;
//     update();
//     state.value = ScreenState.apiSuccess;
//     logcat("referCode::", referCode!.value.toString());
//   }

  void getTimerPopup(BuildContext context) {
    Future.delayed(Duration(seconds: 10), () {
      if (!context.mounted) return;
      getpopup(context,
          isFromProfile: false,
          title: 'No Business Added',
          message:
              'You haven\'t added your business yet. Would you like to add it?',
          function: () {
        Get.to(Updateprofilescreen());
      });
    });
  }
}
