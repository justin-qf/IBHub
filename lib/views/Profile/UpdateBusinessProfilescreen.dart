// import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/componant/button/form_button.dart';
import 'package:ibh/componant/dialogs/dialogs.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/updateProfileController.dart';
import 'package:ibh/utils/helper.dart';
import 'package:sizer/sizer.dart';

class UpdateBusinessProfileScreen extends StatefulWidget {
  final int index;
  const UpdateBusinessProfileScreen({super.key, required this.index});

  @override
  State<UpdateBusinessProfileScreen> createState() =>
      _UpdateBusinessProfileScreenState();
}

class _UpdateBusinessProfileScreenState
    extends State<UpdateBusinessProfileScreen> {
  final Updateprofilecontroller ctr = Get.put(Updateprofilecontroller());

  @override
  void initState() {
    super.initState();
    ctr.getVerificationyApi(context); // this will call API on screen load
    ctr.getCategory(context);
    ctr.getProfileData(context);
    ctr.getState(context);
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
                        Obx(
                          () {
                            return getTextField(
                              label: SignUpConstant.bussinessLabel,
                              ctr: ctr.bussinessCtr,
                              node: ctr.bussinessNode,
                              model: ctr.bussinessModel.value,
                              isenable: ctr.isUserVerfied.value ? false : true,
                              isVerified:
                                  ctr.isUserVerfied.value ? true : false,
                              function: (val) {
                                ctr.validateFields(val,
                                    iscomman: true,
                                    model: ctr.bussinessModel,
                                    errorText1: SignUpConstant.namehint);
                              },
                              hint: SignUpConstant.namehint,
                              isRequired:
                                  ctr.isUserVerfied.value ? false : true,
                            );
                          },
                        ),
                        Obx(() {
                          return getTextField(
                            useOnChanged: false,
                            label: 'Category',
                            ctr: ctr.categoryIDCtr,
                            node: ctr.categoryIdNode,
                            model: ctr.categoryIdModel.value,
                            hint: 'Select Category',
                            wantsuffix: true,
                            isenable: false,
                            isdropdown: true,
                            usegesture: true,
                            isRequired: true,
                            context: context,
                            gestureFunction: () {
                              ctr.searchCategoryCtr.text = "";
                              showDropdownMessage(context,
                                  ctr.setCategoryListDialog(), 'Category',
                                  isShowLoading: ctr.categoryFilterList,
                                  onClick: () {
                                ctr.applyCategoryFilter(
                                  '',
                                );
                              }, refreshClick: () {
                                futureDelay(() {
                                  ctr.getCategory(context);
                                }, isOneSecond: false);
                              });
                              ctr.unfocusAll();
                            },
                          );
                        }),
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
                                    errorText2:
                                        SignUpConstant.contactNumLengthHint,
                                  );
                                },
                                hint: SignUpConstant.contactNumHint,
                                isNumeric: true,
                                isRequired: true);
                          },
                        ),
                        getDynamicSizedBox(height: 2.h),
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
                                  errorText3:
                                      SignUpConstant.invalidEmailFormat);
                            },
                            isRequired: ctr.isEmailVerifed.value ? false : true,
                          );
                        }),

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
                        Obx(
                          () {
                            return getTextField(
                                label: 'Facebook',
                                ctr: ctr.facebookCtr,
                                node: ctr.facebookNode,
                                model: ctr.faceBookModel.value,
                                function: (val) {
                                  ctr.validateFields(val,
                                      iscomman: true,
                                      model: ctr.faceBookModel,
                                      errorText1: 'Enter Facebook Link');
                                },
                                hint: 'Enter Facebook Link',
                                isRequired: false);
                          },
                        ),
                        Obx(
                          () {
                            return getTextField(
                                label: 'Linkedin',
                                ctr: ctr.linkedinCtr,
                                node: ctr.linkedInNode,
                                model: ctr.linkedinModel.value,
                                function: (val) {
                                  ctr.validateFields(val,
                                      iscomman: true,
                                      model: ctr.linkedinModel,
                                      errorText1: 'Enter Linkedin Link');
                                },
                                hint: 'Enter Linkedin Link',
                                isRequired: false);
                          },
                        ),
                        Obx(
                          () {
                            return getTextField(
                                label: 'Whatsapp',
                                ctr: ctr.whatsAppCr,
                                node: ctr.whatsappNo,
                                model: ctr.whatsappModel.value,
                                isNumeric: true,
                                function: (val) {
                                  ctr.validateFields(
                                    val,
                                    isnumber: true,
                                    model: ctr.whatsappModel,
                                    errorText1: SignUpConstant.contactNumHint,
                                    errorText2:
                                        SignUpConstant.contactNumLengthHint,
                                  );
                                },
                                hint: 'Enter Whatsapp Number',
                                isRequired: false);
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
                                    errorText2:
                                        SignUpConstant.pincodeNumLengthHint,
                                  );
                                },
                                hint: SignUpConstant.pinNumHint,
                                isNumeric: true,
                                isRequired: true);
                          },
                        ),
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
                                          SearchScreenConstant
                                              .pleaseSelectState,
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
                                          ctr.getCityApi(
                                              context,
                                              ctr.stateId.value.toString(),
                                              false);
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
                        getDynamicSizedBox(height: 3.h),
                        Obx(() {
                          return getFormButton(context, () async {
                            if (ctr.is0FormInvalidate.value == true) {
                              print('bussines api called');

                              await ctr.updateBussines(context);
                              // futureDelay(() {
                              //   details.onStepContinue?.call();
                              // }, isOneSecond: true);

                              // if (ctr
                              //     .isFormInvalidate
                              //     .value) {
                              //   ctr.updateProfile(
                              //       context);
                              // }
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
                          }, 'Update', validate: ctr.is0FormInvalidate.value);
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
