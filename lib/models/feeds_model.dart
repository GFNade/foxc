import 'package:untitled/models/registration.dart';
import 'package:untitled/models/room_model.dart';

class FeedsModel {
  FeedsModel({
    bool? status,
    String? message,
    List<Feed>? data,
    List<Room>? suggestedRooms,
  }) {
    _status = status;
    _message = message;
    _data = data;
    _suggestedRooms = suggestedRooms;
  }

  FeedsModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Feed.fromJson(v));
      });
    }
    if (json['suggestedRooms'] != null) {
      _suggestedRooms = [];
      json['suggestedRooms'].forEach((v) {
        _suggestedRooms?.add(Room.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<Feed>? _data;
  List<Room>? _suggestedRooms;

  bool? get status => _status;

  String? get message => _message;

  List<Feed>? get data => _data;

  List<Room>? get suggestedRooms => _suggestedRooms;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    if (_suggestedRooms != null) {
      map['suggestedRooms'] = _suggestedRooms?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Feed {
  Feed({
    int? id,
    int? userId,
    String? desc,
    int? commentsCount,
    int? likesCount,
    String? createdAt,
    String? updatedAt,
    int? isLike,
    List<Content>? content,
    User? user,
  }) {
    _id = id;
    _userId = userId;
    _desc = desc;
    _commentsCount = commentsCount;
    _likesCount = likesCount;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _isLike = isLike;
    _content = content;
    _user = user;
  }

  Feed.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _desc = json['desc'];
    _commentsCount = json['comments_count'];
    _likesCount = json['likes_count'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _isLike = json['is_like'];
    if (json['content'] != null) {
      _content = [];
      json['content'].forEach((v) {
        _content?.add(Content.fromJson(v));
      });
    }
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  int? _id;
  int? _userId;
  String? _desc;
  int? _commentsCount;
  int? _likesCount;
  String? _createdAt;
  String? _updatedAt;
  int? _isLike;
  List<Content>? _content;
  User? _user;

  Feed copyWith({
    int? id,
    int? userId,
    String? desc,
    int? commentsCount,
    int? likesCount,
    String? createdAt,
    String? updatedAt,
    int? isLike,
    List<Content>? content,
    User? user,
  }) =>
      Feed(
        id: id ?? _id,
        userId: userId ?? _userId,
        desc: desc ?? _desc,
        commentsCount: commentsCount ?? _commentsCount,
        likesCount: likesCount ?? _likesCount,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        isLike: isLike ?? _isLike,
        content: content ?? _content,
        user: user ?? _user,
      );

  int? get id => _id;

  int? get userId => _userId ?? 0;

  String? get desc => _desc;

  int get commentsCount => _commentsCount ?? 0;

  int get likesCount => _likesCount ?? 0;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  int get isLike => _isLike ?? 0;

  List<Content> get content => _content ?? [];

  User? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['desc'] = _desc;
    map['comments_count'] = _commentsCount;
    map['likes_count'] = _likesCount;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['is_like'] = _isLike;
    if (_content != null) {
      map['content'] = _content?.map((v) => v.toJson()).toList();
    }
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    return map;
  }

  set isLike(int value) {
    _isLike = value;
  }

  set likesCount(int? value) {
    _likesCount = value;
  }

  set commentsCount(int? value) {
    _commentsCount = value;
  }

  set user(User? value) {
    _user = value;
  }

//
// set likesCount(int? value) {
//   _likesCount = value;
// }
//
// set isLike(int? value) {
//   _isLike = value;
// }
//
// set commentsCount(int value) {
//   _commentsCount = value;
// }
}

class Content {
  Content({
    int? id,
    int? postId,
    int? contentType,
    String? content,
    String? thumbnail,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _postId = postId;
    _contentType = contentType;
    _content = content;
    _thumbnail = thumbnail;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Content.fromJson(dynamic json) {
    _id = json['id'];
    _postId = json['post_id'];
    _contentType = json['content_type'];
    _content = json['content'];
    _thumbnail = json['thumbnail'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  int? _id;
  int? _postId;
  int? _contentType;
  String? _content;
  String? _thumbnail;
  String? _createdAt;
  String? _updatedAt;

  Content copyWith({
    int? id,
    int? postId,
    int? contentType,
    String? content,
    String? createdAt,
    String? updatedAt,
  }) =>
      Content(
        id: id ?? _id,
        postId: postId ?? _postId,
        contentType: contentType ?? _contentType,
        content: content ?? _content,
        thumbnail: thumbnail ?? _thumbnail,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );

  int? get id => _id;

  int? get postId => _postId;

  int? get contentType => _contentType;

  String? get content => _content;

  String? get thumbnail => _thumbnail;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['post_id'] = _postId;
    map['content_type'] = _contentType;
    map['content'] = _content;
    map['thumbnail'] = _thumbnail;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}

extension O on Feed {
  DateTime get date => DateTime.parse(createdAt ?? '');
}
