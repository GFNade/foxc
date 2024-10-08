import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/widgets/no_data_found.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/screens/chats_screen/chat_room_view/screens/invite_someone_screen/invite_someone_screen.dart';
import 'package:untitled/screens/chats_screen/chatting_screen/chatting_controller.dart';
import 'package:untitled/screens/extra_views/top_bar.dart';
import 'package:untitled/utilities/const.dart';

class JoinRequestsScreen extends StatelessWidget {
  final ChattingController controller;

  const JoinRequestsScreen({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(milliseconds: 2),
      () {
        controller.fetchRequests();
      },
    );

    return Scaffold(
      body: Column(
        children: [
          TopBarForInView(
            title: LKeys.joinRequests,
            verticalChild: Container(
              padding:
                  const EdgeInsets.only(right: 10, top: 5, bottom: 3, left: 10),
              // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: ShapeDecoration(
                color: cPrimary.withOpacity(0.1),
                shape: const SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius.all(SmoothRadius(
                        cornerRadius: 5, cornerSmoothing: cornerSmoothing))),
              ),
              child: Text(
                controller.room?.title?.toUpperCase() ?? '',
                style: MyTextStyle.gilroySemiBold(color: cPrimary, size: 12)
                    .copyWith(letterSpacing: 1),
              ),
            ),
          ),
          GetBuilder(
              init: controller,
              tag: 'join',
              builder: (context) {
                return Expanded(
                    child: controller.joinRequests.isEmpty
                        ? NoDataFound(controller: controller)
                        : ListView.builder(
                            padding: const EdgeInsets.all(10),
                            itemCount: controller.joinRequests.length,
                            itemBuilder: (context, index) {
                              return RoomMemberCard(
                                type: RoomMemberType.requested,
                                user: controller.joinRequests[index].user!,
                                onRequestAccept: () {
                                  controller.acceptRequest(
                                      controller.joinRequests[index]);
                                },
                                onRequestReject: () {
                                  controller.rejectRequest(
                                      controller.joinRequests[index]);
                                },
                              );
                            },
                          ));
              })
        ],
      ),
    );
  }
}
