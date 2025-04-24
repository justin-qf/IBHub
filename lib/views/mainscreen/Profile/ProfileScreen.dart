import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ibh/componant/dialogs/customDialog.dart';
import 'package:ibh/componant/dialogs/full_image_viewer.dart';
import 'package:ibh/componant/parentWidgets/CustomeParentBackground.dart';
import 'package:ibh/componant/toolbar/toolbar.dart';
import 'package:ibh/configs/assets_constant.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/statusbar.dart';
import 'package:ibh/controller/profile_controller.dart';
import 'package:ibh/utils/enum.dart';
import 'package:ibh/utils/helper.dart';
import 'package:sizer/sizer.dart';
import 'package:sizer/sizer.dart' as sizer;

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  ProfileScreen(this.callBack, {super.key});
  Function callBack;
  int currentPage = 0;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  var controller = Get.put(ProfileController());

  @override
  void initState() {
    controller.getProfileData();
    controller.controllers = BottomSheet.createAnimationController(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Statusbar().transparentStatusbarIsNormalScreen();
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
                return SizedBox(
                  height: Device.height / 1.5,
                  child: apiOtherStates(controller.states.value),
                );
              case ScreenState.apiSuccess:
              case ScreenState.noNetwork:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    getDynamicSizedBox(height: commonHeight()),
                    getCommonToolbar("Profile", showBackButton: false),
                    SizedBox(height: 1.5.h),
                    GestureDetector(
                      onTap: () {
                        // Get.to(const ViewUserProfile());
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 5.w, right: 5.w),
                        height: 17.h,
                        width: 85.w,
                        padding: EdgeInsets.only(
                            left: Device.screenType == sizer.ScreenType.mobile
                                ? 6.w
                                : 3.w,
                            right: 6.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.8.h),
                            gradient: LinearGradient(
                                colors: [
                                  primaryColor,
                                  primaryColor.withOpacity(0.5)
                                ],
                                begin: const FractionalOffset(1.0, 0.0),
                                end: const FractionalOffset(0.0, 0.0),
                                stops: const [0.0, 1.0],
                                tileMode: TileMode.clamp)),
                        child: Obx(
                          () {
                            return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (controller
                                          .profilePic.value.isNotEmpty) {
                                        Get.to(FullScreenImage(
                                          imageUrl: controller.profilePic.value,
                                          fromProfile: true,
                                        ))!
                                            .then((value) => {
                                                  Statusbar()
                                                      .trasparentStatusbar()
                                                });
                                      }
                                    },
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        height: Device.screenType ==
                                                sizer.ScreenType.mobile
                                            ? 9.h
                                            : 10.h,
                                        width: Device.screenType ==
                                                sizer.ScreenType.mobile
                                            ? 20.w
                                            : 11.h,
                                        imageUrl: controller.profilePic.value,
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(
                                              color: primaryColor),
                                        ),
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                CircleAvatar(
                                          radius: Device.screenType ==
                                                  sizer.ScreenType.mobile
                                              ? 6.h
                                              : 8.h,
                                          backgroundImage: imageProvider,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            CircleAvatar(
                                          radius: 6.h,
                                          child: Image.asset(
                                            "assets/pngs/avtar.png",
                                            height: 10.h,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 3.w),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Obx(
                                            () {
                                              return Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      controller.userName.value
                                                              .isNotEmpty
                                                          ? controller.userName
                                                              .value.capitalize!
                                                          : "Your Name",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          fontSize: 16.sp,
                                                          color: white,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.phone,
                                                  size: Device.screenType ==
                                                          sizer
                                                              .ScreenType.mobile
                                                      ? 12
                                                      : 2.2.h,
                                                  color: white),
                                              SizedBox(
                                                width: 1.w,
                                              ),
                                              Expanded(
                                                child: Text(
                                                    controller.number.value
                                                            .isNotEmpty
                                                        ? controller
                                                            .number.value
                                                        : "Your Number",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: white,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 0.4.h),
                                          if (controller.email.value.isNotEmpty)
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(Icons.mail_outline,
                                                    size: Device.screenType ==
                                                            sizer.ScreenType
                                                                .mobile
                                                        ? 12
                                                        : 2.2.h,
                                                    color: white),
                                                SizedBox(
                                                  width: 1.w,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      controller.email.value
                                                              .isNotEmpty
                                                          ? controller
                                                              .email.value
                                                          : "Your Email",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          fontSize: 14.sp,
                                                          color: white,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                ),
                                              ],
                                            )
                                        ],
                                      ),
                                    ),
                                  ),
                                ]);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 2.h),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            FadeInUp(
                                duration: getAnimationDuration(),
                                child: getMenuListItem(
                                    title: "Update Profile",
                                    icon: Asset.profile,
                                    callback: () async {
                                      // Get.to(const UpdateProfile())?.then((value) {
                                      //   if (value == true) {
                                      //     controller.getProfileData();
                                      //     // controller.getProfile(context);
                                      //   }
                                      // });
                                    })),
                            FadeInUp(
                              duration: getAnimationDuration(),
                              child: getMenuListItem(
                                  callback: () {
                                    // Get.to(ResetPassScreen(fromProfile: true));
                                  },
                                  title: "Change Password",
                                  icon: Asset.resetpass),
                            ),
                            FadeInUp(
                                duration: getAnimationDuration(),
                                child: getMenuListItem(
                                    callback: () {
                                      logoutPopupDialogs(context);
                                    },
                                    title: "Logout",
                                    icon: Asset.logout)),
                          ],
                        ),
                      ),
                    )
                  ],
                );
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
          color: primaryColor.withOpacity(0.07),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            icon.isEmpty
                ? Icon(icons,
                    color: fromVaccination == true ? null : primaryColor,
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
                    color: grey.withOpacity(0.7), size: 5.w)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget apiOtherStates(state) {
    if (state == ScreenState.apiLoading) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: SizedBox(
            height: 30,
            width: 30,
            child: Image.asset(
              "assets/gif/ZKZg.gif",
              width: 40,
              height: 40,
            ),
          ),
        ),
      );
    }
    return Image.asset(
      "assets/gif/ZKZg.gif",
      width: 50,
      height: 50,
    );
  }
}
