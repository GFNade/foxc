import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/utilities/const.dart';

class LoginButton extends StatelessWidget {
  final String text;
  final String assetName;
  final Function onTap;

  const LoginButton(
      {Key? key,
      required this.text,
      required this.assetName,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        decoration: ShapeDecoration(
          color: cWhite,
          shape: const SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.all(SmoothRadius(
                  cornerRadius: 8, cornerSmoothing: cornerSmoothing))),
          shadows: [
            BoxShadow(
                color: cBlack.withOpacity(0.02),
                blurRadius: 5,
                offset: const Offset(0, 8)),
            BoxShadow(
              color: cBlack.withOpacity(0.02),
              blurRadius: 2,
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              assetName,
              width: 22,
              height: 22,
            ),
            Text(
              text.tr,
              style: MyTextStyle.gilroyRegular(),
            ),
            const SizedBox(
              width: 22,
            ),
          ],
        ),
      ),
    );
  }
}
