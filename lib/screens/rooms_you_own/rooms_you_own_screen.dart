import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/extensions/int_extension.dart';
import 'package:untitled/common/managers/navigation.dart';
import 'package:untitled/common/widgets/my_cached_image.dart';
import 'package:untitled/common/widgets/no_data_found.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/room_model.dart';
import 'package:untitled/screens/chats_screen/chatting_screen/chatting_view.dart';
import 'package:untitled/screens/extra_views/buttons.dart';
import 'package:untitled/screens/extra_views/top_bar.dart';
import 'package:untitled/screens/rooms_you_own/create_room_screen/create_room_screen.dart';
import 'package:untitled/screens/rooms_you_own/rooms_you_own_controller.dart';
import 'package:untitled/utilities/const.dart';

class RoomsYouOwnScreen extends StatelessWidget {
  const RoomsYouOwnScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = RoomsYouOwnController();
    return Scaffold(
      body: Column(
        children: [
          const TopBarForInView(title: LKeys.roomsYouOwn),
          Expanded(
            child: GetBuilder(
                init: controller,
                builder: (controller) {
                  return controller.rooms.isEmpty
                      ? NoDataFound(controller: controller)
                      : ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: controller.rooms.length,
                          itemBuilder: (context, index) {
                            return MyRoomCard(
                              room: controller.rooms[index],
                              onBack: controller.getMyRooms,
                            );
                          },
                        );
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CommonButton(
                text: LKeys.createNewRoom,
                onTap: () {
                  Navigate.to(const CreateRoomScreen())?.then((value) {
                    if (value is Room) {
                      controller.rooms.add(value);
                      controller.update();
                    }
                  });
                }),
          )
        ],
      ),
    );
  }
}

class MyRoomCard extends StatelessWidget {
  final Room room;
  final Function() onBack;

  const MyRoomCard({Key? key, required this.room, required this.onBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ChattingView(
              room: room,
            ))?.then((value) {
          onBack();
        });
      },
      child: Column(
        children: [
          Container(
            color: Colors.transparent,
            child: Row(
              children: [
                ClipOval(
                    child: MyCachedImage(
                        imageUrl: room.photo, width: 60, height: 60)),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.title ?? '',
                      style: MyTextStyle.gilroyBold(size: 20),
                    ),
                    Row(
                      children: [
                        Text(
                          (room.totalMember ?? 0).makeToString(),
                          style: MyTextStyle.gilroyBold(color: cLightText),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          LKeys.members.tr,
                          style: MyTextStyle.gilroyLight(color: cLightText),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          const Divider()
        ],
      ),
    );
  }
}
