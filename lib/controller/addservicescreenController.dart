import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/Repository.dart';
import 'package:ibh/api_handle/apiCallingFormate.dart';
import 'package:ibh/componant/dialogs/dialogs.dart';
import 'package:ibh/componant/dialogs/loading_indicator.dart';
import 'package:ibh/configs/apicall_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/MasterController.dart';
import 'package:ibh/controller/internet_controller.dart';
import 'package:ibh/models/sign_in_form_validation.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/log.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class AddServicescreencontroller extends GetxController {
  final InternetController networkManager = Get.find<InternetController>();

  Rx<ScreenState> state = ScreenState.apiLoading.obs;

  late FocusNode serviceTitleNode,
      descriptionNode,
      keywordsNode,
      categoryNode,
      thumbnailNode;
  late TextEditingController serviceTitleCtr,
      descriptionCtr,
      keywordsCtr,
      categoryCtr,
      thumbnailCtr;

  var serviceTitleModel = ValidationModel(null, null, isValidate: false).obs;
  var descriptionModel = ValidationModel(null, null, isValidate: false).obs;
  var keywordsModel = ValidationModel(null, null, isValidate: false).obs;
  var categoryModel = ValidationModel(null, null, isValidate: false).obs;
  var thumbnailModel = ValidationModel(null, null, isValidate: false).obs;

  RxBool isFormInvalidate = false.obs;
  var isLoading = false.obs;
  bool get isloading => isLoading.value;
  set isloading(bool value) => isLoading.value = value;

  void init() {
    serviceTitleNode = FocusNode();
    descriptionNode = FocusNode();
    keywordsNode = FocusNode();
    categoryNode = FocusNode();
    thumbnailNode = FocusNode();

    serviceTitleCtr = TextEditingController();
    descriptionCtr = TextEditingController();
    keywordsCtr = TextEditingController();
    categoryCtr = TextEditingController();
    thumbnailCtr = TextEditingController();
  }

  @override
  void onInit() {
    super.onInit();
    init();
  }

  void unfocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void enableSubmitButton() {
    if (serviceTitleModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (descriptionModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (keywordsModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (categoryModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (thumbnailModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else {
      isFormInvalidate.value = true;
    }
    update();
  }

  @override
  void onClose() {
    serviceTitleCtr.clear();
    descriptionCtr.clear();
    keywordsCtr.clear();
    categoryCtr.clear();
    thumbnailCtr.clear();

    serviceTitleNode.unfocus();
    descriptionNode.unfocus();
    keywordsNode.unfocus();
    categoryNode.unfocus();
    thumbnailNode.unfocus();

    serviceTitleModel.value = ValidationModel(null, null, isValidate: false);
    descriptionModel.value = ValidationModel(null, null, isValidate: false);
    keywordsModel.value = ValidationModel(null, null, isValidate: false);
    categoryModel.value = ValidationModel(null, null, isValidate: false);
    thumbnailModel.value = ValidationModel(null, null, isValidate: false);

    isFormInvalidate.value = false;
    isLoading.value = false;
    imageFile.value = null;

    super.onClose();
  }

  void resetForm() {
    serviceTitleCtr.clear();
    descriptionCtr.clear();
    keywordsCtr.clear();
    categoryCtr.clear();
    thumbnailCtr.clear();

    serviceTitleNode.unfocus();
    descriptionNode.unfocus();
    keywordsNode.unfocus();
    categoryNode.unfocus();
    thumbnailNode.unfocus();

    serviceTitleModel.value = ValidationModel(null, null, isValidate: false);
    descriptionModel.value = ValidationModel(null, null, isValidate: false);
    keywordsModel.value = ValidationModel(null, null, isValidate: false);
    categoryModel.value = ValidationModel(null, null, isValidate: false);
    thumbnailModel.value = ValidationModel(null, null, isValidate: false);
    thumbnailModel.value = ValidationModel(null, null, isValidate: false);

    isFormInvalidate.value = false;
    isloading = false;
    imageFile.value = null;
  }

  validateFields(val,
      {model,
      errorText1,
      errorText2,
      errorText3,
      iscomman = false,
      isselectionfield = false,
      isnumber = false,
      shouldEnableButton = true}) {
    return validateField(
        iscomman: iscomman,
        val: val,
        models: model,
        errorText1: errorText1,
        errorText2: errorText2,
        errorText3: errorText3,
        isselectionfield: isselectionfield,
        isnumber: isnumber,
        shouldEnableButton: shouldEnableButton,
        notifyListeners: () {
          update();
        },
        enableBtnFunction: () {
          enableSubmitButton();
        });
  }

  final ImagePicker _picker = ImagePicker();
  Rx<File?> imageFile = null.obs;

  // String imagePath = "";

  Future<void> _pickImage({bool iscamera = false}) async {
    final XFile? image = await _picker.pickImage(
      source: iscamera ? ImageSource.camera : ImageSource.gallery,
    );

    if (image != null) {
      print('Picked Image Path: ${image.path}');
      // imagePath = image.path;
      imageFile = File(image.path).obs;
      final String fileName = path.basename(image.path);
      thumbnailCtr.text = fileName;
      validateFields(fileName,
          model: thumbnailModel,
          errorText1: "Visiting card is required",
          iscomman: true,
          shouldEnableButton: true);
      update(); // not needed if you're using Obx(), but required for GetBuilder
    } else {
      validateFields("",
          model: thumbnailModel,
          errorText1: "Visiting card is required",
          iscomman: true,
          shouldEnableButton: true);
      print('No image selected');
    }
  }

  void showOptionsCupertinoDialog({required BuildContext context}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Background",
      barrierColor: black.withOpacity(0.6), // Dark overlay, no blur
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (context, animation1, animation2) {
        return Center(
          child: CupertinoAlertDialog(
            title: Text('Choose an Option'),
            content: Text(
              'Select how you want to add the picture.',
              style: TextStyle(fontFamily: dM_sans_medium),
            ),
            actions: [
              CupertinoDialogAction(
                child: Text('Camera', style: TextStyle(color: black)),
                onPressed: () {
                  Navigator.of(context).pop();
                  _pickImage(iscamera: true);
                },
              ),
              CupertinoDialogAction(
                child: Text('Gallery', style: TextStyle(color: black)),
                onPressed: () {
                  Navigator.of(context).pop();
                  _pickImage(iscamera: false);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  void submitServiceAPI(context) async {
    var loadingIndicator = LoadingProgressDialog();

    try {
      if (networkManager.connectionType == 0) {
        loadingIndicator.hide(context);
        showDialogForScreen(context, "Service Screen", Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }
      loadingIndicator.show(context, '');

      logcat("ServiceParam", {
        "service_title": serviceTitleCtr.text.toString().trim(),
        "description": descriptionCtr.text.toString().trim(),
        "keywords": keywordsCtr.text.toString().trim(),
        "category_id": categoryCtr.text.toString().trim(),
      });

      var response = await Repository.multiPartPost({
        "service_title": serviceTitleCtr.text.toString().trim(),
        "description": descriptionCtr.text.toString().trim(),
        "keywords": keywordsCtr.text.toString().trim(),
        "category_id": categoryCtr.text.toString().trim(),
      }, ApiUrl.createservice,
          multiPart: imageFile.value != null &&
                  imageFile.value.toString().isNotEmpty
              ? http.MultipartFile(
                  'thumbnail',
                  imageFile.value!.readAsBytes().asStream(),
                  imageFile.value!.lengthSync(),
                  filename: imageFile.value!.path.split('/').last,
                )
              : null,
          allowHeader: true);

      var responseData = await response.stream.toBytes();
      loadingIndicator.hide(context);

      var result = String.fromCharCodes(responseData);
      var json = jsonDecode(result);

      if (response.statusCode == 200) {
        if (json['success'] == true) {
          logcat('Service Creation', 'Service created successfully');
          logcat('Response JSON', JsonEncoder.withIndent('  ').convert(json));

          showDialogForScreen(context, "Service Screen", json['message'],
              callback: () {
            resetForm();
            Get.back(result: true);
          });
        } else {
          showDialogForScreen(context, "Service Screen", json['message'],
              callback: () {});
        }
      } else {
        showDialogForScreen(context, "Service Screen", json['message'],
            callback: () {});
      }
    } catch (e) {
      logcat("Service Creation Exception", e.toString());
      showDialogForScreen(context, "Service Screen", Connection.servererror,
          callback: () {});
      loadingIndicator.hide(context);
    }
  }
}
