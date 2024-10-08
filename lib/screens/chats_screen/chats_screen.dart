import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/extensions/image_extension.dart';
import 'package:untitled/common/widgets/no_data_found.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/chat.dart';
import 'package:untitled/screens/chats_screen/chat_view/chat_card.dart';
import 'package:untitled/screens/chats_screen/chats_screen_controller.dart';
import 'package:untitled/screens/extra_views/back_button.dart';
import 'package:untitled/screens/extra_views/logo_tag.dart';
import 'package:untitled/utilities/const.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatsScreensController controller = ChatsScreensController();
    return GetBuilder<ChatsScreensController>(
        init: controller,
        builder: (controller) {
          return Column(
            children: [
              top(controller),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    segmentController(controller),
                    const SizedBox(height: 15),
                    Expanded(
                      child: PageView(
                        controller: controller.controller,
                        onPageChanged: controller.onChangePage,
                        children: [
                          chatList(controller, 1),
                          chatList(controller, 2),
                          chatList(controller, 0),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  Widget chatList(ChatsScreensController controller, int type) {
    List<ChatUserRoom> chats = (type == 2)
        ? controller.filterRoomChats
        : controller.filterChats
            .where((element) => element.type == type)
            .toList();

    return chats.isEmpty
        ? NoDataFound(controller: controller)
        : ListView.builder(
            padding: const EdgeInsets.only(top: 0),
            itemCount: chats.length,
            itemBuilder: (context, index) {
              var chatUserRoom = chats[index];
              return GestureDetector(
                  onLongPress: () {
                    Get.bottomSheet(Wrap(
                      children: [
                        Container(
                          decoration: const ShapeDecoration(
                            shape: SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius.only(
                                    topLeft: SmoothRadius(
                                        cornerRadius: 30,
                                        cornerSmoothing: cornerSmoothing),
                                    topRight: SmoothRadius(
                                        cornerRadius: 30,
                                        cornerSmoothing: cornerSmoothing))),
                            color: cBlack,
                          ),
                          padding: const EdgeInsets.all(25),
                          child: SafeArea(
                            top: false,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      chatUserRoom.title ?? '',
                                      style: MyTextStyle.gilroyBold(
                                          size: 22, color: cWhite),
                                    ),
                                    const Spacer(),
                                    const XMarkButton(),
                                  ],
                                ),
                                const SizedBox(height: 40),
                                ChatSheetButton(
                                  title: chatUserRoom.newMsgCount == 0
                                      ? LKeys.markAsUnread.tr
                                      : LKeys.markAsRead.tr,
                                  onTap: () =>
                                      controller.markToggle(chatUserRoom),
                                ),
                                const Divider(
                                  color: cLightText,
                                ),
                                const SizedBox(height: 5),
                                ChatSheetButton(
                                  title: LKeys.clearChat.tr,
                                  onTap: () =>
                                      controller.clearChat(chatUserRoom),
                                ),
                                const SizedBox(height: 5),
                                const Divider(
                                  color: cLightText,
                                ),
                                ChatSheetButton(
                                  title: LKeys.deleteChat.tr,
                                  onTap: () =>
                                      controller.deleteChat(chatUserRoom),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ));
                  },
                  child: ChatCard(chatUserRoom: chatUserRoom));
            },
          );
  }

  Widget segmentController(ChatsScreensController controller) {
    return CupertinoSlidingSegmentedControl(
      children: {
        0: buildSegment(LKeys.chats, 0, controller),
        1: buildSegment(LKeys.rooms, 1, controller),
        2: buildSegment(LKeys.requests, 2, controller),
      },
      groupValue: controller.selectedPage,
      backgroundColor: cLightText.withOpacity(0.2),
      thumbColor: cBlack,
      padding: const EdgeInsets.all(0),
      onValueChanged: (value) {
        controller.onChangeSegment(value ?? 0);
      },
    );
  }

  Widget buildSegment(
      String text, int index, ChatsScreensController controller) {
    return Container(
      alignment: Alignment.center,
      width: (Get.width / 3) - 30,
      child: Text(
        text.toUpperCase(),
        style: MyTextStyle.gilroySemiBold(
                size: 13,
                color: controller.selectedPage == index ? cWhite : cBlack)
            .copyWith(letterSpacing: 2),
      ),
    );
  }

  Widget top(ChatsScreensController controller) {
    double imageSize = controller.isSearching ? 17 : 25;
    return Container(
      color: cBG,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SafeArea(
          bottom: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              controller.isSearching
                  ? Expanded(
                      child: TextField(
                        onChanged: controller.onChange,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                            hintText: LKeys.searchHere.tr,
                            hintStyle: MyTextStyle.gilroyRegular(
                                color: cLightText.withOpacity(0.6)),
                            border: InputBorder.none,
                            counterText: '',
                            isDense: true,
                            contentPadding: const EdgeInsets.all(0)),
                        cursorColor: cPrimary,
                        style: MyTextStyle.gilroyRegular(color: cLightText),
                        controller: controller.textEditingController,
                        textInputAction: TextInputAction.newline,
                        autofocus: true,
                      ),
                    )
                  : Expanded(
                      child: Row(
                        children: [
                          SizedBox(width: imageSize),
                          const Spacer(),
                          const LogoTag(),
                          const Spacer(),
                        ],
                      ),
                    ),
              GestureDetector(
                child: Image.asset(
                  controller.isSearching ? MyImages.close : MyImages.search,
                  width: imageSize,
                  height: imageSize,
                ),
                onTap: () {
                  controller.textEditingController.text = "";
                  controller.isSearching = !controller.isSearching;
                  controller.update();
                  controller.onChange('');
                },
              ),
            ],
          )),
    );
  }
}

class ChatSheetButton extends StatelessWidget {
  final String title;
  final Function() onTap;

  const ChatSheetButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          color: cBlack,
          child: Text(title,
              style: MyTextStyle.gilroySemiBold(color: cWhite, size: 18))),
      onTap: () {
        Get.back();
        onTap();
      },
    );
  }
}
