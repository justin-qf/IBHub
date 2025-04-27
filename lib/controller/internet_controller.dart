import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ibh/utils/log.dart';

class InternetController extends GetxController {
  var connectivityResult = ConnectivityResult.none.obs;
  var connectionType = 0.obs;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription _streamSubscription;
  Function? statusChange;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _streamSubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        _updateState(
            results.isNotEmpty ? results.first : ConnectivityResult.none);
      },
    );
  }

  void setStatusCallback(Function? fun) {
    statusChange = fun;
  }

  Future<void> _initConnectivity() async {
    try {
      List<ConnectivityResult> results =
          await _connectivity.checkConnectivity();
      connectivityResult.value =
          results.isNotEmpty ? results.first : ConnectivityResult.none;
      logcat("Result", connectivityResult.value.toString());
    } on PlatformException catch (e) {
      logcat("EXCEPTION:", e);
    }
  }

  void _updateState(ConnectivityResult result) {
    connectivityResult.value = result;
    switch (result) {
      case ConnectivityResult.wifi:
        connectionType.value = 1;
        break;
      case ConnectivityResult.mobile:
        connectionType.value = 2;
        break;
      case ConnectivityResult.ethernet:
        connectionType.value = 3;
        break;
      case ConnectivityResult.none:
        connectionType.value = 0;
        break;
      default:
        break;
    }
    statusChange?.call();
    logcat("Network::", connectionType.value.toString());
  }

  @override
  void onClose() {
    _streamSubscription.cancel();
    super.onClose();
  }
}