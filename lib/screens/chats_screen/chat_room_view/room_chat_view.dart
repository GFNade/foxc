import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/date_time_extension.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/extensions/int_extension.dart';
import 'package:untitled/common/managers/navigation.dart';
import 'package:untitled/common/widgets/my_cached_image.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/screens/chats_screen/chatting_screen/chatting_view.dart';
import 'package:untitled/utilities/const.dart';

class RoomChatView extends StatelessWidget {
  const RoomChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      padding: const EdgeInsets.only(top: 0, bottom: 10),
      itemBuilder: (context, index) {
        return const RoomChatCard();
      },
    );
  }
}

class RoomChatCard extends StatelessWidget {
  const RoomChatCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigate.to(const ChattingView());
      },
      child: Container(
        decoration: const ShapeDecoration(
          shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.all(SmoothRadius(
                  cornerRadius: 12, cornerSmoothing: cornerSmoothing))),
          color: cLightBg,
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: const MyCachedImage(
                imageUrl: '',
                width: 60,
                height: 60,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "California Girls",
                  style: MyTextStyle.gilroyBold(size: 18),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      55792.makeToString(),
                      style: MyTextStyle.gilroySemiBold(
                          size: 16, color: cDarkText),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      LKeys.members.tr,
                      style:
                          MyTextStyle.gilroyLight(size: 16, color: cLightText),
                    ),
                  ],
                ),
              ],
            )),
            Column(
              children: [
                Text(
                  DateTime.now().timeAgo(),
                  style: MyTextStyle.gilroyLight(size: 14, color: cLightText),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 8, left: 8, right: 8),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: cPrimary),
                  child: Text(
                    1.makeToString(),
                    style: MyTextStyle.gilroyBold(size: 14, color: cBlack),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            )
          ],
        ),
      ),
    );
  }
}
