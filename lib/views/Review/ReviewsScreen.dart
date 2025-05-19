// import 'package:animate_do/animate_do.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:get/get.dart';
// import 'package:ibh/api_handle/apiOtherStates.dart';
// import 'package:ibh/componant/input/form_inputs.dart';
// import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
// import 'package:ibh/componant/toolbar/toolbar.dart';
// import 'package:ibh/componant/widgets/widgets.dart';
// import 'package:ibh/configs/colors_constant.dart';
// import 'package:ibh/configs/statusbar.dart';
// import 'package:ibh/configs/string_constant.dart';
// import 'package:ibh/controller/reviewsController.dart';
// import 'package:ibh/models/reviewModel.dart';
// import 'package:ibh/utils/enum.dart';
// import 'package:ibh/utils/log.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:sizer/sizer.dart';
// import 'package:sizer/sizer.dart' as sizer;

// // ignore: must_be_immutable
// class ReviewsScreen extends StatefulWidget {
//   ReviewsScreen({required this.businessId, super.key});
//   String businessId;
//   @override
//   State<ReviewsScreen> createState() => _ReviewsScreenState();
// }

// class _ReviewsScreenState extends State<ReviewsScreen> {
//   var controller = Get.put(ReviewsScreenController());

//   @override
//   void initState() {
//     controller.getReviewList(context, 1, true, isRefress: true);
//     controller.scrollController.addListener(scrollListener);
//     super.initState();
//   }

//   void scrollListener() {
//     if (controller.scrollController.position.pixels ==
//             controller.scrollController.position.maxScrollExtent &&
//         controller.nextPageURL.value.isNotEmpty &&
//         !controller.isFetchingMore) {
//       if (!mounted) return;
//       setState(() => controller.isFetchingMore = true);
//       controller.currentPage++;
//       Future.delayed(
//         Duration.zero,
//         () {
//           controller
//               .getReviewList(context, controller.currentPage, true)
//               .whenComplete(() {
//             if (mounted) {
//               setState(() => controller.isFetchingMore = false);
//             }
//           });
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     Statusbar().transparentStatusbarIsNormalScreen();
//     return CustomParentScaffold(
//       onWillPop: () async {
//         logcat("onWillPop", "DONE");
//         return true;
//       },
//       onTap: () {
//         controller.hideKeyboard(context);
//       },
//       isExtendBodyScreen: true,
//       body: Container(
//         color: transparent,
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 getDynamicSizedBox(height: 5.h),
//                 getCommonToolbar(ReviewsScreenConstant.review,
//                     showBackButton: true, onClick: () {
//                   Get.back();
//                 }),
//                 getDynamicSizedBox(height: 1.h),
//                 Expanded(
//                   child: Stack(
//                     children: [
//                       RefreshIndicator(
//                           color: primaryColor,
//                           onRefresh: () {
//                             return Future.delayed(
//                               const Duration(seconds: 1),
//                               () {
//                                 controller.getReviewList(context, 0, true,
//                                     isRefress: true);
//                               },
//                             );
//                           },
//                           child: CustomScrollView(
//                             physics: const BouncingScrollPhysics(),
//                             slivers: [
//                               SliverToBoxAdapter(
//                                 child: Obx(() {
//                                   return Stack(children: [
//                                     Obx(() {
//                                       switch (controller.state.value) {
//                                         case ScreenState.apiLoading:
//                                         case ScreenState.noNetwork:
//                                         case ScreenState.noDataFound:
//                                         case ScreenState.apiError:
//                                           return SizedBox(
//                                             height: Device.height / 1.2,
//                                             child: apiOtherStates(
//                                                 controller.state.value,
//                                                 controller,
//                                                 controller.reviewList, () {
//                                               controller.getReviewList(
//                                                   context, 0, true);
//                                             }),
//                                           );
//                                         case ScreenState.apiSuccess:
//                                           return apiSuccess(
//                                               controller.state.value);
//                                         default:
//                                           Container();
//                                       }
//                                       return Container();
//                                     }),
//                                     if (controller.isLoading.value == true)
//                                       SizedBox(
//                                           height: Device.height,
//                                           width: Device.width,
//                                           child: Center(
//                                             child: ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(100),
//                                               child: Container(
//                                                 decoration: const BoxDecoration(
//                                                   shape: BoxShape.circle,
//                                                   color: white,
//                                                 ),
//                                                 height: 50,
//                                                 width: 50,
//                                                 padding:
//                                                     const EdgeInsets.all(10),
//                                                 child: LoadingAnimationWidget
//                                                     .discreteCircle(
//                                                   color: primaryColor,
//                                                   size: 35,
//                                                 ),
//                                               ),
//                                             ),
//                                           )),
//                                   ]);
//                                 }),
//                               )
//                             ],
//                           )),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Visibility(
//               visible: controller.isReviewvisible,
//               child: Positioned(
//                   bottom: 0,
//                   left: 0,
//                   right: 0,
//                   child: Container(
//                     width: Device.width,
//                     padding: EdgeInsets.only(
//                         left: 5.w, right: 5.w, top: 0.2.h, bottom: 0.2.h),
//                     decoration: BoxDecoration(
//                       color: white,
//                       boxShadow: [
//                         BoxShadow(
//                           // ignore: deprecated_member_use
//                           color: grey.withOpacity(0.5), // Shadow color
//                           spreadRadius: 5, // Spread radius
//                           blurRadius: 7, // Blur radius
//                           offset: const Offset(0,
//                               3), // Offset in the vertical direction (adjust as needed)
//                         ),
//                       ],
//                       borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(
//                               Device.screenType == sizer.ScreenType.mobile
//                                   ? 10.w
//                                   : 2.w),
//                           topRight: Radius.circular(
//                               Device.screenType == sizer.ScreenType.mobile
//                                   ? 10.w
//                                   : 2.w)),
//                     ),
//                     child: Center(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Expanded(
//                                 child: Container(
//                                   padding: EdgeInsets.only(
//                                       top: 1.5.h, bottom: 1.5.h),
//                                   child: Center(
//                                     child: RatingBar.builder(
//                                       initialRating: controller.userRating,
//                                       minRating: 1,
//                                       direction: Axis.horizontal,
//                                       allowHalfRating: true,
//                                       itemCount: 5,
//                                       itemSize: 8.w,
//                                       itemPadding: const EdgeInsets.symmetric(
//                                           horizontal: 8.0),
//                                       itemBuilder: (context, _) => const Icon(
//                                         Icons.star,
//                                         color: Colors.orange,
//                                       ),
//                                       onRatingUpdate: (rating) {
//                                         logcat("RATING", rating);
//                                         setState(() {
//                                           controller.userRating = rating;
//                                         });
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           getDivider(),
//                           getDynamicSizedBox(height: 0.5.h),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Expanded(
//                                 child: AnimatedSize(
//                                   duration: const Duration(milliseconds: 300),
//                                   child: Obx(() {
//                                     return getReactiveFormField(
//                                         node: controller.commentNode,
//                                         controller: controller.commentctr,
//                                         hintLabel: "Please Enter Review",
//                                         obscuretext: false,
//                                         isReview: true,
//                                         onChanged: (val) {
//                                           if (val!.isEmpty) {
//                                             controller.isFormInvalidate.value =
//                                                 false;
//                                           } else {
//                                             controller.isFormInvalidate.value =
//                                                 true;
//                                           }
//                                           // controller.validateComment(val);
//                                         },
//                                         inputType: TextInputType.text,
//                                         errorText: controller
//                                             .commentModel.value.error);
//                                   }),
//                                 ),
//                               ),
//                               getDynamicSizedBox(width: 3.w),
//                               Obx(
//                                 () {
//                                   return AnimatedSize(
//                                     duration:
//                                         const Duration(milliseconds: 300),
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         if (controller
//                                                 .isFormInvalidate.value ==
//                                             true) {
//                                           controller.addReviewAPI(
//                                               context, widget.businessId);
//                                           // controller.isReviewvisible = false;
//                                           setState(() {});
//                                         }
//                                       },
//                                       child: Icon(Icons.send,
//                                           size: 4.5.h,
//                                           color: controller.isFormInvalidate
//                                                       .value ==
//                                                   true
//                                               ? primaryColor
//                                               : grey),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   )),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget apiSuccess(ScreenState state) {
//     if (controller.state.value == ScreenState.apiSuccess &&
//         controller.reviewList.isNotEmpty) {
//       return Container(
//         margin: EdgeInsets.only(left: 2.w, right: 2.w, top: 1.h),
//         child: ListView.builder(
//           controller: controller.scrollController,
//           padding: EdgeInsets.only(bottom: 3.h),
//           physics: const BouncingScrollPhysics(),
//           // itemCount: controller.reviewList.length,
//           itemCount: controller.reviewList.length +
//               (controller.nextPageURL.value.isNotEmpty ? 1 : 0),
//           clipBehavior: Clip.antiAlias,
//           shrinkWrap: true,
//           itemBuilder: (context, index) {
//             if (index < controller.reviewList.length) {
//               ReviewData model = controller.reviewList[index];
//               return controller.getListItem(context, model, index);
//             } else if (controller.isFetchingMore) {
//               return Center(
//                   child: Padding(
//                       padding: EdgeInsets.symmetric(vertical: 2.h),
//                       child: const CircularProgressIndicator(
//                           color: primaryColor)));
//             } else {
//               return Container();
//             }
//           },
//         ),
//       );
//     } else {
//       return noDataFoundWidget();
//     }
//   }

//   @override
//   void dispose() {
//     controller.currentPage = 1;
//     controller.reviewList.clear();
//     super.dispose();
//   }
// }
