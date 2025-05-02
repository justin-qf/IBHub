import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ibh/api_handle/Repository.dart';
import 'package:ibh/api_handle/apiCallingFormate.dart';
import 'package:ibh/componant/button/form_button.dart';
import 'package:ibh/componant/dialogs/dialogs.dart';
import 'package:ibh/componant/dialogs/loading_indicator.dart';
import 'package:ibh/componant/input/form_inputs.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/apicall_constant.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/models/businessListModel.dart';
import 'package:ibh/models/categoryListModel.dart';
import 'package:ibh/models/categotyModel.dart';
import 'package:ibh/models/cityModel.dart';
import 'package:ibh/models/sign_in_form_validation.dart';
import 'package:ibh/models/stateModel.dart';
import 'package:ibh/utils/helper.dart';
import 'package:ibh/utils/log.dart';
import 'package:ibh/views/mainscreen/ServiceScreen/BusinessDetailScreen.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sizer/sizer.dart' as sizer;
import 'package:sizer/sizer.dart';
import '../utils/enum.dart';
import 'internet_controller.dart';

class SearchScreenController extends GetxController {
  RxInt currentTreeView = 2.obs;
  // Rx<ScreenState> state = ScreenState.apiLoading.obs;
  Rx<ScreenState> state = ScreenState.apiSuccess.obs;
  RxString message = "".obs;
  final InternetController networkManager = Get.find<InternetController>();
  var pageController = PageController();
  var currentPage = 0;
  late TextEditingController searchCtr = TextEditingController();
  bool isSearch = false;
  late FocusNode stateNode, cityNode, categoryNode;
  late TextEditingController statectr, cityctr, categoryCtr;
  var stateModel = ValidationModel(null, null, isValidate: false).obs;
  var cityModel = ValidationModel(null, null, isValidate: false).obs;
  var categoryModel = ValidationModel(null, null, isValidate: false).obs;

  late TextEditingController searchctr;
  late FocusNode searchNode;
  var searchModel = ValidationModel(null, null, isValidate: false).obs;

  late TextEditingController searchCityctr;
  late FocusNode searchCityNode;
  var searchCityModel = ValidationModel(null, null, isValidate: false).obs;

  late TextEditingController searchCategoryctr;
  late FocusNode searchCategoryNode;
  var searchCategoryModel = ValidationModel(null, null, isValidate: false).obs;

  RxList<StateListData> stateFilterList = <StateListData>[].obs;
  RxList<StateListData> stateList = <StateListData>[].obs;
  RxList<CityListData> cityList = <CityListData>[].obs;
  RxList<CityListData> cityFilterList = <CityListData>[].obs;
  RxList<CategoryListData> categoryList = <CategoryListData>[].obs;
  RxList<CategoryListData> categoryFilterList = <CategoryListData>[].obs;

  RxBool isCityApiCallLoading = false.obs;
  RxBool isStateApiCallLoading = false.obs;
  RxBool isCategoryApiCallLoading = false.obs;

  RxString cityId = "".obs;
  RxString stateId = "".obs;
  RxString categoryId = "".obs;
  RxBool isFormInvalidate = true.obs;

  RxString nextPageURL = "".obs;
  bool isFetchingMore = false;

  final ScrollController scrollController = ScrollController();

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void onInit() {
    stateNode = FocusNode();
    cityNode = FocusNode();
    categoryNode = FocusNode();
    searchNode = FocusNode();
    searchCityNode = FocusNode();
    searchCategoryNode = FocusNode();

    statectr = TextEditingController();
    cityctr = TextEditingController();
    categoryCtr = TextEditingController();
    searchctr = TextEditingController();
    searchCityctr = TextEditingController();
    searchCategoryctr = TextEditingController();
    super.onInit();
  }

  final RxString searchQuery = ''.obs; // For storing the search query

  void setSearchQuery(String query) {
    searchQuery.value = query;
    update();
  }

  void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  RxList searchList = [].obs;

  Widget getText(title, TextStyle? style) {
    return Padding(
      padding: EdgeInsets.only(left: 0.5.w, right: 0.5.w),
      child: Text(
        title,
        maxLines: 2,
        style: style,
      ),
    );
  }

  RxBool isFilterApplied = false.obs;

  Future showBottomSheetDialog(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
        ),
      ),
      constraints: BoxConstraints(maxWidth: Device.width),
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30.0),
          ),
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                color: white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getFilterHeader(context, true),
                    getLable(SearchScreenConstant.stateLabel,
                        isFromRetailer: true),
                    Container(
                      margin: EdgeInsets.only(left: 9.w, right: 9.w),
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: Obx(() {
                          return getReactiveFormField(
                              node: stateNode,
                              controller: statectr,
                              hintLabel: SearchScreenConstant.selectStateHint,
                              onChanged: (val) {
                                isFilterApplied.value =
                                    statectr.text.isNotEmpty ||
                                        cityctr.text.isNotEmpty ||
                                        categoryCtr.text.isNotEmpty;
                              },
                              onTap: () {
                                searchctr.text = "";
                                showDropdownMessage(
                                    context,
                                    setStateListDialog(),
                                    isShowLoading: stateFilterList,
                                    SearchScreenConstant.stateList,
                                    onClick: () {
                                  applyFilter('');
                                }, refreshClick: () {
                                  searchctr.text = "";
                                  futureDelay(() {
                                    getStateApi(context, "");
                                  }, isOneSecond: false);
                                });
                              },
                              isReadOnly: true,
                              wantSuffix: true,
                              isdown: true,
                              isEnable: true,
                              inputType: TextInputType.none,
                              errorText: stateModel.value.error);
                        }),
                      ),
                    ),
                    getDynamicSizedBox(height: 1.h),
                    getLable(SearchScreenConstant.cityLabel,
                        isFromRetailer: true),
                    Container(
                      margin: EdgeInsets.only(left: 9.w, right: 9.w),
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: Obx(() {
                          return getReactiveFormField(
                              node: cityNode,
                              controller: cityctr,
                              hintLabel: SearchScreenConstant.selectCityHint,
                              onChanged: (val) {},
                              onTap: () {
                                searchCityctr.text = "";
                                if (statectr.text.toString().isEmpty) {
                                  showDialogForScreen(
                                      context,
                                      SearchScreenConstant.stateLabel,
                                      SearchScreenConstant.pleaseSelectState,
                                      callback: () {});
                                } else {
                                  showDropdownMessage(
                                      context,
                                      setCityListDialog(),
                                      SearchScreenConstant.cityList,
                                      isShowLoading: cityFilterList,
                                      onClick: () {
                                    applyFilterforCity('');
                                  }, refreshClick: () {
                                    searchCityctr.text = "";
                                    futureDelay(() {
                                      getCityApi(context,
                                          stateId.value.toString(), false);
                                    }, isOneSecond: false);
                                  });
                                }
                              },
                              isReadOnly: true,
                              wantSuffix: true,
                              isdown: true,
                              isEnable: true,
                              inputType: TextInputType.none,
                              errorText: cityModel.value.error);
                        }),
                      ),
                    ),
                    getDynamicSizedBox(height: 1.h),
                    getLable(SearchScreenConstant.categoryLabel,
                        isFromRetailer: true),
                    Container(
                      margin: EdgeInsets.only(left: 9.w, right: 9.w),
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: Obx(() {
                          return getReactiveFormField(
                              node: categoryNode,
                              controller: categoryCtr,
                              hintLabel:
                                  SearchScreenConstant.selectCategoryHint,
                              onChanged: (val) {},
                              onTap: () {
                                searchCategoryctr.text = "";
                                showDropdownMessage(
                                    context,
                                    setCategoryListDialog(),
                                    SearchScreenConstant.categoryList,
                                    isShowLoading: categoryFilterList,
                                    onClick: () {
                                  applyCategoryFilter('');
                                }, refreshClick: () {
                                  searchCategoryctr.text = "";
                                  futureDelay(() {
                                    getCategoryApi(context);
                                  }, isOneSecond: false);
                                });
                              },
                              isReadOnly: true,
                              wantSuffix: true,
                              isdown: true,
                              isEnable: true,
                              inputType: TextInputType.none,
                              errorText: cityModel.value.error);
                        }),
                      ),
                    ),
                    getDynamicSizedBox(height: 2.h),
                    Obx(() {
                      return Padding(
                        padding: EdgeInsets.only(left: 8.w, right: 8.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 40.w,
                              child: getFormButton(context, () {
                                if (isFormInvalidate.value == true) {
                                  Navigator.pop(context);
                                  currentPage = 1;
                                  futureDelay(() {
                                    getBusinessList(context, currentPage, false,
                                        categoryId: categoryId.value,
                                        cityId: cityId.value,
                                        stateId: stateId.value,
                                        isFirstTime: true);
                                  }, isOneSecond: false);
                                }
                              }, Button.apply,
                                  validate: isFormInvalidate.value),
                              // validate: isFormInvalidate.value),
                            ),
                            SizedBox(width: 2.w),
                            SizedBox(
                              width: 40.w,
                              child: getFormButton(context, () {
                                Navigator.pop(context);
                                currentPage = 1;
                                cityFilterList.clear();
                                isFormInvalidate.value = true;
                                cityId.value = "";
                                stateId.value = "";
                                statectr.text = "";
                                cityctr.text = "";
                                categoryCtr.text = "";
                                categoryId.value = "";
                                isFilterApplied.value = false;
                                futureDelay(() {
                                  getBusinessList(context, currentPage, false,
                                      isFirstTime: true);
                                }, isOneSecond: false);
                              }, Button.clear, validate: true),
                            )
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget setStateListDialog() {
    return Obx(() {
      if (isStateApiCallLoading.value == true) {
        return setDropDownContent(
            [].obs, const Text(SearchScreenConstant.loading),
            isApiIsLoading: isStateApiCallLoading.value);
      }
      return setDropDownContent(
          stateFilterList,
          controller: searchctr,
          ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: stateFilterList.length,
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
                  stateId.value = stateFilterList[index].id.toString();
                  statectr.text = stateFilterList[index].name;
                  cityctr.text = "";
                  cityId.value = "";
                  cityFilterList.clear();
                  cityList.clear();
                  if (statectr.text.toString().isNotEmpty) {
                    stateFilterList.clear();
                    stateFilterList.addAll(stateList);
                  }
                  isFilterApplied.value = statectr.text.isNotEmpty ||
                      cityctr.text.isNotEmpty ||
                      categoryCtr.text.isNotEmpty;
                  update();
                  futureDelay(() {
                    getCityApi(context, stateId.value.toString(), true);
                  }, isOneSecond: false);
                  // validateState(statectr.text);
                },
                title: showSelectedTextInDialog(
                    name: stateFilterList[index].name,
                    modelId: stateFilterList[index].id.toString(),
                    storeId: stateId.value),
              );
            },
          ),
          searchcontent: getReactiveFormField(
              node: searchNode,
              controller: searchctr,
              hintLabel: SearchScreenConstant.hint,
              onChanged: (val) {
                applyFilter(val.toString());
                update();
              },
              isSearch: true,
              inputType: TextInputType.text,
              errorText: searchModel.value.error));
    });
  }

  void applyFilter(String keyword) {
    stateFilterList.clear();
    for (StateListData stateList in stateList) {
      if (stateList.name
          .toString()
          .toLowerCase()
          .contains(keyword.toLowerCase())) {
        stateFilterList.add(stateList);
      }
    }
    stateFilterList.refresh();
    stateFilterList.call();
    logcat('filterApply', stateFilterList.length.toString());
    logcat('filterApply', jsonEncode(stateFilterList));
    update();
  }

  void applyFilterforCity(String keyword) {
    cityFilterList.clear();
    for (CityListData cityList in cityList) {
      if (cityList.city
          .toString()
          .toLowerCase()
          .contains(keyword.toLowerCase())) {
        cityFilterList.add(cityList);
      }
    }
    cityFilterList.refresh();
    cityFilterList.call();
    logcat('filterApply', cityFilterList.length.toString());
    update();
  }

  Widget setCityListDialog() {
    return Obx(() {
      if (isCityApiCallLoading.value == true) {
        return setDropDownContent(
            [].obs, const Text(SearchScreenConstant.loading),
            isApiIsLoading: isCityApiCallLoading.value);
      }
      return setDropDownContent(
          cityFilterList,
          controller: searchCityctr,
          ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: cityFilterList.length,
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
                  cityId.value = cityFilterList[index].id.toString();
                  cityctr.text = cityFilterList[index].city.toString();
                  if (cityctr.text.toString().isNotEmpty) {
                    cityFilterList.clear();
                    cityFilterList.addAll(cityList);
                  }
                  isFilterApplied.value = statectr.text.isNotEmpty ||
                      cityctr.text.isNotEmpty ||
                      categoryCtr.text.isNotEmpty;
                  validateCity(cityctr.text);
                  update();
                },
                title: showSelectedTextInDialog(
                    name: cityFilterList[index].city,
                    modelId: cityFilterList[index].id.toString(),
                    storeId: cityId.value),
              );
            },
          ),
          searchcontent: getReactiveFormField(
              node: searchCityNode,
              controller: searchCityctr,
              hintLabel: SearchScreenConstant.hint,
              onChanged: (val) {
                applyFilterforCity(val.toString());
                update();
              },
              isSearch: true,
              inputType: TextInputType.text,
              errorText: searchCityModel.value.error));
    });
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
                  isFilterApplied.value = statectr.text.isNotEmpty ||
                      cityctr.text.isNotEmpty ||
                      categoryCtr.text.isNotEmpty;
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

  void validateState(String? val) {
    stateModel.update((model) {
      if (val != null && val.isEmpty) {
        model!.error = "Select State";
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });

    updateFormInvalidate();
  }

  void validateCity(String? val) {
    cityModel.update((model) {
      if (val != null && val.isEmpty) {
        model!.error = SearchScreenConstant.selectCityHint;
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });
    updateFormInvalidate();
  }

  void validateCategory(String? val) {
    categoryModel.update((model) {
      if (val != null && val.isEmpty) {
        model!.error = SearchScreenConstant.selectCategoryHint;
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });
    updateFormInvalidate();
  }

  void updateFormInvalidate() {
    if (cityModel.value.isValidate == false) {
      // isFormInvalidate.value = false;
    } else {
      // isFormInvalidate.value = true;
    }
    update();
  }

  void getCityApi(context, cityID, bool isLoading) async {
    var loadingIndicator = LoadingProgressDialogs();
    commonGetApiCallFormate(context,
        title: SearchScreenConstant.titleScreen,
        // apiEndPoint: "${ApiUrl.getCity}/" + cityID,
        apiEndPoint: "${ApiUrl.getCity}/$cityID",
        allowHeader: true, apisLoading: (isTrue) {
      if (isLoading == true) {
        if (isTrue) {
          loadingIndicator.show(context, '');
        } else {
          loadingIndicator.hide(context);
        }
      }
      isCityApiCallLoading.value = isTrue;
      logcat("isCityList:", isTrue.toString());
      update();
    }, onResponse: (response) {
      var data = CityModel.fromJson(response);
      cityList.clear();
      cityFilterList.clear();
      cityList.addAll(data.data);
      cityFilterList.addAll(data.data);
      logcat("CITY_RESPONSE", jsonEncode(cityFilterList));
      update();
    }, networkManager: networkManager);
  }

  void getStateApi(context, stateID) async {
    logcat("getStateApi", stateID.toString());
    // var loadingIndicator = LoadingProgressDialogs();
    commonGetApiCallFormate(context,
        title: SearchScreenConstant.titleScreen,
        apiEndPoint: ApiUrl.getState,
        allowHeader: true, apisLoading: (isTrue) {
      // if (isTrue) {
      //   loadingIndicator.show(context, '');
      // } else {
      //   loadingIndicator.hide(context);
      // }
      isStateApiCallLoading.value = isTrue;
      logcat("isCityList:", isTrue.toString());
      update();
    }, onResponse: (response) {
      var data = StateModel.fromJson(response);
      stateList.clear();
      stateFilterList.clear();
      stateList.addAll(data.data);
      stateFilterList.addAll(data.data);
      logcat("STATE_RESPONSE", jsonEncode(stateFilterList));
      update();
    }, networkManager: networkManager);
  }

  void getCategoryApi(context) async {
    // var loadingIndicator = LoadingProgressDialogs();
    commonGetApiCallFormate(context,
        title: SearchScreenConstant.titleScreen,
        apiEndPoint: ApiUrl.getCategories,
        allowHeader: true, apisLoading: (isTrue) {
      // if (isTrue) {
      //   loadingIndicator.show(context, '');
      // } else {
      //   loadingIndicator.hide(context);
      // }
      isCategoryApiCallLoading.value = isTrue;
      update();
    }, onResponse: (response) {
      var data = CategoryModel.fromJson(response);
      categoryList.clear();
      categoryFilterList.clear();
      categoryList.addAll(data.data);
      categoryFilterList.addAll(data.data);
      logcat("CATEGORY_RESPONSE", jsonEncode(categoryFilterList));
      update();
    }, networkManager: networkManager);
  }

  RxList businessList = [].obs;
  getBusinessList(context, currentPage, bool hideloading,
      {String? stateId,
      String? cityId,
      String? categoryId,
      String? keyword,
      bool? isFirstTime = false}) async {
    if (hideloading == false) {
      state.value = ScreenState.apiLoading;
    }
    try {
      if (networkManager.connectionType.value == 0) {
        showDialogForScreen(
            context, SearchScreenConstant.titleScreen, Connection.noConnection,
            callback: () {
          Get.back();
        });
        return;
      }

      var pageURL = '${ApiUrl.businessesList}?page=$currentPage';

      Map<String, dynamic> requestBody = {};

      if (stateId != null && stateId.isNotEmpty) {
        requestBody['state'] = int.parse(stateId);
      }
      if (cityId != null && cityId.isNotEmpty) {
        requestBody['city'] = int.parse(cityId);
      }
      if (categoryId != null && categoryId.isNotEmpty) {
        requestBody['category'] = int.parse(categoryId);
      }
      if (keyword != null && keyword.isNotEmpty) {
        requestBody['keyword'] = [keyword]; // list
      }

      logcat("BusinessListParam::", requestBody.toString());
      var response =
          await Repository.post(requestBody, pageURL, allowHeader: true);
      logcat("RESPONSE::", response.body);
      var responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseData['success'] == true) {
          state.value = ScreenState.apiSuccess;
          message.value = '';
          var businessListData = BusinessModel.fromJson(responseData);
          if (isFirstTime == true && businessList.isNotEmpty) {
            businessList.clear();
          }
          if (businessListData.data.data.isNotEmpty) {
            businessList.addAll(businessListData.data.data);
            businessList.refresh();
            update();
          } else {
            businessList.clear();
          }
          if (businessListData.data.nextPageUrl != null) {
            nextPageURL.value = businessListData.data.nextPageUrl.toString();
            logcat("nextPageURL-1", nextPageURL.value.toString());
            update();
          } else {
            nextPageURL.value = "";
            logcat("nextPageURL-2", nextPageURL.value.toString());
            update();
          }
          logcat("nextPageURL", nextPageURL.value.toString());
        } else {
          message.value = responseData['message'];
          showDialogForScreen(context, SearchScreenConstant.titleScreen,
              responseData['message'],
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(context, SearchScreenConstant.titleScreen,
            responseData['message'] ?? ServerError.servererror,
            callback: () {});
      }
    } catch (e) {
      logcat("Ecxeption", e);
      state.value = ScreenState.apiError;
      // message.value = ServerError.servererror;
      // if (hideloading != true) {
      //   loadingIndicator.hide(context);
      // }
      // showDialogForScreen(
      //     context, CategoryScreenConstant.title, ServerError.servererror,
      //     callback: () {});
    }
  }

  getBusinessListItem(BuildContext context, BusinessData item) {
    print('item;${item.isEmailVerified}');
    return GestureDetector(
      onTap: () async {
        bool isEmpty = await isAnyFieldEmpty();
        if (isEmpty) {
          // ignore: use_build_context_synchronously
          showBottomSheetPopup(context);
        } else {
          Get.to(BusinessDetailScreen(
            item: item,
            isFromProfile: false,
          ));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                // ignore: deprecated_member_use
                color: black.withOpacity(0.2),
                spreadRadius: 0.1,
                blurRadius: 5,
                offset: const Offset(0.5, 0.5)),
          ],
        ),
        margin: EdgeInsets.only(left: 3.w, right: 3.w, bottom: 2.h),
        padding: EdgeInsets.only(left: 2.w, top: 1.h, bottom: 1.h, right: 2.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  // padding: const EdgeInsets.all(2),
                  margin: EdgeInsets.only(top: 0.5.h, bottom: 0.5.h),
                  width: 25.w,
                  height: 11.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: primaryColor,
                        width: 1), // border color and width
                    borderRadius: BorderRadius.circular(
                        Device.screenType == sizer.ScreenType.mobile
                            ? 3.5.w
                            : 2.5.w),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        Device.screenType == sizer.ScreenType.mobile
                            ? 3.5.w
                            : 2.5.w),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      height: 18.h,
                      imageUrl: item.visitingCardUrl,
                      placeholder: (context, url) => Center(
                        child: Image.asset(Asset.itemPlaceholder,
                            height: 10.h, fit: BoxFit.cover),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                          Asset.itemPlaceholder,
                          height: 10.h,
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
                Positioned(
                    top: 0.2.h,
                    right: -2,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: white,
                      ),
                      child: SvgPicture.asset(
                        Asset.badge,
                        color: blue,
                      ),
                    )),
                // item.isEmailVerified
                //     ?

                // : SizedBox.shrink()
              ],
            ),
            getDynamicSizedBox(width: 2.w),
            Expanded(
              child: Container(
                height: 11.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      // height: 4.h,
                      width: Device.screenType == sizer.ScreenType.mobile
                          ? 58.w
                          : 65.w,
                      child: Text(
                          // 'asdaiyutasypudsgsaudgasgasdadsdjhdgasbaosdoas',

                          item.businessName,
                          maxLines: 2,
                          style: TextStyle(
                              fontFamily: dM_sans_semiBold,
                              fontSize: 15.sp,
                              height: 1.1,
                              overflow: TextOverflow.ellipsis,
                              color: black,
                              fontWeight: FontWeight.w900)),
                    ),
                    getDynamicSizedBox(height: 1.h),
                    SizedBox(
                      // height: 2.h,
                      width: Device.screenType == sizer.ScreenType.mobile
                          ? 58.w
                          : 70.w,
                      child: Text(item.name,
                          maxLines: 1,
                          style: TextStyle(
                              height: 1.1,
                              fontFamily: dM_sans_semiBold,
                              fontSize: 14.sp,
                              color: black,
                              fontWeight: FontWeight.w500)),
                    ),
                    getDynamicSizedBox(height: 1.h),
                    SizedBox(
                      // height: 4.h,
                      width: Device.screenType == sizer.ScreenType.mobile
                          ? 58.w
                          : 65.w,
                      child: Text(
                          // 'asdaiyutasypudsgsaudgasgasdadsdjhdgasbaosdoas',

                          item.address.isNotEmpty
                              ? item.address
                              : item.city != null
                                  ? item.city!.city
                                  : item.phone,
                          maxLines: 2,
                          style: TextStyle(
                              height: 1.1,
                              fontFamily: dM_sans_semiBold,
                              fontSize: 14.sp,
                              color: black,
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // getBusinessListItem(BuildContext context, BusinessData item) {
  //   return GestureDetector(
  //     onTap: () async {
  //       bool isEmpty = await isAnyFieldEmpty();
  //       if (isEmpty) {
  //         // ignore: use_build_context_synchronously
  //         showBottomSheetPopup(context);
  //       } else {
  //         Get.to(BusinessDetailScreen(
  //           item: item,
  //           isFromProfile: false,
  //         ));
  //       }
  //       // Get.to(BusinessDetailScreen(
  //       //   item: item,
  //       //   isFromProfile: false,
  //       // ));
  //     },
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: white,
  //         borderRadius: const BorderRadius.all(Radius.circular(10)),
  //         boxShadow: [
  //           BoxShadow(
  //               // ignore: deprecated_member_use
  //               color: black.withOpacity(0.2),
  //               spreadRadius: 0.1,
  //               blurRadius: 5,
  //               offset: const Offset(0.5, 0.5)),
  //         ],
  //       ),
  //       margin: EdgeInsets.only(left: 3.w, right: 3.w, bottom: 2.h),
  //       child: Padding(
  //         padding: EdgeInsets.only(
  //             left: 2.5.w, right: 2.5.w, top: 0.5.h, bottom: 0.5.h),
  //         child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Stack(
  //               clipBehavior: Clip.none,
  //               children: [
  //                 Container(
  //                   // padding: const EdgeInsets.all(2),
  //                   margin: EdgeInsets.only(top: 0.5.h, bottom: 0.5.h),
  //                   width: 25.w,
  //                   height: 12.h,
  //                   decoration: BoxDecoration(
  //                     border: Border.all(
  //                         color: primaryColor,
  //                         width: 1), // border color and width
  //                     borderRadius: BorderRadius.circular(
  //                         Device.screenType == sizer.ScreenType.mobile
  //                             ? 3.5.w
  //                             : 2.5.w),
  //                   ),
  //                   child: ClipRRect(
  //                     borderRadius: BorderRadius.circular(
  //                         Device.screenType == sizer.ScreenType.mobile
  //                             ? 3.5.w
  //                             : 2.5.w),
  //                     child: CachedNetworkImage(
  //                       fit: BoxFit.cover,
  //                       height: 18.h,
  //                       imageUrl: item.visitingCardUrl,
  //                       placeholder: (context, url) => Center(
  //                         child: Image.asset(Asset.itemPlaceholder,
  //                             height: 10.h, fit: BoxFit.cover),
  //                       ),
  //                       errorWidget: (context, url, error) => Image.asset(
  //                           Asset.itemPlaceholder,
  //                           height: 10.h,
  //                           fit: BoxFit.cover),
  //                     ),
  //                   ),
  //                 ),
  //                 Positioned(
  //                     top: 0.2.h,
  //                     right: -2,
  //                     child: Container(
  //                       decoration: BoxDecoration(
  //                         shape: BoxShape.circle,
  //                         color: white,
  //                       ),
  //                       child: SvgPicture.asset(
  //                         Asset.badge,
  //                         color: blue,
  //                       ),
  //                     )),
  //               ],
  //             ),
  //             getDynamicSizedBox(width: 2.w),
  //             Expanded(
  //               child: Container(
  //                 height: 11.h,
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     SizedBox(
  //                       width: Device.screenType == sizer.ScreenType.mobile
  //                           ? 58.w
  //                           : 65.w,
  //                       child: Text(item.businessName,
  //                           maxLines: 2,
  //                           style: TextStyle(
  //                               height: 1.1,
  //                               fontFamily: dM_sans_semiBold,
  //                               fontSize: 15.sp,
  //                               overflow: TextOverflow.ellipsis,
  //                               color: black,
  //                               fontWeight: FontWeight.w900)),
  //                     ),
  //                     getDynamicSizedBox(height: 1.h),
  //                     SizedBox(
  //                       width: Device.screenType == sizer.ScreenType.mobile
  //                           ? 64.w
  //                           : 70.w,
  //                       child: Text(item.name,
  //                           maxLines: 1,
  //                           style: TextStyle(
  //                               height: 1.1,
  //                               fontFamily: dM_sans_semiBold,
  //                               fontSize: 14.sp,
  //                               color: black,
  //                               fontWeight: FontWeight.w500)),
  //                     ),
  //                     getDynamicSizedBox(height: 1.h),
  //                     SizedBox(
  //                       width: Device.screenType == sizer.ScreenType.mobile
  //                           ? 58.w
  //                           : 65.w,
  //                       child: Text(
  //                           item.address.isNotEmpty
  //                               ? item.address
  //                               : item.city != null
  //                                   ? item.city!.city
  //                                   : item.phone,
  //                           maxLines: 2,
  //                           style: TextStyle(
  //                               fontFamily: dM_sans_semiBold,
  //                               fontSize: 14.sp,
  //                               color: black,
  //                               fontWeight: FontWeight.w500)),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
