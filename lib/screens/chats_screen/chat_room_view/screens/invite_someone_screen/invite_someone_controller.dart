import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/common/api_service/room_service.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/registration.dart';
import 'package:untitled/models/room_model.dart';

class InviteSomeoneController extends BaseController {
  final Room? room;
  List<User> users = [];
  TextEditingController textEditingController = TextEditingController();
  RefreshController refreshController = RefreshController(initialRefresh: true);

  InviteSomeoneController(this.room);

  @override
  void onReady() {
    searchUser();
    super.onReady();
  }

  void searchUser({bool shouldErase = false}) {
    isLoading = true;
    if (shouldErase) {
      users = [];
    }
    RoomService.shared.searchUserForInvitation(
        room?.id ?? 0, textEditingController.text, users.length, (users) {
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
    });
  }

  void inviteUser(User user) {
    startLoading();
    RoomService.shared.inviteUserToRoom(user.id ?? 0, room?.id ?? 0, () {
      stopLoading();
      showSnackBar(LKeys.invitedSuccessfully.tr, type: SnackBarType.success);
      users.removeWhere((element) => element.id == user.id);
      update();
    });
  }
}
