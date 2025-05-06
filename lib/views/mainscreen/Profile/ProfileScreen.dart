import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ibh/componant/dialogs/customDialog.dart';
import 'package:ibh/componant/dialogs/dialogs.dart';
import 'package:ibh/componant/dialogs/full_image_viewer.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/configs/string_constant.dart';
import 'package:ibh/controller/profile_controller.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/helper.dart';
import 'package:ibh/utils/log.dart';
import 'package:ibh/views/Profile/UpdateProfile.dart';
import 'package:ibh/views/Profile/updateprofilescreen.dart';
import 'package:ibh/views/auth/ReserPasswordScreen/ChangepasswordScreen.dart';
import 'package:ibh/views/mainscreen/ServiceScreen/BusinessDetailScreen.dart';
import 'package:ibh/views/privacypolicy/PrivacyPolicyScreen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:sizer/sizer.dart' as sizer;

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  ProfileScreen(this.callBack, {super.key});
  Function callBack;
  int currentPage = 1;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  var controller = Get.put(ProfileController());

  @override
  void initState() {
    controller.getProfileData();
    controller.getApiProfile(context);
    controller.controllers = BottomSheet.createAnimationController(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Statusbar().trasparentStatusbar();
    return CustomParentScaffold(
        onWillPop: () async {
          SystemNavigator.pop();
          return false;
        },
        isExtendBodyScreen: true,
        body: Obx(
          () {
            switch (controller.states.value) {
              case ScreenState.apiLoading:
              case ScreenState.noDataFound:
              case ScreenState.apiError:
              case ScreenState.apiSuccess:
              case ScreenState.noNetwork:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 22.h,
                      width: Device.width,
                      padding:
                          EdgeInsets.only(right: 3.w, left: 10.w, top: 1.h),
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(35),
                            bottomRight: Radius.circular(35)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // getDynamicSizedBox(height: 3.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(onTap: () {
                                if (controller.profilePic.value.isNotEmpty) {
                                  Get.to(FullScreenImage(
                                    imageUrl: controller.profilePic.value,
                                    fromProfile: true,
                                  ))!
                                      .then((value) =>
                                          {Statusbar().trasparentStatusbar()});
                                }
                              }, child: Obx(() {
                                return CircleAvatar(
                                  backgroundColor: primaryColor,
                                  radius: 25.sp,
                                  child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      height: 20.h,
                                      width: 20.w,
                                      imageUrl: controller.profilePic.value,
                                      // placeholder: (context, url) => const Center(
                                      //   child: CircularProgressIndicator(
                                      //       color: primaryColor),
                                      // ),
                                      placeholder: (context, url) => ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.asset(
                                              Asset.bussinessPlaceholder,
                                              fit: BoxFit.contain)),
                                      imageBuilder: (context, imageProvider) =>
                                          CircleAvatar(
                                              radius: 25.h,
                                              backgroundColor: primaryColor,
                                              backgroundImage: imageProvider),
                                      errorWidget: (context, url, error) =>
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image.asset(
                                                  Asset.bussinessPlaceholder,
                                                  fit: BoxFit.contain))),
                                );
                              })),
                              Expanded(
                                child: Container(
                                  width: 20.w,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 3.w),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Obx(
                                        () {
                                          return Text(
                                            controller.userName.value.isNotEmpty
                                                ? controller
                                                    .userName.value.capitalize!
                                                : "Your Name",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                color: white,
                                                fontFamily: dM_sans_semiBold,
                                                fontWeight: FontWeight.w800),
                                          );
                                        },
                                      ),
                                      Obx(
                                        () {
                                          return Text(
                                            controller
                                                    .bussiness.value.isNotEmpty
                                                ? controller
                                                    .bussiness.value.capitalize!
                                                : "Your Bussiness",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                color: white,
                                                fontFamily: dM_sans_semiBold,
                                                fontWeight: FontWeight.w500),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // getDynamicSizedBox(height: commonHeight()),

                    getDynamicSizedBox(height: 2.5.h),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 2.h),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            getMenuListItem(
                                title: ProfileScreenConst.updateProfile,
                                icons: Icons.person,
                                callback: () async {
                                  Get.to(const UpdateProfile())?.then((value) {
                                    if (value == true) {
                                      print('calledd');
                                      controller.getProfileData();
                                      controller.getApiProfile(context);
                                      isAnyFieldEmpty();
                                    }
                                  });
                                }),
                            getMenuListItem(
                                title: ProfileScreenConst.mybusiness,
                                // icon: Asset.add,
                                icons: Icons.work,
                                callback: () async {
                                  bool isEmpty = await isAnyFieldEmpty();
                                  if (isEmpty) {
                                    // ignore: use_build_context_synchronously
                                    showBottomSheetPopup(context);
                                  } else {
                                    Get.to(
                                      BusinessDetailScreen(
                                        item: null,
                                        isFromProfile: true,
                                      ),
                                    );
                                  }
                                }),
                            getMenuListItem(
                                callback: () {
                                  Get.to(ChangePasswordScreen(
                                    email: "",
                                    fromProfile: true,
                                  ));
                                },
                                title: ProfileScreenConst.changepassword,
                                icons: Icons.lock),
                            // getMenuListItem(
                            //     callback: () async {
                            //       bool isEmpty = await isAnyFieldEmpty();
                            //       if (isEmpty) {
                            //         // ignore: use_build_context_synchronously
                            //         showBottomSheetPopup(context);
                            //       } else {
                            //         pdfPopupDialogs(
                            //           // ignore: use_build_context_synchronously
                            //           context,
                            //           function: (String val) async {
                            //             logcat("SelectedValue::", val);
                            //             controller.getpdfFromApi(context,
                            //                 theme: val);
                            //           },
                            //         );
                            //       }
                            //     },
                            //     title: 'Share Visiting Card',
                            //     icons: Icons.share),
                            getMenuListItem(
                                callback: () async {
                                  logcat("APKURL::",
                                      controller.apkUrl.value.toString());
                                  Share.share(
                                      controller.apkUrl.value.toString());
                                },
                                title: 'Share App',
                                icons: Icons.share),
                            // getMenuListItem(
                            //   title: 'Terms and Conditions',
                            //   icons: Icons.description,
                            //   callback: () {
                            //     // Navigate to Terms and Conditions screen or show dialog
                            //   },
                            // ),
                            getMenuListItem(
                                callback: () {
                                  logoutPopupDialogs(context);
                                },
                                title: ProfileScreenConst.logout,
                                icons: Icons.logout),
                            getMenuListItem(
                                callback: () {
                                  // logoutPopupDialogs(context);
                                },
                                title: 'Delete Account',
                                icons: Icons.delete),
                            getDynamicSizedBox(height: 5.h),
                            GestureDetector(
                              onTap: () {
                                Get.to(PrivacyPolicyScreen(
                                  ispolicyScreen: false,
                                ));
                              },
                              child: Container(
                                // color: Colors.yellow,
                                padding: EdgeInsets.only(
                                    top: 2.h, bottom: 2.h, left: 2.w),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Terms & Conditions',
                                          style: TextStyle(
                                            color: primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: dM_sans_regular,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                        bottom: 1,
                                        child: Container(
                                            width: 37.w,
                                            height: 0.2.h,
                                            color: primaryColor)),
                                  ],
                                ),
                              ),
                            ),
                            // getDynamicSizedBox(height: 2.h),
                            Text(
                              'Powered by IBH',
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.grey,
                                fontFamily: dM_sans_medium,
                              ),
                            ),
                            // getFormButton(context, () {
                            //   Get.to(AddServicescreen());
                            // }, 'add services', validate: true),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              // ignore: unreachable_switch_default
              default:
                const Center(child: Text("Not Found"));
            }
            return const Center(child: Text("Not Found"));
          },
        ));
  }

  Widget getMenuListItem(
      {String icon = "",
      IconData? icons,
      String title = "",
      Function? callback,
      fromVaccination}) {
    return GestureDetector(
      onTap: () {
        if (callback != null) callback();
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: 7.w,
            vertical:
                Device.screenType == sizer.ScreenType.mobile ? 0.6.h : 0.8.h),
        padding: EdgeInsets.symmetric(
            horizontal:
                Device.screenType == sizer.ScreenType.mobile ? 4.w : 3.5.w,
            vertical:
                Device.screenType == sizer.ScreenType.mobile ? 2.h : 1.5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.8.h),
          // ignore: deprecated_member_use
          color: primaryColor.withOpacity(0.07),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            icon.isEmpty
                ? Icon(icons,
                    color: fromVaccination == true ? null : secondaryColor,
                    size: 3.h)
                : SvgPicture.asset(
                    // ignore: deprecated_member_use
                    color: fromVaccination == true ? null : primaryColor,
                    icon,
                    height: 3.h,
                    width: 2.w),
            SizedBox(width: 5.w),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Text(
                title,
                style: TextStyle(
                    fontFamily: dM_sans_bold,
                    fontSize: Device.screenType == sizer.ScreenType.mobile
                        ? 16.sp
                        : 14.sp,
                    fontWeight: FontWeight.w600,
                    color: headingTextColor),
              ),
            ),
            SizedBox(width: 5.w),
            Row(
              children: [
                Icon(Icons.arrow_forward_ios_rounded,
                    // ignore: deprecated_member_use
                    color: primaryColor,
                    size: 5.w)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
