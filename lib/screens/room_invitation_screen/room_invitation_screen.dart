import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/extensions/int_extension.dart';
import 'package:untitled/common/widgets/buttons/circle_button.dart';
import 'package:untitled/common/widgets/my_cached_image.dart';
import 'package:untitled/common/widgets/no_data_found.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/invitations_model.dart';
import 'package:untitled/screens/extra_views/top_bar.dart';
import 'package:untitled/screens/profile_screen/profile_screen.dart';
import 'package:untitled/screens/room_invitation_screen/invitation_controller.dart';
import 'package:untitled/screens/sheets/confirmation_sheet.dart';
import 'package:untitled/utilities/const.dart';

class RoomInvitationScreen extends StatelessWidget {
  const RoomInvitationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = InvitationController();
    return Scaffold(
      body: GetBuilder(
          init: controller,
          builder: (controller) {
            return Column(
              children: [
                const TopBarForInView(title: LKeys.roomsInvitation),
                Expanded(
                    child: controller.invitations.isEmpty
                        ? NoDataFound(controller: controller)
                        : ListView.builder(
                            controller: controller.scrollController,
                            padding: const EdgeInsets.all(10),
                            itemCount: controller.invitations.length,
                            itemBuilder: (context, index) {
                              var invitation = controller.invitations[index];
                              return RoomInvitationCard(
                                invitation: invitation,
                                onAccept: () {
                                  controller.acceptInvitation(invitation);
                                },
                                onReject: () {
                                  Get.bottomSheet(ConfirmationSheet(
                                    desc: LKeys.rejectInvitationDisc,
                                    buttonTitle: LKeys.delete,
                                    onTap: () {
                                      controller.rejectInvitation(invitation);
                                    },
                                  ));
                                },
                              );
                            },
                          ))
              ],
            );
          }),
    );
  }
}

class RoomInvitationCard extends StatelessWidget {
  final Invitation invitation;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const RoomInvitationCard({Key? key, required this.invitation, required this.onAccept, required this.onReject})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ClipOval(
              child: MyCachedImage(
                imageUrl: invitation.room?.photo,
                width: 70,
                height: 70,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    invitation.room?.title ?? '',
                    style: MyTextStyle.gilroyBold(size: 20),
                  ),
                  Row(
                    children: [
                      Text(
                        (invitation.room?.totalMember ?? 0).makeToString(),
                        style: MyTextStyle.gilroyBold(color: cLightText),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        LKeys.members.tr,
                        style: MyTextStyle.gilroyLight(color: cLightText),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        LKeys.invitedBy.tr,
                        style: MyTextStyle.gilroySemiBold(color: cLightText, size: 14),
                      ),
                      const SizedBox(width: 7),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => ProfileScreen(userId: invitation.userId ?? 0), arguments: invitation.userId);
                        },
                        child: Container(
                          decoration: ShapeDecoration(
                              shape: const SmoothRectangleBorder(
                                  borderRadius: SmoothBorderRadius.all(
                                      SmoothRadius(cornerRadius: 8, cornerSmoothing: cornerSmoothing))),
                              color: cLightBg),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Text(
                            "@${invitation.invitedUser?.username ?? ''}",
                            style: MyTextStyle.gilroySemiBold(color: cBlack, size: 12),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            CircleIcon(
              color: cGreen,
              iconData: Icons.check_rounded,
              onTap: onAccept,
            ),
            const SizedBox(width: 7),
            CircleIcon(
              color: cRed,
              iconData: Icons.close_rounded,
              onTap: onReject,
            ),
          ],
        ),
        const Divider()
      ],
    );
  }
}
