import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/screens/extra_views/buttons.dart';
import 'package:untitled/screens/setting_screen/setting_controller.dart';
import 'package:untitled/utilities/const.dart';

class BlockedByAdminScreen extends StatelessWidget {
  const BlockedByAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SettingController controller = SettingController();
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: cRed.withOpacity(0.1),
            padding:
                const EdgeInsets.only(top: 70, bottom: 30, left: 20, right: 20),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.error,
                    color: cRed.withOpacity(0.9),
                    size: 50,
                  ),
                  const SizedBox(height: 10),
                  Text(LKeys.yourAccountBlocked.tr,
                      style: MyTextStyle.gilroyBlack(
                          size: 20, color: cRed.withOpacity(0.9))),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(LKeys.yourAccountBlockedDisc.tr,
                      style: MyTextStyle.gilroyLight(color: cDarkText)),
                  const SizedBox(height: 30),
                  Text(contactEmail,
                      style: MyTextStyle.gilroySemiBold(size: 18)),
                  const Spacer(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: CommonSheetButton(
                      title: LKeys.logOut, onTap: controller.logout),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CommonSheetButton(
                      title: LKeys.deleteMyAcc,
                      onTap: controller.deleteAccount),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
