import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/feeds_model.dart';
import 'package:untitled/models/registration.dart';
import 'package:untitled/screens/add_post_screen/add_post_screen.dart';
import 'package:untitled/screens/feed_screen/feed_screen_controller.dart';
import 'package:untitled/screens/feed_screen/feed_screen_top_bar.dart';
import 'package:untitled/screens/feed_screen/feed_stories_controller.dart';
import 'package:untitled/screens/feed_screen/feed_story_screen.dart';
import 'package:untitled/screens/post/post_card.dart';
import 'package:untitled/screens/rooms_screen/room_card.dart';
import 'package:untitled/screens/story_screen/create_story_screen/create_story_screen.dart';
import 'package:untitled/utilities/const.dart';

import '../../common/extensions/image_extension.dart';
import '../../common/managers/ads/interstitial_manager.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FeedScreenController controller = FeedScreenController(isFromFeedScreen: true);
    FeedStoriesController feedStoriesController = FeedStoriesController();
    return Stack(
      children: [
        GetBuilder(
            init: controller,
            builder: (controller) {
              return Column(
                children: [
                  Container(
                    color: cLightBg,
                    height: (controller.posts.isEmpty ? (0) : Get.height / 2),
                  )
                ],
              );
            }),
        Column(
          children: [
            const FeedScreenTopBar(),
            Container(color: cLightBg, height: 10),
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: controller.scrollController,
                    primary: false,
                    child: Column(
                      children: [
                        FeedStoryScreen(controller: feedStoriesController),
                        Container(color: cLightBg, height: 5),
                        Container(
                          color: cWhite,
                          child: FeedsView(
                            controller: controller,
                            id: controller.feedViewID,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PostButton(
                    onPostBack: (feed) {
                      controller.posts.insert(0, feed);
                      controller.update([controller.feedViewID]);
                      controller.update();
                    },
                    onStoryBack: () {
                      feedStoriesController.fetchMyStories();
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class PostButton extends StatelessWidget {
  final Function(Feed feed)? onPostBack;
  final Function()? onStoryBack;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  PostButton({super.key, this.onPostBack, this.onStoryBack});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: SpeedDial(
          elevation: 2,
          overlayColor: cBlack,
          backgroundColor: cPrimary,
          openCloseDial: isDialOpen,
          children: [
            SpeedDialChild(
                labelWidget: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(8),
                    decoration: const ShapeDecoration(
                        color: cWhite,
                        shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius.all(
                                SmoothRadius(cornerSmoothing: cornerSmoothing, cornerRadius: 8)))),
                    child: Text(
                      LKeys.createStory.tr,
                      style: MyTextStyle.gilroyMedium(),
                    )),
                onTap: () {
                  Get.bottomSheet(CreateStoryScreen(user: SessionManager.shared.getUser() ?? User()),
                          isScrollControlled: true, ignoreSafeArea: false)
                      .then((value) {
                    InterstitialManager.shared.showAd();
                    if (onStoryBack != null) {
                      onStoryBack!();
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(MyImages.story),
                )),
            SpeedDialChild(
                onTap: () {
                  // print("object");
                  Get.to(() => const AddPostScreen())?.then((value) {
                    InterstitialManager.shared.showAd();
                    if (value is Feed) {
                      if (onPostBack != null) {
                        onPostBack!(value);
                      }
                    }
                  });
                },
                labelWidget: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(8),
                    decoration: const ShapeDecoration(
                        color: cWhite,
                        shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius.all(
                                SmoothRadius(cornerSmoothing: cornerSmoothing, cornerRadius: 8)))),
                    child: Text(
                      LKeys.createPost.tr,
                      style: MyTextStyle.gilroyMedium(),
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(MyImages.post),
                )),
          ],
          animationCurve: Curves.elasticInOut,
          activeIcon: Icons.close_rounded,
          foregroundColor: cBlack,
          activeForegroundColor: cBlack,
          child: Image.asset(
            MyImages.quill,
            width: 25,
            height: 25,
          ),
        ),
      ),
    );
  }
}

class FeedsView extends StatelessWidget {
  const FeedsView({
    super.key,
    required this.controller,
    required this.id,
  });

  final FeedScreenController controller;
  final String id;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      tag: id,
      builder: (controller) {
        if (controller.posts.isEmpty && !controller.isLoading) {
          return Container(
            padding: EdgeInsets.only(top: Get.height / 6),
            child: Text(LKeys.noPosts.tr, style: MyTextStyle.gilroyBold(color: cLightText)),
          );
        } else {
          return SafeArea(
            top: false,
            child: ListView.builder(
              primary: false,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 5),
              itemCount: controller.posts.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    (index == 2 && controller.suggestedRooms.isNotEmpty)
                        ? Container(
                            color: cBlack,
                            padding: const EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      LKeys.suggested.tr,
                                      style: MyTextStyle.gilroyLight(color: cWhite, size: 17),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      LKeys.rooms.tr,
                                      style: MyTextStyle.gilroyBold(color: cWhite, size: 17),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                SizedBox(
                                  height: 250,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: controller.suggestedRooms.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(horizontal: Get.width / 50),
                                        child: RoomCard(
                                          room: controller.suggestedRooms[index],
                                          isFromHome: true,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          )
                        : Container(),
                    PostCard(
                      post: controller.posts[index],
                      onDeletePost: (postID) {
                        controller.posts.removeWhere((element) => element.id == postID);
                        controller.update();
                      },
                    ),
                  ],
                );
              },
            ),
          );
        }
      },
    );
  }
}
