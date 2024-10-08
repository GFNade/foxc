import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/widgets/my_cached_image.dart';
import 'package:untitled/models/chat.dart';
import 'package:untitled/models/registration.dart';
import 'package:untitled/screens/chats_screen/chatting_screen/chatting_controller.dart';
import 'package:untitled/screens/chats_screen/chatting_screen/content_full_screen.dart';
import 'package:untitled/screens/extra_views/back_button.dart';
import 'package:untitled/utilities/const.dart';
import 'package:untitled/utilities/firebase_const.dart';

class ChatTag extends StatelessWidget {
  final ChattingController controller;
  final int index;
  final ChatMessage message;
  final bool isFromRoom;

  const ChatTag(
      {Key? key, required this.index, required this.message, this.isFromRoom = false, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isMyMsg = message.senderId == SessionManager.shared.getUserID();
    var msgType = message.msgType == 'TEXT'
        ? MessageType.text
        : (message.msgType == 'IMAGE' ? MessageType.image : MessageType.video);
    return Row(
      mainAxisAlignment: isMyMsg ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        isMyMsg ? const Spacer() : Container(),
        Column(
          crossAxisAlignment: isMyMsg ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: Get.width * 0.6),
              padding: EdgeInsets.only(
                  top: message.msgType == "TEXT" ? 10 : 5,
                  bottom: message.msgType == "TEXT"
                      ? message.msg == ""
                          ? 5
                          : 10
                      : 5,
                  right: 10,
                  left: 10),
              margin: const EdgeInsets.symmetric(vertical: 3),
              decoration: ShapeDecoration(
                color: isMyMsg ? cBlack : cLightText.withOpacity(0.15),
                shape: const SmoothRectangleBorder(
                    borderRadius:
                        SmoothBorderRadius.all(SmoothRadius(cornerRadius: 8, cornerSmoothing: cornerSmoothing))),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  !isMyMsg && isFromRoom
                      ? Column(
                          children: [
                            FittedBox(
                              child: Row(
                                children: [
                                  Text(
                                    controller.room?.roomUsers
                                            ?.firstWhere(
                                              (element) => element.id == message.senderId,
                                              orElse: () => User(fullName: 'Unknown'),
                                            )
                                            .fullName ??
                                        '',
                                    style: MyTextStyle.gilroyBold(color: cBlack),
                                  ),
                                  const SizedBox(width: 5),
                                  const VerifyIcon()
                                ],
                              ),
                            ),
                            const SizedBox(height: 2),
                          ],
                        )
                      : const Column(),
                  msgType == MessageType.text
                      ? Text(
                          message.msg ?? '',
                          style: MyTextStyle.gilroyRegular(color: isMyMsg ? cWhite : cBlack, size: 16),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            ClipSmoothRect(
                              radius: const SmoothBorderRadius.all(
                                  SmoothRadius(cornerRadius: 5, cornerSmoothing: cornerSmoothing)),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.bottomSheet(ContentFullScreen(message: message),
                                          ignoreSafeArea: false, isScrollControlled: true);
                                    },
                                    child: MyCachedImage(
                                      imageUrl: msgType == MessageType.video ? message.thumbnail : message.content,
                                      width: Get.width * 0.6,
                                      height: Get.width * 0.6,
                                    ),
                                  ),
                                  msgType == MessageType.video
                                      ? const CircleAvatar(
                                          radius: 13,
                                          backgroundColor: cPrimary,
                                          foregroundColor: cBlack,
                                          child: Icon(Icons.play_arrow_rounded, size: 20),
                                        )
                                      : Container(width: 0),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            (message.msg ?? '') != ''
                                ? Text(
                                    message.msg ?? '',
                                    style: MyTextStyle.gilroyRegular(color: isMyMsg ? cWhite : cBlack, size: 16),
                                  )
                                : Container(width: 0),
                          ],
                        ),
                ],
              ),
            ),
            Text(
              message.getChatTime(),
              style: MyTextStyle.gilroyRegular(size: 12, color: cLightText),
            ),
            const SizedBox(
              height: 4,
            )
          ],
        ),
        !isMyMsg ? const Spacer() : Container(),
      ],
    );
  }
}

class ChatButton extends StatelessWidget {
  final String title;
  final Color color;
  final Function()? onTap;

  const ChatButton({Key? key, required this.title, required this.color, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 30),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(100)),
        child: Text(
          title.tr,
          style: MyTextStyle.gilroySemiBold(color: color),
        ),
      ),
    );
  }
}
