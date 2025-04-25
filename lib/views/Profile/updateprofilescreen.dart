import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ibh/componant/button/form_button.dart';
import 'package:ibh/componant/dialogs/dialogs.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/updateProfileController.dart';
import 'package:ibh/utils/helper.dart';
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

    ctr.getProfileData();
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
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          children: [
            getDynamicSizedBox(height: 2.h),
            SafeArea(
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                    onTap: () {
                      Get.back(result: true);
                      ctr.resetForm();
                      ctr.unfocusAll();
                    },
                    child: SvgPicture.asset(Asset.arrowBack,

                        // ignore: deprecated_member_use
                        color: black,
                        height: 4.h)),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [

              //     Text(
              //       'Create Your Account',
              //       style: TextStyle(fontFamily: dM_sans_bold, fontSize: 20.sp),
              //     ),
              //   ],
              // ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    getDynamicSizedBox(height: 2.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(
                            fontFamily: dM_sans_bold,
                            fontSize: 24.sp,
                            height: 1.1),
                      ),
                    ),
                    getDynamicSizedBox(height: 2.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Update your details,\nunlock new opportunities.',
                        style: TextStyle(
                            fontFamily: dM_sans_semiBold, color: grey),
                      ),
                    ),
                    getDynamicSizedBox(height: 4.h),
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
                              errorText3: SignUpConstant.invalidEmailFormat);
                        },
                        isRequired: true,
                      );
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
                        hint: SignUpConstant.stateHint,
                        wantsuffix: true,
                        isenable: false,
                        isdropdown: true,
                        usegesture: true,
                        isRequired: true,
                        context: context,
                        gestureFunction: () {
                          ctr.searchStatectr.text = "";

                          // ctr.getState(context);
                          showDropdownMessage(context, ctr.setStateListDialog(),
                              SignUpConstant.stateList,
                              isShowLoading: ctr.stateFilterList, onClick: () {
                            ctr.applyFilter('', isState: true);
                          }, refreshClick: () {
                            futureDelay(() {
                              ctr.getState(context);
                            }, isOneSecond: false);
                          });
                          ctr.unfocusAll();
                          // ctr.showSubjectSelectionPopups(context);
                        },
                      );
                    }),
                    Obx(() {
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
                          ctr.unfocusAll();

                          ctr.getCity(context);
                          showDropdownMessage(context, ctr.setcityListDialog(),
                              SignUpConstant.cityList,
                              isShowLoading: ctr.cityFilterList, onClick: () {
                            ctr.applyFilter('', isState: false);
                          }, refreshClick: () {
                            futureDelay(() {
                              ctr.getCity(context);
                            }, isOneSecond: false);
                          });

                          // ctr.showSubjectSelectionPopups(context);
                        },
                      );
                    }),
                    Obx(
                      () {
                        return getTextField(
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
                                errorText2: SignUpConstant.pincodeNumLengthHint,
                              );
                            },
                            hint: SignUpConstant.pinNumHint,
                            isNumeric: true,
                            isRequired: true);
                      },
                    ),
                    Obx(() {
                      return getTextField(
                        useOnChanged: false,
                        label: SignUpConstant.logoLabel,
                        ctr: ctr.visitingcardCtr,
                        node: ctr.visitingcardNode,
                        model: ctr.visitingCardModel.value,
                        hint: SignUpConstant.pickHint,
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
                    // Obx(() {
                    //   return getTextField(
                    //       label: SignUpConstant.passwordLable,
                    //       ctr: ctr.passCtr,
                    //       node: ctr.passNode,
                    //       model: ctr.passModel.value,
                    //       function: (val) {
                    //         ctr.validateFields(
                    //           val,
                    //           ispassword: true,
                    //           model: ctr.passModel,
                    //           errorText1: SignUpConstant.passwordHint,
                    //           errorText2: SignUpConstant.hintSpaceNotAllowed,
                    //           errorText3: SignUpConstant.validPasswordHint,
                    //         );

                    //         if (ctr.confpassCtr.text.isNotEmpty) {
                    //           ctr.validateFields(
                    //             val,
                    //             isconfirmpassword: true,
                    //             confirmpasswordctr: ctr.confpassCtr.text,
                    //             model: ctr.confpassModel,
                    //             errorText1: SignUpConstant.confirmPasswordHint,
                    //             errorText2: SignUpConstant.hintSpaceNotAllowed,
                    //             errorText3: SignUpConstant.passwordMismatchHint,
                    //           );
                    //         }
                    //       },
                    //       hint: SignUpConstant.validPasswordHint,
                    //       wantsuffix: true,
                    //       ispass: true,
                    //       isRequired: true,
                    //       isobscure: ctr.isObsecurePassText,
                    //       obscureFunction: () {
                    //         ctr.togglePassObscureText();
                    //       });
                    // }),
                    // Obx(() {
                    //   return getTextField(
                    //       label: SignUpConstant.repasswordLable,
                    //       ctr: ctr.confpassCtr,
                    //       node: ctr.confpassNode,
                    //       model: ctr.confpassModel.value,
                    //       function: (val) {
                    //         ctr.validateFields(
                    //           val,
                    //           isconfirmpassword: true,
                    //           model: ctr.confpassModel,
                    //           errorText1: SignUpConstant.confirmPasswordHint,
                    //           errorText2: SignUpConstant.hintSpaceNotAllowed,
                    //           errorText3: SignUpConstant.passwordMismatchHint,
                    //           confirmpasswordctr: ctr.passCtr.text,
                    //         );
                    //       },
                    //       hint: SignUpConstant.confirmPasswordHint,
                    //       wantsuffix: true,
                    //       ispass: true,
                    //       isRequired: true,
                    //       isobscure: ctr.isObsecureConPassText,
                    //       obscureFunction: () {
                    //         ctr.toggleConfPassObscureText();
                    //       });
                    // }),
                    getDynamicSizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
            getDynamicSizedBox(height: 2.h),
            Obx(() {
              return ctr.isloading == false
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.w),
                      child: getFormButton(context, () async {
                        if (ctr.isFormInvalidate.value == true) {
                          ctr.updateProfile(
                            context,
                          );

                          // ctr.validateLogin(context);
                        }
                      }, ProfileScreenConst.save,
                          validate: ctr.isFormInvalidate.value),
                    )
                  : CircularProgressIndicator();
            }),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     Text(
            //       SignUpConstant.alreadyhaveaccount,
            //       style: TextStyle(color: grey, fontFamily: dM_sans_medium),
            //     ),
            //     GestureDetector(
            //       onTap: () {
            //         ctr.resetForm();
            //         Get.back(result: true);
            //       },
            //       child: Container(
            //         padding: EdgeInsets.only(left: 1.w),
            //         child: Stack(
            //           alignment: Alignment.center,
            //           children: [
            //             Text(
            //               SignUpConstant.title,
            //               style: const TextStyle(
            //                 fontFamily: dM_sans_medium,
            //                 color: primaryColor,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             ),
            //             Positioned(
            //               bottom: 1,
            //               // Adjust this value to control the gap
            //               child: Container(
            //                 width: 35.w, // Adjust width based on text length
            //                 height: 0.2.h, // Thickness of the underline
            //                 color: primaryColor,
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            getDynamicSizedBox(height: 3.h)
          ],
        ),
      ),
    );
  }
}
