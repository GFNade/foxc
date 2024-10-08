import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/screens/extra_views/top_bar.dart';
import 'package:untitled/screens/rooms_screen/room_card.dart';
import 'package:untitled/screens/rooms_screen/single_room/single_room_controller.dart';

class SingleRoomScreen extends StatelessWidget {
  final int roomId;

  const SingleRoomScreen({Key? key, required this.roomId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SingleRoomController controller = SingleRoomController(roomId);
    return Scaffold(
      body: Column(
        children: [
          TopBarForInView(title: LKeys.rooms.tr),
          GetBuilder(
            init: controller,
            builder: (controller) {
              return controller.room != null
                  ? RoomCard(room: controller.room!)
                  : Container();
            },
          )
        ],
      ),
    );
  }
}
