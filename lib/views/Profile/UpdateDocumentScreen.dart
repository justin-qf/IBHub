// import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/componant/button/form_button.dart';
import 'package:ibh/componant/dialogs/dialogs.dart';
import 'package:ibh/componant/input/style.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/updateProfileController.dart';
import 'package:ibh/utils/helper.dart';
import 'package:ibh/utils/log.dart';
import 'package:sizer/sizer.dart';

class UpdateDocumentScreen extends StatefulWidget {
  final int index;
  const UpdateDocumentScreen({super.key, required this.index});

  @override
  State<UpdateDocumentScreen> createState() => _UpdateDocumentScreenState();
}

class _UpdateDocumentScreenState extends State<UpdateDocumentScreen> {
  final Updateprofilecontroller ctr = Get.put(Updateprofilecontroller());

  @override
  void initState() {
    super.initState();
    // ctr.getVerificationyApi(context); // this will call API on screen load
    // // ctr.getCategory(context);
    // ctr.getProfileData(context);
    // ctr.getState(context);
  }

  @override
  Widget build(BuildContext context) {
    Statusbar().trasparentStatusbar();
    return CustomParentScaffold(
      isExtendBodyScreen: true,
      // resizeToAvoidBottomInset: false,
      isNormalScreen: true,
      onWillPop: () async {
        return true;
      },
      onTap: () {
        hideKeyboard(context);
      },
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 6.w, right: 6.w),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context)
                          .viewInsets
                          .bottom, // Adjust for keyboard
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: Text(
                        //     'Bussiness Details :-',
                        //     style:
                        //         TextStyle(fontFamily: dM_sans_bold),
                        //   ),
                        // ),
                        // getDynamicSizedBox(height: 1.h),
                        // const Divider(),

                        // Text('data'),
                        Obx(() {
                          return getTextField(
                            useOnChanged: false,
                            label: 'Verification Type',
                            ctr: ctr.verificationCtr,
                            node: ctr.verificationNode,
                            model: ctr.verificationModel.value,
                            hint: 'Select Document Type',
                            wantsuffix: true,
                            isenable: false,
                            isVerified: ctr.isUserVerfied.value ? true : false,
                            isdropdown: true,
                            usegesture: true,
                            isRequired: ctr.isUserVerfied.value ? false : true,
                            context: context,
                            gestureFunction: () {
                              logcat("isUserVerfied::",
                                  ctr.isUserVerfied.value.toString());
                              if (ctr.isUserVerfied.value == false) {
                                ctr.unfocusAll();
                                showDropdownMessage(
                                    context,
                                    ctr.setVerificationListDialog(
                                        validateIndex: widget.index),
                                    'Verification Type',
                                    isShowLoading: ctr.verificationList,
                                    onClick: () {
                                  ctr.applyFilter('', isState: false);
                                }, refreshClick: () {
                                  futureDelay(() {
                                    ctr.getVerificationyApi(context);
                                  }, isOneSecond: false);
                                });
                              }
                            },
                          );
                        }),
                        Obx(
                          () => Align(
                            alignment: Alignment.centerLeft,
                            child: getLable('Document',
                                isVerified:
                                    ctr.isUserVerfied.value ? true : false,
                                isRequired:
                                    ctr.isUserVerfied.value ? false : true),
                          ),
                        ),
                        getDynamicSizedBox(height: 0.5.h),
                        Obx(() {
                          return ctr.isUserVerfied.value == true
                              ? SizedBox.shrink()

                              // Container(
                              //     height: 7.h,
                              //     alignment: Alignment.centerLeft,
                              //     width: 100.w,
                              //     // margin: EdgeInsets.only(left: 2.w),
                              //     padding: EdgeInsets.symmetric(
                              //         vertical: 1.h, horizontal: 5.w),
                              //     decoration: BoxDecoration(
                              //         borderRadius: BorderRadius.circular(10),
                              //         color: inputBgColor),
                              //     child: Obx(() {
                              //       // ignore: unnecessary_null_comparison
                              //       return ctr.selectedPDFName.value != ''
                              //           ? Chip(
                              //               label: Text(
                              //                   ctr.selectedPDFName.value,
                              //                   style: const TextStyle(
                              //                       color: primaryColor,
                              //                       fontFamily:
                              //                           dM_sans_regular)),
                              //               backgroundColor: white,
                              //               shape: RoundedRectangleBorder(
                              //                 borderRadius:
                              //                     BorderRadius.circular(10),
                              //               ),
                              //               deleteIcon:
                              //                   Icon(Icons.close, size: 20.sp),
                              //               onDeleted: () {
                              //                 // ctr.update();
                              //               },
                              //             )
                              //           : Text(
                              //               'Select Document',
                              //               style: styleTextHintFieldLabel(
                              //                   isWhite: true),
                              //             );
                              //     }))
                              : GestureDetector(
                                  onTap: () {
                                    ctr.unfocusAll();
                                    selectPdfFromCameraOrGallery(context,
                                        cameraClick: () {
                                      ctr.pickImageFromGallery(context,
                                          validateIndex: widget.index);
                                    }, galleryClick: () {
                                      ctr.pickPdfFromFile(context,
                                          validateIndex: widget.index);
                                    });
                                  },
                                  child: Container(
                                      height: 7.h,
                                      alignment: Alignment.centerLeft,
                                      width: 100.w,
                                      // margin: EdgeInsets.only(left: 2.w),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 1.h, horizontal: 5.w),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: inputBgColor),
                                      child: Obx(() {
                                        // ignore: unnecessary_null_comparison
                                        return ctr.selectedPDFName.value != ''
                                            ? Chip(
                                                label: Text(
                                                    ctr.selectedPDFName.value,
                                                    style: const TextStyle(
                                                        color: primaryColor,
                                                        fontFamily:
                                                            dM_sans_regular)),
                                                backgroundColor: white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                deleteIcon: Icon(Icons.close,
                                                    size: 20.sp),
                                                onDeleted: () {
                                                  ctr.clearpdf();
                                                  ctr.update();
                                                },
                                              )
                                            : Text(
                                                'Select Document',
                                                style: styleTextHintFieldLabel(
                                                    isWhite: true),
                                              );
                                      })),
                                );
                        }),
                        if (ctr.isUserVerfied.value == true)
                          getDynamicSizedBox(height: 1.h),
                        Obx(() {
                          return ctr.isUserVerfied.value == true
                              ? GestureDetector(
                                  onTap: () {
                                    // print(
                                    //     'selected pdf:${ctr.selectedPDFName}');
                                    ctr.downloadDocument(
                                        context, ctr.selectedPDFName.value);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: black,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    padding: EdgeInsets.all(15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text("Download Your Document",
                                            style: TextStyle(
                                                color: white,
                                                fontFamily: dM_sans_semiBold)),
                                        getDynamicSizedBox(width: 3.w),
                                        Icon(
                                          Icons.download_rounded,
                                          size: 2.h,
                                          color: white,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : Container();
                        }),
                        // getDynamicSizedBox(height: 4.h),
                        getDynamicSizedBox(height: 3.h),

                        ctr.isUserVerfied.value == true
                            ? SizedBox.shrink()
                            : Obx(() {
                                return getFormButton(context, () async {
                                  if (ctr.isUserVerfied.value == true
                                      ? false
                                      : ctr.is1FormInvalidate.value == true) {
                                    // print('bussines api called');

                                    if (ctr.isVerificationDataEmpty.value ==
                                        true) {
                                      // print('verification api called:create');
                                      ctr.updateDocumentation(
                                          isempty: true, context);
                                    } else {
                                      // print('verification api called:update');
                                      ctr.updateDocumentation(context,
                                          isempty: false);
                                    }
                                  }

                                  //  else if (ctr.StepperValue == 1) {
                                  //   print(
                                  //       'verification ctr value is:${ctr.verificationCtr.text}');
                                  //   print(
                                  //       'selectd pdfn ame is:${ctr.selectedPDFName.value}');

                                  //   if (ctr.isVerificationDataEmpty.value == true) {
                                  //     print('verification api called:create');
                                  //     ctr.updateDocumentation(isempty: true, context);
                                  //   } else {
                                  //     print('verification api called:update');
                                  //     ctr.updateDocumentation(context, isempty: false);
                                  //   }

                                  //   // details.onStepContinue
                                  //   //     ?.call();
                                  // }
                                }, 'Update',
                                    validate: ctr.isUserVerfied.value == true
                                        ? false
                                        : ctr.is1FormInvalidate.value);
                              }),

                        getDynamicSizedBox(height: 4.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
