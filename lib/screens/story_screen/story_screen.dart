import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/date_time_extension.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/common/widgets/menu.dart';
import 'package:untitled/common/widgets/my_cached_image.dart';
import 'package:untitled/library/story_view/story_view.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/registration.dart';
import 'package:untitled/screens/extra_views/back_button.dart';
import 'package:untitled/screens/profile_screen/profile_screen.dart';
import 'package:untitled/screens/story_screen/story_screen_controller.dart';
import 'package:untitled/utilities/const.dart';

class StoryScreen extends StatelessWidget {
  final List<User> users;
  final int index;

  const StoryScreen({Key? key, required this.users, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    StoryScreenController controller =
        StoryScreenController(users, index, PageController(initialPage: index));
    return Container(
      color: Colors.black,
      child: GetBuilder<StoryScreenController>(
          init: controller,
          builder: (context) {
            return PageView(
              allowImplicitScrolling: false,
              controller: controller.pageController,
              onPageChanged: controller.onPageChange,
              children: List.generate(controller.stories.length, (index) {
                return StoryView(
                  storyItems: controller.stories[index],
                  inline: true,
                  onStoryShow: controller.onStoryShow,
                  onBack: controller.onPreviousUser,
                  onComplete: controller.onNext,
                  progressPosition: ProgressPosition.top,
                  repeat: false,
                  controller: controller.storyController,
                  overlayWidget: (item) {
                    var user = item.story?.user;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 23, horizontal: 15),
                      child: GestureDetector(
                        onTap: () {
                          controller.storyController.pause();
                          Get.to(() => ProfileScreen(userId: user?.id ?? 0))
                              ?.then((value) {
                            controller.storyController.play();
                          });
                        },
                        child: Row(
                          children: [
                            ClipSmoothRect(
                              radius: const SmoothBorderRadius.all(SmoothRadius(
                                  cornerRadius: 8,
                                  cornerSmoothing: cornerSmoothing)),
                              child: MyCachedImage(
                                imageUrl: user?.profile,
                                width: 40,
                                height: 40,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        user?.fullName ?? 'Unknown',
                                        style: MyTextStyle.gilroyBold(
                                            size: 16, color: cWhite),
                                      ),
                                      const SizedBox(width: 2),
                                      VerifyIcon(user: user),
                                      const Spacer(),
                                      Text(
                                        item.story?.date.timeAgoShort() ??
                                            'now',
                                        style: MyTextStyle.gilroyLight(
                                            color: cWhite, size: 14),
                                      ),
                                      const SizedBox(width: 3),
                                      (user?.id ==
                                              SessionManager.shared.getUserID())
                                          ? Menu(
                                              items: [
                                                PopupMenuItem(
                                                  value: LKeys.delete.tr,
                                                  onTap: () {
                                                    controller.storyController
                                                        .pause();
                                                    if (item.story != null) {
                                                      controller.deleteStory(
                                                          item.story!);
                                                    }
                                                  },
                                                  child: Text(
                                                    LKeys.delete.tr,
                                                    style: MyTextStyle
                                                        .gilroyRegular(),
                                                  ),
                                                )
                                              ],
                                              isFromPost: true,
                                              isForVideo: true,
                                            )
                                          : Container()
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "@${user?.username ?? "unknown"}",
                                    style: MyTextStyle.gilroyLight(
                                        color: cWhite, size: 15),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  // onVerticalSwipeComplete: (p0) {
                  //   Get.back();
                  // },
                );
              }),
            );
          }),
    );
  }
}

// onNextTap: controller.onChangeOfStory,
// onStoryShowComplete: controller.onUserChange
