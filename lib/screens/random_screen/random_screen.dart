import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/extensions/int_extension.dart';
import 'package:untitled/common/widgets/my_cached_image.dart';
import 'package:untitled/common/widgets/plusing_animation/ripple_animation.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/registration.dart';
import 'package:untitled/screens/extra_views/back_button.dart';
import 'package:untitled/screens/extra_views/buttons.dart';
import 'package:untitled/screens/extra_views/logo_tag.dart';
import 'package:untitled/screens/extra_views/top_bar.dart';
import 'package:untitled/screens/profile_screen/profile_screen.dart';
import 'package:untitled/screens/random_screen/random_screen_controller.dart';
import 'package:untitled/screens/rooms_screen/room_card.dart';
import 'package:untitled/utilities/const.dart';

class RandomScreen extends StatelessWidget {
  const RandomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RandomScreenController controller = RandomScreenController();
    return Scaffold(
      backgroundColor: cBG,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: cBG,
            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
            child: const SafeArea(
              bottom: false,
              child: LogoTag(),
            ),
          ),
          const SizedBox(height: 20),
          GetBuilder<RandomScreenController>(
            init: controller,
            builder: (controller) {
              var isProfile = controller.user != null;
              return Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TopBarForOnBoarding(
                            titleEnd: isProfile ? LKeys.found : LKeys.profile,
                            desc: '',
                            titleStart: isProfile ? LKeys.profile : LKeys.searching),
                      ],
                    ),
                    const Spacer(),
                    isProfile
                        ? profileCard(controller)
                        : RipplesAnimation(
                            onPressed: () {},
                            child: MyCachedImage(
                              imageUrl: SessionManager.shared.getUser()?.profile,
                              width: 100,
                              height: 100,
                            )),
                    const Spacer(),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: isProfile ? 40 : 60, right: 40, left: 40),
                      child: isProfile
                          ? CommonButton(text: LKeys.next, onTap: controller.next)
                          : Text(LKeys.searchingDesc.tr,
                              textAlign: TextAlign.center, style: MyTextStyle.gilroyLight(color: cDarkText)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget profileCard(RandomScreenController controller) {
    return Container(
      decoration: ShapeDecoration(
          color: cBlack,
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(cornerRadius: 25, cornerSmoothing: cornerSmoothing),
          )),
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipSmoothRect(
                radius: const SmoothBorderRadius.all(SmoothRadius(cornerRadius: 12, cornerSmoothing: cornerSmoothing)),
                child: MyCachedProfileImage(
                  imageUrl: controller.user?.profile,
                  width: 70,
                  height: 70,
                  fullName: controller.user?.fullName,
                ),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        controller.user?.fullName ?? "",
                        style: MyTextStyle.gilroyBold(color: cWhite, size: 17),
                      ),
                      const SizedBox(width: 2),
                      const VerifyIcon(),
                    ],
                  ),
                  Text(
                    "@${controller.user?.username ?? ''}",
                    style: MyTextStyle.gilroyLight(color: cPrimary),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        (controller.user?.followers ?? 0).makeToString(),
                        style: MyTextStyle.gilroyBold(color: cWhite),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        LKeys.followers.tr,
                        style: MyTextStyle.gilroyLight(color: cWhite),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          Text(
            controller.user?.bio ?? '',
            style: MyTextStyle.gilroyLight(color: cWhite, size: 18),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Wrap(
            children: (controller.user?.getInterestsStringList() ?? []).map((e) {
              return RoomCardInterestTagToShow(
                tag: e,
                color: cLightText,
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              Get.to(() => ProfileScreen(
                    userId: controller.user?.id ?? 0,
                  ));
            },
            child: Container(
              alignment: Alignment.center,
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: cDarkText.withOpacity(0.5)), borderRadius: BorderRadius.circular(10)),
              child: Text(
                LKeys.viewFullProfile.tr,
                style: MyTextStyle.gilroyRegular(color: cWhite),
              ),
            ),
          )
        ],
      ),
    );
  }
}
