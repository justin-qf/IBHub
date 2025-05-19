// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ibh/componant/button/form_button.dart';
// import 'package:ibh/componant/dialogs/dialogs.dart';
// import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
// import 'package:ibh/componant/toolbar/toolbar.dart';
// import 'package:ibh/componant/widgets/widgets.dart';
// import 'package:ibh/configs/colors_constant.dart';
// import 'package:ibh/configs/statusbar.dart';
// import 'package:ibh/configs/string_constant.dart';
// import 'package:ibh/controller/contactUsController.dart';
// import 'package:ibh/utils/helper.dart';
// import 'package:ibh/utils/log.dart';
// import 'package:sizer/sizer.dart';
// import 'package:sizer/sizer.dart' as sizer;

// class Contactus extends StatefulWidget {
//   const Contactus({super.key});

//   @override
//   State<Contactus> createState() => _ContactusState();
// }

// class _ContactusState extends State<Contactus> {
//   final Contactuscontroller ctr = Get.put(Contactuscontroller());

//   @override
//   void initState() {
//     super.initState();
//     ctr.getprofile(context);
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
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   getDynamicSizedBox(height: 2.h),
//                   Container(
//                     margin: EdgeInsets.symmetric(horizontal: 1.w),
//                     child: getleftsidebackbtn(
//                       title: 'Contact Us',
//                       backFunction: () {
//                         Get.back(result: true);
//                       },
//                     ),
//                   ),
//                   getDynamicSizedBox(height: 2.h),
//                   Center(
//                     child: GestureDetector(
//                       child: Obx(() {
//                         return ctr.getImage();
//                       }),
//                       onTap: () async {
//                         selectImageFromCameraOrGallery(context,
//                             cameraClick: () {
//                           ctr.actionClickUploadImageFromCamera(context,
//                               isCamera: true);
//                         }, galleryClick: () {
//                           ctr.actionClickUploadImageFromCamera(context,
//                               isCamera: false);
//                         });
//                         setState(() {});
//                       },
//                     ),
//                   ),
//                   getLable('Upload Image', isRequired: false),
//                   Obx(() {
//                     return getTextField(
//                         label: SignUpConstant.nameLabel,
//                         ctr: ctr.nameCtr,
//                         node: ctr.nameNode,
//                         model: ctr.nameModel.value,
//                         function: (val) {
//                           ctr.validateFields(val,
//                               iscomman: true,
//                               model: ctr.nameModel,
//                               errorText1: 'Enter Contact Name');
//                         },
//                         hint: 'Enter Contact Name',
//                         isRequired: true);
//                   }),
//                   Obx(
//                     () {
//                       return getTextField(
//                           label: SignUpConstant.contactLabel,
//                           ctr: ctr.phoneCtr,
//                           node: ctr.phoneNode,
//                           model: ctr.phoneModel.value,
//                           function: (val) {
//                             ctr.validateFields(
//                               val,
//                               isnumber: true,
//                               model: ctr.phoneModel,
//                               errorText1: SignUpConstant.contactNumHint,
//                               errorText2: SignUpConstant.contactNumLengthHint,
//                             );
//                           },
//                           hint: SignUpConstant.contactNumHint,
//                           isNumeric: true,
//                           isRequired: true);
//                     },
//                   ),
//                   Obx(() {
//                     return getTextField(
//                       label: SignUpConstant.email,
//                       hint: SignUpConstant.enterEmail,
//                       ctr: ctr.emailCtr,
//                       node: ctr.emailNode,
//                       model: ctr.emailModel.value,
//                       function: (val) {
//                         ctr.validateFields(val,
//                             isemail: true,
//                             model: ctr.emailModel,
//                             errorText1: SignUpConstant.enterEmail,
//                             errorText2: SignUpConstant.emailcontain,
//                             errorText3: SignUpConstant.invalidEmailFormat);
//                       },
//                       isRequired: true,
//                     );
//                   }),
//                   Obx(
//                     () {
//                       return getTextField(
//                           isMultipline: true,
//                           label: 'Message',
//                           ctr: ctr.messageCtr,
//                           node: ctr.messageNode,
//                           model: ctr.messageModel.value,
//                           function: (val) {
//                             ctr.validateFields(val,
//                                 iscomman: true,
//                                 model: ctr.messageModel,
//                                 errorText1: 'Enter Message');
//                           },
//                           hint: 'Enter Message',
//                           isRequired: true);
//                     },
//                   ),
//                   getDynamicSizedBox(height: 4.h),
//                   Obx(() {
//                     return getFormButton(context, () async {
//                       if (ctr.isFormInvalidate.value == true) {
//                         logcat('Priniting', 'Submit');
//                       }
//                     }, 'Submit', validate: ctr.isFormInvalidate.value);
//                   }),
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }
// }
