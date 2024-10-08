import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/extensions/image_extension.dart';
import 'package:untitled/common/managers/ads/banner_ad.dart';
import 'package:untitled/common/managers/navigation.dart';
import 'package:untitled/common/widgets/my_cached_image.dart';
import 'package:untitled/common/widgets/no_data_found.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/notification_model.dart';
import 'package:untitled/models/user_notification_model.dart';
import 'package:untitled/screens/extra_views/back_button.dart';
import 'package:untitled/screens/extra_views/top_bar.dart';
import 'package:untitled/screens/notification_screen/notification_controller.dart';
import 'package:untitled/screens/profile_screen/profile_screen.dart';
import 'package:untitled/screens/rooms_screen/single_room/single_room_screen.dart';
import 'package:untitled/screens/single_post_screen/single_post_screen.dart';
import 'package:untitled/utilities/const.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NotificationScreenController controller = NotificationScreenController();
    return Scaffold(
      body: Column(
        children: [
          const TopBarForInView(title: LKeys.notification),
          GetBuilder<NotificationScreenController>(
              init: controller,
              builder: (controller) {
                return Expanded(
                  child: controller.notifications.isEmpty
                      ? NoDataFound(controller: controller)
                      : Column(
                          children: [
                            Container(
                              color: cDarkBG,
                              width: double.infinity,
                              child: Column(
                                children: [
                                  const SizedBox(height: 15),
                                  segmentController(controller),
                                  const SizedBox(height: 15),
                                ],
                              ),
                            ),
                            Expanded(
                              child: PageView(
                                controller: controller.controller,
                                onPageChanged: controller.onChangePage,
                                children: [
                                  ListView.builder(
                                    controller: controller.userScrollController,
                                    padding: const EdgeInsets.all(10),
                                    itemCount: controller.userNotifications.length,
                                    itemBuilder: (context, index) {
                                      return UserNotificationCard(
                                        notification: controller.userNotifications[index],
                                      );
                                    },
                                  ),
                                  listView(controller: controller),
                                ],
                              ),
                            ),
                          ],
                        ),
                );
              }),
          BannerAdView(bottom: true)
        ],
      ),
    );
  }

  Widget segmentController(NotificationScreenController controller) {
    return CupertinoSlidingSegmentedControl(
      children: {0: buildSegment(LKeys.forYou, 0, controller), 1: buildSegment(LKeys.platform, 1, controller)},
      groupValue: controller.selectedPage,
      backgroundColor: cWhite.withOpacity(0.12),
      thumbColor: cWhite,
      padding: const EdgeInsets.all(0),
      onValueChanged: (value) {
        controller.onChangeSegment(value ?? 0);
      },
    );
  }

  Widget buildSegment(String text, int index, NotificationScreenController controller) {
    return Container(
      alignment: Alignment.center,
      width: (Get.width / 2) - 30,
      child: Text(
        text.tr.toUpperCase(),
        style: MyTextStyle.gilroySemiBold(size: 13, color: controller.selectedPage == index ? cBlack : cWhite)
            .copyWith(letterSpacing: 2),
      ),
    );
  }

  Widget listView({required NotificationScreenController controller}) {
    return ListView.builder(
      controller: controller.scrollController,
      padding: const EdgeInsets.all(10),
      itemCount: controller.notifications.length,
      itemBuilder: (context, index) {
        return NotificationCard(
          notification: controller.notifications[index],
        );
      },
    );
  }
}

class UserNotificationCard extends StatelessWidget {
  final UserNotification notification;

  const UserNotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (notification.post != null) {
              Navigate.to(SinglePostScreen(postId: notification.post?.id ?? 0));
            } else if (notification.room != null) {
              Navigate.to(SingleRoomScreen(roomId: notification.room?.id?.toInt() ?? 0));
            } else if (notification.user != null) {
              Navigate.to(ProfileScreen(userId: notification.user?.id ?? 0));
            }
          },
          child: Container(
            color: Colors.transparent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigate.to(ProfileScreen(userId: notification.user?.id ?? 0));
                  },
                  child: ClipSmoothRect(
                    radius:
                        const SmoothBorderRadius.all(SmoothRadius(cornerRadius: 12, cornerSmoothing: cornerSmoothing)),
                    child: MyCachedImage(
                      imageUrl: notification.user?.profile,
                      width: 55,
                      height: 55,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            notification.user?.fullName ?? '',
                            style: MyTextStyle.gilroyBold(),
                          ),
                          const SizedBox(width: 1),
                          VerifyIcon(user: notification.user)
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "${notification.user?.fullName ?? ''} ${notificationContent()}",
                        style: MyTextStyle.gilroyRegular(color: cLightText, size: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider()
      ],
    );
  }

  String notificationContent() {
    switch ((notification.type ?? 0).toInt()) {
      case 1:
        return LKeys.hasStartedFollowingYou.tr;
      case 2:
        return LKeys.hasCommentedToYourPost.tr;
      case 3:
        return LKeys.hasLikedYourPost.tr;
      case 4:
        return '${LKeys.hasInvitedToRoom.tr} ${notification.room?.title ?? ''}';
      case 5:
        return '${LKeys.hasAcceptedYourInvitationOfRoom.tr} ${notification.room?.title ?? ''}';
      case 6:
        return '${LKeys.hasRequestedToJoinYourRoom.tr} ${notification.room?.title ?? ''}';
      case 7:
        return '${LKeys.hasJoinedYourRoom.tr} ${notification.room?.title ?? ''}';
      case 8:
        return '${LKeys.hasAcceptedYourJoinRequestOfRoom.tr} ${notification.room?.title ?? ''}';
    }
    return "";
  }
}

class NotificationCard extends StatelessWidget {
  final PlatformNotification notification;

  const NotificationCard({Key? key, required this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipSmoothRect(
              radius: SmoothBorderRadius(cornerRadius: 12, cornerSmoothing: cornerSmoothing),
              child: Container(
                color: cBlack,
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  MyImages.logo,
                  width: 22,
                  height: 22,
                ),
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
                        notification.title ?? '',
                        style: MyTextStyle.gilroyBold(),
                      ),
                      const SizedBox(width: 5),
                      const VerifyIcon()
                    ],
                  ),
                  const SizedBox(height: 1),
                  Text(
                    notification.description ?? '',
                    style: MyTextStyle.gilroyLight(color: cLightText, size: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Divider()
      ],
    );
  }
}
