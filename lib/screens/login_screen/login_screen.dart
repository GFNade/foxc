import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/extensions/image_extension.dart';
import 'package:untitled/common/managers/navigation.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/screens/extra_views/logo_tag.dart';
import 'package:untitled/screens/extra_views/top_bar.dart';
import 'package:untitled/screens/login_screen/login_button.dart';
import 'package:untitled/screens/login_screen/login_controller.dart';
import 'package:untitled/utilities/const.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = LoginController();
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            const LogoTag(width: 150),
            const Spacer(),
            const TopBarForLogin(
              titleStart: LKeys.signInTo,
              titleEnd: LKeys.continue1,
              alignment: MainAxisAlignment.center,
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              textAlign: TextAlign.center,
              LKeys.signInDesc.tr,
              style: MyTextStyle.gilroyLight(color: cLightText, size: 18),
            ),
            const Spacer(),
            Column(
              children: [
                LoginButton(
                  text: LKeys.signInWithGoogle,
                  assetName: MyImages.google,
                  onTap: () {
                    controller.googleLogin();
                  },
                ),
                LoginButton(
                  text: LKeys.signInWithEmail,
                  assetName: MyImages.email,
                  onTap: () {
                    controller.emailLogin();
                  },
                ),
                (GetPlatform.isIOS)
                    ? LoginButton(
                        text: LKeys.signInWithApple,
                        assetName: MyImages.apple,
                        onTap: () {
                          controller.appleLogin();
                        },
                      )
                    : Container()
              ],
            ),
            const Spacer(),
            Text(
              textAlign: TextAlign.center,
              LKeys.bySelectingAgree.tr,
              style: MyTextStyle.gilroyLight(color: cLightText, size: 14),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  LKeys.iAgreeTo.tr,
                  style: MyTextStyle.gilroyLight(color: cLightText, size: 14),
                ),
                const SizedBox(
                  width: 6,
                ),
                GestureDetector(
                  onTap: () {
                    Navigate.openURLSheet(
                        title: LKeys.termsOfUse.tr, url: termsURL);
                  },
                  child: Text(
                    LKeys.termsOfUse.tr,
                    style:
                        MyTextStyle.gilroySemiBold(color: cPrimary, size: 14),
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  LKeys.and.tr,
                  style: MyTextStyle.gilroyLight(color: cLightText, size: 14),
                ),
                const SizedBox(
                  width: 6,
                ),
                GestureDetector(
                  onTap: () {
                    Navigate.openURLSheet(
                        title: LKeys.privacyPolicy.tr, url: privacyURL);
                  },
                  child: Text(
                    LKeys.privacyPolicy.tr,
                    style:
                        MyTextStyle.gilroySemiBold(color: cPrimary, size: 14),
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
