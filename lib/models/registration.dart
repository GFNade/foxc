import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/models/setting_model.dart';
import 'package:untitled/models/story.dart';

class Registration {
  Registration({
    bool? status,
    String? message,
    User? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  Registration.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? User.fromJson(json['data']) : null;
  }

  bool? _status;
  String? _message;
  User? _data;

  Registration copyWith({
    bool? status,
    String? message,
    User? data,
  }) =>
      Registration(
        status: status ?? _status,
        message: message ?? _message,
        data: data ?? _data,
      );

  bool? get status => _status;

  String? get message => _message;

  User? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

class User {
  User({
    this.id,
    this.identity,
    this.username,
    this.fullName,
    this.bio,
    this.interestIds,
    this.profile,
    this.backgroundImage,
    this.isPushNotifications,
    this.isInvitedToRoom,
    this.isVerified,
    this.isBlock,
    this.blockUserIds,
    this.following,
    this.followers,
    this.loginType,
    this.deviceType,
    this.deviceToken,
    this.createdAt,
    this.updatedAt,
    this.followingStatus,
    this.story,
    this.interest,
  });

  User.fromJson(dynamic json) {
    id = json['id'];
    identity = json['identity'];
    username = json['username'];
    fullName = json['full_name'];
    bio = json['bio'];
    interestIds = json['interest_ids'];
    profile = json['profile'];
    backgroundImage = json['background_image'];
    isPushNotifications = json['is_push_notifications'];
    isInvitedToRoom = json['is_invited_to_room'];
    isVerified = json['is_verified'];
    isBlock = json['is_block'];
    blockUserIds = json['block_user_ids'];
    following = json['following'];
    followers = json['followers'];
    loginType = json['login_type'];
    deviceType = json['device_type'];
    deviceToken = json['device_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    followingStatus = json['followingStatus'];

    if (json['interest'] != null) {
      interest = [];
      json['interest'].forEach((v) {
        interest?.add(Interest.fromJson(v));
      });
    }

    if (json['story'] != null) {
      story = [];
      json['story'].forEach((v) {
        var s = Story.fromJson(v);
        s.user = this;
        story?.add(s);
      });
    }
  }

  num? id;
  String? identity;
  String? username;
  String? fullName;
  String? bio;
  String? interestIds;
  String? profile;
  String? backgroundImage;
  num? isPushNotifications;
  num? isInvitedToRoom;
  num? isVerified;
  num? isBlock;
  String? blockUserIds;
  num? following;
  num? followers;
  num? loginType;
  num? deviceType;
  String? deviceToken;
  String? createdAt;
  String? updatedAt;

  /// koi ek bija ne follow nathi kartu to 0
  /// same valo mane follow kar che to 1
  /// hu same vala ne follow karu chu to 2
  /// banne ek bija ne follow kare to 3
  num? followingStatus;
  List<Story>? story;
  List<Interest>? interest;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['identity'] = identity;
    map['username'] = username;
    map['full_name'] = fullName;
    map['bio'] = bio;
    map['interest_ids'] = interestIds;
    map['profile'] = profile;
    map['background_image'] = backgroundImage;
    map['is_push_notifications'] = isPushNotifications;
    map['is_invited_to_room'] = isInvitedToRoom;
    map['is_verified'] = isVerified;
    map['is_block'] = isBlock;
    map['block_user_ids'] = blockUserIds;
    map['following'] = following;
    map['followers'] = followers;
    map['login_type'] = loginType;
    map['device_type'] = deviceType;
    map['device_token'] = deviceToken;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['followingStatus'] = followingStatus;
    if (story != null) {
      map['story'] = story?.map((v) => v.toJson()).toList();
    }
    if (interest != null) {
      map['interest'] = interest?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  String firebaseId() {
    return "${id ?? 0}";
  }

  bool isAllStoryShown() {
    var isWatched = true;
    for (var element in (story ?? [])) {
      if (!element.isWatchedByMe()) {
        isWatched = false;
        break;
      }
    }
    return isWatched;
  }

  bool isBlockedByMe() {
    return SessionManager.shared.getUser()?.blockUserIds?.split(',').contains('$id') ?? false;
  }
}

extension O on User {
  List<String> getInterestsStringList() {
    List<String> arr = (interestIds ?? '').split(',');
    List<Interest> interests = SessionManager.shared.getSettings()?.interests?.where((element) {
          return arr.contains("${element.id}");
        }).toList() ??
        [];

    return interests.map((e) => e.title ?? "").toList();
  }

  List<Interest> getInterests() {
    List<String> arr = (interestIds ?? '').split(',');
    List<Interest> interests = SessionManager.shared.getSettings()?.interests?.where((element) {
          return arr.contains("${element.id}");
        }).toList() ??
        [];

    return interests;
  }
}
