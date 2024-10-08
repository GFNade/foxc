import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/extensions/int_extension.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/registration.dart';
import 'package:untitled/models/room_member_model.dart';
import 'package:untitled/models/room_model.dart';
import 'package:untitled/screens/chats_screen/chat_room_view/screens/invite_someone_screen/invite_someone_screen.dart';
import 'package:untitled/screens/chats_screen/chat_room_view/screens/room_member_screen/room_memebers_controller.dart';
import 'package:untitled/screens/chats_screen/chatting_screen/chatting_controller.dart';
import 'package:untitled/screens/extra_views/top_bar.dart';
import 'package:untitled/utilities/const.dart';

class RoomMembersScreen extends StatelessWidget {
  final ChattingController chattingController;

  const RoomMembersScreen({Key? key, required this.chattingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    RoomMembersController controller =
        RoomMembersController(chattingController);
    return Scaffold(
      body: GetBuilder(
          init: controller,
          builder: (controller) {
            return Column(
              children: [
                top(controller),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        color: cDarkBG,
                        width: double.infinity,
                        child: Column(
                          children: [
                            const SizedBox(height: 15),
                            segmentController(controller),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                      Expanded(
                        child: PageView(
                          controller: controller.controller,
                          onPageChanged: controller.onChangePage,
                          children: [
                            SmartRefresher(
                              controller: controller.refreshController,
                              enablePullDown: false,
                              onLoading: controller.fetchRoomUsers,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(10),
                                itemCount: controller.users.length,
                                itemBuilder: (context, index) {
                                  var member = controller.users[index];
                                  var user = member.user ?? User();
                                  return RoomMemberCard(
                                    type: getType(member),
                                    user: user,
                                    onAdminRemove: () {
                                      controller.removeAdminFromAdmin(member);
                                    },
                                    onMakeAdmin: () {
                                      controller.makeRoomAdmin(member);
                                    },
                                    onRemoveFromRoom: () {
                                      controller.removeUserFromRoom(user);
                                    },
                                  );
                                },
                              ),
                            ),
                            ListView.builder(
                              padding: const EdgeInsets.all(10),
                              itemCount: controller.admins.length,
                              itemBuilder: (context, index) {
                                var user = controller.admins[index];
                                return RoomMemberCard(
                                  type: getType(user),
                                  user: user.user ?? User(),
                                  onAdminRemove: () {
                                    controller.removeAdminFromAdmin(user);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }

  RoomMemberType getType(RoomMember member) {
    if (member.type == GroupUserAccessType.admin.value) {
      return RoomMemberType.owner;
    } else if (member.type == GroupUserAccessType.coAdmin.value) {
      return RoomMemberType.admin;
    }
    return RoomMemberType.member;
  }

  Widget segmentController(RoomMembersController controller) {
    return CupertinoSlidingSegmentedControl(
      children: {
        0: buildSegment(LKeys.allMembers, 0, controller),
        1: buildSegment(LKeys.admins, 1, controller)
      },
      groupValue: controller.selectedPage,
      backgroundColor: cWhite.withOpacity(0.12),
      thumbColor: cWhite,
      padding: const EdgeInsets.all(0),
      onValueChanged: (value) {
        controller.onChangeSegment(value ?? 0);
      },
    );
  }

  Widget buildSegment(
      String text, int index, RoomMembersController controller) {
    return Container(
      alignment: Alignment.center,
      width: (Get.width / 2) - 30,
      child: Text(
        text.tr.toUpperCase(),
        style: MyTextStyle.gilroySemiBold(
                size: 13,
                color: controller.selectedPage == index ? cBlack : cWhite)
            .copyWith(letterSpacing: 2),
      ),
    );
  }

  Widget top(RoomMembersController controller) {
    return TopBarForInView(
        title: LKeys.roomMembers,
        verticalChild: Row(
          children: [
            Text(
              controller.chattingController.room?.totalMember?.makeToString() ??
                  '',
              style: MyTextStyle.gilroyBold(color: cPrimary),
            ),
            const SizedBox(width: 5),
            Text(
              LKeys.members.tr,
              style: MyTextStyle.gilroyLight(color: cPrimary),
            ),
          ],
        ));
  }
}
