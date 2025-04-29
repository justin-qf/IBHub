// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:ibh/componant/button/form_button.dart';
// import 'package:ibh/componant/dialogs/dialogs.dart';
// import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
// import 'package:ibh/componant/toolbar/toolbar.dart';
// import 'package:ibh/componant/widgets/widgets.dart';
// import 'package:ibh/configs/assets_constant.dart';
// import 'package:ibh/configs/colors_constant.dart';
// import 'package:ibh/configs/font_constant.dart';
// import 'package:ibh/configs/statusbar.dart';
// import 'package:ibh/configs/string_constant.dart';
// import 'package:ibh/controller/addservicescreenController.dart';
// import 'package:ibh/utils/helper.dart';
// import 'package:sizer/sizer.dart';

// class AddServicescreen extends StatefulWidget {
//   const AddServicescreen({super.key});

//   @override
//   State<AddServicescreen> createState() => _ServicescreenState();
// }

// class _ServicescreenState extends State<AddServicescreen> {
//   final AddServicescreencontroller ctr = Get.put(AddServicescreencontroller());

//   @override
//   Widget build(BuildContext context) {
//     Statusbar().trasparentStatusbar();
//     return CustomParentScaffold(
//       isExtendBodyScreen: true,
//       onWillPop: () async {
//         return true;
//       },
//       onTap: () {
//         hideKeyboard(context);
//       },
//       body: Container(
//         padding: EdgeInsets.symmetric(horizontal: 5.w),
//         child: Column(
//           children: [
//             getDynamicSizedBox(height: 2.h),
//             SafeArea(
//               child: getleftsidebackbtn(
//                   title: 'Add Service',
//                   backFunction: () {
//                     Get.back(result: true);
//                   }),

//               // Align(
//               //   alignment: Alignment.centerLeft,
//               //   child: GestureDetector(
//               //       onTap: () {
//               //         Get.back(result: true);
//               //         ctr.resetForm();
//               //         ctr.unfocusAll();
//               //       },
//               //       child: SvgPicture.asset(Asset.arrowBack,

//               //           // ignore: deprecated_member_use
//               //           color: black,
//               //           height: 4.h)),
//               // ),
//               // Row(
//               //   mainAxisAlignment: MainAxisAlignment.start,
//               //   children: [

//               //     Text(
//               //       'Create Your Account',
//               //       style: TextStyle(fontFamily: dM_sans_bold, fontSize: 20.sp),
//               //     ),
//               //   ],
//               // ),
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 physics: BouncingScrollPhysics(),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     getDynamicSizedBox(height: 5.h),
//                     // // Align(
//                     // //   alignment: Alignment.centerLeft,
//                     // //   child: Text(
//                     // //     'Add Service',
//                     // //     style: TextStyle(
//                     // //         fontFamily: dM_sans_bold,
//                     // //         fontSize: 24.sp,
//                     // //         height: 1.1),
//                     // //   ),
//                     // // ),
//                     // getDynamicSizedBox(height: 2.h),
//                     // // Align(
//                     // //   alignment: Alignment.centerLeft,
//                     // //   child: Text(
//                     // //     'Don’t just wait for opportunity — create it.\nAdd your services and take the lead.',
//                     // //     style: TextStyle(
//                     // //         fontFamily: dM_sans_semiBold, color: grey),
//                     // //   ),
//                     // // ),
//                     // getDynamicSizedBox(height: 4.h),
//                     Obx(() {
//                       return getTextField(
//                           label: ServicesScreenConstant.service,
//                           ctr: ctr.serviceTitleCtr,
//                           node: ctr.serviceTitleNode,
//                           model: ctr.serviceTitleModel.value,
//                           function: (val) {
//                             ctr.validateFields(val,
//                                 iscomman: true,
//                                 model: ctr.serviceTitleModel,
//                                 errorText1:
//                                     ServicesScreenConstant.servicetitle);
//                           },
//                           hint: ServicesScreenConstant.servicetitle,
//                           isRequired: true);
//                     }),
//                     Obx(() {
//                       return getTextField(
//                           label: ServicesScreenConstant.description,
//                           ctr: ctr.descriptionCtr,
//                           node: ctr.descriptionNode,
//                           model: ctr.descriptionModel.value,
//                           function: (val) {
//                             ctr.validateFields(val,
//                                 iscomman: true,
//                                 model: ctr.descriptionModel,
//                                 errorText1:
//                                     ServicesScreenConstant.enterDescription);
//                           },
//                           hint: ServicesScreenConstant.enterDescription,
//                           isRequired: true);
//                     }),
//                     Obx(() {
//                       return getTextField(
//                           label: ServicesScreenConstant.keyword,
//                           ctr: ctr.keywordsCtr,
//                           node: ctr.keywordsNode,
//                           model: ctr.keywordsModel.value,
//                           function: (val) {
//                             ctr.validateFields(val,
//                                 iscomman: true,
//                                 model: ctr.keywordsModel,
//                                 errorText1:
//                                     ServicesScreenConstant.enterKeyword);
//                           },
//                           hint: ServicesScreenConstant.enterKeyword,
//                           isRequired: true);
//                     }),

//                     Obx(() {
//                       return getTextField(
//                         useOnChanged: false,
//                         label: SignUpConstant.categoryLabel,
//                         ctr: ctr.categoryCtr,
//                         node: ctr.categoryNode,
//                         model: ctr.categoryModel.value,
//                         hint: SignUpConstant.stateHint,
//                         wantsuffix: true,
//                         isenable: false,
//                         isdropdown: true,
//                         usegesture: true,
//                         isRequired: true,
//                         context: context,
//                         gestureFunction: () {
//                           ctr.searchCategoryCtr.text = "";
//                           ctr.getCategory(context,);
//                           showDropdownMessage(
//                               context,
//                               ctr.setCategoryListDialog(),
//                               SignUpConstant.stateList,
//                               isShowLoading: ctr.categoryFilterList,
//                               onClick: () {
//                             ctr.applyFilter('');
//                           }, refreshClick: () {
//                             futureDelay(() {
//                               ctr.getCategory(context);
//                             }, isOneSecond: false);
//                           });
//                           ctr.unfocusAll();
//                           // ctr.showSubjectSelectionPopups(context);
//                         },
//                       );
//                     }),
//                     // Obx(() {
//                     //   return getTextField(
//                     //       label: ServicesScreenConstant.category,
//                     //       ctr: ctr.categoryCtr,
//                     //       node: ctr.categoryNode,
//                     //       model: ctr.categoryModel.value,
//                     //       function: (val) {
//                     //         ctr.validateFields(val,
//                     //             iscomman: true,
//                     //             model: ctr.categoryModel,
//                     //             errorText1:
//                     //                 ServicesScreenConstant.selectCategory);
//                     //       },
//                     //       hint: ServicesScreenConstant.selectCategory,
//                     //       isRequired: true);
//                     // }),
//                     Obx(() {
//                       return getTextField(
//                         useOnChanged: false,
//                         label: ServicesScreenConstant.thumbnail,
//                         ctr: ctr.thumbnailCtr,
//                         node: ctr.thumbnailNode,
//                         model: ctr.thumbnailModel.value,
//                         hint: ServicesScreenConstant.uploadThumbnail,
//                         isenable: false,
//                         usegesture: true,
//                         isRequired: true,
//                         context: context,
//                         gestureFunction: () {
//                           ctr.unfocusAll();
//                           ctr.showOptionsCupertinoDialog(context: context);

//                           // ctr.showSubjectSelectionPopups(context);
//                         },
//                       );
//                     }),
//                     getDynamicSizedBox(height: 2.h),
//                     Obx(() {
//                       return ctr.isloading == false
//                           ? Container(
//                               margin: EdgeInsets.symmetric(horizontal: 5.w),
//                               child: getFormButton(context, () async {
//                                 if (ctr.isFormInvalidate.value == true) {
//                                   ctr.submitServiceAPI(
//                                     context,
//                                   );
//                                   // ctr.validateLogin(context);
//                                 }
//                               }, ServicesScreenConstant.submit,
//                                   validate: ctr.isFormInvalidate.value),
//                             )
//                           : CircularProgressIndicator();
//                     }),
//                     // Obx(() {
//                     //   return getTextField(
//                     //       label: ServicesScreenConstant.thumbnail,
//                     //       ctr: ctr.thumbnailCtr,
//                     //       node: ctr.thumbnailNode,
//                     //       model: ctr.thumbnailModel.value,
//                     //       function: (val) {
//                     //         ctr.validateFields(val,
//                     //             iscomman: true,
//                     //             model: ctr.thumbnailModel,
//                     //             errorText1:
//                     //                 ServicesScreenConstant.uploadThumbnail);
//                     //       },
//                     //       hint: ServicesScreenConstant.uploadThumbnail,
//                     //       isRequired: true);
//                     // }),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
