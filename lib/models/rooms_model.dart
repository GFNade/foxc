import 'package:untitled/models/room_model.dart';

class RoomsModel {
  RoomsModel({
      this.status, 
      this.message, 
      this.data,});

  RoomsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Room.fromJson(v));
      });
    }
  }
  bool? status;
  String? message;
  List<Room>? data;
RoomsModel copyWith({  bool? status,
  String? message,
  List<Room>? data,
}) => RoomsModel(  status: status ?? this.status,
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
