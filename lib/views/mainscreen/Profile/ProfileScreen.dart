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
import 'package:ibh/views/Profile/updateprofilescreen.dart';
import 'package:ibh/views/auth/ReserPasswordScreen/ChangepasswordScreen.dart';
import 'package:ibh/views/mainscreen/ServiceScreen/BusinessDetailScreen.dart';
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
                    // getDynamicSizedBox(height: commonHeight()),
                    Stack(
                      children: [
                        Container(
                          height: 23.h,
                          width: Device.width,
                          padding:
                              EdgeInsets.only(right: 3.w, left: 3.w, top: 1.h),
                          decoration: const BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(35),
                              bottomRight: Radius.circular(35),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // getDynamicSizedBox(height: 3.h),
                              Container(
                                margin: EdgeInsets.only(left: 6.w, top: 2.h),
                                decoration: const BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(35),
                                      bottomRight: Radius.circular(35)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(onTap: () {
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
                                    }, child: Obx(() {
                                      return ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(30)),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            height: 20.h,
                                            width: 20.w,
                                            imageUrl:
                                                controller.profilePic.value,
                                            placeholder: (context, url) =>
                                                const Center(
                                              child: CircularProgressIndicator(
                                                  color: primaryColor),
                                            ),
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    CircleAvatar(
                                              radius: 25.h,
                                              backgroundImage: imageProvider,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    CircleAvatar(
                                                        radius: 25.h,
                                                        child: const Icon(
                                                            Icons.person)),
                                          ));
                                    })),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 3.w),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Obx(
                                              () {
                                                return Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      controller.userName.value
                                                              .isNotEmpty
                                                          ? controller.userName
                                                              .value.capitalize!
                                                          : "Your Name",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          fontSize: 17.sp,
                                                          color: black,
                                                          fontFamily:
                                                              fontSemiBold,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                            Obx(
                                              () {
                                                return Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      controller.bussiness.value
                                                              .isNotEmpty
                                                          ? controller.bussiness
                                                              .value.capitalize!
                                                          : "Your Bussiness",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          fontSize: 16.sp,
                                                          color: black,
                                                          fontFamily:
                                                              fontSemiBold,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10.h,
                          right: 12.w,
                          child: IconButton(
                              onPressed: () async {
                                bool isEmpty = await isAnyFieldEmpty();
                                if (isEmpty) {
                                  // ignore: use_build_context_synchronously
                                  showBottomSheetPopup(context);
                                } else {
                                  pdfPopupDialogs(
                                    // ignore: use_build_context_synchronously
                                    context,
                                    function: (String val) async {
                                      logcat("SelectedValue::", val);
                                      controller.visitingCardAPI(context,
                                          theme: val);
                                    },
                                  );
                                }
                              },
                              icon: const Icon(Icons.share)),
                        )
                      ],
                    ),
                    getDynamicSizedBox(height: 2.5.h),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 2.h),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            getMenuListItem(
                                title: ProfileScreenConst.updateProfile,
                                icon: Asset.profile,
                                callback: () async {
                                  Get.to(const Updateprofilescreen())
                                      ?.then((value) {
                                    if (value == true) {
                                      controller.getProfileData();
                                      controller.getApiProfile(context);
                                      isAnyFieldEmpty();
                                    }
                                  });
                                }),
                            getMenuListItem(
                                title: ProfileScreenConst.mybusiness,
                                // icon: Asset.add,
                                icons: Icons.business,
                                callback: () async {
                                  bool isEmpty = await isAnyFieldEmpty();
                                  if (isEmpty) {
                                    // ignore: use_build_context_synchronously
                                    showBottomSheetPopup(context);
                                  } else {
                                    Get.to(BusinessDetailScreen(
                                      item: null,
                                      isFromProfile: true,
                                    ));
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
                                icon: Asset.resetpass),
                            getMenuListItem(
                                callback: () {
                                  logoutPopupDialogs(context);
                                },
                                title: ProfileScreenConst.logout,
                                icon: Asset.logout),
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
                    // ignore: deprecated_member_use
                    color: grey.withOpacity(0.7),
                    size: 5.w)
              ],
            )
          ],
        ),
      ),
    );
  }
}
