import 'package:untitled/models/comments_model.dart';

class CommentModel {
  CommentModel({
    this.status,
    this.message,
    this.data,
  });

  CommentModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Comment.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  Comment? data;

  CommentModel copyWith({
    bool? status,
    String? message,
    Comment? data,
  }) =>
      CommentModel(
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
