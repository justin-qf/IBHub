import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/componant/button/form_button.dart';
import 'package:ibh/componant/input/form_inputs.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/emailController.dart';
import 'package:ibh/utils/helper.dart';
import 'package:sizer/sizer.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => EmailScreenState();
}

class EmailScreenState extends State<EmailScreen> {
  final controller = Get.put(EmailController());

  @override
  Widget build(BuildContext context) {
    Statusbar().trasparentStatusbar();
    return CustomParentScaffold(
      onWillPop: () async {
        return true;
      },
      onTap: () {
        hideKeyboard(context);
      },
      isExtendBodyScreen: true,
      body: Form(
        key: controller.resetpasskey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              getDynamicSizedBox(height: 5.h),
              getCommonToolbar(EmailScreenConstant.title, showBackButton: true,
                  onClick: () {
                Get.back();
              }),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 7.0.w, right: 7.0.w, bottom: 3.h, top: 0.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        getDynamicSizedBox(height: 4.h),
                        getLable(LoginConst.emailLable),
                        AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            child: Obx(() {
                              return getReactiveFormField(
                                node: controller.emailNode,
                                controller: controller.emailctr,
                                hintLabel: LoginConst.emailHint,
                                onChanged: (val) {
                                  controller.validateEmail(val);
                                },
                                errorText: controller.emailModel.value.error,
                                inputType: TextInputType.emailAddress,
                              );
                            })),
                        getDynamicSizedBox(height: 3.h),
                        Obx(() {
                          return getFormButton(context, () {
                            if (controller.isFormInvalidate.value == true) {
                              controller.getForgotOtp(context);
                            }
                          }, Button.continues,
                              validate: controller.isFormInvalidate.value);
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
