import 'package:untitled/models/registration.dart';

class RoomMemberModel {
  RoomMemberModel({
    this.status,
    this.message,
    this.data,
  });

  RoomMemberModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? RoomMember.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  RoomMember? data;

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

class RoomMembersModel {
  RoomMembersModel({
    this.status,
    this.message,
    this.data,
  });

  RoomMembersModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(RoomMember.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<RoomMember>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class RoomMember {
  RoomMember({
    this.roomId,
    this.userId,
    this.type,
    this.updatedAt,
    this.createdAt,
    this.isMute,
    this.id,
    this.user,
  });

  RoomMember.fromJson(dynamic json) {
    roomId = json['room_id'];
    userId = json['user_id'];
    type = json['type'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    isMute = json['is_mute'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  num? roomId;
  num? userId;
  num? type;
  String? updatedAt;
  String? createdAt;
  num? id;
  num? isMute;
  User? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['room_id'] = roomId;
    map['user_id'] = userId;
    map['type'] = type;
    map['updated_at'] = updatedAt;
    map['created_at'] = createdAt;
    map['id'] = id;
    map['is_mute'] = isMute;
    map['user'] = user;
    return map;
  }
}
