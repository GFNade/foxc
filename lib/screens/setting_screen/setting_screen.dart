import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/managers/navigation.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/screens/block_list_screen/blocklist_screen.dart';
import 'package:untitled/screens/edit_profile_screen/edit_profile_screen.dart';
import 'package:untitled/screens/extra_views/logo_tag.dart';
import 'package:untitled/screens/extra_views/top_bar.dart';
import 'package:untitled/screens/faq_screen/faq_screen.dart';
import 'package:untitled/screens/languages_screen/languages_screen.dart';
import 'package:untitled/screens/notification_screen/notification_screen.dart';
// import 'package:untitled/screens/profile_verification_screen/profile_verification_screen.dart';
import 'package:untitled/screens/setting_screen/setting_controller.dart';
import 'package:untitled/utilities/const.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SettingController controller = SettingController();
    return Scaffold(
      body: Column(
        children: [
          const TopBarForInView(title: LKeys.profileSetting),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 20, left: 10, right: 10),
                child: SafeArea(
                  top: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SettingButton(
                        title: LKeys.editProfile,
                        onTap: () {
                          Navigate.to(const EditProfileScreen());
                        },
                      ),
                      SettingButton(title: LKeys.roomsYouOwn, onTap: controller.tapRoomsYouOwn),
                      SettingButton(title: LKeys.roomsInvitation, onTap: controller.tapRoomInvitation),
                      SettingButton(
                          title: LKeys.notification,
                          onTap: () {
                            Navigate.to(const NotificationScreen());
                          }),
                      (SessionManager.shared.getUser()?.isVerified != 2 &&
                              SessionManager.shared.getUser()?.isVerified != 3)
                          ? SettingButton(
                              title: LKeys.profileVerification,
                              onTap: () {
                                var type = SessionManager.shared.getUser()?.isVerified;
                                if (type == 0) {
                                  // Navigate.to(const ProfileVerificationScreen());
                                } else {
                                  controller.showSnackBar(LKeys.verificationPending.tr);
                                }
                              },
                            )
                          : Container(),
                      SettingButton(
                        title: LKeys.blockList,
                        onTap: () {
                          Navigate.to(const BlockListScreen());
                        },
                      ),
                      SettingButton(
                        title: LKeys.languages,
                        onTap: () {
                          Navigate.to(const LanguagesScreen());
                        },
                      ),
                      const SizedBox(height: 40),
                      GetBuilder<SettingController>(
                          id: controller.notificationID,
                          init: controller,
                          builder: (context) {
                            return SettingButtonWithSwitch(
                              title: LKeys.pushNotification,
                              desc: LKeys.pushNotificationDesc,
                              isOn: controller.isNotification,
                              onChange: controller.changeOfNotification,
                            );
                          }),
                      GetBuilder<SettingController>(
                          id: controller.getInvitedID,
                          init: controller,
                          builder: (context) {
                            return SettingButtonWithSwitch(
                                title: LKeys.getInvitedToRooms,
                                desc: LKeys.getInvitedToRoomsDesc,
                                isOn: controller.isGetInvited,
                                onChange: controller.changeOfGetInvited);
                          }),
                      const SizedBox(height: 40),
                      SettingButton(
                        title: LKeys.privacyPolicy,
                        onTap: () {
                          openSheetWithURL(privacyURL, LKeys.privacyPolicy);
                        },
                      ),
                      SettingButton(
                        title: LKeys.termsOfUse,
                        onTap: () {
                          openSheetWithURL(termsURL, LKeys.termsOfUse);
                        },
                      ),
                      SettingButton(
                        title: LKeys.helpSupport,
                        onTap: () {
                          openSheetWithURL(helpURL, LKeys.helpSupport);
                        },
                      ),
                      SettingButton(
                        title: LKeys.faqS,
                        onTap: () {
                          Navigate.to(const FAQsScreen());
                        },
                      ),
                      SettingButton(
                        title: LKeys.logOut,
                        isNavigationShow: false,
                        onTap: () {
                          controller.logout();
                        },
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const LogoTag(
                                  width: 120,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                GetBuilder(
                                    init: controller,
                                    id: 'version',
                                    builder: (context) {
                                      return Text(
                                        "${LKeys.version.tr} ${controller.version}",
                                        style: MyTextStyle.gilroyLight(color: cLightText, size: 14),
                                      );
                                    })
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      SettingButton(
                        title: LKeys.deleteMyAcc,
                        isNavigationShow: false,
                        onTap: () {
                          controller.deleteAccount();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void openSheetWithURL(String url, String title) {
    Navigate.openURLSheet(title: title, url: url);
  }
}

class SettingButton extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final bool isNavigationShow;

  const SettingButton({Key? key, required this.title, this.onTap, this.isNavigationShow = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const ShapeDecoration(
            shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.all(SmoothRadius(cornerRadius: 8, cornerSmoothing: cornerSmoothing))),
            color: cLightBg),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        child: Row(
          children: [
            Text(
              title.tr,
              style: MyTextStyle.gilroySemiBold(size: 17, color: cDarkText),
            ),
            const Spacer(),
            isNavigationShow
                ? const Icon(
                    Icons.chevron_right_rounded,
                    color: cPrimary,
                    size: 30,
                  )
                : const Opacity(
                    opacity: 0,
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: cPrimary,
                      size: 30,
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

class SettingButtonWithSwitch extends StatelessWidget {
  final String title;
  final String desc;
  final bool isOn;
  final Function(bool) onChange;

  const SettingButtonWithSwitch(
      {Key? key, required this.title, required this.desc, required this.isOn, required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const ShapeDecoration(
          shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.all(SmoothRadius(cornerRadius: 8, cornerSmoothing: cornerSmoothing))),
          color: cLightBg),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.tr,
                  style: MyTextStyle.gilroySemiBold(size: 17, color: cDarkText),
                ),
                Text(
                  desc.tr,
                  style: MyTextStyle.gilroyRegular(size: 15, color: cLightText),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          CupertinoSwitch(
            activeColor: cPrimary,
            value: isOn,
            onChanged: onChange,
          )
        ],
      ),
    );
  }
}
