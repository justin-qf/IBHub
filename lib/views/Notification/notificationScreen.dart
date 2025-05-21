// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:ibh/api_handle/apiOtherStates.dart';
// import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
// import 'package:ibh/componant/toolbar/toolbar.dart';
// import 'package:ibh/componant/widgets/widgets.dart';
// import 'package:ibh/configs/assets_constant.dart';
// import 'package:ibh/configs/colors_constant.dart';
// import 'package:ibh/configs/font_constant.dart';
// import 'package:ibh/configs/statusbar.dart';
// import 'package:ibh/controller/notificationcontroller.dart';
// import 'package:ibh/models/notificationModel.dart';
// import 'package:ibh/utils/enum.dart';
// import 'package:ibh/utils/helper.dart';
// import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
// import 'package:sizer/sizer.dart';
// import 'package:sizer/sizer.dart' as sizer;

// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({super.key});

//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {
//   final Notificationcontroller ctr = Get.put(Notificationcontroller());

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       ctr.currentPage = 1;
//       ctr.getnotificationAPi(context, ctr.currentPage, false,
//           isFirstTime: true);
//     });

//     ctr.scrollController.addListener(scrollListener);
//   }

//   void scrollListener() {
//     if (ctr.scrollController.position.pixels ==
//             ctr.scrollController.position.maxScrollExtent &&
//         ctr.nextPageURL.value.isNotEmpty &&
//         !ctr.isFetchingMore) {
//       if (!mounted) return;
//       setState(() => ctr.isFetchingMore = true);
//       ctr.currentPage++;
//       Future.delayed(
//         Duration.zero,
//         () {
//           ctr
//               .getnotificationAPi(context, ctr.currentPage, true,
//                   isFirstTime: false)
//               .whenComplete(() {
//             if (mounted) {
//               setState(() => ctr.isFetchingMore = false);
//             }
//           });
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     Statusbar().trasparentStatusbar();
//     return CustomParentScaffold(
//         isExtendBodyScreen: true,
//         isNormalScreen: true,
//         onWillPop: () async {
//           return true;
//         },
//         onTap: () {
//           hideKeyboard(context);
//         },
//         body: Scaffold(
//           backgroundColor: transparent,
//           body: Container(
//             padding: EdgeInsets.symmetric(horizontal: 3.w),
//             margin: EdgeInsets.only(
//                 left:
//                     Device.screenType == sizer.ScreenType.mobile ? 1.5.w : 1.w,
//                 right:
//                     Device.screenType == sizer.ScreenType.mobile ? 1.5.w : 1.w,
//                 top: 1.h),
//             child: Column(
//               children: [
//                 getDynamicSizedBox(height: 2.h),
//                 Container(
//                   margin: EdgeInsets.symmetric(horizontal: 1.w),
//                   child: getleftsidebackbtn(
//                     title: 'Notifications',
//                     backFunction: () {
//                       Get.back(result: true);
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: SmartRefresher(
//                     physics: const BouncingScrollPhysics(),
//                     controller: ctr.refreshController,
//                     enablePullDown: true,
//                     enablePullUp: false,
//                     header: const WaterDropMaterialHeader(
//                         backgroundColor: primaryColor, color: white),
//                     onRefresh: () async {
//                       ctr.currentPage = 1;
//                       futureDelay(() {
//                         ctr.getnotificationAPi(context, ctr.currentPage, false,
//                             isFirstTime: true);
//                       }, isOneSecond: false);
//                       ctr.refreshController.refreshCompleted();
//                     },
//                     child: CustomScrollView(
//                       controller: ctr.scrollController,
//                       physics: const BouncingScrollPhysics(),
//                       slivers: [
//                         SliverToBoxAdapter(
//                           child: Obx(() {
//                             switch (ctr.state.value) {
//                               case ScreenState.apiLoading:
//                               case ScreenState.noNetwork:
//                               case ScreenState.noDataFound:
//                               case ScreenState.apiError:
//                                 return SizedBox(
//                                     height: Device.height / 1.5,
//                                     child: apiOtherStates(ctr.state.value, ctr,
//                                         ctr.notificationDataMessages, () {
//                                       futureDelay(() {
//                                         ctr.currentPage = 1;
//                                         ctr.getnotificationAPi(
//                                             context, ctr.currentPage, false,
//                                             isFirstTime: true);
//                                       }, isOneSecond: false);
//                                       ctr.refreshController.refreshCompleted();
//                                     }));
//                               case ScreenState.apiSuccess:
//                                 return apiSuccess(ctr.state.value);
//                               default:
//                                 Container();
//                             }
//                             return Container();
//                           }),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }

//   Widget apiSuccess(ScreenState state) {
//     if (ctr.state.value == ScreenState.apiSuccess &&
//         ctr.notificationDataMessages.isNotEmpty) {
//       return ListView.builder(
//         // controller: controller.scrollController,
//         physics: const BouncingScrollPhysics(),
//         padding: EdgeInsets.only(left: 1.w, right: 1.w, top: 1.h, bottom: 3.h),
//         scrollDirection: Axis.vertical,
//         shrinkWrap: true,
//         clipBehavior: Clip.antiAlias,
//         itemCount: ctr.notificationDataMessages.length +
//             (ctr.nextPageURL.value.isNotEmpty ? 1 : 0),
//         itemBuilder: (context, index) {
//           if (index < ctr.notificationDataMessages.length) {
//             NotificationDataMessages data = ctr.notificationDataMessages[index];
//             return ctr.notificationList(context, data);
//           } else if (ctr.isFetchingMore) {
//             return Center(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(vertical: 2.h),
//                 child: const CircularProgressIndicator(color: primaryColor),
//               ),
//             );
//           } else {
//             return Container();
//           }
//         },
//       );
//     } else {
//       return noDataFoundWidget();
//     }
//   }
// }
