import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/utils/log.dart';
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
  // RxList<SavedItem> filterList = <SavedItem>[].obs;

  @override
  void onInit() {
    logcat("Search", "Screen");
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
}
