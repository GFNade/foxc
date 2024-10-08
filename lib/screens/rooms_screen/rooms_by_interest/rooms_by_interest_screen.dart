import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/common/widgets/no_data_found.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/setting_model.dart';
import 'package:untitled/screens/extra_views/top_bar.dart';
import 'package:untitled/screens/rooms_screen/room_card.dart';
import 'package:untitled/screens/rooms_screen/rooms_by_interest/room_explore_by_interests.dart';
import 'package:untitled/screens/rooms_screen/rooms_by_interest/rooms_by_interest_controller.dart';
import 'package:untitled/utilities/const.dart';

class RoomsByInterestScreen extends StatelessWidget {
  final Interest interest;

  const RoomsByInterestScreen({Key? key, required this.interest})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller =
    RoomsByInterestController(interestId: interest.id?.toInt() ?? 0);

    return Scaffold(
      body: GetBuilder(
          init: controller,
          tag: "in ${interest.id}",
          builder: (controller) {
            return Column(
              children: [
                top(),
                Expanded(
                  child: controller.rooms.isEmpty
                      ? NoDataFound(controller: controller)
                      : SmartRefresher(
                    enablePullDown: false,
                    enablePullUp: true,
                    controller: controller.refreshController,
                    onLoading: () {
                      controller.fetchRooms(interest.id?.toInt() ?? 0);
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemCount: controller.rooms.length,
                      itemBuilder: (context, index) {
                        return RoomCard(
                          room: controller.rooms[index],

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

  Widget top() {
    return Container(
      color: cBG,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const BackButton(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TopBarForLogin(
                  titleEnd: LKeys.interests,
                  alignment: MainAxisAlignment.start,
                  titleStart: LKeys.roomsBy,
                  size: 20,
                ),
                RoomInterestTag(
                  tag: interest,
                  count: 1,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
