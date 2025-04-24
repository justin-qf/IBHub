import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
}
