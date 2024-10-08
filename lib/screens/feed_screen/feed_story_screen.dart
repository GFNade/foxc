import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/managers/ads/interstitial_manager.dart';
import 'package:untitled/common/widgets/my_cached_image.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/screens/feed_screen/feed_stories_controller.dart';
import 'package:untitled/screens/story_screen/create_story_screen/create_story_screen.dart';
import 'package:untitled/screens/story_screen/story_screen.dart';
import 'package:untitled/utilities/const.dart';

class FeedStoryScreen extends StatelessWidget {
  final FeedStoriesController controller;

  const FeedStoryScreen({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cBG,
      height: 100,
      alignment: Alignment.centerLeft,
      child: GetBuilder(
          init: controller,
          builder: (controller) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              primary: true,
              child: Row(
                children: [
                  myCard(controller),
                  ListView.builder(
                    shrinkWrap: true,
                    // padding: const EdgeInsets.symmetric(: 5),
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.storyUsers.length,
                    itemBuilder: (context, index) {
                      var storyUser = controller.storyUsers[index];
                      return GestureDetector(
                        onTap: () {
                          Get.bottomSheet(StoryScreen(users: controller.storyUsers, index: index),
                                  isScrollControlled: true, ignoreSafeArea: false)
                              .then((value) {
                            controller.fetchStories();
                          });
                        },
                        child: Container(
                          // color: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          width: 80,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: storyUser.isAllStoryShown() ? cLightText.withOpacity(0.4) : cPrimary,
                                      width: 2,
                                    ),
                                    shape: BoxShape.circle),
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                child: ClipOval(
                                  child: MyCachedProfileImage(
                                    imageUrl: storyUser.profile,
                                    fullName: storyUser.fullName,
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: 72,
                                child: Text(
                                  storyUser.username ?? '',
                                  style: MyTextStyle.gilroyMedium(size: 14),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget myCard(FeedStoriesController controller) {
    var isAnyStory = controller.myUser.story?.isNotEmpty ?? false;
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(CreateStoryScreen(user: controller.myUser), isScrollControlled: true, ignoreSafeArea: false)
            .then((value) {
          controller.fetchMyStories();
          InterstitialManager.shared.showAd();
        });
      },
      child: Container(
        width: 90,
        // color: Colors.green,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.transparent,
                    width: 2,
                  ),
                  shape: BoxShape.circle),
              // padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: isAnyStory
                              ? (controller.myUser.isAllStoryShown() ? cLightText.withOpacity(0.4) : cPrimary)
                              : Colors.transparent,
                          width: 2,
                        ),
                        shape: BoxShape.circle),
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    child: ClipOval(
                      child: MyCachedProfileImage(
                        imageUrl: controller.myUser.profile,
                        fullName: controller.myUser.fullName,
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(3),
                    decoration: const BoxDecoration(color: cWhite, shape: BoxShape.circle),
                    child: const Icon(
                      Icons.add_circle,
                      color: cPrimary,
                      size: 18,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              LKeys.you.tr,
              style: MyTextStyle.gilroyMedium(size: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
