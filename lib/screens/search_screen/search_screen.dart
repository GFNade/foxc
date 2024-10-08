import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/widgets/my_cached_image.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/registration.dart';
import 'package:untitled/screens/extra_views/back_button.dart';
import 'package:untitled/screens/extra_views/search_bar.dart';
import 'package:untitled/screens/extra_views/top_bar.dart';
import 'package:untitled/screens/profile_screen/profile_screen.dart';
import 'package:untitled/screens/search_screen/search_controller.dart';
import 'package:untitled/utilities/const.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = SearchScreenController();
    return Scaffold(
      body: GetBuilder(
          init: controller,
          builder: (context) {
            return Column(
              children: [
                const TopBarForInView(title: LKeys.search),
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
                        return ProfileCard(user: controller.users[index]);
                      },
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final User user;

  const ProfileCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ProfileScreen(
              userId: user.id ?? 0,
            ));
      },
      child: Container(
        color: cWhite,
        child: Column(
          children: [
            Row(
              children: [
                ClipSmoothRect(
                  radius:
                      const SmoothBorderRadius.all(SmoothRadius(cornerRadius: 12, cornerSmoothing: cornerSmoothing)),
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
                          user.fullName ?? 'Unknown',
                          style: MyTextStyle.gilroyBold(size: 17),
                        ),
                        const SizedBox(width: 2),
                        VerifyIcon(user: user)
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "@${user.username ?? "unknown"}",
                      style: MyTextStyle.gilroyLight(color: cLightText, size: 15),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
            const Divider()
          ],
        ),
      ),
    );
  }
}
