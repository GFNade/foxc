import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/common/api_service/user_service.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/models/registration.dart';

class SearchScreenController extends BaseController {
  List<User> users = [];
  TextEditingController textEditingController = TextEditingController();
  RefreshController refreshController = RefreshController(initialRefresh: true);

  // ScrollController scrollController = ScrollController();

  @override
  void onReady() {
    // scrollController.addListener(
    //   () {
    //     if (scrollController.offset ==
    //         scrollController.position.maxScrollExtent) {
    //       if (!isLoading) {
    //         searchUser();
    //       }
    //     }
    //   },
    // );

    searchUser();
    super.onReady();
  }

  void searchUser({bool shouldErase = false}) {
    isLoading = true;
    if (shouldErase) {
      users = [];
    }
    UserService.shared.searchProfile(
      textEditingController.text,
      users.length,
      (users) {
        isLoading = false;
        if (shouldErase) {
          this.users = [];
        }
        this.users.addAll(users);
        refreshController.loadComplete();
        if (users.isEmpty) {
          refreshController.loadNoData();
        }
        update();
      },
    );
  }
}
