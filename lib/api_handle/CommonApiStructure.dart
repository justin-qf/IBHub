import 'dart:convert';
import 'package:get/get.dart';
import 'package:ibh/api_handle/Repository.dart';
import 'package:ibh/componant/dialogs/dialogs.dart';
import 'package:ibh/componant/dialogs/loading_indicator.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/apicall_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/internet_controller.dart';
import 'package:ibh/controller/serviceDetailController.dart';
import 'package:ibh/models/login_model.dart';
import 'package:ibh/preference/UserPreference.dart';
import 'package:ibh/utils/log.dart';

void addFavouriteAPI(context, InternetController networkManager,
    String businessId, String screenName,
    {bool? isFromList,
    // CommonProductList? item,
    Function? onClick,
    RxList? favouriteFilterList}) async {
  var loadingIndicator = LoadingProgressDialogs();
  loadingIndicator.show(context, '');
  try {
    if (networkManager.connectionType.value == 0) {
      loadingIndicator.hide(context);
      showDialogForScreen(context, screenName, Connection.noConnection,
          callback: () {
        Get.back();
      });
      return;
    }
    User? getUserData = await UserPreferences().getSignInInfo();
    logcat('favParam', {
      "business_id": businessId.toString().trim(),
    });

    var response = await Repository.post({
      "business_id": businessId.toString().trim(),
    }, ApiUrl.addToFav, allowHeader: true);
    loadingIndicator.hide(context);
    var data = jsonDecode(response.body);
    logcat("tag", data);
    if (response.statusCode == 200) {
      // onClick!(true);
      if (data['success'] == true) {
        Get.find<ServiceDetailScreenController>().getIsProductAddToFav(true);
        showCustomToast(context, data['message'].toString());
        // if (data['message'].toString() == 'Product added to favorites.!') {
        //   Get.find<ServiceDetailScreenController>().getIsProductAddToFav(true);
        // } else {
        //   Get.find<ServiceDetailScreenController>().getIsProductAddToFav(false);
        // }
      } else {
        showCustomToast(context, data['message'].toString());
      }
    } else {
      showDialogForScreen(context, screenName, data['message'] ?? "",
          callback: () {});
      loadingIndicator.hide(context);
    }
  } catch (e) {
    logcat("Exception", e);
    showDialogForScreen(context, screenName, ServerError.servererror,
        callback: () {});
  } finally {
    loadingIndicator.hide(context);
  }
}

void removeFavouriteAPI(context, InternetController networkManager,
    String businessId, String screenName,
    {bool? isFromList,
    // CommonProductList? item,
    Function? onClick,
    RxList? favouriteFilterList}) async {
  var loadingIndicator = LoadingProgressDialogs();
  loadingIndicator.show(context, '');
  try {
    if (networkManager.connectionType.value == 0) {
      loadingIndicator.hide(context);
      showDialogForScreen(context, screenName, Connection.noConnection,
          callback: () {
        Get.back();
      });
      return;
    }
    User? getUserData = await UserPreferences().getSignInInfo();
    logcat('favParam', {
      "business_id": businessId.toString().trim(),
    });

    print('BusinessId + ${businessId}');
    var response = await Repository.delete('${ApiUrl.removeToFav}/$businessId',
        allowHeader: true);
    loadingIndicator.hide(context);
    var data = jsonDecode(response.body);
    logcat("tag", data);
    logcat("statusCode::", response.statusCode.toString());
    if (response.statusCode == 200) {
      if (data['success'] == true) {
        showCustomToast(context, data['message'].toString());
        if (onClick != null) {
          onClick();
        } else {
          Get.find<ServiceDetailScreenController>().getIsProductAddToFav(false);
        }
      } else {
        showCustomToast(context, data['message'].toString());
      }
    } else {
      logcat("message", data['message'].toString());
      showDialogForScreen(context, screenName, data['message'] ?? "",
          callback: () {});
      loadingIndicator.hide(context);
    }
  } catch (e) {
    logcat("Exception", e);
    showDialogForScreen(context, screenName, ServerError.servererror,
        callback: () {});
  } finally {
    loadingIndicator.hide(context);
  }
}
