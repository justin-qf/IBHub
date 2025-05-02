// import 'package:medical_history/componant/dialogs/loading_indicator.dart';
// import 'package:medical_history/preference/UserPreference.dart';
// import 'package:medical_history/utils/log.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class DynamicLinksApi {
//   FirebaseDynamicLinks dynamicLink = FirebaseDynamicLinks.instance;
//   UserPreferences userPreferences = UserPreferences();

//   initDynamicLink() async {
//     try {
//       await dynamicLink.getInitialLink();
//       dynamicLink.onLink.listen((dynamicLinkData) {
//         logcat("handleSuccessLinking", "dynamicLinkData");
//         handleSuccessLinking(dynamicLinkData);
//         return;
//       }, onError: (error) async {
//         logcat("initDynamicLink ERROR", error.message.toString());
//       });
//     } catch (e) {
//       logcat("initDynamicLink catch ERROR", e.toString());
//     }
//     initUniLinks();
//   }

//   Future<void> initUniLinks() async {
//     try {
//       final initialLink = await dynamicLink.getInitialLink();
//       if (initialLink == null) return;
//       handleDeepLink(initialLink.link.path);
//     } catch (e) {
//       // Error
//     }
//   }

//   void handleDeepLink(String path) {
//     if (path.startsWith("/referral")) {
//       String referCode = Uri.parse(path).queryParameters['refer'] ?? "";
//       logcat("Received referral code:", referCode);
//     }
//   }

//   Future<String> createReferralLink(context) async {
//     var loadingIndicator = LoadingProgressDialogWithTransparent();
//     try {
//       loadingIndicator.show(context, '');
//       String? referralCode = await userPreferences.getReferralCodeFromSignIn();
//       logcat("referralCode::", referralCode);
//       final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
//         // uriPrefix: "https://medicalhistory.page.link/?",
//         uriPrefix: 'https://mymeditrack.page.link/?',
//         link: Uri.parse("https://com.app.medicalhistory?refer=$referralCode"),
//         socialMetaTagParameters: SocialMetaTagParameters(
//           title: 'Refer A Friend',
//           description: 'Refer App',
//           //https://img.freepik.com/premium-vector/refer-friend-concept-design-people-share-info-about-referral-earn-money-suitable-web-landing-page-ui-mobile-app-banner-template-vector-illustration-glassmorphism-landing-page-concept_317038-302.jpg?w=900
//           imageUrl: Uri.parse(
//               'https://img.freepik.com/premium-vector/refer-friend-flat-design-illustration-with-megaphone-screen-mobile-phone-social-media-marketing-friends-via-banner-background-poster_2175-2228.jpg'),
//         ),
//         androidParameters: AndroidParameters(
//           packageName: 'com.app.medicalhistory',
//           minimumVersion: 21,
//           fallbackUrl: Uri.parse(
//               "https://drive.google.com/file/d/1lvwymIgQCEBS-QJU0kSiOFcDBW9T-Wcd/view?usp=drive_link"),
//         ),
//         iosParameters: const IOSParameters(
//           bundleId: 'com.app.medicalhistory',
//           minimumVersion: '0',
//         ),
//       );
//       final ShortDynamicLink shortLink =
//           await dynamicLink.buildShortLink(dynamicLinkParams);
//       final Uri dynamicUrl = shortLink.shortUrl;
//       logcat("DYNAMIC_LINK", dynamicUrl);
//       String message =
//           "Hello!! I invite you to use MYMEDITRACK APP.\n\nUse below link to download our APP.\n\nMYMEDITRACK is show list of medical history of every family member and also share medical history data.\n\nTry it now:\n$dynamicUrl";
//       Share.share(message);
//       loadingIndicator.hide(context);
//       return dynamicUrl.toString();
//     } catch (e) {
//       loadingIndicator.hide(context);
//       logcat("Error", e.toString());
//       return 'Something Went Wrong';
//     }
//   }

//   static void handleSuccessLinking(PendingDynamicLinkData data) async {
//     logcat("handleSuccessLink:", data.link.toString());
//     logcat("handleSuccessLinkPATH:", data.link.path.toString());
//     final Uri deepLink = data.link;
//     String referCode = deepLink.queryParameters['refer'].toString();
//     logcat("referCode:", referCode.toString());
//     try {
//       if (referCode.isNotEmpty) {
//         // UserPreferences().setReferralCode(referCode);
//         // Share.share("This Is the Link $referCode");
//       }
//     } on Exception catch (_, e) {
//       e.toString();
//     }
//   }

//   getInvitation(BuildContext context) async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     String referrerCode = "";
//     FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
//       Uri deepLink;
//       deepLink = dynamicLinkData.link;
//       String referLink = deepLink.toString();
//       try {
//         referLink = referLink.substring(referLink.lastIndexOf("=") + 1);
//         referrerCode = referLink.substring(referLink.lastIndexOf("=") + 1);
//         logcat("FETCHED : ", referrerCode);
//         pref.setString('SplashReferrer', referrerCode);
//       } on Exception catch (_, e) {
//         e.toString();
//       }
//       //Navigator.pushNamed(context, dynamicLinkData.link.path);
//     }).onError((error) {
//       // Handle errors
//     });
//   }
// }
