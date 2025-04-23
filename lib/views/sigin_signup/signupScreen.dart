import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ibh/componant/dialogs/dialogs.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/signupScreenController.dart';
import 'package:ibh/utils/helper.dart';
import 'package:sizer/sizer.dart';

class Signupscreen extends StatelessWidget {
  const Signupscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Signupscreencontroller ctr = Get.put(Signupscreencontroller());
    return CustomParentScaffold(
      isExtendBodyScreen: true,
      onWillPop: () async {
        return false;
      },
      onTap: () {
        hideKeyboard(context);
      },
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          children: [
            getDynamicSizedBox(height: 1.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Create Your Account',
                  style: TextStyle(fontFamily: dM_sans_bold, fontSize: 20.sp)),
            ),
            getDynamicSizedBox(height: 4.h),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    'Discover opportunities, build your brand\nSign up and showcase your skills to the world.',
                    style:
                        TextStyle(fontFamily: dM_sans_semiBold, color: grey))),
            getDynamicSizedBox(height: 2.h),
            Expanded(
              child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
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
                          Obx(() {
                            return getTextField(
                                label: SignUpConstant.email,
                                hint: SignUpConstant.enterEmail,
                                ctr: ctr.emailCtr,
                                node: ctr.emailNode,
                                model: ctr.emailModel.value,
                                function: (val) {
                                  ctr.validateFields(val,
                                      isemail: true,
                                      model: ctr.emailModel,
                                      errorText1: SignUpConstant.enterEmail,
                                      errorText2: SignUpConstant.emailcontain,
                                      errorText3:
                                          SignUpConstant.invalidEmailFormat);
                                },
                                isRequired: true);
                          }),
                          Obx(
                            () {
                              return getTextField(
                                  label: SignUpConstant.contactLabel,
                                  ctr: ctr.passCtr,
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
                          Obx(
                            () {
                              return getTextField(
                                  label: SignUpConstant.bussinessLabel,
                                  ctr: ctr.bussinessCtr,
                                  node: ctr.bussinessNode,
                                  model: ctr.bussinessModel.value,
                                  function: (val) {
                                    ctr.validateFields(val,
                                        iscomman: true,
                                        model: ctr.bussinessModel,
                                        errorText1: SignUpConstant.namehint);
                                  },
                                  hint: SignUpConstant.namehint,
                                  isRequired: true);
                            },
                          ),
                          Obx(() {
                            return getTextField(
                              useOnChanged: false,
                              label: SignUpConstant.stateLabel,
                              ctr: ctr.stateCtr,
                              node: ctr.stateNode,
                              model: ctr.stateModel.value,
                              hint: SignUpConstant.subjectHint,
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
                                  ctr.applyFilter('');
                                }, refreshClick: () {
                                  futureDelay(() {
                                    // ctr.getStateApi(context, "");
                                  }, isOneSecond: false);
                                });
                                ctr.unfocusAll();
                              },
                            );
                          }),
                          Obx(() {
                            return getTextField(
                              useOnChanged: false,
                              label: SignUpConstant.cityLabel,
                              ctr: ctr.stateCtr,
                              node: ctr.stateNode,
                              model: ctr.stateModel.value,
                              hint: SignUpConstant.subjectHint,
                              wantsuffix: true,
                              isenable: false,
                              isdropdown: true,
                              usegesture: true,
                              isRequired: true,
                              context: context,
                              gestureFunction: () {
                                ctr.unfocusAll();
                              },
                            );
                          }),
                          Obx(
                            () {
                              return getTextField(
                                  label: SignUpConstant.pinCodeLabel,
                                  ctr: ctr.passCtr,
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
                        ],
                      ),
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
