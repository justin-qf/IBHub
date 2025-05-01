import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/utils/helper.dart';
import 'package:ibh/utils/log.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class PrivacyPolicyScreen extends StatefulWidget {
  bool ispolicyScreen;
  PrivacyPolicyScreen({super.key, required this.ispolicyScreen});
  @override
  State<PrivacyPolicyScreen> createState() => PrivacyPolicyScreenState();
}

class PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    urlSetUp();
    super.initState();
  }

  urlSetUp() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            logcat("Loading progress: $progress%", '');
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
            logcat("Page started loading:", url);
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
            logcat("Page finished loading:", url);
          },
          onHttpError: (HttpResponseError error) {
            logcat("HTTP error:", error);
          },
          onWebResourceError: (WebResourceError error) {
            logcat("Web resource error:", error.description);
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(PrivacyPolicyScreenText.googleUrl)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.ispolicyScreen
          ? PrivacyPolicyScreenText.privacy
          : PrivacyPolicyScreenText.terms));
  }

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
      body: Column(
        children: [
          getDynamicSizedBox(height: 4.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: getleftsidebackbtn(
              title: widget.ispolicyScreen
                  ? PrivacyPolicyScreenText.privacyPolicy
                  : PrivacyPolicyScreenText.termAndCOndition,
              backFunction: () {
                Get.back(result: true);
              },
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(controller: controller),
                if (isLoading)
                  const Center(
                      child: CircularProgressIndicator(color: primaryColor))
              ],
            ),
          )
        ],
      ),
    );
  }
}
