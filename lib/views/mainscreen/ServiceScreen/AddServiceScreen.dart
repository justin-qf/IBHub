import 'package:advanced_chips_input/advanced_chips_input.dart';
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
import 'package:ibh/utils/helper.dart';
import 'package:sizer/sizer.dart';

class AddServicescreen extends StatefulWidget {
  const AddServicescreen({super.key});

  @override
  State<AddServicescreen> createState() => _ServicescreenState();
}

class _ServicescreenState extends State<AddServicescreen> {
  final AddServicescreencontroller ctr = Get.put(AddServicescreencontroller());

  @override
  void initState() {
    futureDelay(() {
      ctr.getCategory(context, '');
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
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          children: [
            getDynamicSizedBox(height: 5.h),
            getleftsidebackbtn(
                title: 'Add Service',
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

                          // ctr.showSubjectSelectionPopups(context);
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
                      child: getLable('Keywords', isRequired: true),
                    ),
                    AdvancedChipsInput(
                      onChanged: (val) {
                        ctr.validateFields(val,
                            iscomman: true,
                            model: ctr.keywordsModel,
                            errorText1: ServicesScreenConstant.enterKeyword);
                      },
                      separatorCharacter: ',',
                      placeChipsSectionAbove: true,
                      widgetContainerDecoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      chipContainerDecoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      chipTextStyle: TextStyle(color: primaryColor),
                      validateInput: true,
                      onSubmitted: (text) {
                        ctr.addKeyword(text);
                        print('${ctr.keywords.length}');
                        print(ctr.keywords);
                      },
                      validateInputMethod: (value) {
                        if (value.length < 3) {
                          return 'Input should be at least 3 characters long';
                        }
                        return null;
                      },
                      deleteIcon: Icon(
                        Icons.close,
                        size: 20.sp,
                      ),
                      eraseKeyLabel: 'erase',
                      onChipDeleted: (chipText, index) {
                        print('Before deletion: ${ctr.keywords}');

                        if (index >= 0 && index < ctr.keywords.length) {
                          // Remove only by index — this is sufficient
                          ctr.keywords.removeAt(index);
                        }
                        ctr.enableSubmitButton();

                        print('After deletion: ${ctr.keywords}');
                      },
                    ),

                    // Obx(() {
                    //   return Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       getTextField(
                    //         label: ServicesScreenConstant.keyword,
                    //         ctr: ctr.keywordsCtr,
                    //         node: ctr.keywordsNode,
                    //         model: ctr.keywordsModel.value,
                    //         wantsuffix: true,
                    //         isAdd: true,
                    //         onAddBtn: () {
                    //           print('call');
                    //           if (ctr.keywordsCtr.text.isNotEmpty) {
                    //             ctr.addKeyword(ctr.keywordsCtr.text);
                    //           }
                    //         },
                    //         function: (val) {
                    //           // ctr.validateFields(val,
                    //           //     iscomman: true,
                    //           //     model: ctr.keywordsModel,
                    //           //     errorText1:
                    //           //         ServicesScreenConstant.enterKeyword);
                    //         },
                    //         hint: ServicesScreenConstant.enterKeyword,
                    //         isRequired: true,
                    //         context: context,
                    //       ),
                    //       getDynamicSizedBox(height: 1.h), // Add some spacing
                    //       Obx(() => Wrap(
                    //             spacing: 8.0,
                    //             runSpacing: 4.0,
                    //             children: ctr.keywords
                    //                 .map((keyword) => Chip(
                    //                       label: Text(keyword,
                    //                           style: TextStyle(
                    //                             fontSize: 14,
                    //                             color: isDarkMode()
                    //                                 ? Colors.white
                    //                                 : Colors.black,
                    //                           )),
                    //                       deleteIcon:
                    //                           Icon(Icons.close, size: 18),
                    //                       onDeleted: () {
                    //                         ctr.removeKeyword(keyword);
                    //                       },
                    //                       backgroundColor: Colors.grey[200],
                    //                       shape: RoundedRectangleBorder(
                    //                         borderRadius:
                    //                             BorderRadius.circular(10),
                    //                         side: BorderSide(
                    //                           color: Colors.grey[400]!,
                    //                           width: 0.5,
                    //                         ),
                    //                       ),
                    //                     ))
                    //                 .toList(),
                    //           )),
                    //     ],
                    //   );
                    // }),
                    // Obx(() {
                    //   return getTextField(
                    //       label: ServicesScreenConstant.keyword,
                    //       ctr: ctr.keywordsCtr,
                    //       node: ctr.keywordsNode,
                    //       model: ctr.keywordsModel.value,
                    //       wantsuffix: true,
                    //       isAdd: true,
                    //       onAddBtn: () {
                    //         ctr.addKeyword(ctr.keywordsCtr.text);

                    //         print('${ctr.keywords}');
                    //       },
                    //       function: (val) {
                    //         ctr.validateFields(val,
                    //             iscomman: true,
                    //             model: ctr.keywordsModel,
                    //             errorText1:
                    //                 ServicesScreenConstant.enterKeyword);
                    //       },
                    //       hint: ServicesScreenConstant.enterKeyword,
                    //       isRequired: true);
                    // }),
                    getDynamicSizedBox(height: 2.h),
                    Obx(() {
                      return ctr.isloading == false
                          ? Container(
                              margin: EdgeInsets.symmetric(horizontal: 5.w),
                              child: getFormButton(context, () async {
                                if (ctr.isFormInvalidate.value == true) {
                                  ctr.addServiceApi(context);
                                }
                              }, ServicesScreenConstant.submit,
                                  validate: ctr.isFormInvalidate.value),
                            )
                          : const CircularProgressIndicator();
                    }),
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
