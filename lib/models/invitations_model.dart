import 'package:untitled/models/registration.dart';
import 'package:untitled/models/room_model.dart';

class InvitationsModel {
  InvitationsModel({
    this.status,
    this.message,
    this.data,
  });

  InvitationsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Invitation.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<Invitation>? data;

  InvitationsModel copyWith({
    bool? status,
    String? message,
    List<Invitation>? data,
  }) =>
      InvitationsModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

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

class Invitation {
  Invitation({
    this.id,
    this.roomId,
    this.userId,
    this.invitedBy,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.room,
    this.user,
    this.invitedUser,
  });

  Invitation.fromJson(dynamic json) {
    id = json['id'];
    roomId = json['room_id'];
    userId = json['user_id'];
    invitedBy = json['invited_by'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    room = json['room'] != null ? Room.fromJson(json['room']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    invitedUser = json['invited_user'] != null ? User.fromJson(json['invited_user']) : null;
  }

  num? id;
  num? roomId;
  num? userId;
  num? invitedBy;
  num? type;
  String? createdAt;
  String? updatedAt;
  Room? room;
  User? user;
  User? invitedUser;

  Invitation copyWith({
    num? id,
    num? roomId,
    num? userId,
    num? invitedBy,
    num? type,
    String? createdAt,
    String? updatedAt,
    Room? room,
    User? user,
    User? invitedUser,
  }) =>
      Invitation(
        id: id ?? this.id,
        roomId: roomId ?? this.roomId,
        userId: userId ?? this.userId,
        invitedBy: invitedBy ?? this.invitedBy,
        type: type ?? this.type,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        room: room ?? this.room,
        user: user ?? this.user,
        invitedUser: user ?? this.invitedUser,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['room_id'] = roomId;
    map['user_id'] = userId;
    map['invited_by'] = invitedBy;
    map['type'] = type;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (room != null) {
      map['room'] = room?.toJson();
    }
    if (user != null) {
      map['user'] = user?.toJson();
    }

    if (invitedUser != null) {
      map['invited_user'] = invitedUser?.toJson();
    }
    return map;
  }
}
