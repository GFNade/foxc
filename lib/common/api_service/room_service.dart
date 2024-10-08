import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/common/api_service/api_service.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/common_response.dart';
import 'package:untitled/models/invitations_model.dart';
import 'package:untitled/models/registration.dart';
import 'package:untitled/models/room_member_model.dart';
import 'package:untitled/models/room_model.dart';
import 'package:untitled/models/rooms_model.dart';
import 'package:untitled/models/users_model.dart';
import 'package:untitled/utilities/const.dart';
import 'package:untitled/utilities/params.dart';
import 'package:untitled/utilities/web_service.dart';

import '../managers/session_manager.dart';

class RoomService {
  static var shared = RoomService();

  void removeUserFromRoom(num? roomId, num? userId, Function() completion) {
    var param = {Param.userId: userId, Param.roomId: roomId};
    ApiService.shared.call(
      url: WebService.removeUserFromRoom,
      param: param,
      completion: (response) {
        var obj = CommonResponse.fromJson(response);
        if (obj.status == true) {
          completion();
        }
      },
    );
  }

  void makeRoomAdmin(
      num? roomId, num? userId, Function(RoomMember? member) completion) {
    var param = {Param.userId: userId, Param.roomId: roomId};
    ApiService.shared.call(
      url: WebService.makeRoomAdmin,
      param: param,
      completion: (response) {
        var obj = RoomMemberModel.fromJson(response);
        if (obj.status == true) {
          completion(obj.data);
        }
      },
    );
  }

  void removeAdminFromRoom(
      num? roomId, num? userId, Function(RoomMember? member) completion) {
    var param = {Param.userId: userId, Param.roomId: roomId};
    ApiService.shared.call(
      url: WebService.removeAdminFromRoom,
      param: param,
      completion: (response) {
        var obj = RoomMemberModel.fromJson(response);
        if (obj.status == true) {
          completion(obj.data);
        }
      },
    );
  }

  void fetchRoomAdmins(
      num? roomId, Function(List<RoomMember> users) completion) {
    var param = {
      Param.roomId: roomId,
    };
    ApiService.shared.call(
      url: WebService.fetchRoomAdmins,
      param: param,
      completion: (response) {
        var data = RoomMembersModel.fromJson(response).data;
        if (data != null) {
          completion(data);
        }
      },
    );
  }

  void fetchRoomsIAmIn(Function(List<RoomMember> rooms) completion) {
    var param = {
      Param.userId: SessionManager.shared.getUser()?.id ?? 0,
    };
    ApiService.shared.call(
      url: WebService.fetchRoomsIAmIn,
      param: param,
      completion: (response) {
        var data = RoomMembersModel.fromJson(response).data;
        if (data != null) {
          completion(data);
        }
      },
    );
  }

  void fetchRoomUsersList(
      num roomId, num start, Function(List<RoomMember> users) completion) {
    var param = {
      Param.roomId: roomId,
      Param.start: start,
      Param.limit: Limits.pagination,
    };
    ApiService.shared.call(
      url: WebService.fetchRoomUsersList,
      param: param,
      completion: (response) {
        var data = RoomMembersModel.fromJson(response).data;
        if (data != null) {
          completion(data);
        }
      },
    );
  }

  void deleteRoom(num roomId, Function() completion) {
    var param = {
      Param.roomId: roomId,
      Param.userId: SessionManager.shared.getUserID()
    };
    ApiService.shared.call(
      url: WebService.deleteRoom,
      param: param,
      completion: (response) {
        var obj = CommonResponse.fromJson(response);
        if (obj.status == true) {
          completion();
        }
      },
    );
  }

  void acceptRoomRequest(num userId, num roomId, Function() completion) {
    var param = {Param.userId: userId, Param.roomId: roomId};
    ApiService.shared.call(
      url: WebService.acceptRoomRequest,
      param: param,
      completion: (response) {
        var obj = CommonResponse.fromJson(response);
        if (obj.status == true) {
          completion();
        }
      },
    );
  }

  void rejectRoomRequest(num userId, num roomId, Function() completion) {
    var param = {Param.userId: userId, Param.roomId: roomId};
    ApiService.shared.call(
      url: WebService.rejectRoomRequest,
      param: param,
      completion: (response) {
        var obj = CommonResponse.fromJson(response);
        if (obj.status == true) {
          completion();
        }
      },
    );
  }

  void muteUnmuteNotification(num isMute, num roomId, Function() completion) {
    var param = {
      Param.userId: SessionManager.shared.getUser()?.id ?? 0,
      Param.isMute: isMute,
      Param.roomId: roomId
    };
    ApiService.shared.call(
      url: WebService.muteUnmuteRoomNotification,
      param: param,
      completion: (response) {
        var obj = CommonResponse.fromJson(response);
        if (obj.status == true) {
          completion();
        }
      },
    );
  }

  void fetchRoomRequestList(
      num roomId, Function(List<Invitation> invitation) completion) {
    var param = {Param.roomId: roomId};

    ApiService.shared.call(
      url: WebService.fetchRoomRequestList,
      param: param,
      completion: (response) {
        var invitations = InvitationsModel.fromJson(response).data;
        if (invitations != null) {
          completion(invitations);
        }
      },
    );
  }

  void leaveThisRoom(num roomId, Function() completion) {
    var param = {
      Param.roomId: roomId,
      Param.userId: SessionManager.shared.getUserID()
    };

    ApiService.shared.call(
      url: WebService.leaveThisRoom,
      param: param,
      completion: (response) {
        var obj = CommonResponse.fromJson(response);
        if (obj.status == true) {
          completion();
        }
      },
    );
  }

  void searchUserForInvitation(num roomId, String keyword, int start,
      Function(List<User> users) completion) {
    var param = {
      Param.roomId: roomId,
      Param.myUserId: SessionManager.shared.getUserID(),
      Param.start: start,
      Param.keyword: keyword,
      Param.limit: Limits.pagination
    };

    ApiService.shared.call(
      url: WebService.searchUserForInvitation,
      param: param,
      completion: (response) {
        var data = UsersModel.fromJson(response).data;
        if (data != null) {
          completion(data);
        }
      },
    );
  }

  void inviteUserToRoom(num userId, num roomId, Function() completion) {
    var param = {Param.roomId: roomId, Param.userId: userId};
    ApiService.shared.call(
      url: WebService.inviteUserToRoom,
      param: param,
      completion: (response) {
        var status = CommonResponse.fromJson(response).status;
        if (status == true) {
          completion();
        }
      },
    );
  }

  void fetchRoom(int roomId, Function(Room room) completion,
      {bool shouldShowMembers = false}) {
    var param = {
      Param.roomId: roomId,
      Param.userId: SessionManager.shared.getUserID(),
      Param.shouldShowMember: shouldShowMembers ? 1 : 0,
    };
    ApiService.shared.call(
      url: WebService.fetchRoomDetail,
      param: param,
      completion: (response) {
        var room = RoomModel.fromJson(response).data;
        if (room != null) {
          completion(room);
        }
      },
    );
  }

  void joinRoomRequest(num roomId, Function(RoomMember? member) completion) {
    var param = {
      Param.roomId: roomId,
      Param.userId: SessionManager.shared.getUserID(),
    };
    ApiService.shared.call(
      url: WebService.joinOrRequestRoom,
      param: param,
      completion: (response) {
        var obj = RoomMemberModel.fromJson(response);
        if (obj.status == false) {
          completion(null);
          BaseController.share.showSnackBar(obj.message ?? "");
          return;
        }
        var member = obj.data;
        if (member != null) {
          completion(member);
        }
      },
    );
  }

  void acceptInvitation(num roomId, Function() completion) {
    var param = {
      Param.roomId: roomId,
      Param.userId: SessionManager.shared.getUserID(),
    };
    ApiService.shared.call(
      url: WebService.acceptInvitation,
      param: param,
      completion: (response) {
        var obj = CommonResponse.fromJson(response);
        if (obj.status == true) {
          completion();
        }
      },
    );
  }

  void rejectInvitation(num roomId, Function() completion) {
    var param = {
      Param.roomId: roomId,
      Param.userId: SessionManager.shared.getUserID(),
    };
    ApiService.shared.call(
      url: WebService.rejectInvitation,
      param: param,
      completion: (response) {
        var obj = CommonResponse.fromJson(response);
        if (obj.status == true) {
          completion();
        }
      },
    );
  }

  void getInvitationList(
      int start, Function(List<Invitation> invitations) completion) {
    var param = {
      Param.userId: SessionManager.shared.getUserID(),
      Param.start: start,
      Param.limit: Limits.pagination
    };
    ApiService.shared.call(
      url: WebService.getInvitationList,
      param: param,
      completion: (response) {
        var invitations = InvitationsModel.fromJson(response).data;
        if (invitations != null) {
          completion(invitations);
        }
      },
    );
  }

  void reportRoom(num roomId, String reason, String desc) {
    var param = {
      Param.roomId: roomId,
      Param.reason: reason,
      Param.desc: desc,
      Param.userId: SessionManager.shared.getUserID()
    };
    ApiService.shared.call(
      url: WebService.reportRoom,
      param: param,
      completion: (response) {
        var obj = CommonResponse.fromJson(response);
        if (obj.status == true) {
          Get.back();
          Get.back();
          BaseController.share.showSnackBar(LKeys.reportAddedSuccessfully.tr,
              type: SnackBarType.success);
        }
      },
    );
  }

  void fetchRoomByInterest(
      int interestId, int start, Function(List<Room> rooms) completion) {
    var param = {
      Param.userId: SessionManager.shared.getUserID(),
      Param.interestId: interestId,
      Param.start: start,
      Param.limit: Limits.pagination
    };
    ApiService.shared.call(
      url: WebService.fetchRoomsByInterest,
      param: param,
      completion: (response) {
        var rooms = RoomsModel.fromJson(response).data;
        if (rooms != null) {
          completion(rooms);
        }
      },
    );
  }

  void fetchRooms(Function(List<Room> rooms) completion) {
    var param = {
      Param.limit: Limits.pagination,
      Param.userId: SessionManager.shared.getUserID()
    };
    ApiService.shared.call(
      url: WebService.fetchRandomRooms,
      param: param,
      completion: (response) {
        var rooms = RoomsModel.fromJson(response).data;
        if (rooms != null) {
          completion(rooms);
        }
      },
    );
  }

  void fetchMyOwnRooms(Function(List<Room> rooms) completion) {
    var param = {Param.myUserId: SessionManager.shared.getUserID()};
    ApiService.shared.call(
      url: WebService.fetchMyOwnRooms,
      param: param,
      completion: (response) {
        var rooms = RoomsModel.fromJson(response).data;
        if (rooms != null) {
          completion(rooms);
        }
      },
    );
  }

  void createOrEditRoom({
    num? roomId,
    required String title,
    required String description,
    required String interestsIds,
    XFile? image,
    required int isPrivate,
    required int isEnableJoin,
    required Function(Room room) completion,
  }) {
    var param = {
      Param.roomId: roomId ?? 0,
      Param.adminId: SessionManager.shared.getUserID(),
      Param.title: title,
      Param.desc: description,
      Param.isPrivate: isPrivate,
      Param.isEnableRequest: isEnableJoin,
      Param.interestIds: interestsIds
    };
    ApiService.shared.multiPartCallApi(
      url: roomId == null ? WebService.createRoom : WebService.editRoom,
      param: param,
      filesMap: {
        Param.photo: [image]
      },
      completion: (response) {
        var room = RoomModel.fromJson(response).data;
        if (room != null) {
          completion(room);
        }
      },
    );
  }
}
