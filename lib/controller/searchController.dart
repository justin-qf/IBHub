import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
import 'package:ibh/models/categotyModel.dart';
import 'package:ibh/models/cityModel.dart';
import 'package:ibh/models/sign_in_form_validation.dart';
import 'package:ibh/models/stateModel.dart';
import 'package:ibh/utils/helper.dart';
import 'package:ibh/utils/log.dart';
import 'package:ibh/views/mainscreen/ServiceScreen/ServiceScreen.dart';
import 'package:readmore/readmore.dart';
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
  RxList<CategoryData> categoryList = <CategoryData>[].obs;
  RxList<CategoryData> categoryFilterList = <CategoryData>[].obs;

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
  // void getSearchList(context, String searchText) async {
  //   state.value = ScreenState.apiLoading;
  //   try {
  //     if (networkManager.connectionType == 0) {
  //       showDialogForScreen(
  //           context, SearchScreenConstant.title, Connection.noConnection,
  //           callback: () {
  //         Get.back();
  //       });
  //       return;
  //     }
  //     var response = await Repository.get(
  //         {}, "${ApiUrl.getSearch}?search_product=$searchText",
  //         allowHeader: true);
  //     logcat("SEARCH_RESPONSE::", response.body);
  //     if (response.statusCode == 200) {
  //       var responseData = jsonDecode(response.body);
  //       if (responseData['status'] == 1) {
  //         state.value = ScreenState.apiSuccess;
  //         message.value = '';
  //         var searchData = SearchModel.fromJson(responseData);
  //         searchList.clear();
  //         if (searchData.data.isNotEmpty) {
  //           searchList.addAll(searchData.data);
  //           update();
  //         } else {
  //           //state.value = ScreenState.noDataFound;
  //         }

  //         List<CommonProductList> cartItems =
  //             await UserPreferences().loadCartItems();

  //         for (CommonProductList item in searchData.data) {
  //           int existingIndex =
  //               cartItems.indexWhere((cartItem) => cartItem.id == item.id);
  //           if (existingIndex != -1) {
  //             item.isInCart!.value = true;
  //             item.quantity!.value = cartItems[existingIndex].quantity!.value;
  //           } else {
  //             item.isInCart!.value = false;
  //             item.quantity!.value = 0;
  //           }
  //         }
  //       } else {
  //         message.value = responseData['message'];
  //         showDialogForScreen(
  //             context, SearchScreenConstant.title, responseData['message'],
  //             callback: () {});
  //       }
  //     } else {
  //       state.value = ScreenState.apiError;
  //       message.value = APIResponseHandleText.serverError;
  //       showDialogForScreen(
  //           context, SearchScreenConstant.title, ServerError.servererror,
  //           callback: () {});
  //     }
  //   } catch (e) {
  //     logcat("Ecxeption", e);
  //     state.value = ScreenState.apiError;
  //     message.value = ServerError.servererror;
  //     showDialogForScreen(
  //         context, SearchScreenConstant.title, ServerError.servererror,
  //         callback: () {});
  //   }
  // }

  // getItemListItem(
  //     BuildContext context, CommonProductList data, bool? isGuestUser) {
  //   return GestureDetector(
  //     onTap: () {
  //       Get.to(
  //         ProductDetailScreen(
  //           SearchScreenConstant.title,
  //           data: data,
  //         ),
  //         transition: Transition.fadeIn,
  //         curve: Curves.easeInOut,
  //       );
  //     },
  //     child: FadeInUp(
  //       child: Wrap(
  //         children: [
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(
  //                 SizerUtil.deviceType == DeviceType.mobile ? 4.w : 2.2.w),
  //             child: Container(
  //               width: double.infinity,
  //               margin: EdgeInsets.only(bottom: 0.5.h, left: 1.w, right: 2.w),
  //               decoration: BoxDecoration(
  //                 border: Border.all(
  //                   color: grey, // Border color
  //                   width: isDarkMode() ? 1 : 0.2, // Border width
  //                 ),
  //                 color: isDarkMode() ? tileColour : white,
  //                 borderRadius: BorderRadius.circular(
  //                     SizerUtil.deviceType == DeviceType.mobile ? 4.w : 2.2.w),
  //               ),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Stack(
  //                     children: [
  //                       Container(
  //                         width: double.infinity,
  //                         decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(
  //                                 SizerUtil.deviceType == DeviceType.mobile
  //                                     ? 3.5.w
  //                                     : 2.5.w),
  //                             border: Border.all(
  //                                 color: grey, // Set the border color here
  //                                 width: isDarkMode()
  //                                     ? 1
  //                                     : 0.2 // Set the border width
  //                                 )),
  //                         child: ClipRRect(
  //                           borderRadius: BorderRadius.circular(
  //                               SizerUtil.deviceType == DeviceType.mobile
  //                                   ? 3.5.w
  //                                   : 2.5.w),
  //                           child: CachedNetworkImage(
  //                             fit: BoxFit.cover,
  //                             height: 12.h,
  //                             imageUrl: ApiUrl.imageUrl + data.images[0],
  //                             placeholder: (context, url) => const Center(
  //                               child: CircularProgressIndicator(
  //                                   color: primaryColor),
  //                             ),
  //                             errorWidget: (context, url, error) => Image.asset(
  //                               Asset.productPlaceholder,
  //                               height: 12.h,
  //                               fit: BoxFit.contain,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(
  //                     height: 1.h,
  //                   ),
  //                   Container(
  //                     margin: EdgeInsets.only(left: 1.w, right: 1.w),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         getText(
  //                           data.name,
  //                           TextStyle(
  //                               fontFamily: fontSemiBold,
  //                               overflow: TextOverflow.ellipsis,
  //                               fontWeight: FontWeight.w500,
  //                               color: isDarkMode() ? black : black,
  //                               fontSize:
  //                                   SizerUtil.deviceType == DeviceType.mobile
  //                                       ? 10.sp
  //                                       : 7.sp,
  //                               height: 1.2),
  //                         ),
  //                         getDynamicSizedBox(
  //                           height: 0.5.h,
  //                         ),
  //                         Row(
  //                           children: [
  //                             getText(
  //                               '${IndiaRupeeConstant.inrCode}${data.price}',
  //                               TextStyle(
  //                                   fontFamily: fontBold,
  //                                   color: primaryColor,
  //                                   fontSize: SizerUtil.deviceType ==
  //                                           DeviceType.mobile
  //                                       ? 12.sp
  //                                       : 7.sp,
  //                                   height: 1.2),
  //                             ),
  //                             const Spacer(),
  //                             RatingBar.builder(
  //                               initialRating: data.averageRating ?? 0.0,
  //                               minRating: 1,
  //                               direction: Axis.horizontal,
  //                               allowHalfRating: true,
  //                               itemCount: 1,
  //                               itemSize: 3.5.w,
  //                               unratedColor: Colors.orange,
  //                               itemBuilder: (context, _) => const Icon(
  //                                 Icons.star,
  //                                 color: Colors.orange,
  //                               ),
  //                               onRatingUpdate: (rating) {
  //                                 logcat("RATING", rating);
  //                               },
  //                             ),
  //                             getText(
  //                               data.averageRating != null
  //                                   ? data.averageRating.toString()
  //                                   : '0.0',
  //                               TextStyle(
  //                                   fontFamily: fontSemiBold,
  //                                   color: lableColor,
  //                                   fontWeight:
  //                                       isDarkMode() ? FontWeight.w600 : null,
  //                                   fontSize: SizerUtil.deviceType ==
  //                                           DeviceType.mobile
  //                                       ? 9.sp
  //                                       : 7.sp,
  //                                   height: 1.2),
  //                             ),
  //                           ],
  //                         ),
  //                         getDynamicSizedBox(
  //                           height: 0.5.h,
  //                         ),
  //                         // Row(
  //                         //   crossAxisAlignment: CrossAxisAlignment.center,
  //                         //   mainAxisAlignment: MainAxisAlignment.center,
  //                         //   children: [
  //                         //     RatingBar.builder(
  //                         //       initialRating: 3.5,
  //                         //       minRating: 1,
  //                         //       direction: Axis.horizontal,
  //                         //       allowHalfRating: true,
  //                         //       itemCount: 1,
  //                         //       itemSize: 3.5.w,
  //                         //       // itemPadding:
  //                         //       //     const EdgeInsets.symmetric(horizontal: 5.0),
  //                         //       itemBuilder: (context, _) => const Icon(
  //                         //         Icons.star,
  //                         //         color: Colors.orange,
  //                         //       ),
  //                         //       onRatingUpdate: (rating) {
  //                         //         logcat("RATING", rating);
  //                         //       },
  //                         //     ),
  //                         //     getText(
  //                         //       "3.2",
  //                         //       TextStyle(
  //                         //           fontFamily: fontSemiBold,
  //                         //           color: lableColor,
  //                         //           fontWeight:
  //                         //               isDarkMode() ? FontWeight.w900 : null,
  //                         //           fontSize:
  //                         //               SizerUtil.deviceType == DeviceType.mobile
  //                         //                   ? 8.sp
  //                         //                   : 7.sp,
  //                         //           height: 1.2),
  //                         //     ),
  //                         //     const Spacer(),
  //                         //     Obx(
  //                         //       () {
  //                         //         return getAddToCartBtn(
  //                         //             'Add to Cart', Icons.shopping_cart,
  //                         //             addCartClick: () {
  //                         //           if (isGuest!.value == true) {
  //                         //             getGuestUserAlertDialog(
  //                         //                 context, SearchScreenConstant.title);
  //                         //           } else {
  //                         //             Get.to(const CartScreen())!.then((value) {
  //                         //               Statusbar()
  //                         //                   .trasparentStatusbarProfile(true);
  //                         //             });
  //                         //           }
  //                         //         }, isEnable: isGuest!.value);
  //                         //       },
  //                         //     )
  //                         //   ],
  //                         // ),
  //                         Obx(
  //                           () {
  //                             return data.isInCart!.value == false
  //                                 ? getAddToCartBtn(
  //                                     'Add to Cart', Icons.shopping_cart,
  //                                     addCartClick: () async {
  //                                     if (isGuest!.value == true) {
  //                                       getGuestUserAlertDialog(context,
  //                                           SearchScreenConstant.title);
  //                                     } else {
  //                                       data.isInCart!.value = true;
  //                                       incrementDecrementCartItem(
  //                                           isFromIcr: true,
  //                                           data: data,
  //                                           //itemList: popularItemList,
  //                                           quantity: data.quantity!.value);
  //                                     }
  //                                     update();
  //                                   }, isAddToCartClicked: data.isInCart!)
  //                                 : homeCartIncDecUi(
  //                                     qty: data.quantity.toString(),
  //                                     increment: () async {
  //                                       incrementDecrementCartItemInList(
  //                                           isFromIcr: true,
  //                                           data: data,
  //                                           // itemList: popularItemList,
  //                                           quantity: data.quantity!.value);

  //                                       update();
  //                                     },
  //                                     isFromPopular: false,
  //                                     decrement: () async {
  //                                       incrementDecrementCartItemInList(
  //                                           isFromIcr: false,
  //                                           data: data,
  //                                           // itemList: popularItemList,
  //                                           quantity: data.quantity!.value);
  //                                       update();
  //                                     });
  //                           },
  //                         ),
  //                         // Obx(
  //                         //   () {
  //                         //     return getAddToCartBtn(
  //                         //         'Add to Cart', Icons.shopping_cart,
  //                         //         addCartClick: () {
  //                         //       if (isGuest!.value == true) {
  //                         //         getGuestUserAlertDialog(
  //                         //             context, SearchScreenConstant.title);
  //                         //       } else {
  //                         //         Get.to(const CartScreen())!.then((value) {
  //                         //           Statusbar().trasparentStatusbarProfile(true);
  //                         //         });
  //                         //       }
  //                         //     }, isEnable: isGuest!.value);
  //                         //   },
  //                         // ),
  //                         getDynamicSizedBox(
  //                           height: 1.h,
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
                    getLable("State", isFromRetailer: true),
                    Container(
                      margin: EdgeInsets.only(left: 9.w, right: 9.w),
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: Obx(() {
                          return getReactiveFormField(
                              node: stateNode,
                              controller: statectr,
                              hintLabel: "Select State",
                              onChanged: (val) {},
                              onTap: () {
                                searchctr.text = "";
                                showDropdownMessage(
                                    context,
                                    setStateListDialog(),
                                    isShowLoading: stateFilterList,
                                    "State List", onClick: () {
                                  applyFilter('');
                                }, refreshClick: () {
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
                    getLable("City", isFromRetailer: true),
                    Container(
                      margin: EdgeInsets.only(left: 9.w, right: 9.w),
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: Obx(() {
                          return getReactiveFormField(
                              node: cityNode,
                              controller: cityctr,
                              hintLabel: "Select City",
                              onChanged: (val) {},
                              onTap: () {
                                searchCityctr.text = "";
                                if (statectr.text.toString().isEmpty) {
                                  showDialogForScreen(
                                      context, "State", "Please Select State",
                                      callback: () {});
                                } else {
                                  showDropdownMessage(
                                      context, setCityListDialog(), "City List",
                                      isShowLoading: cityFilterList,
                                      onClick: () {
                                    applyFilterforCity('');
                                  }, refreshClick: () {
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
                    getLable("Category", isFromRetailer: true),
                    Container(
                      margin: EdgeInsets.only(left: 9.w, right: 9.w),
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: Obx(() {
                          return getReactiveFormField(
                              node: categoryNode,
                              controller: categoryCtr,
                              hintLabel: "Select Category",
                              onChanged: (val) {},
                              onTap: () {
                                searchCategoryctr.text = "";
                                showDropdownMessage(context,
                                    setCategoryListDialog(), "Category List",
                                    isShowLoading: categoryFilterList,
                                    onClick: () {
                                  applyCategoryFilter('');
                                }, refreshClick: () {
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
        return setDropDownContent([].obs, const Text("Loading"),
            isApiIsLoading: isStateApiCallLoading.value);
      }
      return setDropDownContent(
          stateFilterList,
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
              hintLabel: "Search Here",
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
        return setDropDownContent([].obs, const Text("Loading"),
            isApiIsLoading: isCityApiCallLoading.value);
      }
      return setDropDownContent(
          cityFilterList,
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
                  validateCity(cityctr.text);
                  update();
                },
                title: showSelectedTextInDialog(
                    name: cityFilterList[index].city,
                    modelId: cityFilterList[index].id.toString(),
                    storeId: cityId.value),
                //      Text(
                //   cityFilterList[index].name,
                //   style: TextStyle(
                //       fontFamily: fontRegular,
                //       fontSize: SizerUtil.deviceType == DeviceType.mobile
                //           ? 13.5.sp
                //           : 9.sp,
                //       color: black),
                // ),
              );
            },
          ),
          searchcontent: getReactiveFormField(
              node: searchCityNode,
              controller: searchCityctr,
              hintLabel: "Search Here",
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
                  // categoryFilterList.clear();
                  // categoryList.clear();
                  if (categoryCtr.text.toString().isNotEmpty) {
                    categoryFilterList.clear();
                    categoryFilterList.addAll(categoryList);
                  }
                  update();
                  // validateState(statectr.text);
                },
                title: showSelectedTextInDialog(
                    name: categoryFilterList[index].name,
                    modelId: categoryFilterList[index].id.toString(),
                    storeId: categoryId.value),
              );
            },
          ),
          searchcontent: getReactiveFormField(
              node: searchNode,
              controller: searchctr,
              hintLabel: "Search Here",
              onChanged: (val) {
                applyCategoryFilter(val.toString());
                update();
              },
              isSearch: true,
              inputType: TextInputType.text,
              errorText: searchModel.value.error));
    });
  }

  void applyCategoryFilter(String keyword) {
    categoryFilterList.clear();
    for (CategoryData categoryItem in categoryList) {
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
        model!.error = "Select City";
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
        model!.error = "Select Category";
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
        title: "City List",
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
        title: "State List",
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
        title: "Category List",
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
    var loadingIndicator = LoadingProgressDialog();

    // if (hideloading == true) {
    //   state.value = ScreenState.apiLoading;
    // } else {
    //   loadingIndicator.show(context, '');
    //   update();
    // }
    if (hideloading == false) {
      state.value = ScreenState.apiLoading;
    }
    try {
      if (networkManager.connectionType.value == 0) {
        showDialogForScreen(
            context, CategoryScreenConstant.title, Connection.noConnection,
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
      // if (hideloading != true) {
      //   loadingIndicator.hide(context);
      // }
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
          }
          if (businessListData.data.nextPageUrl != 'null' ||
              businessListData.data.nextPageUrl != null) {
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
          showDialogForScreen(
              context, CategoryScreenConstant.title, responseData['message'],
              callback: () {});
        }
      } else {
        state.value = ScreenState.apiError;
        message.value = APIResponseHandleText.serverError;
        showDialogForScreen(context, CategoryScreenConstant.title,
            responseData['message'] ?? ServerError.servererror,
            callback: () {});
      }
    } catch (e) {
      logcat("Ecxeption", e);
      state.value = ScreenState.apiError;
      message.value = ServerError.servererror;
      if (hideloading != true) {
        loadingIndicator.hide(context);
      }
      showDialogForScreen(
          context, CategoryScreenConstant.title, ServerError.servererror,
          callback: () {});
    }
  }

  getBusinessListItem(BuildContext context, BusinessData item) {
    return GestureDetector(
      onTap: () {
        // Get.to(ServiceDetailScreen(item: item));
        Get.to(ServiceScreen(data: item));
      },
      child: Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: black.withOpacity(0.2),
                spreadRadius: 0.1,
                blurRadius: 5,
                offset: const Offset(0.5, 0.5)),
          ],
        ),
        margin: EdgeInsets.only(left: 3.w, right: 3.w, bottom: 2.h),
        child: Padding(
          padding:
              EdgeInsets.only(left: 2.w, right: 2.w, top: 0.2.h, bottom: 0.2.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                margin: EdgeInsets.only(top: 0.5.h, bottom: 0.5.h),
                width: 25.w,
                height: 12.h,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey.withOpacity(0.8),
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
                    placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(color: primaryColor)),
                    errorWidget: (context, url, error) => Image.asset(
                        Asset.placeholder,
                        height: 10.h,
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              getDynamicSizedBox(width: 2.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(item.businessName,
                            style: TextStyle(
                                fontFamily: dM_sans_semiBold,
                                fontSize: 15.sp,
                                color: black,
                                fontWeight: FontWeight.w900)),
                        const Spacer(),
                        // if (item.businessReviewsAvgRating != null)
                        // Text(item.businessReviewsAvgRating.toString(),
                        //     style: TextStyle(
                        //         fontFamily: fontMedium,
                        //         fontSize: 14.sp,
                        //         color: grey,
                        //         fontWeight: FontWeight.w900))
                        RatingBar.builder(
                          initialRating: item.businessReviewsAvgRating ?? 0.0,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 1,
                          itemSize: 3.5.w,
                          unratedColor: Colors.orange,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.orange,
                          ),
                          onRatingUpdate: (rating) {
                            logcat("RATING", rating);
                          },
                        ),
                        getText(
                          item.businessReviewsAvgRating != null
                              ? item.businessReviewsAvgRating.toString()
                              : '0.0',
                          TextStyle(
                              fontFamily: fontSemiBold,
                              color: lableColor,
                              fontSize:
                                  Device.screenType == sizer.ScreenType.mobile
                                      ? 14.sp
                                      : 7.sp,
                              height: 1.2),
                        ),
                      ],
                    ),
                    getDynamicSizedBox(height: 1.h),
                    Text(item.name,
                        style: TextStyle(
                            fontFamily: fontRegular,
                            fontSize: 14.sp,
                            color: black,
                            fontWeight: FontWeight.w500)),
                    getDynamicSizedBox(height: 1.h),
                    Text(
                        item.address.isNotEmpty
                            ? item.address
                            : item.city != null
                                ? item.city!.city
                                : item.phone,
                        maxLines: 2,
                        style: TextStyle(
                            fontFamily: fontRegular,
                            fontSize: 14.sp,
                            color: black,
                            fontWeight: FontWeight.w500)),
                    // getText(
                    //   item.address,
                    //   TextStyle(
                    //       fontFamily: fontSemiBold,
                    //       color: lableColor,
                    //       fontSize: Device.screenType == sizer.ScreenType.mobile
                    //           ? 14.sp
                    //           : 7.sp,
                    //       height: 1.2),
                    // ),
                    // AbsorbPointer(
                    //     absorbing: true,
                    //     child: ReadMoreText(item.address,
                    //         textAlign: TextAlign.start,
                    //         trimLines: 2, callback: (val) {
                    //       logcat("ONTAP", val.toString());
                    //     },
                    //         colorClickableText: primaryColor,
                    //         trimMode: TrimMode.Line,
                    //         trimCollapsedText: '...Show more',
                    //         trimExpandedText: '',
                    //         delimiter: ' ',
                    //         style: TextStyle(
                    //             overflow: TextOverflow.ellipsis,
                    //             fontSize:
                    //                 Device.screenType == sizer.ScreenType.mobile
                    //                     ? 14.sp
                    //                     : 10.sp,
                    //             fontFamily: fontBold,
                    //             color: grey),
                    //         lessStyle: TextStyle(
                    //             fontFamily: fontMedium,
                    //             fontSize:
                    //                 Device.screenType == sizer.ScreenType.mobile
                    //                     ? 14.sp
                    //                     : 12.sp),
                    //         moreStyle: TextStyle(
                    //             fontFamily: fontMedium,
                    //             fontSize:
                    //                 Device.screenType == sizer.ScreenType.mobile
                    //                     ? 14.sp
                    //                     : 12.sp,
                    //             color: primaryColor))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
