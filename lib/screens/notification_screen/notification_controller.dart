import 'package:flutter/material.dart';
import 'package:untitled/common/api_service/common_service.dart';
import 'package:untitled/common/controller/cupertino_controller.dart';
import 'package:untitled/models/notification_model.dart';
import 'package:untitled/models/user_notification_model.dart';

class NotificationScreenController extends CupertinoController {
  ScrollController scrollController = ScrollController();
  ScrollController userScrollController = ScrollController();
  List<PlatformNotification> notifications = [];
  List<UserNotification> userNotifications = [];
  bool isPlatformNotificationLoading = false;

  @override
  void onReady() {
    scrollController.addListener(
      () {
        if (scrollController.offset ==
            scrollController.position.maxScrollExtent) {
          if (!isPlatformNotificationLoading) {
            fetchNotification();
          }
        }
      },
    );
    userScrollController.addListener(() {
      if (userScrollController.offset ==
          userScrollController.position.maxScrollExtent) {
        if (!isLoading) {
          fetchUserNotifications();
        }
      }
    });
    fetchUserNotifications();
    fetchNotification();

    super.onReady();
  }

  void fetchNotification() {
    isPlatformNotificationLoading = true;
    CommonService.shared.fetchPlatformNotification(notifications.length,
        (notifications) {
      isPlatformNotificationLoading = false;
      this.notifications.addAll(notifications);
      update();
    });
  }

  void fetchUserNotifications() {
    if (userNotifications.isEmpty) {
      startLoading();
    }

    CommonService.shared.fetchUserNotifications(userNotifications.length,
        (notifications) {
      if (userNotifications.isEmpty) {
        stopLoading();
      }
      userNotifications.addAll(notifications);
      update();
    });
  }
}
