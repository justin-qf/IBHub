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
import 'package:ibh/models/ServiceListModel.dart';
import 'package:ibh/models/categotyModel.dart';
import 'package:ibh/models/sign_in_form_validation.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/log.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

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

  var keywords = <String>[].obs;

  RxBool isFromHomeScreen = false.obs;

  void addKeyword(String keyword) {
    final trimmedKeyword = keyword.trim(); // Trim only leading/trailing spaces
    if (trimmedKeyword.isNotEmpty && !keywords.contains(trimmedKeyword)) {
      keywords.add(trimmedKeyword); // Add the entire keyword as one entry
      keywordsCtr.clear(); // Clear the input field
      validateFields(trimmedKeyword,
          model: keywordsModel,
          errorText1: ServicesScreenConstant.enterKeyword,
          iscomman: true,
          shouldEnableButton: true);
      enableSubmitButton();
      update();
    }
  }

  // Remove keyword from the list
  void removeKeyword(String keyword) {
    keywords.remove(keyword);
    update();
  }

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
    } else if (keywords.isEmpty) {
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
    keywords.clear();

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
    keywords.clear();

    serviceTitleModel.value = ValidationModel(null, null, isValidate: false);
    descriptionModel.value = ValidationModel(null, null, isValidate: false);
    keywordsModel.value = ValidationModel(null, null, isValidate: false);
    categoryModel.value = ValidationModel(null, null, isValidate: false);
    thumbnailModel.value = ValidationModel(null, null, isValidate: false);

    isFormInvalidate.value = false;
    isloading = false;
    imageFile.value = null;
  }

//for edit screen
  ServiceDataList? editServiceItems;
  RxString thumbnail = "".obs;
  RxString service = "".obs;
  RxString description = "".obs;
  RxString categoryEditid = "".obs;
  RxString keyword = "".obs;

  void fillEditData() {
    if (editServiceItems != null) {
      thumbnail.value = editServiceItems!.thumbnail.toString();
      service.value = editServiceItems!.serviceTitle.toString();
      description.value = editServiceItems!.description.toString();
      keyword.value = editServiceItems!.keywords.toString();
      // categoryEditid.value = editServiceItems!.categoryId.toString();
      categoryId.value = editServiceItems!.categoryId.toString();
      thumbnailCtr.text = editServiceItems!.thumbnail.toString();
      serviceTitleCtr.text = editServiceItems!.serviceTitle.toString();
      descriptionCtr.text = editServiceItems!.description.toString();
      keywordsCtr.text = '';
      keywords.clear();
      if (editServiceItems!.keywords.isNotEmpty) {
        try {
          final keywordList = jsonDecode(editServiceItems!.keywords);
          if (keywordList is List) {
            keywords
                .addAll(keywordList.map((e) => e['value'].toString()).toList());
          }
        } catch (e) {
          keywords.addAll(
              editServiceItems!.keywords.split(',').map((e) => e.trim()));
        }
      }
    }
  }

  void getCategory(context, stateID, {isfromHomescreen}) async {
    commonGetApiCallFormate(context,
        title: AddServiceScreenViewConst.category,
        apiEndPoint: ApiUrl.getCategories,
        allowHeader: true, apisLoading: (isTrue) {
      isCategoryApiCallLoading.value = isTrue;

      update();
    }, onResponse: (response) {
      var categoryData = CategoryModel.fromJson(response);
      categoryList.clear();
      categoryFilterList.clear();
      categoryList.addAll(categoryData.data);
      categoryFilterList.addAll(categoryData.data);

      if (isfromHomescreen && categoryId.value.isNotEmpty) {
        final selectedCategory = categoryList.firstWhere(
          (category) => category.id.toString() == categoryId.value,
        );
        // ignore: unnecessary_null_comparison
        if (selectedCategory != null) {
          categoryCtr.text = selectedCategory.name;
          categoryId.value = selectedCategory.id.toString();
        } else {
          categoryId.value = '';
          categoryCtr.text = '';
        }
      }
      update();
    }, networkManager: networkManager);
  }

  Widget setCategoryListDialog({isFromHomeScreen}) {
    return Obx(() {
      if (isCategoryApiCallLoading.value == true) {
        return setDropDownContent(
            [].obs, const Text(AddServiceScreenViewConst.loading),
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
                  // if (isFromHomeScreen == true) {
                  //   categoryEditid.value =
                  //       categoryFilterList[index].id.toString();
                  // } else {
                  categoryId.value = categoryFilterList[index].id.toString();
                  // }

                  categoryCtr.text = categoryFilterList[index].name;
                  if (categoryCtr.text.toString().isNotEmpty) {
                    categoryFilterList.clear();
                    categoryFilterList.addAll(categoryList);
                  }

                  validateFields(categoryCtr.text,
                      model: categoryModel,
                      errorText1: AddServiceScreenViewConst.categoryReq,
                      iscomman: true,
                      shouldEnableButton: true);
                  update();
                },
                title: showSelectedTextInDialog(
                  name: categoryFilterList[index].name,
                  modelId: categoryFilterList[index].id.toString(),
                  storeId: categoryId.value,
                ),
              );
            },
          ),
          searchcontent: getReactiveFormField(
              node: searchCategoryNode,
              controller: searchCategoryCtr,
              hintLabel: AddServiceScreenViewConst.searchHere,
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
          errorText1: AddServiceScreenViewConst.visitingCardReq,
          iscomman: true,
          shouldEnableButton: true);
      update(); // not needed if you're using Obx(), but required for GetBuilder
    } else {
      validateFields("",
          model: thumbnailModel,
          errorText1: AddServiceScreenViewConst.visitingCardReq,
          iscomman: true,
          shouldEnableButton: true);
    }
  }

  void showOptionsCupertinoDialog({required BuildContext context}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: AddServiceScreenViewConst.background,
      barrierColor: black.withOpacity(0.6), // Dark overlay, no blur
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation1, animation2) {
        return Center(
          child: CupertinoAlertDialog(
            title: const Text(AddServiceScreenViewConst.chooseOpt),
            content: const Text(AddServiceScreenViewConst.selectPic,
                style: TextStyle(fontFamily: dM_sans_medium)),
            actions: [
              CupertinoDialogAction(
                child: const Text(AddServiceScreenViewConst.camera,
                    style: TextStyle(color: black)),
                onPressed: () {
                  Navigator.of(context).pop();
                  _pickImage(iscamera: true);
                },
              ),
              CupertinoDialogAction(
                child: const Text(AddServiceScreenViewConst.gallery,
                    style: TextStyle(color: black)),
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

  void updateServiceApi(context) async {
    var loadingIndicator = LoadingProgressDialog();

    try {
      if (networkManager.connectionType.value == 0) {
        loadingIndicator.hide(context);
        showDialogForScreen(context, AddServiceScreenViewConst.serviceScr,
            Connection.noConnection, callback: () {
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

      var response = await Repository.update({
        "service_title": serviceTitleCtr.text.toString().trim(),
        "description": descriptionCtr.text.toString().trim(),
        "keywords":
            jsonEncode(keywords.map((keyword) => {"value": keyword}).toList()),
        "category_id": categoryId.value.toString().trim(),
      }, '${ApiUrl.updateService}${editServiceItems!.id}', allowHeader: true);

      loadingIndicator.hide(context);

      var json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (json['success'] == true) {
          showDialogForScreen(
              context, AddServiceScreenViewConst.serviceScr, json['message'],
              callback: () {
            Get.back(result: true);
          });
        } else {
          showDialogForScreen(
              context, AddServiceScreenViewConst.serviceScr, json['message'],
              callback: () {});
        }
      } else {
        showDialogForScreen(
            context, AddServiceScreenViewConst.serviceScr, json['message'],
            callback: () {});
      }
    } catch (e) {
      logcat("Service Creation Exception", e.toString());
      showDialogForScreen(
          context, AddServiceScreenViewConst.serviceScr, Connection.servererror,
          callback: () {});
      loadingIndicator.hide(context);
    }
  }

  void addUpdateServiceApi(BuildContext context, bool isFromAdd) async {
    var loadingIndicator = LoadingProgressDialog();
    loadingIndicator.show(context, '');

    try {
      if (networkManager.connectionType.value == 0) {
        loadingIndicator.hide(context);
        showDialogForScreen(context, AddServiceScreenViewConst.serviceScr,
            Connection.noConnection, callback: () {
          Get.back();
        });
        return;
      }

      logcat("ServiceParam", {
        "service_title": serviceTitleCtr.text.toString().trim(),
        "description": descriptionCtr.text.toString().trim(),
        "keywords": keywordsCtr.text.toString().trim(),
        "category_id": categoryId.value.toString().trim(),
      });

      var response = await Repository.multiPartPost(
          {
            "service_title": serviceTitleCtr.text.toString().trim(),
            "description": descriptionCtr.text.toString().trim(),
            "keywords": jsonEncode(
                keywords.map((keyword) => {"value": keyword}).toList()),
            "category_id": categoryId.value.toString().trim(),
          },
          isFromAdd == true
              ? ApiUrl.addService
              : '${ApiUrl.updateService}${editServiceItems!.id}',
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
          showDialogForScreen(
              context, AddServiceScreenViewConst.serviceScr, json['message'],
              callback: () {
            Get.back(result: true);
          });
        } else {
          showDialogForScreen(
              context, AddServiceScreenViewConst.serviceScr, json['message'],
              callback: () {});
        }
      } else {
        showDialogForScreen(
            context, AddServiceScreenViewConst.serviceScr, json['message'],
            callback: () {});
      }
    } catch (e) {
      logcat("Service Creation Exception", e.toString());
      showDialogForScreen(
          context, AddServiceScreenViewConst.serviceScr, Connection.servererror,
          callback: () {});
      loadingIndicator.hide(context);
    }
  }

  deleteService(context) async {
    var loadingIndicator = LoadingProgressDialog();

    try {
      if (networkManager.connectionType.value == 0) {
        loadingIndicator.hide(context);
        showDialogForScreen(context, AddServiceScreenViewConst.serviceScr,
            Connection.noConnection, callback: () {
          Get.back();
        });
        return;
      }

      loadingIndicator.show(context, '');
      var response = await Repository.delete(
          '${ApiUrl.deleteService}${editServiceItems!.id}',
          allowHeader: true);

      loadingIndicator.hide(context);
      var result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (result['success'] == true) {
          showDialogForScreen(
              context, AddServiceScreenViewConst.serviceScr, result['message'],
              callback: () {
            Get.back(result: true); // Go back and pass result true
          });
        } else {
          showDialogForScreen(
              context, AddServiceScreenViewConst.serviceScr, result['message'],
              callback: () {});
        }
      } else {
        showDialogForScreen(
            context, AddServiceScreenViewConst.serviceScr, result['message'],
            callback: () {});
      }
    } catch (e) {
      loadingIndicator.hide(context);
      logcat("Delete Service Exception", e.toString());

      void servicerAPI(BuildContext context, bool bool) {}
      showDialogForScreen(
          context, AddServiceScreenViewConst.serviceScr, Connection.servererror,
          callback: () {});
    }
  }
}
