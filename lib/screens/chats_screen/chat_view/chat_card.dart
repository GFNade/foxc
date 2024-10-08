import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled/common/extensions/date_time_extension.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/extensions/int_extension.dart';
import 'package:untitled/common/managers/navigation.dart';
import 'package:untitled/common/widgets/my_cached_image.dart';
import 'package:untitled/models/chat.dart';
import 'package:untitled/screens/chats_screen/chatting_screen/chatting_view.dart';
import 'package:untitled/screens/extra_views/back_button.dart';
import 'package:untitled/utilities/const.dart';

class ChatCard extends StatelessWidget {
  final ChatUserRoom chatUserRoom;

  const ChatCard({Key? key, required this.chatUserRoom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigate.to(ChattingView(chatUserRoom: chatUserRoom));
      },
      child: Container(
        decoration: const ShapeDecoration(
            shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.all(SmoothRadius(
                    cornerRadius: 8, cornerSmoothing: cornerSmoothing))),
            color: cLightBg),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          children: [
            ClipSmoothRect(
              radius: const SmoothBorderRadius.all(SmoothRadius(
                  cornerRadius: 15, cornerSmoothing: cornerSmoothing)),
              child: MyCachedProfileImage(
                imageUrl: chatUserRoom.profileImage,
                fullName: chatUserRoom.title,
                width: 50,
                height: 50,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chatUserRoom.title ?? '',
                          style: MyTextStyle.gilroyBold(size: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const VerifyIcon()
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    chatUserRoom.lastMsg ?? '',
                    style: MyTextStyle.gilroyLight(size: 14, color: cLightText),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  chatUserRoom.time?.timeAgo() ?? '',
                  style: MyTextStyle.gilroyLight(size: 14, color: cLightText),
                ),
                Opacity(
                  opacity: chatUserRoom.newMsgCount != 0 ? 1 : 0,
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 8, left: 8, right: 8),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: cPrimary),
                    child: Text(
                      (chatUserRoom.newMsgCount == -1
                          ? ""
                          : chatUserRoom.newMsgCount?.makeToString() ?? ''),
                      style: MyTextStyle.gilroyBold(size: 14, color: cBlack),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
