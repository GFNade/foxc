import 'package:untitled/common/api_service/user_service.dart';
import 'package:untitled/models/registration.dart';
import 'package:untitled/screens/chats_screen/chatting_screen/block_user_controller.dart';

class BlockListController extends BlockUserController {
  List<User> users = [];

  @override
  void onReady() {
    fetchBlockList();
    super.onReady();
  }

  void fetchBlockList() {
    startLoading();
    UserService.shared.fetchBlockedUserList((users) {
      this.users = users;
      stopLoading();
      update();
    });
  }
}
