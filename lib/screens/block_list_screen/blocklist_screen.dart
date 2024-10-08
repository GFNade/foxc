import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/widgets/my_cached_image.dart';
import 'package:untitled/common/widgets/no_data_found.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/registration.dart';
import 'package:untitled/screens/block_list_screen/block_list_controller.dart';
import 'package:untitled/screens/extra_views/back_button.dart';
import 'package:untitled/screens/extra_views/top_bar.dart';
import 'package:untitled/utilities/const.dart';

class BlockListScreen extends StatelessWidget {
  const BlockListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BlockListController controller = BlockListController();
    return Scaffold(
      body: Column(
        children: [
          TopBarForInView(title: LKeys.blockList.tr),
          Expanded(
            child: GetBuilder(
              init: controller,
              builder: (controller) {
                return controller.users.isEmpty
                    ? NoDataFound(controller: controller)
                    : ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: controller.users.length,
                        itemBuilder: (context, index) {
                          var user = controller.users[index];
                          return card(user, controller);
                        },
                      );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget card(User user, BlockListController controller) {
    return Column(
      children: [
        Row(
          children: [
            ClipSmoothRect(
              radius: const SmoothBorderRadius.all(SmoothRadius(
                  cornerRadius: 12, cornerSmoothing: cornerSmoothing)),
              child: MyCachedImage(
                imageUrl: user.profile,
                width: 55,
                height: 55,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.fullName ?? '',
                      style: MyTextStyle.gilroyBold(),
                    ),
                    const SizedBox(width: 1),
                    VerifyIcon(user: user)
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  "@${user.username ?? ''}",
                  style: MyTextStyle.gilroyLight(color: cLightText, size: 14),
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                controller.unblockUser(user, () {
                  controller.users
                      .removeWhere((element) => element.id == user.id);
                  controller.update();
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 7, horizontal: 18),
                decoration: ShapeDecoration(
                    color: cRed.withOpacity(0.15),
                    shape: const SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius.all(SmoothRadius(
                            cornerRadius: 5,
                            cornerSmoothing: cornerSmoothing)))),
                child: Text(
                  LKeys.unBlock.tr.toUpperCase(),
                  style: MyTextStyle.gilroySemiBold(size: 11)
                      .copyWith(letterSpacing: 1, color: cRed),
                ),
              ),
            )
          ],
        ),
        const Divider()
      ],
    );
  }
}
