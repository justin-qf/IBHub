import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/models/login_model.dart';
import 'package:ibh/preference/UserPreference.dart';
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

  RxString address = "".obs;
  RxString city = "".obs;
  RxString states = "".obs;
  RxString pincode = "".obs;
  RxString visitingCardUrl = "".obs;

  getProfileData() async {
    state.value = ScreenState.apiLoading;
    User? retrievedObject = await UserPreferences().getSignInInfo();
    address.value = retrievedObject!.address;
    city.value = retrievedObject.city.toString();
    states.value = retrievedObject.state.toString();
    pincode.value = retrievedObject.pincode.toString();
    visitingCardUrl.value = retrievedObject.visitingCardUrl;
    update();
    state.value = ScreenState.apiSuccess;
  }

  void getTimerPopup(BuildContext context) {
    Future.delayed(const Duration(seconds: 10), () {
      if (!context.mounted) return;
      // Check if ANY of the fields are empty
      if (address.value.isEmpty ||
          city.value.isEmpty ||
          states.value.isEmpty ||
          pincode.value.isEmpty ||
          visitingCardUrl.value.isEmpty) {
        // showBottomSheetPopup(context);
      }
    });
  }
}
