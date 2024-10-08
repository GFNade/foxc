import 'package:untitled/models/registration.dart';

class CommentsModel {
  CommentsModel({
    this.status,
    this.message,
    this.data,
  });

  CommentsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Comment.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<Comment>? data;

  CommentsModel copyWith({
    bool? status,
    String? message,
    List<Comment>? data,
  }) =>
      CommentsModel(
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

class Comment {
  Comment({
    this.id,
    this.userId,
    this.postId,
    this.desc,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  Comment.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    postId = json['post_id'];
    desc = json['desc'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  num? id;
  num? userId;
  num? postId;
  String? desc;
  String? createdAt;
  String? updatedAt;
  User? user;

  Comment copyWith({
    num? id,
    num? userId,
    num? postId,
    String? desc,
    String? createdAt,
    String? updatedAt,
    User? user,
  }) =>
      Comment(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        postId: postId ?? this.postId,
        desc: desc ?? this.desc,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        user: user ?? this.user,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['post_id'] = postId;
    map['desc'] = desc;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }
}

extension O on Comment {
  DateTime get date => DateTime.parse(createdAt ?? '');
}
