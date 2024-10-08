import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/extensions/string_extension.dart';
import 'package:untitled/common/widgets/buttons/circle_button.dart';
import 'package:untitled/common/widgets/menu.dart';
import 'package:untitled/common/widgets/my_cached_image.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/registration.dart';
import 'package:untitled/models/room_model.dart';
import 'package:untitled/screens/chats_screen/chat_room_view/screens/invite_someone_screen/invite_someone_controller.dart';
import 'package:untitled/screens/extra_views/back_button.dart';
import 'package:untitled/screens/extra_views/search_bar.dart';
import 'package:untitled/screens/extra_views/top_bar.dart';
import 'package:untitled/screens/profile_screen/profile_screen.dart';
import 'package:untitled/utilities/const.dart';

class InviteSomeoneScreen extends StatelessWidget {
  final Room? room;

  const InviteSomeoneScreen({Key? key, this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InviteSomeoneController controller = InviteSomeoneController(room);
    return Scaffold(
      body: GetBuilder(
          init: controller,
          builder: (context) {
            return Column(
              children: [
                TopBarForInView(
                  title: LKeys.inviteSomeone,
                  verticalChild: Container(
                    padding: const EdgeInsets.only(
                        right: 10, top: 5, bottom: 3, left: 10),
                    decoration: ShapeDecoration(
                        shape: const SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius.all(SmoothRadius(
                                cornerRadius: 5,
                                cornerSmoothing: cornerSmoothing))),
                        color: cPrimary.withOpacity(0.1)),
                    child: Text(
                      (room?.title ?? '').toUpperCase(),
                      style:
                          MyTextStyle.gilroySemiBold(color: cPrimary, size: 12)
                              .copyWith(letterSpacing: 1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                MySearchBar(
                  controller: controller.textEditingController,
                  onChange: (text) {
                    controller.searchUser(shouldErase: true);
                  },
                ),
                Expanded(
                  child: SmartRefresher(
                    enablePullUp: true,
                    enablePullDown: false,
                    controller: controller.refreshController,
                    enableTwoLevel: false,
                    onLoading: () {
                      controller.searchUser();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: controller.users.length,
                      itemBuilder: (context, index) {
                        var user = controller.users[index];
                        return RoomMemberCard(
                          type: RoomMemberType.user,
                          user: user,
                          onTapInvitation: () {
                            controller.inviteUser(user);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class RoomMemberCard extends StatelessWidget {
  final User user;
  final RoomMemberType type;
  final Function()? onTapInvitation;
  final Function()? onRequestAccept;
  final Function()? onRequestReject;
  final Function()? onAdminRemove;
  final Function()? onMakeAdmin;
  final Function()? onRemoveFromRoom;

  const RoomMemberCard(
      {Key? key,
      required this.type,
      required this.user,
      this.onTapInvitation,
      this.onRequestAccept,
      this.onRequestReject,
      this.onAdminRemove,
      this.onMakeAdmin,
      this.onRemoveFromRoom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => ProfileScreen(userId: user.id ?? 0));
          },
          child: Row(
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
              button()
            ],
          ),
        ),
        const Divider()
      ],
    );
  }

  Widget button() {
    if (type == RoomMemberType.user) {
      return GestureDetector(
        onTap: onTapInvitation,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 18),
          decoration: ShapeDecoration(
              color: cPrimary.withOpacity(0.15),
              shape: const SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius.all(SmoothRadius(
                      cornerRadius: 5, cornerSmoothing: cornerSmoothing)))),
          child: Text(
            LKeys.invite.tr.toUpperCase(),
            style:
                MyTextStyle.gilroySemiBold(size: 11).copyWith(letterSpacing: 1),
          ),
        ),
      );
    } else if (type == RoomMemberType.admin) {
      return GestureDetector(
        onTap: onAdminRemove,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 18),
          decoration: ShapeDecoration(
              color: cRed.withOpacity(0.15),
              shape: const SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius.all(SmoothRadius(
                      cornerRadius: 5, cornerSmoothing: cornerSmoothing)))),
          child: Text(
            LKeys.remove.tr.toUpperCase(),
            style: MyTextStyle.gilroySemiBold(size: 11)
                .copyWith(letterSpacing: 1, color: cRed),
          ),
        ),
      );
    } else if (type == RoomMemberType.requested) {
      return Row(
        children: [
          CircleIcon(
              color: cGreen,
              iconData: Icons.check_rounded,
              onTap: onRequestAccept),
          const SizedBox(width: 7),
          CircleIcon(
            color: cRed,
            iconData: Icons.close_rounded,
            onTap: onRequestReject,
          ),
        ],
      );
    } else if (type == RoomMemberType.member) {
      return Menu(
        items: [
          PopupMenuItem(
              onTap: onMakeAdmin,
              child: LKeys.makeAdmin.toTextTR(MyTextStyle.gilroyMedium())),
          PopupMenuItem(
              onTap: onRemoveFromRoom,
              child: LKeys.removeFromRoom.toTextTR(MyTextStyle.gilroyMedium()))
        ],
        color: cLightText,
      );
    } else if (type == RoomMemberType.owner) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 18),
        decoration: ShapeDecoration(
            shape: const SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.all(SmoothRadius(
                    cornerRadius: 5, cornerSmoothing: cornerSmoothing))),
            color: cGreen.withOpacity(0.15)),
        child: Text(
          LKeys.owner.tr.toUpperCase(),
          style: MyTextStyle.gilroySemiBold(size: 11)
              .copyWith(letterSpacing: 1, color: cGreen),
        ),
      );
    }
    return Container();
  }
}

enum RoomMemberType {
  user,
  member,
  admin,
  owner,
  unknown,
  requested;
}
