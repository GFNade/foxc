import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/extensions/int_extension.dart';
import 'package:untitled/common/widgets/my_cached_image.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/room_model.dart';
import 'package:untitled/screens/chats_screen/chatting_screen/chatting_view.dart';
import 'package:untitled/screens/rooms_screen/room_controller.dart';
import 'package:untitled/screens/rooms_screen/room_sheet.dart';
import 'package:untitled/utilities/const.dart';

class RoomCard extends StatelessWidget {
  final Room room;
  final bool isFromHome;

  const RoomCard({Key? key, required this.room, this.isFromHome = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = RoomController(room);
    return GetBuilder(
        tag: '${room.id}',
        init: controller,
        builder: (controller) {
          return GestureDetector(
            onTap: () {
              if (controller.room.getUserAccessType() == GroupUserAccessType.member ||
                  controller.room.getUserAccessType() == GroupUserAccessType.admin ||
                  controller.room.getUserAccessType() == GroupUserAccessType.coAdmin) {
                Get.to(() => ChattingView(room: controller.room))?.then(controller.onBack);
              } else {
                Get.bottomSheet(
                    RoomSheet(
                      controller: controller,
                      room: controller.room,
                    ),
                    isScrollControlled: true);
              }
            },
            child: isFromHome ? homeCard(controller) : simpleCard(controller),
          );
        });
  }

  Widget simpleCard(RoomController controller) {
    return Container(
      decoration: ShapeDecoration(
          color: cLightBg.withOpacity(0.5),
          shape: const SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.all(SmoothRadius(cornerRadius: 12, cornerSmoothing: cornerSmoothing)))),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                  child: MyCachedImage(
                imageUrl: controller.room.photo,
                width: 60,
                height: 60,
              )),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.room.title ?? '',
                      style: MyTextStyle.gilroyBold(size: 20, color: cBlack),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text(
                          (controller.room.totalMember ?? 0).makeToString(),
                          style: MyTextStyle.gilroySemiBold(size: 17, color: cLightText),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          LKeys.members.tr,
                          style: MyTextStyle.gilroyLight(size: 17, color: cLightText),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Text(
            controller.room.desc ?? '',
            style: MyTextStyle.gilroyLight(color: cBlack),
          ),
          const SizedBox(height: 5),
          Wrap(
            children: controller.room.getInterests().map((e) {
              return RoomCardInterestTagToShow(
                tag: e.title ?? '',
                color: cGreen,
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget homeCard(RoomController controller) {
    return ClipSmoothRect(
      radius: const SmoothBorderRadius.all(SmoothRadius(cornerRadius: 15, cornerSmoothing: cornerSmoothing)),
      child: Column(
        children: [
          MyCachedImage(
            imageUrl: controller.room.photo,
            width: Get.width / 2.3,
            height: 120,
          ),
          Expanded(
            child: Container(
              width: Get.width / 2.3,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              color: cDarkGreen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.room.title ?? '',
                    style: MyTextStyle.gilroySemiBold(color: cWhite),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    controller.room.getInterestWithHashtag().toLowerCase(),
                    style: MyTextStyle.gilroyRegular(color: cPrimary),
                    // overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const SizedBox(width: 5),
                      Text(
                        (controller.room.totalMember ?? 0).makeToString(),
                        style: MyTextStyle.gilroySemiBold(size: 14, color: cWhite),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        LKeys.members.tr,
                        style: MyTextStyle.gilroyLight(size: 14, color: cWhite),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RoomCardInterestTagToShow extends StatelessWidget {
  const RoomCardInterestTagToShow({Key? key, required this.tag, this.color = cPrimary}) : super(key: key);
  final String tag;

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(100)),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      margin: const EdgeInsets.only(right: 5, top: 5, bottom: 5),
      child: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          tag.toUpperCase(),
          style: MyTextStyle.gilroyBold(size: 13, color: color).copyWith(letterSpacing: 0.5),
        ),
      ),
    );
  }
}
