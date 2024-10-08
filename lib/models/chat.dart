// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:untitled/models/registration.dart';

class ChatUserRoom {
  bool? _iBlocked;
  bool? _iAmBlocked;
  String? _conversationId;
  String? _deletedId;
  bool? _isDeleted;
  bool? _isMute;
  String? _lastMsg;
  int? _newMsgCount;
  String? _title;
  String? _profileImage;
  int? _type;
  num? _userIdOrRoomId;
  DateTime? _time;
  List<num>? _usersIds;
  Map<String, String>? _deleteChatIds;
  Map<String, num>? _unreadCounts;

  ChatUserRoom(
      {String? conversationId,
      bool? iAmBlocked,
      bool? iBlocked,
      String? deletedId,
      bool? isDeleted,
      bool? isMute,
      String? lastMsg,
      int? newMsgCount,
      DateTime? time,
      String? title,
      String? profileImage,
      num? userIdOrRoomId,
      List<num>? usersIds,
      int? type,
      Map<String, String>? deleteChatIds,
      Map<String, num>? unreadCounts}) {
    _title = title;
    _conversationId = conversationId;
    _iAmBlocked = iAmBlocked;
    _iBlocked = iBlocked;
    _deletedId = deletedId;
    _isDeleted = isDeleted;
    _isMute = isMute;
    _lastMsg = lastMsg;
    _newMsgCount = newMsgCount;
    _time = time;
    _profileImage = profileImage;
    _type = type;
    _userIdOrRoomId = userIdOrRoomId;
    _usersIds = usersIds;
    _deleteChatIds = deleteChatIds;
    _unreadCounts = unreadCounts;
  }

  factory ChatUserRoom.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ChatUserRoom(
        conversationId: data?['conversationId'],
        iAmBlocked: data?['iAmBlocked'],
        iBlocked: data?['iBlocked'],
        deletedId: data?['deletedId'],
        isDeleted: data?['isDeleted'],
        isMute: data?['isMute'],
        lastMsg: data?['lastMsg'],
        newMsgCount: data?['newMsgCount'],
        time: (data?['time'] as Timestamp?)?.toDate(),
        type: data?['type'],
        title: data?['title'],
        profileImage: data?['profileImage'],
        userIdOrRoomId: data?['userIdOrRoomId'],
        usersIds: data?['usersIds'].cast<num>(),
        deleteChatIds: data?['deleteChatIds'],
        unreadCounts: data?['unreadCounts']);
  }

  String? get conversationId => _conversationId;

  List<num>? get usersIds => _usersIds;

  set usersIds(List<num>? value) {
    _usersIds = value;
  }

  bool? get iAmBlocked => _iAmBlocked;

  Map<String, dynamic> toFireStore() {
    return {
      if (conversationId != null) "conversationId": _conversationId,
      if (iAmBlocked != null) "iAmBlocked": _iAmBlocked,
      if (iBlocked != null) "iBlocked": _iBlocked,
      if (deletedId != null) "deletedId": _deletedId,
      if (isDeleted != null) "isDeleted": _isDeleted,
      if (isMute != null) "isMute": _isMute,
      if (lastMsg != null) "lastMsg": _lastMsg,
      if (newMsgCount != null) "newMsgCount": _newMsgCount,
      if (time != null) "time": _time,
      if (type != null) "type": _type,
      if (title != null) "title": _title,
      if (profileImage != null) "profileImage": _profileImage,
      if (userIdOrRoomId != null) "userIdOrRoomId": _userIdOrRoomId,
      if (usersIds != null) "usersIds": _usersIds,
      if (deleteChatIds != null) "deleteChatIds": _deleteChatIds,
      if (unreadCounts != null) "unreadCounts": _unreadCounts
    };
  }

  ChatUserRoom.fromJson(Map<String, dynamic> json) {
    _conversationId = json["conversationId"];
    _iAmBlocked = json["iAmBlocked"];
    _iBlocked = json["iBlocked"];
    _deletedId = json["deletedId"];
    _isDeleted = json["isDeleted"];
    _isMute = json["isMute"];
    _lastMsg = json["lastMsg"];
    _newMsgCount = json["newMsgCount"];
    _time = (json['time'] as Timestamp?)?.toDate();
    _type = json["type"];
    _title = json["title"];
    _profileImage = json["profileImage"];
    _userIdOrRoomId = json["userIdOrRoomId"];
    // ignore: prefer_null_aware_operators
    _usersIds = json['usersIds'] == null ? null : json['usersIds'].cast<num>();
    _deleteChatIds = json['deleteChatIds'] == null
        ? null
        : json['deleteChatIds'].cast<String, String>();

    _unreadCounts =
        // ignore: prefer_null_aware_operators
        json['unreadCounts'] == null
            ? null
            : json['unreadCounts'].cast<String, num>();
  }

  Map<String, Object?> toJson() {
    return {
      "conversationId": _conversationId,
      "iAmBlocked": _iAmBlocked,
      "iBlocked": _iBlocked,
      "deletedId": _deletedId,
      "isDeleted": _isDeleted,
      "isMute": _isMute,
      "lastMsg": _lastMsg,
      "newMsgCount": _newMsgCount,
      "time": _time,
      "title": _title,
      "profileImage": _profileImage,
      "type": _type,
      "userIdOrRoomId": _userIdOrRoomId,
      "usersIds": _usersIds,
      'deleteChatIds': deleteChatIds,
      'unreadCounts': unreadCounts,
    };
  }

  void setConversationId(String? con) {
    _conversationId = con;
  }

  bool? get iBlocked => _iBlocked;

  String? get deletedId => _deletedId;

  bool? get isDeleted => _isDeleted;

  bool? get isMute => _isMute;

  String? get lastMsg => _lastMsg;

  int? get newMsgCount => _newMsgCount;

  String? get title => _title;

  String? get profileImage => _profileImage;

  Map<String, num>? get unreadCounts => _unreadCounts;

  Map<String, String>? get deleteChatIds => _deleteChatIds;

  /// 0 = RequestChat
  /// 1 = UserChat
  /// 2 = RoomChat
  int? get type => _type;

  num? get userIdOrRoomId => _userIdOrRoomId;

  DateTime? get time => _time;

  set type(int? value) {
    _type = value;
  }

  set time(DateTime? value) {
    _time = value;
  }

  set lastMsg(String? value) {
    _lastMsg = value;
  }

  set newMsgCount(int? value) {
    _newMsgCount = value;
  }

  set iAmBlocked(bool? value) {
    _iAmBlocked = value;
  }

  set iBlocked(bool? value) {
    _iBlocked = value;
  }

  set isDeleted(bool? value) {
    _isDeleted = value;
  }

  set unreadCounts(Map<String, num>? value) {
    _unreadCounts = value;
  }

  set deleteChatIds(Map<String, String>? value) {
    _deleteChatIds = value;
  }
}

class ChatUser {
  int? _userid;
  String? _username;
  String? _fullName;
  String? _image;
  bool? _isVerified;

  ChatUser({
    String? username,
    String? fullName,
    String? image,
    bool? isVerified,
    int? userid,
  }) {
    _username = username;
    _fullName = fullName;
    _image = image;
    _isVerified = isVerified;
    _userid = userid;
  }

  Map<String, dynamic> toJson() {
    return {
      "username": _username,
      "fullName": _fullName,
      "image": _image,
      "isVerified": _isVerified,
      "userid": _userid,
    };
  }

  ChatUser.fromJson(Map<String, dynamic> json) {
    _username = json["username"];
    _fullName = json["fullName"];
    _image = json["image"];
    _isVerified = json["isVerified"];
    _userid = json["userid"];
  }

  bool? get isVerified => _isVerified;

  String? get image => _image;

  String? get fullName => _fullName;

  String? get username => _username;

  int? get userid => _userid;
}

class ChatMessage {
  String? _id;
  String? _content;
  String? _thumbnail;
  String? _msg;
  String? _msgType;
  List<String>? _deletedIds;
  num? _senderId;

  ChatMessage(
      {String? id,
      String? content,
      String? thumbnail,
      String? msg,
      String? msgType,
      num? senderId,
      List<String>? notDeletedIdentities}) {
    _id = id;
    _content = content;
    _msg = msg;
    _msgType = msgType;
    _senderId = senderId;
    _deletedIds = notDeletedIdentities;
    _thumbnail = thumbnail;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": _id,
      "content": _content,
      "thumbnail": _thumbnail,
      "msg": _msg,
      "msgType": _msgType,
      "senderId": _senderId,
      "deletedIds": _deletedIds?.map((v) => v).toList()
    };
  }

  ChatMessage.fromJson(Map<String, dynamic>? json) {
    _id = json?["id"];
    _content = json?["content"];
    _thumbnail = json?["thumbnail"];
    _msg = json?["msg"];
    _msgType = json?["msgType"];
    _senderId = json?["senderId"];
    if (json?['deletedIds'] != null) {
      _deletedIds = [];
      json?['deletedIds'].forEach((v) {
        _deletedIds?.add(v);
      });
    }
  }

  factory ChatMessage.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    List<String> notDeletedIdentities = [];
    if (data?['not_deleted_identities'] != null) {
      data?['not_deleted_identities'].forEach((v) {
        notDeletedIdentities.add(v);
      });
    }
    return ChatMessage(
      id: data?['id'],
      content: data?['content'],
      thumbnail: data?['thumbnail'],
      msg: data?['msg'],
      msgType: data?['msgType'],
      notDeletedIdentities: notDeletedIdentities,
      senderId: data?['senderId'],
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      if (id != null) "id": _id,
      if (content != null) "content": _content,
      if (thumbnail != null) "thumbnail": _thumbnail,
      if (msg != null) "msg": _msg,
      if (msgType != null) "msgType": _msgType,
      if (senderId != null) "senderId": _senderId,
      if (notDeletedIdentities != null)
        "not_deleted_identities": _deletedIds?.map((v) => v).toList()
    };
  }

  String getChatTime() {
    return DateFormat('dd MMM, yyyy h:mm a').format(
      DateTime.fromMillisecondsSinceEpoch(
          (int.parse(id ?? '0') / 1000).round()),
    );
  }

  String? get content => _content;

  String? get thumbnail => _thumbnail;

  List<String>? get notDeletedIdentities => _deletedIds;

  num? get senderId => _senderId;

  String? get msgType => _msgType;

  String? get msg => _msg;

  String? get id => _id;
}

extension ChatUserExt on User {
  ChatUser toChatUser() {
    return ChatUser(
        fullName: fullName,
        image: profile,
        isVerified: isVerified == 1,
        userid: id?.toInt(),
        username: username);
  }
}
