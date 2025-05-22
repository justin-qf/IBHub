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
import 'package:ibh/controller/addservicescreenController.dart';
import 'package:ibh/models/ServiceListModel.dart';
import 'package:ibh/utils/helper.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class AddServicescreen extends StatefulWidget {
  bool isFromHomeScreen;
  ServiceDataList? item;
  AddServicescreen({super.key, this.isFromHomeScreen = false, this.item});

  @override
  State<AddServicescreen> createState() => _ServicescreenState();
}

class _ServicescreenState extends State<AddServicescreen> {
  final ctr = Get.put(AddServicescreencontroller());

  @override
  void initState() {
    ctr.isFromUpdate.value = widget.isFromHomeScreen;
    ctr.editServiceItems = widget.item;
    if (ctr.editServiceItems != null && widget.isFromHomeScreen) {
      ctr.fillEditData();
    }
    if (ctr.isFromUpdate.value == false) {
      // ctr.imageFile.value == null;
      ctr.imageURl.value = "";
      setState(() {});
    }
    futureDelay(() {
      ctr.getCategory(context, '', isfromHomescreen: widget.isFromHomeScreen);
    }, isOneSecond: false);
    super.initState();
  }

  @override
  void dispose() {
    // ctr.imageFile.value == null;
    ctr.imageURl.value = "";
    ctr.categoryId.value = "";

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Statusbar().trasparentStatusbar();
    return CustomParentScaffold(
      isExtendBodyScreen: true,
      onWillPop: () async {
        ctr.resetForm();
        return true;
      },
      onTap: () {
        hideKeyboard(context);
      },
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          children: [
            getDynamicSizedBox(height: 3.h),
            getleftsidebackbtn(
                title: ctr.isFromUpdate.value
                    ? AddServiceScreenViewConst.editService
                    : AddServiceScreenViewConst.addService,
                backFunction: () {
                  Get.back(result: true);
                  ctr.resetForm();
                }),
            getDynamicSizedBox(height: 2.h),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 5.h),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    getDynamicSizedBox(height: 3.h),
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

                    // Obx(() {
                    //   return getTextField(
                    //     useOnChanged: false,
                    //     label: ServicesScreenConstant.thumbnail,
                    //     ctr: ctr.thumbnailCtr,
                    //     node: ctr.thumbnailNode,
                    //     model: ctr.thumbnailModel.value,
                    //     hint: ServicesScreenConstant.uploadThumbnail,
                    //     isenable: false,
                    //     usegesture: true,
                    //     isRequired: true,
                    //     context: context,
                    //     gestureFunction: () {
                    //       ctr.unfocusAll();
                    //       ctr.showOptionsCupertinoDialog(context: context);
                    //     },
                    //   );
                    // }),
                    Obx(() {
                      return getTextField(
                          label: ServicesScreenConstant.service,
                          ctr: ctr.serviceTitleCtr,
                          node: ctr.serviceTitleNode,
                          model: ctr.serviceTitleModel.value,
                          function: (val) {
                            ctr.validateFields(val,
                                iscomman: true,
                                model: ctr.serviceTitleModel,
                                errorText1: 'Enter Service / Product');
                          },
                          hint: 'Enter Service / Product',
                          isRequired: true);
                    }),
                    Obx(() {
                      return getTextField(
                          isMultipline: true,
                          label: ServicesScreenConstant.description,
                          ctr: ctr.descriptionCtr,
                          node: ctr.descriptionNode,
                          model: ctr.descriptionModel.value,
                          function: (val) {
                            // ctr.validateFields(val,
                            //     iscomman: true,
                            //     model: ctr.descriptionModel,
                            //     errorText1:
                            //         ServicesScreenConstant.enterDescription);
                          },
                          hint: ServicesScreenConstant.enterDescription,
                          isRequired: false);
                    }),
                    Obx(() {
                      return getTextField(
                        useOnChanged: false,
                        label: ServicesScreenConstant.categoryLabel,
                        ctr: ctr.categoryCtr,
                        node: ctr.categoryNode,
                        model: ctr.categoryModel.value,
                        hint: SignUpConstant.categoryHint,
                        wantsuffix: true,
                        isenable: false,
                        isdropdown: true,
                        usegesture: true,
                        isRequired: true,
                        context: context,
                        gestureFunction: () {
                          ctr.searchCategoryCtr.text = "";
                          showDropdownMessage(
                              context,
                              ctr.setCategoryListDialog(
                                  isFromHomeScreen: widget.isFromHomeScreen),
                              ServicesScreenConstant.categoryListLable,
                              isShowLoading: ctr.categoryFilterList,
                              onClick: () {
                            ctr.applyFilter('');
                          }, refreshClick: () {
                            futureDelay(() {
                              ctr.getCategory(context, '');
                            }, isOneSecond: false);
                          });
                          ctr.unfocusAll();
                        },
                      );
                    }),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: getLable(AddServiceScreenViewConst.keyword,
                          isRequired: true),
                    ),
                    Obx(
                      () => TextField(
                        controller: ctr.keywordsCtr,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.redAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.redAccent),
                          ),
                          hintText: 'Enter keyword',
                          hintStyle: const TextStyle(
                              color: const Color.fromARGB(255, 145, 145, 145)),
                          errorStyle: styleTextForErrorFieldHint(),
                          errorText: ctr.keywordsModel.value.error,
                          filled: true,
                          fillColor: inputBgColor,
                        ),
                        style: const TextStyle(
                            color: black, fontFamily: dM_sans_regular),
                        onChanged: (val) {
                          ctr.validateFields(val,
                              iscomman: true,
                              model: ctr.keywordsModel,
                              errorText1: ServicesScreenConstant.enterKeyword);
                        },
                        onSubmitted: (text) {
                          if (text.trim().isEmpty) {
                            ctr.keywordsModel.update((model) {
                              model?.error = ServicesScreenConstant
                                  .enterKeyword; // "Keyword cannot be empty"
                            });
                          } else if (text.trim().length < 3) {
                            ctr.keywordsModel.update((model) {
                              model?.error =
                                  'Keyword must be at least 3 characters long';
                            });
                          } else {
                            ctr.keywordsModel.update((model) {
                              model?.error = null;
                            });
                            ctr.addKeyword(text);
                            ctr.enableSubmitButton();
                          }
                        },
                      ),
                    ),
                    // if (ctr.keywordsCtr.text == '')
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Note:Press Enter to add the keyword',
                          style: TextStyle(
                              fontFamily: dM_sans_regular, color: grey),
                        )),
                    getDynamicSizedBox(height: 2.h),
                    Obx(() => ctr.keywords.isNotEmpty
                        ? Container(
                            width: 100.w,
                            padding: EdgeInsets.symmetric(vertical: 2.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: inputBgColor),
                            child: Wrap(
                              spacing: 8.0,
                              children:
                                  ctr.keywords.asMap().entries.map((entry) {
                                final index = entry.key;
                                final chipText = entry.value;
                                return Chip(
                                  label: Text(chipText,
                                      style: const TextStyle(
                                          color: primaryColor,
                                          fontFamily: dM_sans_regular)),
                                  backgroundColor: white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  deleteIcon: Icon(Icons.close, size: 20.sp),
                                  onDeleted: () {
                                    ctr.keywords.removeAt(index);
                                    ctr.enableSubmitButton();
                                    ctr.update();
                                  },
                                );
                              }).toList(),
                            ),
                          )
                        : const SizedBox.shrink()),
                    getDynamicSizedBox(height: 2.h),
                    Obx(() {
                      return ctr.isloading == false
                          ? Container(
                              margin: EdgeInsets.symmetric(horizontal: 5.w),
                              child: getFormButton(context, () async {
                                if (ctr.isFormInvalidate.value == true) {
                                  if (ctr.isFromUpdate.value == true) {
                                    ctr.addUpdateServiceApi(context, false);
                                  } else {
                                    ctr.addUpdateServiceApi(context, true);
                                  }
                                }
                              },
                                  ctr.isFromUpdate.value
                                      ? ServicesScreenConstant.update
                                      : ServicesScreenConstant.submit,
                                  validate: ctr.isFormInvalidate.value),
                            )
                          : const CircularProgressIndicator();
                    }),
                    getDynamicSizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
