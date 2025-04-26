import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/Repository.dart';
import 'package:ibh/api_handle/apiCallingFormate.dart';
import 'package:ibh/componant/dialogs/dialogs.dart';
import 'package:ibh/componant/dialogs/loading_indicator.dart';
import 'package:ibh/componant/input/form_inputs.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/apicall_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/MasterController.dart';
import 'package:ibh/controller/internet_controller.dart';
import 'package:ibh/models/categotyModel.dart';
import 'package:ibh/models/sign_in_form_validation.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/log.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
// import 'package:sizer/sizer.dart';

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

  late TextEditingController searchCategoryCtr;
  late FocusNode searchCategoryNode;
  var searchCategoryModel = ValidationModel(null, null, isValidate: false).obs;

  RxBool isCategoryApiCallLoading = false.obs;
  RxList<CategoryData> categoryFilterList = <CategoryData>[].obs;
  RxList<CategoryData> categoryList = <CategoryData>[].obs;

  RxString categoryId = "".obs;

  void init() {
    serviceTitleNode = FocusNode();
    descriptionNode = FocusNode();
    keywordsNode = FocusNode();
    categoryNode = FocusNode();
    thumbnailNode = FocusNode();
    searchCategoryNode = FocusNode();

    serviceTitleCtr = TextEditingController();
    descriptionCtr = TextEditingController();
    keywordsCtr = TextEditingController();
    categoryCtr = TextEditingController();
    thumbnailCtr = TextEditingController();
    searchCategoryCtr = TextEditingController();
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
    searchCategoryCtr.clear();

    serviceTitleNode.unfocus();
    descriptionNode.unfocus();
    keywordsNode.unfocus();
    categoryNode.unfocus();
    thumbnailNode.unfocus();
    searchCategoryNode.unfocus();

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
    searchCategoryCtr.clear();

    serviceTitleNode.unfocus();
    descriptionNode.unfocus();
    keywordsNode.unfocus();
    categoryNode.unfocus();
    thumbnailNode.unfocus();
    searchCategoryNode.unfocus();

    serviceTitleModel.value = ValidationModel(null, null, isValidate: false);
    descriptionModel.value = ValidationModel(null, null, isValidate: false);
    keywordsModel.value = ValidationModel(null, null, isValidate: false);
    categoryModel.value = ValidationModel(null, null, isValidate: false);
    thumbnailModel.value = ValidationModel(null, null, isValidate: false);

    isFormInvalidate.value = false;
    isloading = false;
    imageFile.value = null;
  }

  void getCategory(context, stateID) async {
    commonGetApiCallFormate(context,
        title: 'Category',
        apiEndPoint: ApiUrl.getCategories,
        allowHeader: true, apisLoading: (isTrue) {
      isCategoryApiCallLoading.value = isTrue;
      logcat("isCityList:", isTrue.toString());
      update();
    }, onResponse: (response) {
      var categoryData = CategoryModel.fromJson(response);
      categoryList.clear();
      categoryFilterList.clear();
      categoryList.addAll(categoryData.data);
      categoryFilterList.addAll(categoryData.data);
      // for (StateDataList stateList in stateFilterList) {
      //   if (stateID == stateList.id) {
      //     statectr.text = stateList.name.capitalize.toString();
      //     stateId.value = stateList.id.toString();
      //     validateState(statectr.text);
      //   }
      // }
      logcat("CATEGORY_RESPONSE", jsonEncode(categoryFilterList));
      update();
    }, networkManager: networkManager);
  }

  Widget setCategoryListDialog() {
    return Obx(() {
      if (isCategoryApiCallLoading.value == true) {
        return setDropDownContent([].obs, const Text("Loading"),
            isApiIsLoading: isCategoryApiCallLoading.value);
      }
      return setDropDownContent(
          categoryFilterList,
          ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: categoryFilterList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                dense: true,
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                contentPadding:
                    const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
                horizontalTitleGap: null,
                minLeadingWidth: 5,
                onTap: () async {
                  Get.back();
                  categoryId.value = categoryFilterList[index].id.toString();
                  categoryCtr.text = categoryFilterList[index].name;
                  if (categoryCtr.text.toString().isNotEmpty) {
                    categoryFilterList.clear();
                    categoryFilterList.addAll(categoryList);
                  }

                  validateFields(categoryCtr.text,
                      model: categoryModel,
                      errorText1: "Category is required",
                      iscomman: true,
                      shouldEnableButton: true);
                  update();
                },
                title: showSelectedTextInDialog(
                    name: categoryFilterList[index].name,
                    modelId: categoryFilterList[index].id.toString(),
                    storeId: categoryId.value),
              );
            },
          ),
          searchcontent: getReactiveFormField(
              node: searchCategoryNode,
              controller: searchCategoryCtr,
              hintLabel: "Search Here",
              onChanged: (val) {
                applyFilter(val.toString());
                update();
              },
              isSearch: true,
              inputType: TextInputType.text,
              errorText: searchCategoryModel.value.error));
    });
  }

  void applyFilter(String keyword) {
    categoryFilterList.clear();
    for (CategoryData categoryList in categoryList) {
      if (categoryList.name
          .toString()
          .toLowerCase()
          .contains(keyword.toLowerCase())) {
        categoryFilterList.add(categoryList);
      }
    }
    categoryFilterList.refresh();
    categoryFilterList.call();
    logcat('filterApply', categoryFilterList.length.toString());

    update();
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

  Future<void> _pickImage({bool iscamera = false}) async {
    final XFile? image = await _picker.pickImage(
      source: iscamera ? ImageSource.camera : ImageSource.gallery,
    );

    if (image != null) {
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
    }
  }

  void showOptionsCupertinoDialog({required BuildContext context}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Background",
      barrierColor: black.withOpacity(0.6), // Dark overlay, no blur
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation1, animation2) {
        return Center(
          child: CupertinoAlertDialog(
            title: const Text('Choose an Option'),
            content: const Text('Select how you want to add the picture.',
                style: TextStyle(fontFamily: dM_sans_medium)),
            actions: [
              CupertinoDialogAction(
                child: const Text('Camera', style: TextStyle(color: black)),
                onPressed: () {
                  Navigator.of(context).pop();
                  _pickImage(iscamera: true);
                },
              ),
              CupertinoDialogAction(
                child: const Text('Gallery', style: TextStyle(color: black)),
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

  void addServiceApi(context) async {
    var loadingIndicator = LoadingProgressDialog();

    try {
      if (networkManager.connectionType.value == 0) {
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
        "category_id": categoryId.value.toString().trim(),
      });

      var response = await Repository.multiPartPost({
        "service_title": serviceTitleCtr.text.toString().trim(),
        "description": descriptionCtr.text.toString().trim(),
        "keywords": keywordsCtr.text.toString().trim(),
        "category_id": categoryId.value.toString().trim(),
      }, ApiUrl.addService,
          multiPart:
              imageFile.value != null && imageFile.value.toString().isNotEmpty
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
          showDialogForScreen(context, "Service Screen", json['message'],
              callback: () {
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
