import 'package:untitled/models/feeds_model.dart';

class SingleFeedModel {
  SingleFeedModel({
      this.status, 
      this.message, 
      this.data,});

  SingleFeedModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Feed.fromJson(json['data']) : null;
  }
  bool? status;
  String? message;
  Feed? data;
SingleFeedModel copyWith({  bool? status,
  String? message,
  Feed? data,
}) => SingleFeedModel(  status: status ?? this.status,
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