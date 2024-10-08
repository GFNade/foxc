import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/screens/rooms_screen/room_card.dart';
import 'package:untitled/screens/rooms_screen/room_screen_top_bar.dart';
import 'package:untitled/screens/rooms_screen/rooms_by_interest/room_explore_by_interests.dart';
import 'package:untitled/screens/rooms_screen/rooms_by_interest/rooms_by_interest_controller.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = RoomsByInterestController();
    controller.fetchRandomRooms();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RoomScreenTopBar(),
        Expanded(
          child: SingleChildScrollView(
            primary: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RoomExploreByInterests(),
                GetBuilder(
                    init: controller,
                    tag: 'all',
                    builder: (controller) {
                      return ListView.builder(
                        padding: const EdgeInsets.only(top: 0, bottom: 10),
                        shrinkWrap: true,
                        primary: false,
                        itemCount: controller.rooms.length,
                        itemBuilder: (context, index) {
                          return RoomCard(room: controller.rooms[index]);
                        },
                      );
                    }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
