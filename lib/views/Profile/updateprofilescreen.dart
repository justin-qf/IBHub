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

class Updateprofilescreen extends StatefulWidget {
  const Updateprofilescreen({super.key});

  @override
  State<Updateprofilescreen> createState() => _UpdateprofilescreenState();
}

class _UpdateprofilescreenState extends State<Updateprofilescreen> {
  final Updateprofilecontroller ctr = Get.put(Updateprofilecontroller());

  @override
  void initState() {
    super.initState();
    ctr.getVerificationyApi(context); // this will call API on screen load
    ctr.getProfileData(context);
    ctr.getState(context);
  }

  // bool _isInitialized = false;
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (!_isInitialized) {
  //     ctr.getState(context); // ✅ now it's safe to use context
  //     _isInitialized = true;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Statusbar().trasparentStatusbar();
    return CustomParentScaffold(
      isExtendBodyScreen: true,
      onWillPop: () async {
        return true;
      },
      onTap: () {
        hideKeyboard(context);
      },
      body: Column(
        children: [
          getDynamicSizedBox(height: 3.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            child: getleftsidebackbtn(
              title: 'Edit Profile',
              backFunction: () {
                Get.back(result: true);
              },
            ),
          ),
          getDynamicSizedBox(height: 2.h),
          // GestureDetector(
          //   child: Obx(() {
          //     return ctr.getImage();
          //   }),
          //   onTap: () async {
          //     selectImageFromCameraOrGallery(context, cameraClick: () {
          //       ctr.actionClickUploadImageFromCamera(context, isCamera: true);
          //     }, galleryClick: () {
          //       ctr.actionClickUploadImageFromCamera(context, isCamera: false);
          //     });
          //     setState(() {});
          //   },
          // ),

          // Stack(
          //   children: [
          //     Container(
          //       decoration: BoxDecoration(
          //         shape: BoxShape.circle,
          //         border: Border.all(color: black, width: 2),
          //       ),
          //       child: ClipRRect(
          //           borderRadius: BorderRadius.circular(100),
          //           child: Obx(() {
          //             return ctr.imageFile.value != null &&
          //                     ctr.imageFile.value!.path.isNotEmpty
          //                 ? Image.file(
          //                     File(ctr.imageFile.value!.path),
          //                     height: 9.5.h,
          //                     width: 20.w,
          //                     fit: BoxFit.cover,
          //                   )
          //                 : ctr.imageURl.value
          //                         .isNotEmpty // If the URL is not empty
          //                     ? Image.network(
          //                         ctr.imageURl.value, // Use the image URL here
          //                         height: 9.5.h,
          //                         width: 20.w,
          //                         fit: BoxFit.cover,
          //                       )
          //                     : Icon(
          //                         Icons.account_circle,
          //                         size: 35.sp,
          //                       );
          //           })),
          //     ),
          //     Positioned(
          //       bottom: 4,
          //       right: 4,
          //       child: GestureDetector(
          //         onTap: () {
          //           ctr.showOptionsCupertinoDialog(context: context);
          //           setState(() {});
          //         },
          //         child: Container(
          //           decoration: BoxDecoration(
          //               color: white, borderRadius: BorderRadius.circular(50)),
          //           child: SvgPicture.asset(Asset.plus),
          //         ),
          //       ),
          //     )
          //   ],
          // ),

          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      child: Obx(() {
                        return ctr.getImage();
                      }),
                      onTap: () async {
                        selectImageFromCameraOrGallery(context,
                            cameraClick: () {
                          ctr.actionClickUploadImageFromCamera(context,
                              isCamera: true);
                        }, galleryClick: () {
                          ctr.actionClickUploadImageFromCamera(context,
                              isCamera: false);
                        });
                        setState(() {});
                      },
                    ),
                    getLable('Logo', isRequired: false),
                    getDynamicSizedBox(height: 2.h),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Personal Details :-',
                        style: TextStyle(fontFamily: dM_sans_bold),
                      ),
                    ),
                    getDynamicSizedBox(height: 1.h),
                    const Divider(),
                    Obx(() {
                      return getTextField(
                          label: SignUpConstant.nameLabel,
                          ctr: ctr.nameCtr,
                          node: ctr.nameNode,
                          model: ctr.nameModel.value,
                          function: (val) {
                            ctr.validateFields(val,
                                iscomman: true,
                                model: ctr.nameModel,
                                errorText1: SignUpConstant.namehint);
                          },
                          hint: SignUpConstant.namehint,
                          isRequired: true);
                    }),
                    Obx(
                      () {
                        return getTextField(
                            label: SignUpConstant.contactLabel,
                            ctr: ctr.phoneCtr,
                            node: ctr.phoneNode,
                            model: ctr.phoneModel.value,
                            function: (val) {
                              ctr.validateFields(
                                val,
                                isnumber: true,
                                model: ctr.phoneModel,
                                errorText1: SignUpConstant.contactNumHint,
                                errorText2: SignUpConstant.contactNumLengthHint,
                              );
                            },
                            hint: SignUpConstant.contactNumHint,
                            isNumeric: true,
                            isRequired: true);
                      },
                    ),
                    getDynamicSizedBox(height: 2.h),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Bussiness Details :-',
                        style: TextStyle(fontFamily: dM_sans_bold),
                      ),
                    ),
                    getDynamicSizedBox(height: 1.h),
                    const Divider(),
                    Obx(
                      () {
                        return getTextField(
                          label: SignUpConstant.bussinessLabel,
                          ctr: ctr.bussinessCtr,
                          node: ctr.bussinessNode,
                          model: ctr.bussinessModel.value,
                          isenable: ctr.isUserVerfied.value ? false : true,
                          isVerified: ctr.isUserVerfied.value ? true : false,
                          function: (val) {
                            ctr.validateFields(val,
                                iscomman: true,
                                model: ctr.bussinessModel,
                                errorText1: SignUpConstant.namehint);
                          },
                          hint: SignUpConstant.namehint,
                          isRequired: ctr.isUserVerfied.value ? false : true,
                        );
                      },
                    ),
                    Obx(
                      () {
                        return getTextField(
                            label: 'Website Link',
                            ctr: ctr.websiteCtr,
                            node: ctr.websiteNode,
                            model: ctr.websiteModel.value,
                            function: (val) {
                              ctr.validateFields(val,
                                  iscomman: true,
                                  model: ctr.websiteModel,
                                  errorText1: 'Enter Website Link');
                            },
                            hint: 'Enter Website Link',
                            isRequired: false);
                      },
                    ),
                    Obx(() {
                      return getTextField(
                        label: SignUpConstant.email,
                        hint: SignUpConstant.enterEmail,
                        ctr: ctr.emailCtr,
                        node: ctr.emailNode,
                        model: ctr.emailModel.value,
                        isenable: ctr.isEmailVerifed.value ? false : true,
                        isVerified: ctr.isEmailVerifed.value ? true : false,
                        function: (val) {
                          ctr.validateFields(val,
                              isemail: true,
                              model: ctr.emailModel,
                              errorText1: SignUpConstant.enterEmail,
                              errorText2: SignUpConstant.emailcontain,
                              errorText3: SignUpConstant.invalidEmailFormat);
                        },
                        isRequired: ctr.isEmailVerifed.value ? false : true,
                      );
                    }),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(() {
                            return getTextField(
                              useOnChanged: false,
                              label: SignUpConstant.stateLabel,
                              ctr: ctr.stateCtr,
                              node: ctr.stateNode,
                              model: ctr.stateModel.value,
                              hint: SignUpConstant.stateHint,
                              wantsuffix: true,
                              isenable: false,
                              isdropdown: true,
                              usegesture: true,
                              isRequired: true,
                              context: context,
                              gestureFunction: () {
                                ctr.searchStatectr.text = "";
                                showDropdownMessage(
                                    context,
                                    ctr.setStateListDialog(),
                                    SignUpConstant.stateList,
                                    isShowLoading: ctr.stateFilterList,
                                    onClick: () {
                                  ctr.applyFilter('', isState: true);
                                }, refreshClick: () {
                                  futureDelay(() {
                                    ctr.getState(context);
                                  }, isOneSecond: false);
                                });
                                ctr.unfocusAll();
                              },
                            );
                          }),
                        ),
                        getDynamicSizedBox(width: 3.w),
                        Expanded(
                          child: Obx(() {
                            return getTextField(
                              useOnChanged: false,
                              label: SignUpConstant.cityLabel,
                              ctr: ctr.cityCtr,
                              node: ctr.cityNode,
                              model: ctr.cityModel.value,
                              hint: SignUpConstant.cityHint,
                              wantsuffix: true,
                              isenable: false,
                              isdropdown: true,
                              usegesture: true,
                              isRequired: true,
                              context: context,
                              gestureFunction: () {
                                ctr.searchCityctr.text = "";
                                if (ctr.stateCtr.text.toString().isEmpty) {
                                  showDialogForScreen(
                                      context,
                                      SearchScreenConstant.stateLabel,
                                      SearchScreenConstant.pleaseSelectState,
                                      callback: () {});
                                } else {
                                  showDropdownMessage(
                                      context,
                                      ctr.setcityListDialog(),
                                      SignUpConstant.cityList,
                                      isShowLoading: ctr.cityFilterList,
                                      onClick: () {
                                    ctr.applyFilter('', isState: false);
                                  }, refreshClick: () {
                                    futureDelay(() {
                                      ctr.getCityApi(context,
                                          ctr.stateId.value.toString(), false);
                                    }, isOneSecond: false);
                                  });
                                  ctr.unfocusAll();
                                }
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                    Obx(
                      () {
                        return getTextField(
                            label: SignUpConstant.pinCodeLabel,
                            ctr: ctr.pincodeCtr,
                            node: ctr.pincodeNode,
                            model: ctr.pincodeModel.value,
                            function: (val) {
                              ctr.validateFields(
                                val,
                                isPincode: true,
                                model: ctr.pincodeModel,
                                errorText1: SignUpConstant.pinNumHint,
                                errorText2: SignUpConstant.pincodeNumLengthHint,
                              );
                            },
                            hint: SignUpConstant.pinNumHint,
                            isNumeric: true,
                            isRequired: true);
                      },
                    ),
                    Obx(
                      () {
                        return getTextField(
                            isMultipline: true,
                            label: SignUpConstant.addressLabel,
                            ctr: ctr.addressCtr,
                            node: ctr.addressNode,
                            model: ctr.addressModel.value,
                            function: (val) {
                              ctr.validateFields(val,
                                  iscomman: true,
                                  model: ctr.addressModel,
                                  errorText1: SignUpConstant.addressHint);
                            },
                            hint: SignUpConstant.addressHint,
                            isRequired: true);
                      },
                    ),
                    getDynamicSizedBox(height: 2.h),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Verification Details :-',
                        style: TextStyle(fontFamily: dM_sans_bold),
                      ),
                    ),
                    getDynamicSizedBox(height: 1.h),
                    const Divider(),
                    getDynamicSizedBox(height: 1.h),
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
                                ctr.setVerificationListDialog(),
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
                            isVerified: ctr.isUserVerfied.value ? true : false,
                            isRequired: ctr.isUserVerfied.value ? false : true),
                      ),
                    ),
                    getDynamicSizedBox(height: 0.5.h),
                    Obx(() {
                      return ctr.isUserVerfied.value == true
                          ? Container(
                              height: 7.h,
                              alignment: Alignment.centerLeft,
                              width: 100.w,
                              // margin: EdgeInsets.only(left: 2.w),
                              padding: EdgeInsets.symmetric(
                                  vertical: 1.h, horizontal: 5.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: inputBgColor),
                              child: Obx(() {
                                // ignore: unnecessary_null_comparison
                                return ctr.selectedPDFName.value != ''
                                    ? Chip(
                                        label: Text(ctr.selectedPDFName.value,
                                            style: const TextStyle(
                                                color: primaryColor,
                                                fontFamily: dM_sans_regular)),
                                        backgroundColor: white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        deleteIcon:
                                            Icon(Icons.close, size: 20.sp),
                                        onDeleted: () {
                                          // ctr.update();
                                        },
                                      )
                                    : Text(
                                        'Select Document',
                                        style: styleTextHintFieldLabel(
                                            isWhite: true),
                                      );
                              }))
                          : GestureDetector(
                              onTap: () {
                                ctr.unfocusAll();
                                selectPdfFromCameraOrGallery(context,
                                    cameraClick: () {
                                  ctr.pickImageFromGallery(context);
                                }, galleryClick: () {
                                  ctr.pickPdfFromFile(context);
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
                                      borderRadius: BorderRadius.circular(10),
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
                                            deleteIcon:
                                                Icon(Icons.close, size: 20.sp),
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
                    Obx(() {
                      return ctr.isUserVerfied.value == true
                          ? Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(top: 0.5.h, bottom: 0.5.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        ctr.downloadDocument(
                                            context, ctr.selectedPDFName.value);
                                      },
                                      child: const Text("Download Your Doc",
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontFamily: dM_sans_regular)),
                                    ),
                                    getDynamicSizedBox(width: 3.w),
                                    Icon(
                                      Icons.download_rounded,
                                      size: 2.h,
                                    )
                                  ],
                                ),
                              ),
                            )
                          : Container();
                    }),
                    getDynamicSizedBox(height: 3.h),
                    Obx(() {
                      return ctr.isloading == false
                          ? Container(
                              margin: EdgeInsets.symmetric(horizontal: 5.w),
                              child: getFormButton(context, () async {
                                if (ctr.isFormInvalidate.value == true) {
                                  ctr.updateProfile(context);
                                }
                              }, ProfileScreenConst.save,
                                  validate: ctr.isFormInvalidate.value),
                            )
                          : const CircularProgressIndicator();
                    }),
                    getDynamicSizedBox(height: 3.h)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
