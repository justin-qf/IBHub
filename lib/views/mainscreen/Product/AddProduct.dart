import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/componant/button/form_button.dart';
import 'package:ibh/componant/dialogs/dialogs.dart';
import 'package:ibh/componant/input/form_inputs.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/addProductScreenController.dart';
import 'package:ibh/models/FormFieldModel.dart';
import 'package:ibh/models/sign_in_form_validation.dart';
import 'package:ibh/utils/helper.dart';
import 'package:ibh/utils/log.dart';
import 'package:sizer/sizer.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  var ctr = Get.put(AddProductScreencontroller());

  @override
  void initState() {
    super.initState();
    ctr.getCategoryApi(context);
    addField();
  }

  void addField() {
    ctr.formFields.add(FormFieldModel(
      textValue: '',
      specificationCtr: TextEditingController(),
      reportTypeId: RxList<String>(),
    ));
    ctr.isAddBtnVisibler.value = false;
    ctr.specificationValidationModels.add(Rx(ValidationModel('', null)));
    ctr.storeSpecification.add(""); // prepare for the new index
    // Initialize showAddMoreButtonList based on the initial conditions.
    ctr.showAddMoreButtonList = ctr.formFields.map((field) {
      return field.specificationCtr.text.toString().isNotEmpty == true;
    }).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Statusbar().trasparentStatusbar();
    return CustomParentScaffold(
      isExtendBodyScreen: true,
      onWillPop: () async {
        ctr.resetForm();
        ctr.unfocusAll();
        return true;
      },
      onTap: () {
        hideKeyboard(context);
      },
      body: Column(
        children: [
          getDynamicSizedBox(height: 4.h),
          Container(
            margin: EdgeInsets.only(left: 5.w),
            child: getleftsidebackbtn(
                title: AddProductConstant.title,
                backFunction: () {
                  Get.back(result: true);
                  ctr.resetForm();
                  ctr.unfocusAll();
                },
                istitle: true),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 3.h),
              physics: const BouncingScrollPhysics(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Obx(() {
                      return getTextField(
                        label: AddProductConstant.productImageLable,
                        hint: AddProductConstant.productImageHint,
                        ctr: ctr.productImageCtr,
                        node: ctr.productImageNode,
                        model: ctr.productImageModel.value,
                        isenable: false,
                        wantsuffix: true,
                        useOnChanged: false,
                        isdropdown: true,
                        usegesture: true,
                        isRequired: true,
                        context: context,
                        gestureFunction: () {
                          selectImageFromCameraOrGallery(context,
                              //     cameraClick: () {
                              //   ctr.actionClickUploadImageFromCamera(context,
                              //       isCamera: true);
                              // },
                              galleryClick: () {
                            ctr.selectMultipleImagesFromGallery();
                          });
                          setState(() {});
                        },
                        function: (val) {
                          ctr.validateFields(
                            val,
                            iscomman: true,
                            model: ctr.productImageModel,
                            errorText1: AddProductConstant.productImageHint,
                          );
                        },
                      );
                    }),
                    Obx(() {
                      final images = ctr.uploadMorePrescriptionFile;
                      if (images.isEmpty) {
                        return const SizedBox.shrink(); // hide UI if no images
                      }
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: images.map((file) {
                            return ctr.buildImagePreview(file, () {
                              ctr.uploadMorePrescriptionFile.remove(file);
                              ctr.update();
                            });
                          }).toList(),
                        ),
                      );
                    }),
                    // GestureDetector(
                    //   child: Obx(() {
                    //     return ctr.getImage();
                    //   }),
                    //   onTap: () async {
                    //     selectImageFromCameraOrGallery(context,
                    //         cameraClick: () {
                    //       ctr.actionClickUploadImageFromCamera(context,
                    //           isCamera: true);
                    //     }, galleryClick: () {
                    //       ctr.actionClickUploadImageFromCamera(context,
                    //           isCamera: false);
                    //     });
                    //     setState(() {});
                    //   },
                    // ),
                    Obx(() {
                      return getTextField(
                        label: AddProductConstant.productNameLable,
                        hint: AddProductConstant.productNameHint,
                        ctr: ctr.nameCtr,
                        node: ctr.nameNode,
                        model: ctr.nameModel.value,
                        isenable: true,
                        function: (val) {
                          ctr.validateFields(
                            val,
                            iscomman: true,
                            model: ctr.nameModel,
                            errorText1: AddProductConstant.productNameHint,
                          );
                        },
                        isRequired: true,
                      );
                    }),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: getLable(
                                    SearchScreenConstant.categoryLabel,
                                    isFromRetailer: false),
                              ),
                              Obx(() {
                                return getReactiveFormField(
                                  node: ctr.categoryNode,
                                  controller: ctr.categoryCtr,
                                  hintLabel:
                                      SearchScreenConstant.selectCategoryHint,
                                  onChanged: (val) {},
                                  onTap: () {
                                    ctr.searchCategoryctr.text = "";
                                    showDropdownMessage(
                                      context,
                                      ctr.setCategoryListDialog(),
                                      SearchScreenConstant.categoryList,
                                      isShowLoading: ctr.categoryFilterList,
                                      onClick: () {
                                        ctr.applyCategoryFilter('');
                                      },
                                      refreshClick: () {
                                        ctr.searchCategoryctr.text = "";
                                        futureDelay(() {
                                          ctr.getCategoryApi(context);
                                        }, isOneSecond: false);
                                      },
                                    );
                                  },
                                  isReadOnly: true,
                                  wantSuffix: true,
                                  isdown: true,
                                  isEnable: true,
                                  inputType: TextInputType.none,
                                  errorText: ctr.categoryModel.value.error,
                                );
                              }),
                            ],
                          ),
                        ),
                        getDynamicSizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: getLable(AddProductConstant.serviceLable,
                                    isFromRetailer: false),
                              ),
                              Obx(() {
                                return getReactiveFormField(
                                  node: ctr.serviceNode,
                                  controller: ctr.serviceCtr,
                                  hintLabel: AddProductConstant.serviceHint,
                                  onChanged: (val) {},
                                  onTap: () {
                                    ctr.searchServicectr.text = "";
                                    showDropdownMessage(
                                      context,
                                      ctr.setServiceListDialog(),
                                      AddProductConstant.serviceListHint,
                                      isShowLoading: ctr.categoryFilterList,
                                      onClick: () {
                                        ctr.applyCategoryFilter('');
                                      },
                                      refreshClick: () {
                                        ctr.searchServicectr.text = "";
                                        futureDelay(() {
                                          ctr.getCategoryApi(context);
                                        }, isOneSecond: false);
                                      },
                                    );
                                  },
                                  isReadOnly: true,
                                  wantSuffix: true,
                                  isdown: true,
                                  isEnable: true,
                                  inputType: TextInputType.none,
                                  errorText: ctr.serviceModel.value.error,
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Align(
                    //   alignment: Alignment.topLeft,
                    //   child: getLable(SearchScreenConstant.categoryLabel,
                    //       isFromRetailer: false),
                    // ),
                    // Obx(() {
                    //   return getReactiveFormField(
                    //       node: ctr.categoryNode,
                    //       controller: ctr.categoryCtr,
                    //       hintLabel: SearchScreenConstant.selectCategoryHint,
                    //       onChanged: (val) {},
                    //       onTap: () {
                    //         ctr.searchCategoryctr.text = "";
                    //         showDropdownMessage(
                    //             context,
                    //             ctr.setCategoryListDialog(),
                    //             SearchScreenConstant.categoryList,
                    //             isShowLoading: ctr.categoryFilterList,
                    //             onClick: () {
                    //           ctr.applyCategoryFilter('');
                    //         }, refreshClick: () {
                    //           ctr.searchCategoryctr.text = "";
                    //           futureDelay(() {
                    //             ctr.getCategoryApi(context);
                    //           }, isOneSecond: false);
                    //         });
                    //       },
                    //       isReadOnly: true,
                    //       wantSuffix: true,
                    //       isdown: true,
                    //       isEnable: true,
                    //       inputType: TextInputType.none,
                    //       errorText: ctr.categoryModel.value.error);
                    // }),
                    // Align(
                    //   alignment: Alignment.topLeft,
                    //   child: getLable(AddProductConstant.serviceLable,
                    //       isFromRetailer: false),
                    // ),
                    // Obx(() {
                    //   return getReactiveFormField(
                    //       node: ctr.serviceNode,
                    //       controller: ctr.serviceCtr,
                    //       hintLabel: AddProductConstant.serviceHint,
                    //       onChanged: (val) {},
                    //       onTap: () {
                    //         ctr.searchServicectr.text = "";
                    //         showDropdownMessage(
                    //             context,
                    //             ctr.setServiceListDialog(),
                    //             AddProductConstant.serviceListHint,
                    //             isShowLoading: ctr.categoryFilterList,
                    //             onClick: () {
                    //           ctr.applyCategoryFilter('');
                    //         }, refreshClick: () {
                    //           ctr.searchServicectr.text = "";
                    //           futureDelay(() {
                    //             ctr.getCategoryApi(context);
                    //           }, isOneSecond: false);
                    //         });
                    //       },
                    //       isReadOnly: true,
                    //       wantSuffix: true,
                    //       isdown: true,
                    //       isEnable: true,
                    //       inputType: TextInputType.none,
                    //       errorText: ctr.categoryModel.value.error);
                    // }),
                    Obx(() {
                      return getTextField(
                        isMultipline: true,
                        label: AddProductConstant.descriptionLable,
                        hint: AddProductConstant.descriptionHint,
                        ctr: ctr.descriptionCtr,
                        node: ctr.descriptionNode,
                        model: ctr.descriptionModel.value,
                        isenable: true,
                        function: (val) {
                          ctr.validateFields(
                            val,
                            iscomman: true,
                            model: ctr.descriptionModel,
                            errorText1: AddProductConstant.descriptionHint,
                          );
                        },
                        isRequired: true,
                      );
                    }),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Obx(() {
                            return getTextField(
                              label: AddProductConstant.priceLable,
                              hint: AddProductConstant.priceHint,
                              ctr: ctr.priceCtr,
                              node: ctr.priceNode,
                              model: ctr.priceModel.value,
                              isenable: true,
                              isNumber: true,
                              function: (val) {
                                ctr.validateFields(
                                  val,
                                  iscomman: true,
                                  model: ctr.priceModel,
                                  errorText1: AddProductConstant.priceHint,
                                );
                              },
                              isRequired: true,
                            );
                          }),
                        ),
                        getDynamicSizedBox(width: 3.w),
                        Expanded(
                          child: Obx(() {
                            return getTextField(
                              label: AddProductConstant.salePriceLable,
                              hint: AddProductConstant.salePriceHint,
                              ctr: ctr.salePriceCtr,
                              node: ctr.salePriceNode,
                              model: ctr.salePriceModel.value,
                              isenable: true,
                              isNumeric: true,
                              function: (val) {
                                ctr.validateFields(
                                  val,
                                  iscomman: true,
                                  model: ctr.salePriceModel,
                                  errorText1: AddProductConstant.salePriceHint,
                                );
                              },
                              isRequired: true,
                            );
                          }),
                        ),
                      ],
                    ),
                    // Obx(() {
                    //   return getTextField(
                    //     label: AddProductConstant.priceLable,
                    //     hint: AddProductConstant.priceHint,
                    //     ctr: ctr.priceCtr,
                    //     node: ctr.priceNode,
                    //     model: ctr.priceModel.value,
                    //     isenable: true,
                    //     isNumber: true,
                    //     function: (val) {
                    //       ctr.validateFields(
                    //         val,
                    //         iscomman: true,
                    //         model: ctr.priceModel,
                    //         errorText1: AddProductConstant.priceHint,
                    //       );
                    //     },
                    //     isRequired: true,
                    //   );
                    // }),
                    // Obx(() {
                    //   return getTextField(
                    //     label: AddProductConstant.salePriceLable,
                    //     hint: AddProductConstant.salePriceHint,
                    //     ctr: ctr.salePriceCtr,
                    //     node: ctr.salePriceNode,
                    //     model: ctr.salePriceModel.value,
                    //     isenable: true,
                    //     isNumeric: true,
                    //     function: (val) {
                    //       ctr.validateFields(
                    //         val,
                    //         iscomman: true,
                    //         model: ctr.salePriceModel,
                    //         errorText1: AddProductConstant.salePriceHint,
                    //       );
                    //     },
                    //     isRequired: true,
                    //   );
                    // }),
                    getDynamicSizedBox(height: 1.5.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Obx(() => ctr.getFeatureRadioButtons())),
                        getDynamicSizedBox(width: 3.w),
                        Expanded(
                            child: Obx(() => ctr.getServiceRadioButtons())),
                      ],
                    ),
                    // Obx(() => ctr.getFeatureRadioButtons()),
                    // Obx(() => ctr.getServiceRadioButtons()),
                    //  visible: ctr.servicGroupvalue.value ==
                    //               AddProductConstant.yesLable
                    //           ? true
                    //           : false,
                    getDynamicSizedBox(height: 1.5.h),
                    Column(
                      children: [
                        Align(
                            alignment: Alignment.topLeft,
                            child: getRadioLable(
                                AddProductConstant.specificationLable)),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(top: 0.8.h),
                          shrinkWrap: true,
                          itemCount: ctr.formFields.length,
                          itemBuilder: (context, index) {
                            final field = ctr.formFields[index];
                            return Obx(() {
                              return Container(
                                margin: EdgeInsets.only(bottom: 0.8.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Expanded TextField
                                    Expanded(
                                      child: getReactiveFormField(
                                        node: ctr.specificationsNode,
                                        controller: field.specificationCtr,
                                        hintLabel: AddProductConstant
                                            .specificationHint,
                                        onChanged: (String? val) {
                                          final capitalized =
                                              val?.capitalize ?? '';
                                          field.specificationCtr.text =
                                              capitalized;
                                          field.specificationCtr.selection =
                                              TextSelection.fromPosition(
                                            TextPosition(
                                                offset: capitalized.length),
                                          );

                                          // Ensure storeSpecification has up-to-date values
                                          if (ctr.storeSpecification.length >
                                              index) {
                                            ctr.storeSpecification[index] =
                                                capitalized;
                                          } else {
                                            ctr.storeSpecification
                                                .add(capitalized);
                                          }

                                          // Trim extra entries if length exceeds formFields
                                          if (ctr.storeSpecification.length >
                                              ctr.formFields.length) {
                                            ctr.storeSpecification.removeRange(
                                              ctr.formFields.length,
                                              ctr.storeSpecification.length,
                                            );
                                          }

                                          ctr.validateFields(
                                            val,
                                            iscomman: true,
                                            model:
                                                ctr.specificationValidationModels[
                                                    index],
                                            errorText1: AddProductConstant
                                                .specificationHint,
                                          );
                                        },
                                        onTap: () {
                                          ctr.specificationsCtr.text = "";
                                        },
                                        isReadOnly: false,
                                        wantSuffix: false,
                                        inputType: TextInputType.text,
                                        errorText: ctr
                                            .specificationValidationModels[
                                                index]
                                            .value
                                            .error,
                                      ),
                                    ),

                                    // "+" button only on the last field
                                    if (index == ctr.formFields.length - 1)
                                      IconButton(
                                        icon: const Icon(Icons.add_circle,
                                            color: primaryColor),
                                        onPressed: () {
                                          final currentText = field
                                              .specificationCtr.text
                                              .trim();

                                          if (currentText.isEmpty) {
                                            ctr.validateFields(
                                              currentText,
                                              iscomman: true,
                                              model:
                                                  ctr.specificationValidationModels[
                                                      index],
                                              errorText1: AddProductConstant
                                                  .specificationHint,
                                            );
                                            ctr.update();
                                          } else {
                                            ctr.validateFields(
                                              currentText,
                                              iscomman: true,
                                              model:
                                                  ctr.specificationValidationModels[
                                                      index],
                                              errorText1: AddProductConstant
                                                  .specificationHint,
                                            );

                                            // ✅ Call your add field function
                                            addField();

                                            // 🔄 Trim storeSpecification if needed
                                            if (ctr.storeSpecification.length >
                                                ctr.formFields.length) {
                                              ctr.storeSpecification
                                                  .removeRange(
                                                ctr.formFields.length,
                                                ctr.storeSpecification.length,
                                              );
                                            }
                                          }
                                        },
                                      ),

                                    // Delete button on all except the last
                                    if (index != ctr.formFields.length - 1)
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          ctr.formFields.removeAt(index);
                                          ctr.specificationValidationModels
                                              .removeAt(index);
                                          if (ctr.storeSpecification.length >
                                              index) {
                                            ctr.storeSpecification
                                                .removeAt(index);
                                          }

                                          // 🔄 Trim excess entries if needed
                                          if (ctr.storeSpecification.length >
                                              ctr.formFields.length) {
                                            ctr.storeSpecification.removeRange(
                                              ctr.formFields.length,
                                              ctr.storeSpecification.length,
                                            );
                                          }

                                          // Show/hide add button based on last field's content
                                          final lastField = ctr.formFields.last;
                                          ctr.isAddBtnVisibler.value = lastField
                                              .specificationCtr.text
                                              .trim()
                                              .isNotEmpty;

                                          setState(() {});
                                        },
                                      ),
                                  ],
                                ),
                              );
                            });
                          },
                        ),
                      ],
                    ),
                    getDynamicSizedBox(
                        height: isSmallDevice(context) ? 3.h : 5.h),
                    Obx(() {
                      return ctr.isloading == false
                          ? Container(
                              margin: EdgeInsets.symmetric(horizontal: 5.w),
                              child: getFormButton(context, () async {
                                // logcat("formFields.length",
                                //     ctr.formFields.length.toString());
                                // logcat("storeSpecification.length",
                                //     ctr.storeSpecification.length.toString());
                                // for (int i = 0;
                                //     i < ctr.storeSpecification.length;
                                //     i++) {
                                //   logcat("storeSpecification[$i]",
                                //       "'${ctr.storeSpecification[i]}'");
                                // }
                                if (ctr.isFormInvalidate.value == true) {
                                  ctr.addProduct(context, false);
                                }
                              }, AddProductConstant.submit,
                                  validate: ctr.isFormInvalidate.value),
                            )
                          : const CircularProgressIndicator();
                    }),
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
