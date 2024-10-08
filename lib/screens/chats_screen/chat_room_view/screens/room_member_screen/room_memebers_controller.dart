import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/common/api_service/room_service.dart';
import 'package:untitled/common/controller/cupertino_controller.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/registration.dart';
import 'package:untitled/models/room_member_model.dart';
import 'package:untitled/models/room_model.dart';
import 'package:untitled/screens/chats_screen/chatting_screen/chatting_controller.dart';
import 'package:untitled/screens/sheets/confirmation_sheet.dart';

class RoomMembersController extends CupertinoController {
  final ChattingController chattingController;

  RefreshController refreshController = RefreshController();
  List<RoomMember> users = [];
  List<RoomMember> admins = [];

  RoomMembersController(this.chattingController);

  @override
  void onReady() {
    fetchRoomUsers();
    fetchRoomAdmins();
    super.onReady();
  }

  void fetchRoomUsers() {
    if (users.isEmpty) {
      startLoading();
    }
    RoomService.shared.fetchRoomUsersList(
        chattingController.room?.id ?? 0, users.length, (users) {
      stopLoading();
      this.users.addAll(users);
      refreshController.loadComplete();
      if (users.isEmpty) {
        refreshController.loadNoData();
      }
      update();
    });
  }

  void fetchRoomAdmins() {
    RoomService.shared.fetchRoomAdmins(chattingController.room?.id, (users) {
      admins = users;
      update();
    });
  }

  void removeUserFromRoom(User user) {
    Future.delayed(
      const Duration(milliseconds: 5),
      () {
        Get.bottomSheet(ConfirmationSheet(
          desc: LKeys.removeFromAdmin,
          buttonTitle: LKeys.remove,
          onTap: () {
            startLoading();
            RoomService.shared
                .removeUserFromRoom(chattingController.room?.id, user.id, () {
              stopLoading();
              users.removeWhere((element) => element.id == user.id);
              chattingController.room?.totalMember =
                  (chattingController.room?.totalMember ?? 0) - 1;
              chattingController.update();
              print(chattingController.room?.totalMember);
              update();
            });
          },
        ));
      },
    );
  }

  void makeRoomAdmin(RoomMember roomMember) {
    RoomService.shared.makeRoomAdmin(
        chattingController.room?.id, roomMember.userId, (member) {
      stopLoading();
      users.removeWhere((element) => element.id == roomMember.id);
      if (member != null) {
        member.user = roomMember.user;
        admins.add(member);
        users.add(member);
      }
      update();
    });
  }

  void removeAdminFromAdmin(RoomMember roomMember) {
    Get.bottomSheet(ConfirmationSheet(
      desc: LKeys.removeFromAdmin,
      buttonTitle: LKeys.remove,
      onTap: () {
        RoomService.shared.removeAdminFromRoom(
            chattingController.room?.id, roomMember.userId, (member) {
          stopLoading();
          if (roomMember.user?.id == SessionManager.shared.getUserID()) {
            Get.back();
            chattingController.room?.userRoomStatus =
                GroupUserAccessType.member.value;
            chattingController.update();
          } else {
            admins.removeWhere((element) => element.id == roomMember.id);
            users.removeWhere((element) => element.id == roomMember.id);
            if (member != null) {
              member.user = roomMember.user;
              users.add(member);
            }
            update();
          }
        });
      },
    ));
  }
}
