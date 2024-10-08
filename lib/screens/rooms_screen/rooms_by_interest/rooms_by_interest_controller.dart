import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/common/api_service/room_service.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/models/room_model.dart';

class RoomsByInterestController extends BaseController {
  RefreshController refreshController = RefreshController();
  List<Room> rooms = [];
  int? interestId;

  RoomsByInterestController({this.interestId});

  @override
  void onReady() {
    if (interestId != null) {
      fetchRooms((interestId ?? 0).toInt());
    }
    super.onReady();
  }

  void fetchRandomRooms() {
    isLoading = true;
    RoomService.shared.fetchRooms((rooms) {
      isLoading = false;
      this.rooms.addAll(rooms);
      update();
    });
  }

  void fetchRooms(int interestId) {
    if (rooms.isEmpty) {
      startLoading();
    }

    RoomService.shared.fetchRoomByInterest(interestId, rooms.length, (rooms) {
      stopLoading();
      refreshController.loadComplete();
      if (rooms.isEmpty) {
        refreshController.loadNoData();
      }
      this.rooms.addAll(rooms);
      update();
    });
  }
}
