import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/utilities/const.dart';

const pOnBoarding = EdgeInsets.all(30);

class TopBarForOnBoarding extends StatelessWidget {
  final String? titleStart;
  final String titleEnd;
  final String desc;

  const TopBarForOnBoarding(
      {Key? key, this.titleStart, required this.titleEnd, required this.desc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TopBarForLogin(
          titleEnd: titleEnd,
          titleStart: titleStart,
          alignment: MainAxisAlignment.start,
        ),
        desc != ""
            ? Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    desc.tr,
                    style: MyTextStyle.gilroyLight(color: cLightText, size: 16),
                  )
                ],
              )
            : Container(),
      ],
    );
  }
}

class TopBarForLogin extends StatelessWidget {
  final String? titleStart;
  final String titleEnd;
  final MainAxisAlignment alignment;
  final double? size;

  const TopBarForLogin(
      {Key? key,
      this.titleStart,
      required this.titleEnd,
      required this.alignment,
      this.size = 24})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      children: [
        Text(
          (titleStart ?? LKeys.selectYour).tr,
          style: MyTextStyle.gilroyLight(size: size),
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          titleEnd.tr,
          style: MyTextStyle.gilroyBold(size: size),
        )
      ],
    );
  }
}

class TopBarForInView extends StatelessWidget {
  final String title;
  final Widget? child;
  final Widget? verticalChild;
  final IconData? backIcon;
  final double size;

  const TopBarForInView(
      {Key? key,
      required this.title,
      this.child,
      this.verticalChild,
      this.backIcon,
      this.size = 35})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      color: cDarkBG,
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            GestureDetector(
              child: Icon(
                backIcon ?? Icons.chevron_left_rounded,
                color: cWhite,
                size: size,
              ),
              onTap: () {
                Get.back();
              },
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.tr,
                    style: MyTextStyle.gilroyLight(color: cWhite, size: 18),
                  ),
                  SizedBox(
                    height: verticalChild == null ? 0 : 5,
                  ),
                  verticalChild ?? Container()
                ],
              ),
            ),
            child ?? Container()
          ],
        ),
      ),
    );
  }
}
