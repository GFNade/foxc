import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/common/api_service/story_service.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/library/story_view/story_view.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/registration.dart';
import 'package:untitled/models/story.dart';
import 'package:untitled/screens/sheets/confirmation_sheet.dart';

class StoryScreenController extends BaseController {
  StoryController storyController = StoryController();
  PageController pageController;
  int selectedPage;
  List<User> users;
  List<List<StoryItem>> stories = [];
  User? myUser = SessionManager.shared.getUser();

  StoryScreenController(this.users, this.selectedPage, this.pageController) {
    for (var user in users) {
      List<StoryItem> userStories = user.story?.map((e) => e.toStoryItem(storyController)).toList() ?? [];
      stories.add(userStories);
      update();
    }
  }

  void deleteStory(Story story) {
    Future.delayed(
      const Duration(milliseconds: 1),
      () {
        Get.bottomSheet(ConfirmationSheet(
          desc: LKeys.storyDeleteDisc,
          buttonTitle: LKeys.delete.tr,
          onTap: () {
            StoryService.shared.deleteStory(story.id ?? 0, () {
              Get.back();
            });
          },
        )).then((value) {
          storyController.play();
        });
      },
    );
  }

  void onStoryShow(StoryItem value) {
    //TODO: Comment-Out This
    if (!value.viewedByUsersIds.contains('${myUser?.id ?? 0}')) {
      StoryService.shared.viewStory(value.id, () {});
    }
  }

  void onPreviousUser() {
    if (selectedPage == 0) {
      return;
    }
    pageController.animateToPage(selectedPage - 1, duration: const Duration(milliseconds: 500), curve: Curves.ease);
    update();
  }

  void onNext() {
    if (selectedPage == (stories.length - 1)) {
      Get.back();
      return;
    }
    pageController.animateToPage(selectedPage + 1, duration: const Duration(milliseconds: 500), curve: Curves.ease);
    update();
  }

  void onPageChange(int value) {
    selectedPage = value;
    update();
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }
}
