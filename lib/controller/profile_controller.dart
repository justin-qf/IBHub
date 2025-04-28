import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/Repository.dart';
import 'package:ibh/api_handle/apiCallingFormate.dart';
import 'package:ibh/componant/dialogs/dialogs.dart';
import 'package:ibh/componant/dialogs/loading_indicator.dart';
import 'package:ibh/configs/apicall_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/models/login_model.dart';
import 'package:ibh/models/pdfModel.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/views/sigin_signup/signinScreen.dart';
import '../../preference/UserPreference.dart';
import '../../utils/log.dart';
import 'internet_controller.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ProfileController extends GetxController {
  final InternetController networkManager = Get.find<InternetController>();

  Rx<ScreenState> states = ScreenState.apiLoading.obs;
  RxString message = "".obs;
  RxString customerId = "".obs;

  RxString userName = "".obs;
  RxString bussiness = "".obs;
  RxString number = "".obs;
  RxString email = "".obs;
  RxString profilePic = "".obs;
  RxString gender = "".obs;
  AnimationController? controllers;
  RxString? referCode = "".obs;

  @override
  void onInit() {
    logcat("test", "DONE");
    super.onInit();
  }

  getProfileData() async {
    states.value = ScreenState.apiLoading;
    User? retrievedObject = await UserPreferences().getSignInInfo();
    userName.value = retrievedObject!.name;
    email.value = retrievedObject.email;
    number.value = retrievedObject.phone;
    bussiness.value = retrievedObject.businessName;
    profilePic.value = retrievedObject.visitingCardUrl;
    // gender.value = retrievedObject.city;
    // referCode!.value = retrievedObject.state;
    update();
    states.value = ScreenState.apiSuccess;
    logcat("referCode::", referCode!.value.toString());
  }

  void getApiProfile(context) async {
    commonGetApiCallFormate(context,
        title: 'Profile',
        apiEndPoint: ApiUrl.profile,
        allowHeader: true, apisLoading: (isTrue) {
      logcat("IsProfile:", isTrue.toString());
      update();
    }, onResponse: (response) {
      var userData = User.fromJson(response);

      profilePic.value = userData.visitingCardUrl;

      print(profilePic.value);

      logcat("Profile", jsonEncode(userData));
      update();
    }, networkManager: networkManager);
  }

  BuildContext? contexts;

  // Function to download PDF and return the file path
  Future<String?> downloadPDF(String url, String fileName) async {
    try {
      // Make HTTP request to download the PDF
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Get the temporary directory
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/$fileName';
        // Write the PDF to a file
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      } else {
        print('Failed to download PDF: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error downloading PDF: $e');
      return null;
    }
  }

  // Function to share PDF to WhatsApp
  Future<void> sharePDF(String filePath) async {
    try {
      // ignore: deprecated_member_use
      await Share.shareXFiles(
        [XFile(filePath)],
        text: 'Check out my profile PDF!',
        subject: 'Profile PDF',
      );
    } catch (e) {
      print('Error sharing PDF: $e');
    }
  }

  RxString pdflink = "".obs;
  RxString pdfname = "".obs;
  void getpdfFromApi(BuildContext context, {theme}) async {
    pdflink.value = '';
    pdfname.value = '';
    try {
      if (networkManager.connectionType.value == 0) {
        showDialogForScreen(context, "Profile", Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }

      // Direct API call (instead of using commonPostApiCallFormate)
      var response = await Repository.post(
        {"theme": theme},
        ApiUrl.pdfDownload,
        allowHeader: true,
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        var responseDetail = PdfData.fromJson(data);

        if (responseDetail.success == true) {
          pdflink.value = responseDetail.data.url;
          pdfname.value = extractPdfNameFromUrl(responseDetail.data.url);
          showDialogForScreen(context, "Profile", data['message'],
              callback: () {
            Get.back();
          });

          states.value = ScreenState.apiSuccess;
          message.value = "";
          update();
        } else {
          states.value = ScreenState.apiError;
          showDialogForScreen(context, "Profile", data['message'],
              callback: () {});
        }
      } else {
        states.value = ScreenState.apiError;
        showDialogForScreen(
            context, "Profile", data['message'] ?? "Server Error",
            callback: () {});
      }
    } catch (e) {
      states.value = ScreenState.apiError;
      showDialogForScreen(context, "Profile", ServerError.retryServererror,
          callback: () {});
      print('Exception in getpdfFromApi: $e');
    }
  }

  String extractPdfNameFromUrl(String url) {
    // Assuming the URL structure is like: http://example.com/indian_business_hub/storage/visiting_card_pdfs/JohnDoe/visiting_card_1.pdf
    Uri uri = Uri.parse(url);
    String path = uri.path;

    // Split the path into segments
    List<String> pathSegments = path.split('/');

    // The PDF name should be the last segment (the filename)
    String pdfFileName = pathSegments.last;

    // Remove the file extension (.pdf)
    String pdfNameWithoutExtension = pdfFileName.replaceAll('.pdf', '');

    // Return the extracted PDF name
    return pdfNameWithoutExtension;
  }

  void logoutApi(context) async {
    var loadingIndicator = LoadingProgressDialog();
    loadingIndicator.show(context, '');
    try {
      if (networkManager.connectionType.value == 0) {
        showDialogForScreen(context, "Profile", Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }

      var response = await Repository.get({}, ApiUrl.logout);
      loadingIndicator.hide(context);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (data['status'] == true) {
          Navigator.pop(context);
          UserPreferences().logout();
          Get.offAll(const Signinscreen());
        } else {
          showDialogForScreen(context, "Profile", data['message'],
              callback: () {
            Get.back();
          });
        }
        states.value = ScreenState.apiSuccess;
        message.value = "";
        update();
      } else {
        states.value = ScreenState.apiError;
        showDialogForScreen(context, "Profile", data['message'],
            callback: () {});
      }
    } catch (e) {
      states.value = ScreenState.apiError;
      showDialogForScreen(context, "Profile", ServerError.retryServererror,
          callback: () {});
    }
  }
}
