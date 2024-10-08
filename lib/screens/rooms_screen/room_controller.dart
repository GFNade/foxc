import 'package:get/get.dart';
import 'package:untitled/common/api_service/room_service.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/common/managers/firebase_notification_manager.dart';
import 'package:untitled/models/room_model.dart';
import 'package:untitled/screens/chats_screen/chatting_screen/chatting_view.dart';

class RoomController extends BaseController {
  Room room;

  RoomController(this.room);

  void joinOrRequestOrAccept() {
    if (room.getUserAccessType() == GroupUserAccessType.invited) {
      startLoading();
      RoomService.shared.acceptInvitation(room.id ?? 0, () {
        stopLoading();
        Get.back();
        room.userRoomStatus = GroupUserAccessType.member.value;
        room.totalMember = (room.totalMember ?? 0) + 1;
        update();
        Get.to(() => ChattingView(room: room))?.then(onBack);
      });
      return;
    }
    if (room.getUserAccessType() != GroupUserAccessType.none) {
      return;
    }
    startLoading();
    RoomService.shared.joinRoomRequest(room.id ?? 0, (member) {
      stopLoading();
      Get.back();
      if (member != null) {
        room.userRoomStatus = member.type;
        if (room.getUserAccessType() == GroupUserAccessType.member) {
          FirebaseNotificationManager.shared
              .subscribeToTopic('room_${room.id ?? 0}');
          room.totalMember = (room.totalMember ?? 0) + 1;
          Get.to(() => ChattingView(room: room))?.then(onBack);
        }
        update();
      }
    });
  }

  void onBack(dynamic value) {
    if (value is Room?) {
      print('${value}');
      if (value != null) {
        room.totalMember = value.totalMember;
        room.userRoomStatus = value.userRoomStatus;
        update();
      }
    }
  }
}
