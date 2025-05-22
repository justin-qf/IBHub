import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/Repository.dart';
import 'package:ibh/api_handle/apiCallingFormate.dart';
import 'package:ibh/componant/dialogs/dialogs.dart';
import 'package:ibh/componant/dialogs/loading_indicator.dart';
import 'package:ibh/componant/input/form_inputs.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/apicall_constant.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/MasterController.dart';
import 'package:ibh/controller/internet_controller.dart';
import 'package:ibh/models/FormFieldModel.dart';
import 'package:ibh/models/ServiceModel.dart';
import 'package:ibh/models/categoryListModel.dart';
import 'package:ibh/models/categotyModel.dart';
import 'package:ibh/models/sign_in_form_validation.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/helper.dart';
import 'package:ibh/utils/log.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:sizer/sizer.dart' as sizer;
import 'package:http/http.dart' as http;

class AddProductScreencontroller extends GetxController {
  final InternetController networkManager = Get.find<InternetController>();

  Rx<ScreenState> state = ScreenState.apiLoading.obs;

  late TextEditingController categoryCtr,
      nameCtr,
      descriptionCtr,
      priceCtr,
      salePriceCtr,
      productImageCtr,
      specificationsCtr,
      unitCtr,
      serviceCtr,
      searchStatectr,
      searchCategoryctr,
      searchServicectr;

  late FocusNode categoryNode,
      nameNode,
      descriptionNode,
      priceNode,
      salePriceNode,
      productImageNode,
      specificationsNode,
      unitNode,
      serviceNode,
      searchStateNode,
      searchCategoryNode,
      searchServiceNode;

  var categoryModel = ValidationModel(null, null, isValidate: false).obs;
  var nameModel = ValidationModel(null, null, isValidate: false).obs;
  var descriptionModel = ValidationModel(null, null, isValidate: false).obs;
  var priceModel = ValidationModel(null, null, isValidate: false).obs;
  var salePriceModel = ValidationModel(null, null, isValidate: false).obs;
  var productImageModel = ValidationModel(null, null, isValidate: false).obs;
  var specificationsModel = ValidationModel(null, null, isValidate: false).obs;
  var unitModel = ValidationModel(null, null, isValidate: false).obs;
  var serviceModel = ValidationModel(null, null, isValidate: false).obs;
  var searchModel = ValidationModel(null, null, isValidate: false).obs;
  var searchCategoryModel = ValidationModel(null, null, isValidate: false).obs;
  // var imageModel = ValidationModel(null, null, isValidate: false).obs;

  RxBool isFormInvalidate = false.obs;

  var isLoading = false.obs;
  bool get isloading => isLoading.value;
  set isloading(bool value) => isLoading.value = value;

  RxBool isStateApiCallLoading = false.obs;
  RxList stateFilterList = [].obs;
  RxString stateId = "".obs;
  RxList stateList = [].obs;

  RxList<CategoryListData> categoryFilterList = <CategoryListData>[].obs;
  RxList<CategoryListData> categoryList = <CategoryListData>[].obs;

  RxList<ServiceData> serviceFilterList = <ServiceData>[].obs;
  RxList<ServiceData> serviceList = <ServiceData>[].obs;
  RxString categoryId = "".obs;
  RxString serviceId = "".obs;

  RxBool isCategoryApiCallLoading = false.obs;
  RxBool isServiceApiCallLoading = false.obs;

  // Rx<File?> imageFile = null.obs;
  RxString imageURl = "".obs;

  RxList<File> uploadMorePrescriptionFile = <File>[].obs;
  RxList<File> uploadMultipleImagePAth = <File>[].obs;

  // var isFeatureSelected = false.obs;
  var featureGroupValue = ''.obs;

  // var isServiceSelected = false.obs;
  var servicGroupvalue = ''.obs;

  List<FormFieldModel> formFields = [];
  RxBool isAddBtnVisibler = false.obs;
  RxBool isRepotyTypeId = false.obs;
  List<bool> showAddMoreButtonList = [];
  final List<String> storeSpecification = <String>[];
  final specificationValidationModels = <Rx<ValidationModel>>[].obs;

  void inti() {
    categoryNode = FocusNode();
    nameNode = FocusNode();
    descriptionNode = FocusNode();
    priceNode = FocusNode();
    salePriceNode = FocusNode();
    productImageNode = FocusNode();
    specificationsNode = FocusNode();
    unitNode = FocusNode();
    serviceNode = FocusNode();
    searchStateNode = FocusNode();
    searchCategoryNode = FocusNode();
    searchServiceNode = FocusNode();
    categoryCtr = TextEditingController();
    nameCtr = TextEditingController();
    descriptionCtr = TextEditingController();
    priceCtr = TextEditingController();
    salePriceCtr = TextEditingController();
    productImageCtr = TextEditingController();
    specificationsCtr = TextEditingController();
    unitCtr = TextEditingController();
    serviceCtr = TextEditingController();
    searchStatectr = TextEditingController();
    searchCategoryctr = TextEditingController();
    searchServicectr = TextEditingController();
  }

  @override
  void onInit() {
    super.onInit();
    inti();
  }

  unfocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void enableSignUpButton() {
    logcat("categoryModel:", categoryModel.value.isValidate.toString());
    logcat("serviceModel:", serviceModel.value.isValidate.toString());
    logcat("nameModel:", nameModel.value.isValidate.toString());
    logcat("descriptionModel:", descriptionModel.value.isValidate.toString());
    logcat("priceModel:", priceModel.value.isValidate.toString());
    logcat("salePriceModel:", salePriceModel.value.isValidate.toString());
    logcat("productImageModel:", productImageModel.value.isValidate.toString());
    logcat("featureGroupValue:", featureGroupValue.value.toString());
    logcat("serviceModel:", servicGroupvalue.value.toString());
    if (productImageModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (nameModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (categoryModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (serviceModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (descriptionModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (priceModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (salePriceModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (featureGroupValue.value == '') {
      isFormInvalidate.value = false;
    } else if (servicGroupvalue.value == '') {
      isFormInvalidate.value = false;
    } else {
      isFormInvalidate.value = true;
    }
    update();
  }

  @override
  void onClose() {
    categoryCtr.clear();
    nameCtr.clear();
    descriptionCtr.clear();
    priceCtr.clear();
    salePriceCtr.clear();
    productImageCtr.clear();
    specificationsCtr.clear();
    unitCtr.clear();
    serviceCtr.clear();
    categoryModel.value = ValidationModel(null, null, isValidate: false);
    nameModel.value = ValidationModel(null, null, isValidate: false);
    descriptionModel.value = ValidationModel(null, null, isValidate: false);
    priceModel.value = ValidationModel(null, null, isValidate: false);
    salePriceModel.value = ValidationModel(null, null, isValidate: false);
    productImageModel.value = ValidationModel(null, null, isValidate: false);
    specificationsModel.value = ValidationModel(null, null, isValidate: false);
    unitModel.value = ValidationModel(null, null, isValidate: false);
    serviceModel.value = ValidationModel(null, null, isValidate: false);
    // Reset reactive variables
    isFormInvalidate.value = false;
    isLoading.value = false;
    super.onClose();
  }

  void resetForm() {
    // Clear text fields
    categoryCtr.clear();
    nameCtr.clear();
    descriptionCtr.clear();
    priceCtr.clear();
    salePriceCtr.clear();
    productImageCtr.clear();
    specificationsCtr.clear();
    unitCtr.clear();
    serviceCtr.clear();
    searchStatectr.clear();
    categoryNode.unfocus();
    nameNode.unfocus();
    descriptionNode.unfocus();
    priceNode.unfocus();
    salePriceNode.unfocus();
    productImageNode.unfocus();
    specificationsNode.unfocus();
    unitNode.unfocus();
    serviceNode.unfocus();
    searchStateNode.unfocus();

    // Reset validation models
    categoryModel.value = ValidationModel(null, null, isValidate: false);
    nameModel.value = ValidationModel(null, null, isValidate: false);
    descriptionModel.value = ValidationModel(null, null, isValidate: false);
    priceModel.value = ValidationModel(null, null, isValidate: false);
    salePriceModel.value = ValidationModel(null, null, isValidate: false);
    productImageModel.value = ValidationModel(null, null, isValidate: false);
    specificationsModel.value = ValidationModel(null, null, isValidate: false);
    unitModel.value = ValidationModel(null, null, isValidate: false);
    serviceModel.value = ValidationModel(null, null, isValidate: false);
    isFormInvalidate.value = false;
    isloading = false;
  }

  validateEmailFields() {
    if (nameCtr.text.isNotEmpty) {
      validateFields(
        nameCtr.text,
        model: nameModel,
        errorText1: "Email is required",
        iscomman: true,
        shouldEnableButton: false,
      );
    }
  }

  validateFields(val,
      {model,
      errorText1,
      errorText2,
      errorText3,
      iscomman = false,
      isselectionfield = false,
      isotp = false,
      isnumber = false,
      ispassword = false,
      isemail = false,
      isconfirmpassword = false,
      confirmpasswordctr,
      isPincode = false,
      shouldEnableButton = true}) {
    return validateField(
        iscomman: iscomman,
        val: val,
        models: model,
        errorText1: errorText1,
        errorText2: errorText2,
        errorText3: errorText3,
        isselectionfield: isselectionfield,
        isotp: isotp,
        isnumber: isnumber,
        ispassword: ispassword,
        isEmail: isemail,
        ispincode: isPincode,
        isconfirmpassword: isconfirmpassword,
        confirmpasswordctr: confirmpasswordctr,
        shouldEnableButton: shouldEnableButton,
        notifyListeners: () {
          update();
        },
        enableBtnFunction: () {
          enableSignUpButton();
        });
  }

  void setReportTypeId(String? val) {
    if (val != null && val.isEmpty) {
      isRepotyTypeId.value = false;
    } else {
      isRepotyTypeId.value = true;
    }
    update();
    // enableAddNewDynamicBtn();
  }

  RxBool isGmailLogin = false.obs;

  void addProduct(context, bool isFromViewHistory) async {
    var loadingIndicator = LoadingProgressDialog();

    try {
      if (networkManager.connectionType.value == 0) {
        loadingIndicator.hide(context);

        showDialogForScreen(
            context, AddProductConstant.title, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }
      loadingIndicator.show(context, '');

      logcat('PassingParam', {
        'category_id': categoryId.value.toString(),
        'services_id': serviceId.value.toString(),
        "name": nameCtr.text.toString().trim(),
        "description": descriptionCtr.text.toString().trim(),
        "price": priceCtr.text.toString().trim(),
        "sale_price": salePriceCtr.text.toString().trim(),
        "is_featured": featureGroupValue.value.isNotEmpty
            ? featureGroupValue.value == "Yes"
                ? "1"
                : "0"
            : '0',
        "status": "1",
        "is_service": servicGroupvalue.value.isNotEmpty
            ? featureGroupValue.value == "Yes"
                ? "1"
                : "0"
            : '0',
        "unit": "hour",
      });
      List<http.MultipartFile> newList = [];

      for (int i = 0; i < uploadMorePrescriptionFile.length; i++) {
        File imageFile = uploadMorePrescriptionFile[i];
        String fileName = imageFile.path.split('/').last;
        int fileSize = imageFile.lengthSync();

        logcat("Image File #$i",
            "Path: ${imageFile.path}, Name: $fileName, Size: $fileSize bytes");

        var multipartFile = http.MultipartFile(
          'images[$i]', // 👈 this is important: gives names like images[0], images[1]
          imageFile.readAsBytes().asStream(),
          imageFile.lengthSync(),
          filename: imageFile.path.split('/').last,
        );

        newList.add(multipartFile);
      }

      Map<String, dynamic> body = {
        'category_id': categoryId.value.toString(),
        'services_id': serviceId.value.toString(),
        "name": nameCtr.text.toString().trim(),
        "description": descriptionCtr.text.toString().trim(),
        "price": priceCtr.text.toString().trim(),
        "sale_price": salePriceCtr.text.toString().trim(),
        "is_featured": featureGroupValue.value.isNotEmpty
            ? featureGroupValue.value == "Yes"
                ? "1"
                : "0"
            : '0',
        "status": "1",
        "is_service": servicGroupvalue.value.isNotEmpty
            ? featureGroupValue.value == "Yes"
                ? "1"
                : "0"
            : '0',
        "unit": "hour",
      };

      // Add dynamic specifications to the body
      for (int i = 0; i < storeSpecification.length; i++) {
        body['specifications[$i]'] = storeSpecification[i];
      }

      var response = await Repository.multiPartPost(
          body.cast<String, String>(), ApiUrl.addProduct,
          multiPartData: newList,
          // multiPartData: isReport.value == true ? newList : null,
          allowHeader: true);
      var responseData = await response.stream.toBytes();
      loadingIndicator.hide(context);

      var result = String.fromCharCodes(responseData);
      var json = jsonDecode(result);
      logcat("productResponse::", jsonEncode(json));
      logcat("statusCode::", response.statusCode.toString());
      if (response.statusCode == 201) {
        if (json['success'] == true) {
          showDialogForScreen(
              context, AddProductConstant.title, json['message'], callback: () {
            Get.back(result: true);
          });
        } else {
          showDialogForScreen(
              context, AddProductConstant.title, json['message'],
              callback: () {});
        }
      } else {
        showDialogForScreen(context, AddProductConstant.title, json['message'],
            callback: () {});
      }
    } catch (e) {
      logcat("Exception", e);
      showDialogForScreen(
          context, AddProductConstant.title, ServerError.servererror,
          callback: () {});
    }
  }

  getCategoryApi(context) async {
    // var loadingIndicator = LoadingProgressDialogs();
    commonPostApiCallFormate(
      context,
      title: AddProductConstant.title,
      apiEndPoint: ApiUrl.getCategories,
      apisLoading: (isTrue) {
        // if (isTrue) {
        //   loadingIndicator.show(context, '');
        // } else {
        //   loadingIndicator.hide(context);
        // }
        isCategoryApiCallLoading.value = isTrue;
        update();
      },
      body: {
        // "category_id": categoryId.trim(),
      },
      onResponse: (response) {
        var data = CategoryModel.fromJson(response);
        categoryList.clear();
        categoryFilterList.clear();
        categoryList.addAll(data.data);
        categoryFilterList.addAll(data.data);
        logcat("CATEGORY_RESPONSE", jsonEncode(categoryFilterList));
        update();
      },
      networkManager: networkManager,
      isModelResponse: true,
    );
  }

  void getServiceApi(context, String categoryId) async {
    commonPostApiCallFormate(
      context,
      title: AddProductConstant.title,
      body: {
        "category_id": categoryId.trim(),
      },
      apiEndPoint: ApiUrl.getServiceDropdownList,
      apisLoading: (isTrue) {
        isServiceApiCallLoading.value = isTrue;
        update();
      },
      onResponse: (data) async {
        var serviceData = ServiceDropdownModel.fromJson(data);
        serviceList.clear();
        serviceFilterList.clear();
        serviceList.addAll(serviceData.data);
        serviceFilterList.addAll(serviceData.data);
        logcat("SERVICE_RESPONSE", jsonEncode(categoryFilterList));
        update();
      },
      networkManager: networkManager,
      isModelResponse: true,
    );
  }

  Widget setCategoryListDialog() {
    return Obx(() {
      if (isCategoryApiCallLoading.value == true) {
        return setDropDownContent(
            [].obs, const Text(SearchScreenConstant.loading),
            isApiIsLoading: isCategoryApiCallLoading.value);
      }
      return setDropDownContent(
          categoryFilterList,
          controller: searchCategoryctr,
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
                      errorText1: AddServiceScreenViewConst.categoryReq,
                      iscomman: true,
                      shouldEnableButton: true);
                  update();
                  futureDelay(() {
                    getServiceApi(context, categoryId.value.toString());
                  }, isOneSecond: false);
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
              controller: searchCategoryctr,
              hintLabel: SearchScreenConstant.hint,
              onChanged: (val) {
                applyCategoryFilter(val.toString());
                update();
              },
              isSearch: true,
              inputType: TextInputType.text,
              errorText: searchCategoryModel.value.error));
    });
  }

  Widget setServiceListDialog() {
    return Obx(() {
      if (isServiceApiCallLoading.value == true) {
        return setDropDownContent(
            [].obs, const Text(SearchScreenConstant.loading),
            isApiIsLoading: isServiceApiCallLoading.value);
      }
      return setDropDownContent(
          serviceFilterList,
          controller: searchCategoryctr,
          ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: serviceFilterList.length,
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
                  serviceId.value = serviceFilterList[index].id.toString();
                  serviceCtr.text = serviceFilterList[index].serviceTitle;
                  if (categoryCtr.text.toString().isNotEmpty) {
                    serviceFilterList.clear();
                    serviceFilterList.addAll(serviceList);
                  }
                  validateFields(serviceCtr.text,
                      model: serviceModel,
                      errorText1: AddProductConstant.serviceHint,
                      iscomman: true,
                      shouldEnableButton: true);
                  update();
                  update();
                },
                title: showSelectedTextInDialog(
                    name: serviceFilterList[index].serviceTitle,
                    modelId: serviceFilterList[index].id.toString(),
                    storeId: categoryId.value),
              );
            },
          ),
          searchcontent: getReactiveFormField(
              node: searchServiceNode,
              controller: searchServicectr,
              hintLabel: SearchScreenConstant.hint,
              onChanged: (val) {
                applyServiceFilter(val.toString());
                update();
              },
              isSearch: true,
              inputType: TextInputType.text,
              errorText: searchCategoryModel.value.error));
    });
  }

  void applyCategoryFilter(String keyword) {
    categoryFilterList.clear();
    for (CategoryListData categoryItem in categoryList) {
      if (categoryItem.name
          .toString()
          .toLowerCase()
          .contains(keyword.toLowerCase())) {
        categoryFilterList.add(categoryItem);
      }
    }
    categoryFilterList.refresh();
    categoryFilterList.call();
    logcat('filterApply', categoryFilterList.length.toString());
    logcat('filterApply', jsonEncode(categoryFilterList));
    update();
  }

  void applyServiceFilter(String keyword) {
    serviceFilterList.clear();
    for (ServiceData serviceItem in serviceList) {
      if (serviceItem.serviceTitle
          .toString()
          .toLowerCase()
          .contains(keyword.toLowerCase())) {
        serviceFilterList.add(serviceItem);
      }
    }
    serviceFilterList.refresh();
    serviceFilterList.call();
    logcat('filterApply', serviceFilterList.length.toString());
    logcat('filterApply', jsonEncode(serviceFilterList));
    update();
  }

  // getImage() {
  //   return Stack(
  //     children: [
  //       Positioned(
  //         left: 0,
  //         right: 0,
  //         child: Container(
  //           width: 12.h,
  //         ),
  //       ),
  //       Container(
  //         height: Device.screenType == sizer.ScreenType.mobile ? 10.h : 10.8.h,
  //         margin: const EdgeInsets.only(right: 10),
  //         width: Device.screenType == sizer.ScreenType.mobile ? 10.h : 10.8.h,
  //         decoration: BoxDecoration(
  //           border: Border.all(color: white, width: 1.w),
  //           borderRadius: BorderRadius.circular(100.w),
  //           boxShadow: [
  //             BoxShadow(
  //               color: black.withOpacity(0.1),
  //               blurRadius: 5.0,
  //             )
  //           ],
  //         ),
  //         child: CircleAvatar(
  //           child: ClipRRect(
  //             borderRadius: BorderRadius.circular(50.0),
  //             child: imageFile.value == null && imageURl.value.isNotEmpty
  //                 ? CachedNetworkImage(
  //                     fit: BoxFit.fitWidth,
  //                     imageUrl: imageURl.value,
  //                     placeholder: (context, url) => const Center(
  //                           child:
  //                               CircularProgressIndicator(color: primaryColor),
  //                         ),
  //                     imageBuilder: (context, imageProvider) => Image.network(
  //                           imageURl.value,
  //                           fit: BoxFit.fitWidth,
  //                         ),
  //                     errorWidget: (context, url, error) => Image.asset(
  //                           Asset.bussinessPlaceholder,
  //                           height: 8.0.h,
  //                           width: 8.0.h,
  //                         ))
  //                 : imageFile.value == null
  //                     ? Image.asset(
  //                         Asset.bussinessPlaceholder,
  //                         height: 8.0.h,
  //                         width: 8.0.h,
  //                       )
  //                     : Image.file(
  //                         imageFile.value!,
  //                         height: Device.screenType == sizer.ScreenType.mobile
  //                             ? 8.0.h
  //                             : 8.5.h,
  //                         width: Device.screenType == sizer.ScreenType.mobile
  //                             ? 8.0.h
  //                             : 8.5.h,
  //                         errorBuilder: (context, error, stackTrace) {
  //                           return Image.asset(
  //                             Asset.bussinessPlaceholder,
  //                             height: 8.0.h,
  //                             width: 8.0.h,
  //                           );
  //                         },
  //                       ),
  //           ),
  //         ),
  //       ),
  //       Positioned(
  //         right: 5,
  //         bottom: 0.5.h,
  //         child: Container(
  //           height: 3.3.h,
  //           width: 3.3.h,
  //           padding: const EdgeInsets.all(5),
  //           alignment: Alignment.center,
  //           decoration: BoxDecoration(
  //             color: primaryColor,
  //             border: Border.all(color: white, width: 0.6.w),
  //             borderRadius: BorderRadius.circular(100.w),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: black.withOpacity(0.1),
  //                 blurRadius: 5.0,
  //               )
  //             ],
  //           ),
  //           child: SvgPicture.asset(
  //             Asset.add,
  //             height: 12.0.h,
  //             width: 15.0.h,
  //             fit: BoxFit.cover,
  //             // ignore: deprecated_member_use
  //             color: white,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // actionClickUploadImageFromCamera(BuildContext context,
  //     {bool? isCamera}) async {
  //   final pickedFile = await ImagePicker().pickImage(
  //     source: isCamera == true ? ImageSource.camera : ImageSource.gallery,
  //     maxWidth: 1080,
  //     maxHeight: 1080,
  //     imageQuality: 100,
  //   );

  //   if (pickedFile != null) {
  //     // Crop the image
  //     final croppedFile = await ImageCropper().cropImage(
  //       sourcePath: pickedFile.path,
  //       maxWidth: 1080,
  //       maxHeight: 1080,
  //       aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
  //       uiSettings: [
  //         if (Platform.isAndroid)
  //           AndroidUiSettings(
  //             toolbarTitle: 'Crop Image',
  //             toolbarColor: primaryColor,
  //             statusBarColor: primaryColor,
  //             backgroundColor: Colors.white,
  //             toolbarWidgetColor: white,
  //             activeControlsWidgetColor: primaryColor,
  //             initAspectRatio: CropAspectRatioPreset.original,
  //             lockAspectRatio: false,
  //           ),
  //         if (Platform.isIOS)
  //           IOSUiSettings(
  //             title: 'Crop Image',
  //             cancelButtonTitle: 'Cancel',
  //             doneButtonTitle: 'Done',
  //             aspectRatioLockEnabled: false,
  //           ),
  //       ],
  //     );

  //     if (croppedFile != null) {
  //       imageFile = File(croppedFile.path).obs;
  //       imageURl.value = croppedFile.path;

  //       validateFields(
  //         croppedFile.path,
  //         model: imageModel,
  //         errorText1: "Profile picture is required",
  //         iscomman: true,
  //         shouldEnableButton: true,
  //       );

  //       imageFile.refresh();
  //       update();
  //     }
  //   }

  //   update();
  // }

  Future<void> selectMultipleImagesFromGallery() async {
    // Clear previous images
    uploadMorePrescriptionFile.clear();
    imageURl.value = ''; // Clear URL if you want

    final pickedFiles = await ImagePicker().pickMultiImage(
      maxWidth: 1080,
      maxHeight: 1080,
      imageQuality: 100,
    );

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      for (var file in pickedFiles) {
        File image = File(file.path);
        uploadMorePrescriptionFile.add(image);

        // Update imageURl with last selected image's path (optional)
        imageURl.value = file.path;

        validateFields(
          file.path,
          model: productImageModel,
          errorText1: "Profile picture is required",
          iscomman: true,
          shouldEnableButton: true,
        );
      }
      update();
    }
  }

  actionClickUploadImageFromCamera(BuildContext context,
      {bool? isCamera}) async {
    if (isCamera == true) {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 100,
      );

      if (pickedFile != null) {
        File file = File(pickedFile.path);
        // imageFile = file.obs;
        imageURl.value = pickedFile.path;

        validateFields(
          pickedFile.path,
          model: productImageModel,
          errorText1: "Profile picture is required",
          iscomman: true,
          shouldEnableButton: true,
        );

        // imageFile.refresh();
        update();
      }
    } else {
      // Clear previous gallery images and camera image
      uploadMorePrescriptionFile.clear();
      // imageFile.value = File('');
      // imageURl.value = '';
      update();

      final pickedFiles = await ImagePicker().pickMultiImage(
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 100,
      );

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        for (var file in pickedFiles) {
          File image = File(file.path);

          uploadMorePrescriptionFile.add(image);

          // Only set imageURl (for validation/UI), not imageFile
          imageURl.value = file.path;

          validateFields(
            file.path,
            model: productImageModel,
            errorText1: "Profile picture is required",
            iscomman: true,
            shouldEnableButton: true,
          );
        }
        update();
      }
    }

    update();
  }

  // actionClickUploadImageFromCamera(BuildContext context,
  //     {bool? isCamera}) async {
  //   if (isCamera == true) {
  //     final pickedFile = await ImagePicker().pickImage(
  //       source: ImageSource.camera,
  //       maxWidth: 1080,
  //       maxHeight: 1080,
  //       imageQuality: 100,
  //     );

  //     if (pickedFile != null) {
  //       await _cropAndSetImage(File(pickedFile.path));
  //     }
  //   } else {
  //     final pickedFiles = await ImagePicker().pickMultiImage(
  //       maxWidth: 1080,
  //       maxHeight: 1080,
  //       imageQuality: 100,
  //     );

  //     if (pickedFiles != null && pickedFiles.isNotEmpty) {
  //       for (final pickedFile in pickedFiles) {
  //         await _cropAndSetImage(File(pickedFile.path));
  //       }
  //     }
  //   }

  //   update();
  // }

  Future<void> _cropAndSetImage(File imageFileInput) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFileInput.path,
      maxWidth: 1080,
      maxHeight: 1080,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        if (Platform.isAndroid)
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: primaryColor,
            statusBarColor: primaryColor,
            backgroundColor: Colors.white,
            toolbarWidgetColor: white,
            activeControlsWidgetColor: primaryColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
        if (Platform.isIOS)
          IOSUiSettings(
            title: 'Crop Image',
            cancelButtonTitle: 'Cancel',
            doneButtonTitle: 'Done',
            aspectRatioLockEnabled: false,
          ),
      ],
    );

    if (croppedFile != null) {
      // Do whatever you need for each image
      // imageFile = File(croppedFile.path).obs;
      imageURl.value = croppedFile.path;

      validateFields(
        croppedFile.path,
        model: productImageModel,
        errorText1: "Profile picture is required",
        iscomman: true,
        shouldEnableButton: true,
      );

      // imageFile.refresh();
      update();
    }
  }

  void updateFeature(String selectedRole) {
    featureGroupValue.value = selectedRole;
    // isFeatureSelected.value = false;

    update();
  }

  void updateService(String selectedRole) {
    servicGroupvalue.value = selectedRole;
    // isServiceSelected.value = false;
    // logcat("isServiceSelected::", isServiceSelected.value.toString());
    logcat("serviceroupvalue::", servicGroupvalue.value.toString());
    update();
  }

  getFeatureRadioButtons() {
    return getRadioButton(
        label: AddProductConstant.featureLabel,
        firstText: AddProductConstant.yesLable,
        secondText: AddProductConstant.noLable,
        groupvalue: featureGroupValue.value,
        // isSelected: isFeatureSelected,
        isrequired: true,
        notifyListeners: () {
          update();
        },
        onChanged: (val) {
          updateFeature(val);
        },
        unfocused: () {
          unfocusAll();
        },
        enableFunction: (val) {
          validateField(
            val: val,
            isselectionfield: true,
            rolegroupvalue: featureGroupValue.value,
            formvalidate: isFormInvalidate.value,
            shouldEnableButton: false,
            notifyListeners: () {
              update();
            },
            enableBtnFunction: () {
              enableSignUpButton();
            },
          );
        });
  }

  getServiceRadioButtons() {
    return getRadioButton(
        label: AddProductConstant.serviceLabel,
        firstText: AddProductConstant.yesLable,
        secondText: AddProductConstant.noLable,
        groupvalue: servicGroupvalue.value,
        // isSelected: isServiceSelected,
        isrequired: true,
        notifyListeners: () {
          update();
        },
        onChanged: (val) {
          updateService(val);
        },
        unfocused: () {
          unfocusAll();
        },
        enableFunction: (val) {
          validateField(
              val: val,
              isselectionfield: true,
              rolegroupvalue: servicGroupvalue.value,
              formvalidate: isFormInvalidate.value,
              shouldEnableButton: false,
              notifyListeners: () {
                update();
              },
              enableBtnFunction: () {
                enableSignUpButton();
              });
        });
  }

  Widget buildImagePreview(File file, VoidCallback onDelete) {
    return Stack(
      children: [
        Container(
            width: 8.h,
            height: 8.h,
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: FileImage(file),
                  fit: BoxFit.cover,
                ))),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: onDelete,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }
}
