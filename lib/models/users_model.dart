import 'package:untitled/models/registration.dart';

class UsersModel {
  UsersModel({
    this.status,
    this.message,
    this.data,
  });

  UsersModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(User.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<User>? data;

  UsersModel copyWith({
    bool? status,
    String? message,
    List<User>? data,
  }) =>
      UsersModel(
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
