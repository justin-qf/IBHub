// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:science_cafe/api_handle/Repository.dart';
// import 'package:science_cafe/componant/dialogs/dialogs.dart';
// import 'package:science_cafe/componant/dialogs/loading_indicator.dart';
// import 'package:science_cafe/configs/string_constant.dart';
// import 'package:science_cafe/controller/internet_controller.dart';
// import 'package:science_cafe/utils/log.dart';

// commonPostApiCallFormate(context,
//     {String? title,
//     Map<String, dynamic>? body,
//     required Function(Map<String, dynamic>) onResponse,
//     String? apiEndPoint,
//     bool? allowHeader,
//     InternetProvider? networkManager,
//     Function? apisLoading,
//     bool? isModelResponse = false}) async {
//   var loadingIndicator = LoadingProgressDialog();
//   try {
//     if (networkManager!.connectionType == 0) {
//       loadingIndicator.hide(context);
//       showDialogForScreen(context, title!, Connection.noConnection,
//           callback: () {
//         Get.back();
//       });
//       return;
//     }
//     if (apisLoading != null) {
//       apisLoading(true);
//     } else {
//       loadingIndicator.show(context, '');
//     }
//     var response =
//         await Repository.post(body!, apiEndPoint!, allowHeader: allowHeader);
//     if (apisLoading != null) {
//       apisLoading(false);
//     } else {
//       loadingIndicator.hide(context);
//     }
//     // loadingIndicator.hide(context);
//     var data = jsonDecode(response.body);
//     logcat("RESPOSNE", data);
//     if (response.statusCode == 200) {
//       if (data['status'] == true) {
//         if (isModelResponse == true) {
//           onResponse(data);
//         } else {
//           showDialogForScreen(context, title!, data['message'], callback: () {
//             onResponse(data);
//           });
//         }
//       } else {
//         showDialogForScreen(context, title!, data['message'], callback: () {});
//       }
//     } else {
//       showDialogForScreen(context, title!, data['message'].toString(),
//           callback: () {});
//     }
//   } catch (e) {
//     logcat("Exception", e);
//     showDialogForScreen(context, title!, Connection.servererror,
//         callback: () {});
//     if (apisLoading != null) {
//       apisLoading(false);
//     } else {
//       loadingIndicator.hide(context);
//     }
//     // loadingIndicator.hide(context);
//   }
// }

// void commonGetApiCallFormate(context,
//     {String? title,
//     required Function(Map<String, dynamic>) onResponse,
//     String? apiEndPoint,
//     bool? allowHeader,
//     Function? apisLoading,
//     InternetProvider? networkManager,
//     bool? isFromPartyList}) async {
//   apisLoading!(true);
//   try {
//     if (networkManager!.connectionType == 0) {
//       showDialogForScreen(context, title!, Connection.noConnection,
//           callback: () {
//         Get.back();
//       });
//       return;
//     }
//     var response = await Repository.get({}, apiEndPoint!, allowHeader: true);
//     apisLoading(false);
//     var responseData = jsonDecode(response.body);
//     if (response.statusCode == 200) {
//       if (responseData['status'] == true) {
//         onResponse(responseData);
//       } else {
//         showDialogForScreen(context, title!, responseData['message'],
//             callback: () {});
//       }
//     } else {
//       isFromPartyList != true
//           ? showDialogForScreen(context, title!,
//               responseData['message'] ?? Connection.servererror,
//               callback: () {})
//           : Container();
//     }
//   } catch (e) {
//     apisLoading(false);
//     logcat('Exception', e);
//   }
// }
