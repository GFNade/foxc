import 'package:untitled/models/feeds_model.dart';
import 'package:untitled/models/registration.dart';
import 'package:untitled/models/room_model.dart';

class UserNotificationModel {
  UserNotificationModel({
    this.status,
    this.message,
    this.data,
  });

  UserNotificationModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(UserNotification.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<UserNotification>? data;

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

class UserNotification {
  UserNotification({
    this.id,
    this.myUserId,
    this.userId,
    this.postId,
    this.roomId,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.post,
    this.room,
  });

  UserNotification.fromJson(dynamic json) {
    id = json['id'];
    myUserId = json['my_user_id'];
    userId = json['user_id'];
    postId = json['post_id'];
    roomId = json['room_id'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    post = json['post'] != null ? Feed.fromJson(json['post']) : null;
    room = json['room'] != null ? Room.fromJson(json['room']) : null;
  }

  num? id;
  num? myUserId;
  num? userId;
  num? postId;
  num? roomId;
  num? type;
  String? createdAt;
  String? updatedAt;
  User? user;
  Feed? post;
  Room? room;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['my_user_id'] = myUserId;
    map['user_id'] = userId;
    map['post_id'] = postId;
    map['room_id'] = roomId;
    map['type'] = type;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    if (user != null) {
      map['post'] = post?.toJson();
    }
    if (room != null) {
      map['room'] = room?.toJson();
    }
    return map;
  }
}
