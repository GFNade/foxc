import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/common/api_service/user_service.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/models/registration.dart';

class FollowerFollowingController extends BaseController {
  final bool isForFollowing;
  final num userId;
  List<User> users = [];
  RefreshController refreshController = RefreshController();

  FollowerFollowingController(this.isForFollowing, this.userId);

  @override
  void onReady() {
    fetchUsers();
    super.onReady();
  }

  void fetchUsers() {
    if (users.isEmpty) {
      startLoading();
    }
    if (isForFollowing) {
      UserService.shared.fetchFollowingList(userId, users.length, (users) {
        stopLoading();
        this.users.addAll(users);
        refreshController.loadComplete();
        if (users.isEmpty) {
          refreshController.loadNoData();
        }
        update();
      });
    } else {
      UserService.shared.fetchFollowerList(userId, users.length, (users) {
        stopLoading();
        this.users.addAll(users);
        refreshController.loadComplete();
        if (users.isEmpty) {
          refreshController.loadNoData();
        }
        update();
      });
    }
  }
}
