import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/screens/extra_views/buttons.dart';
import 'package:untitled/screens/extra_views/top_bar.dart';
import 'package:untitled/screens/interests_screen/interests_controller.dart';
import 'package:untitled/utilities/const.dart';

class InterestScreen extends StatelessWidget {
  InterestScreen({Key? key}) : super(key: key);

  final InterestsController controller = Get.put(InterestsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: pOnBoarding,
          child: Column(
            children: [
              const TopBarForOnBoarding(
                titleStart: LKeys.selectYour,
                titleEnd: LKeys.interests,
                desc: LKeys.interestsDesc,
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child:
                        GetBuilder<InterestsController>(builder: (controller) {
                      return Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.center,
                        children: InterestsController.interests.map((e) {
                          return InterestTag(
                              interest: e.title ?? "",
                              isContain:
                                  controller.selectedInterests.contains(e),
                              onTap: () {
                                controller.toggleInterest(e);
                              });
                        }).toList(),
                      );
                    }),
                  ),
                ),
              ),
              CommonButton(
                  text: LKeys.continue1,
                  onTap: () {
                    controller.updateInterests();
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class InterestTag extends StatelessWidget {
  final String interest;
  final bool isContain;
  final Function() onTap;

  const InterestTag(
      {Key? key,
      required this.interest,
      required this.isContain,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: ShapeDecoration(
            shape: const SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.all(SmoothRadius(
                    cornerRadius: 23, cornerSmoothing: cornerSmoothing))),
            color: isContain ? cPrimary : cLightBg,
            shadows: isContain ? kMyBoxShadow : []),
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 25),
        child: Text(
          interest.toUpperCase(),
          style: MyTextStyle.gilroyBold(
              color: isContain ? cBlack : cLightText, size: 14),
        ),
      ),
    );
  }
}
