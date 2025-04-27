import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/componant/button/form_button.dart';
import 'package:ibh/componant/dialogs/dialogs.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/colors_constant.dart';
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
  final AddServicescreencontroller ctr = Get.put(AddServicescreencontroller());

  @override
  void initState() {
    ctr.isFromHomeScreen.value = widget.isFromHomeScreen;
    ctr.editServiceItems = widget.item;

    futureDelay(() {
      ctr.getCategory(context, '', isfromHomescreen: widget.isFromHomeScreen);

      // Only fill the data if editing an existing item
      if (ctr.editServiceItems != null && widget.isFromHomeScreen) {
        ctr.fillEditData();
      }
    }, isOneSecond: true);
    super.initState();
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
            getDynamicSizedBox(height: 5.h),
            getleftsidebackbtn(
                title: ctr.isFromHomeScreen.value
                    ? AddServiceScreenViewConst.editService
                    : AddServiceScreenViewConst.addService,
                backFunction: () {
                  Get.back(result: true);
                  ctr.resetForm();
                }),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    getDynamicSizedBox(height: 3.h),
                    Obx(() {
                      return getTextField(
                        useOnChanged: false,
                        label: ServicesScreenConstant.thumbnail,
                        ctr: ctr.thumbnailCtr,
                        node: ctr.thumbnailNode,
                        model: ctr.thumbnailModel.value,
                        hint: ServicesScreenConstant.uploadThumbnail,
                        isenable: false,
                        usegesture: true,
                        isRequired: true,
                        context: context,
                        gestureFunction: () {
                          ctr.unfocusAll();
                          ctr.showOptionsCupertinoDialog(context: context);
                        },
                      );
                    }),
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
                                errorText1:
                                    ServicesScreenConstant.servicetitle);
                          },
                          hint: ServicesScreenConstant.servicetitle,
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
                            ctr.validateFields(val,
                                iscomman: true,
                                model: ctr.descriptionModel,
                                errorText1:
                                    ServicesScreenConstant.enterDescription);
                          },
                          hint: ServicesScreenConstant.enterDescription,
                          isRequired: true);
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
                              ctr.setCategoryListDialog(),
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
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Enter keyword',
                          hintStyle: TextStyle(color: grey),
                          errorText: ctr.keywordsModel.value.error,
                          filled: true,
                          fillColor: inputBgColor,
                        ),
                        style: TextStyle(
                          color: black,
                        ),
                        onChanged: (val) {
                          ctr.validateFields(val,
                              iscomman: true,
                              model: ctr.keywordsModel,
                              errorText1: ServicesScreenConstant.enterKeyword);
                        },
                        onSubmitted: (text) {
                          if (text.trim().isNotEmpty &&
                              text.trim().length >= 3) {
                            ctr.addKeyword(text);

                            ctr.enableSubmitButton();
                          }
                        },
                      ),
                    ),
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
                                      style: TextStyle(color: primaryColor)),
                                  backgroundColor: secondaryColor,
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
                        : SizedBox.shrink()),
                    getDynamicSizedBox(height: 2.h),
                    Obx(() {
                      return ctr.isloading == false
                          ? Container(
                              margin: EdgeInsets.symmetric(horizontal: 5.w),
                              child: getFormButton(context, () async {
                                if (ctr.isFormInvalidate.value == true) {
                                  if (ctr.isFromHomeScreen.value == true) {
                                  

                                    ctr.updateServiceApi(context);
                                  } else {
                                    ctr.addServiceApi(context);
                                  }
                                }
                              },
                                  ctr.isFromHomeScreen.value
                                      ? ServicesScreenConstant.update
                                      : ServicesScreenConstant.submit,
                                  validate: ctr.isFormInvalidate.value),
                            )
                          : const CircularProgressIndicator();
                    }),
                    getDynamicSizedBox(height: 2.h),
                    if (ctr.isFromHomeScreen.value == true)
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 5.w),
                        child: getFormButton(isdelete: true, context, () async {
                          //delete api call put here

                          ctr.deleteService(context);
                        }, ServicesScreenConstant.delete, validate: true),
                      )
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
