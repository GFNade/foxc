import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/date_time_extension.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/extensions/int_extension.dart';
import 'package:untitled/common/widgets/my_cached_image.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/room_model.dart';
import 'package:untitled/screens/extra_views/back_button.dart';
import 'package:untitled/screens/extra_views/buttons.dart';
import 'package:untitled/screens/profile_screen/profile_screen.dart';
import 'package:untitled/screens/rooms_screen/room_card.dart';
import 'package:untitled/screens/rooms_screen/room_controller.dart';
import 'package:untitled/utilities/const.dart';

class RoomSheet extends StatelessWidget {
  const RoomSheet(
      {Key? key, this.isFromInfo = false, required this.room, required this.controller})
      : super(key: key);
  final bool isFromInfo;
  final Room room;
  final RoomController controller;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        GetBuilder(
            init: controller,
            builder: (controller) {
              return Container(
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
                          ClipOval(
                            child: MyCachedImage(
                                imageUrl: room.photo, width: 60, height: 60),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  room.title ?? '',
                                  style: MyTextStyle.gilroyBold(
                                      size: 19, color: cWhite),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      (room.totalMember ?? 0).makeToString(),
                                      style: MyTextStyle.gilroyBold(
                                          size: 16, color: cPrimary),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      LKeys.members.tr,
                                      style: MyTextStyle.gilroyLight(
                                          size: 16, color: cPrimary),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const XMarkButton()
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        children: room.getInterests().map((e) {
                          return RoomCardInterestTagToShow(
                            tag: e.title ?? '',
                            color: cGreen,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        room.desc ?? '',
                        style: MyTextStyle.gilroyLight(color: cLightIcon),
                      ),
                      const SizedBox(height: 30),
                      isFromInfo || room.isPrivate == 0
                          ? SizedBox(
                        height: isFromInfo ? 200 : null,
                        child: isFromInfo
                            ? infoView()
                            : room.isJoinRequestEnable == 1
                            ? Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              LKeys.requestToJoinThisRoom.tr,
                              style: MyTextStyle.gilroyBold(
                                  size: 20, color: cLightIcon),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              LKeys.requestToJoinDesc.tr,
                              style: MyTextStyle.gilroyLight(
                                  color: cLightIcon, size: 16),
                            ),
                            const SizedBox(height: 20),
                          ],
                        )
                            : Container(),
                      )
                          : Container(),
                      isFromInfo
                          ? Container()
                          : CommonSheetButton(
                        color: controller.room.getUserAccessType() ==
                            GroupUserAccessType.requested
                            ? cLightText.withOpacity(0.7)
                            : cWhite,
                        title: room.getUserAccessType() ==
                            GroupUserAccessType.invited
                            ? LKeys.acceptInvitation
                            : room.isJoinRequestEnable == 1
                            ? controller.room.getUserAccessType() ==
                            GroupUserAccessType.requested
                            ? LKeys.requested
                            : LKeys.requestToJoin
                            : LKeys.joinThisRoom,
                        onTap: controller.joinOrRequestOrAccept,
                      )
                    ],
                  ),
                ),
              );
            }),
      ],
    );
  }

  Widget infoView() {
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 70,
            child: Stack(
              children: List.generate(room.roomUsers?.length ?? 0, (index) {
                return Positioned(
                  left: index * 40,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: cWhite.withOpacity(0.8), width: 2),
                        shape: BoxShape.circle),
                    // padding: const EdgeInsets.all(1.5),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    child: ClipOval(
                      child: MyCachedImage(
                        imageUrl: room.roomUsers?[index].profile,
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 40), // const SizedBox(height: 40),
          Row(
            children: [
              Text(
                LKeys.createdOn.tr,
                style: MyTextStyle.gilroyLight(color: cWhite),
              ),
              const SizedBox(width: 5),
              Text(
                DateTime.parse(room.createdAt ?? '').formatFullDate(),
                style: MyTextStyle.gilroySemiBold(color: cPrimary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Get.back();
              Get.to(() => ProfileScreen(userId: room.admin?.id ?? 0));
            },
            child: Row(
              children: [
                Text(
                  LKeys.createdBy.tr,
                  style: MyTextStyle.gilroyLight(color: cWhite),
                ),
                const SizedBox(width: 5),
                Text(
                  '@${room.admin?.username ?? 'unknown'}',
                  style: MyTextStyle.gilroySemiBold(color: cPrimary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
