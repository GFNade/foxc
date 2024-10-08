import 'package:untitled/models/registration.dart';
import 'package:untitled/models/setting_model.dart';

import '../common/managers/session_manager.dart';

class RoomModel {
  RoomModel({
    this.status,
    this.message,
    this.data,
  });

  RoomModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Room.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  Room? data;

  RoomModel copyWith({
    bool? status,
    String? message,
    Room? data,
  }) =>
      RoomModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class Room {
  Room({
    this.id,
    this.adminId,
    this.photo,
    this.title,
    this.desc,
    this.interestIds,
    this.isPrivate,
    this.isJoinRequestEnable,
    this.totalMember,
    this.createdAt,
    this.updatedAt,
    this.userRoomStatus,
    this.isMute,
    this.interests,
    this.admin,
    this.roomUsers,
  });

  Room.fromJson(dynamic json) {
    id = json['id'];
    adminId = json['admin_id'];
    photo = json['photo'];
    title = json['title'];
    desc = json['desc'];
    interestIds = json['interest_ids'];
    isPrivate = json['is_private'];
    isJoinRequestEnable = json['is_join_request_enable'];
    totalMember = json['total_member'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userRoomStatus = json['userRoomStatus'];
    isMute = json['is_mute'];
    if (json['interests'] != null) {
      interests = [];
      json['interests'].forEach((v) {
        interests?.add(Interest.fromJson(v));
      });
    }
    admin = json['admin'] != null ? User.fromJson(json['admin']) : null;
    if (json['roomUsers'] != null) {
      roomUsers = [];
      json['roomUsers'].forEach((v) {
        roomUsers?.add(User.fromJson(v));
      });
    }
  }

  num? id;
  num? adminId;
  String? photo;
  String? title;
  String? desc;
  String? interestIds;
  num? isPrivate;
  num? isJoinRequestEnable;
  num? totalMember;
  String? createdAt;
  String? updatedAt;
  num? userRoomStatus;
  num? isMute;
  List<Interest>? interests;
  User? admin;
  List<User>? roomUsers;

  Room copyWith({
    num? id,
    num? adminId,
    String? photo,
    String? title,
    String? desc,
    String? interestIds,
    num? isPrivate,
    num? isJoinRequestEnable,
    num? totalMember,
    String? createdAt,
    String? updatedAt,
    num? userRoomStatus,
    List<Interest>? interests,
    User? admin,
    List<User>? roomUsers,
  }) =>
      Room(
        id: id ?? this.id,
        adminId: adminId ?? this.adminId,
        photo: photo ?? this.photo,
        title: title ?? this.title,
        desc: desc ?? this.desc,
        interestIds: interestIds ?? this.interestIds,
        isPrivate: isPrivate ?? this.isPrivate,
        isJoinRequestEnable: isJoinRequestEnable ?? this.isJoinRequestEnable,
        totalMember: totalMember ?? this.totalMember,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        userRoomStatus: userRoomStatus ?? this.userRoomStatus,
        interests: interests ?? this.interests,
        admin: admin ?? this.admin,
        roomUsers: roomUsers ?? this.roomUsers,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['admin_id'] = adminId;
    map['photo'] = photo;
    map['title'] = title;
    map['desc'] = desc;
    map['interest_ids'] = interestIds;
    map['is_private'] = isPrivate;
    map['is_join_request_enable'] = isJoinRequestEnable;
    map['total_member'] = totalMember;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['userRoomStatus'] = userRoomStatus;
    map['is_mute'] = isMute;
    if (interests != null) {
      map['interests'] = interests?.map((v) => v.toJson()).toList();
    }
    if (admin != null) {
      map['admin'] = admin?.toJson();
    }
    if (roomUsers != null) {
      map['roomUsers'] = roomUsers?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  String firebaseId() {
    return 'room_${id ?? 0}';
  }

  String getInterestWithHashtag() {
    List<String> arr = (interestIds ?? '').split(',');
    List<Interest> interests =
        SessionManager.shared.getSettings()?.interests?.where((element) {
              return arr.contains("${element.id}");
            }).toList() ??
            [];
    var str = '';
    for (var element in interests) {
      str += '#${element.title ?? ''} ';
    }
    return str;
  }

  GroupUserAccessType getUserAccessType() {
    switch (userRoomStatus ?? 0) {
      case 1:
        return GroupUserAccessType.requested;
      case 2:
        return GroupUserAccessType.member;
      case 3:
        return GroupUserAccessType.coAdmin;
      case 4:
        return GroupUserAccessType.invited;
      case 5:
        return GroupUserAccessType.admin;
      default:
        return GroupUserAccessType.none;
    }
  }
}

enum GroupUserAccessType {
  none(0),
  requested(1),
  member(2),
  coAdmin(3),
  invited(4),
  admin(5);

  const GroupUserAccessType(this.value);

  final int value;
}

extension O on Room {
  List<String> getInterestsStringList() {
    List<String> arr = (interestIds ?? '').split(',');
    List<Interest> interests =
        SessionManager.shared.getSettings()?.interests?.where((element) {
              return arr.contains("${element.id}");
            }).toList() ??
            [];

    return interests.map((e) => e.title ?? "").toList();
  }

  List<Interest> getInterests() {
    List<String> arr = (interestIds ?? '').split(',');
    List<Interest> interests =
        SessionManager.shared.getSettings()?.interests?.where((element) {
              return arr.contains("${element.id}");
            }).toList() ??
            [];

    return interests;
  }
}
