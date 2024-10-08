import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/common/extensions/int_extension.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/registration.dart';
import 'package:untitled/screens/extra_views/top_bar.dart';
import 'package:untitled/screens/profile_screen/follower_following/follower_following_controller.dart';
import 'package:untitled/screens/search_screen/search_screen.dart';

class FollowerFollowingScreen extends StatelessWidget {
  final bool isForFollowing;
  final User? user;

  const FollowerFollowingScreen(
      {Key? key, required this.isForFollowing, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    FollowerFollowingController controller =
        FollowerFollowingController(isForFollowing, user?.id ?? 0);
    return Scaffold(
      body: Column(
        children: [
          TopBarForInView(
            title: isForFollowing
                ? "${(user?.following ?? 0).makeToString()} ${LKeys.following.tr}"
                : "${(user?.followers ?? 0).makeToString()} ${LKeys.followers.tr}",
          ),
          GetBuilder(
              init: controller,
              tag: '${user?.id ?? 0}',
              builder: (context) {
                return Expanded(
                  child: SmartRefresher(
                    enablePullUp: true,
                    enablePullDown: false,
                    controller: controller.refreshController,
                    enableTwoLevel: false,
                    onLoading: () {
                      controller.fetchUsers();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: controller.users.length,
                      itemBuilder: (context, index) {
                        return ProfileCard(user: controller.users[index]);
                      },
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }
}
