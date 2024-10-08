class NotificationModel {
  NotificationModel({
    this.status,
    this.message,
    this.data,
  });

  NotificationModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(PlatformNotification.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<PlatformNotification>? data;

  NotificationModel copyWith({
    bool? status,
    String? message,
    List<PlatformNotification>? data,
  }) =>
      NotificationModel(
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

class PlatformNotification {
  PlatformNotification({
    this.id,
    this.title,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  PlatformNotification.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  num? id;
  String? title;
  String? description;
  String? createdAt;
  String? updatedAt;

  PlatformNotification copyWith({
    num? id,
    String? title,
    String? description,
    String? createdAt,
    String? updatedAt,
  }) =>
      PlatformNotification(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}
