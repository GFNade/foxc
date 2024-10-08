import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/common/api_service/story_service.dart';
import 'package:untitled/common/api_service/user_service.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/models/registration.dart';

class FeedStoriesController extends BaseController {
  List<User> storyUsers = [];
  User myUser = SessionManager.shared.getUser() ?? User();

  @override
  void onReady() {
    fetchStories();
    fetchMyStories();
    super.onReady();
  }

  void fetchStories() {
    StoryService.shared.fetchStories((storyUsers) {
      this.storyUsers = storyUsers;
      this.storyUsers.sort((a, b) {
        if (a.isAllStoryShown()) {
          return 1;
        }
        return -1;
      });
      update();
    });
  }

  void fetchMyStories() {
    UserService.shared.fetchProfile(SessionManager.shared.getUserID(), (user) {
      myUser = user;
      update();
    });
  }
}
