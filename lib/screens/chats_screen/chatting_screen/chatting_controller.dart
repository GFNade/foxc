import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/api_service/notification_service.dart';
import 'package:untitled/common/api_service/room_service.dart';
import 'package:untitled/common/api_service/user_service.dart';
import 'package:untitled/common/extensions/int_extension.dart';
import 'package:untitled/common/managers/firebase_notification_manager.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/chat.dart';
import 'package:untitled/models/invitations_model.dart';
import 'package:untitled/models/registration.dart';
import 'package:untitled/models/room_model.dart';
import 'package:untitled/screens/chats_screen/chatting_screen/block_user_controller.dart';
import 'package:untitled/screens/sheets/confirmation_sheet.dart';
import 'package:untitled/utilities/firebase_const.dart';

class ChattingController extends BlockUserController {
  ScrollController scrollController = ScrollController();
  DocumentReference? documentSender;
  DocumentReference? documentReceiver;
  CollectionReference? drChatMessages;
  StreamSubscription? messagesListener;
  StreamSubscription? userListener;
  StreamSubscription? myUserListener;
  List<ChatMessage> messages = [];
  ChatUserRoom? chatUserRoom;
  ChatUserRoom? myChatRoom;
  QueryDocumentSnapshot<ChatMessage>? lastMsgQuery;
  String deleteId = "";
  bool isFirstTime = true;
  Room? room;
  User? user;
  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController messageTextController = TextEditingController();
  User? myUser = SessionManager.shared.getUser();

  ChattingController({this.room, this.user, ChatUserRoom? chatUserRoom}) {
    if (chatUserRoom != null) {
      this.chatUserRoom = chatUserRoom;
    } else if (room != null) {
      this.chatUserRoom = ChatUserRoom(
          conversationId: room?.firebaseId(),
          title: room?.title ?? '',
          profileImage: room?.photo ?? '',
          userIdOrRoomId: room?.id,
          type: 2);
    } else if (user != null) {
      this.chatUserRoom = ChatUserRoom(
          conversationId: user?.id?.toConversationId(),
          title: user?.fullName ?? '',
          profileImage: user?.profile ?? '',
          userIdOrRoomId: user?.id,
          type: 1);
    }
    var firebaseUserIdentity = this.chatUserRoom?.userIdOrRoomId?.toString() ?? '';

    documentSender = db
        .collection(FirebaseConst.users)
        .doc(myUser?.firebaseId())
        .collection(FirebaseConst.userList)
        .doc(firebaseUserIdentity);

    documentReceiver = db
        .collection(FirebaseConst.users)
        .doc(firebaseUserIdentity)
        .collection(FirebaseConst.userList)
        .doc(myUser?.firebaseId());
    //
    drChatMessages = db
        .collection(FirebaseConst.chats)
        .doc(this.chatUserRoom?.conversationId ?? '')
        .collection(FirebaseConst.messages);
    SessionManager.shared.setStoredConversation(chatUserRoom?.conversationId ?? '');
    print('In Chat Room: ${chatUserRoom?.conversationId}');
  }

  @override
  void onReady() {
    fetchDetailWithAPI();
    super.onReady();
  }

  @override
  void onInit() {
    scrollController.addListener(
      () {
        if (scrollController.offset == scrollController.position.maxScrollExtent) {
          if (!isLoading) {
            loadOldData();
          }
        }
      },
    );
    super.onInit();
  }

  void sendMsg({MessageType type = MessageType.text}) {
    if (messageTextController.text.isEmpty) {
      return;
    }
    commonSend(type: MessageType.text);
  }

  void commonSend({required MessageType type, String content = '', String thumbnail = ''}) {
    if (chatUserRoom?.iAmBlocked == true) {
      return;
    }
    if (chatUserRoom?.iBlocked == true) {
      unblockUser(user, () {});
      return;
    }
    var date = DateTime.now();
    var lastMsg = messageTextController.text.isEmpty
        ? (type == MessageType.image ? 'Image' : 'Video')
        : messageTextController.text;
    if (room != null) {
      var roomData = ChatUserRoom(
          conversationId: room?.firebaseId(),
          lastMsg: lastMsg,
          profileImage: room?.photo,
          title: room?.title,
          time: date,
          type: 2,
          usersIds: room?.roomUsers?.map((e) => e.id ?? 0).toList(),
          userIdOrRoomId: room?.id,
          unreadCounts: {},
          deleteChatIds: {});
      chatUserRoom?.usersIds?.forEach((element) {
        roomData.unreadCounts?['${element.toInt()}'] = (chatUserRoom?.unreadCounts?['${element.toInt()}'] ?? 0) + 1;
        roomData.deleteChatIds?['${element.toInt()}'] =
            ((chatUserRoom?.deleteChatIds?['${element.toInt()}']) ?? '').replaceFirst(RegExp('d'), '');
      });
      if (deleteId == "" && messages.isEmpty) {
        db.collection(FirebaseConst.chats).doc(roomData.conversationId ?? '').set(roomData.toFireStore());
      } else {
        db.collection(FirebaseConst.chats).doc(roomData.conversationId ?? '').update(roomData.toFireStore());
      }
      var totalUserForNotifications = room?.roomUsers
          ?.where((element) => element.isPushNotifications == 1)
          .map((e) => e.deviceToken ?? '')
          .toList();
      totalUserForNotifications?.removeWhere((element) => element == '');
      NotificationService.shared.sendToTopic(
          topic: 'room_${room?.id ?? 0}',
          title: room?.title ?? '',
          body: '${myUser?.fullName ?? ''} : $lastMsg',
          conversationId: chatUserRoom?.conversationId ?? '');
    } else {
      chatUserRoom?.lastMsg = lastMsg;
      chatUserRoom?.time = date;
      chatUserRoom?.newMsgCount = 0;
      chatUserRoom?.isDeleted = false;
      if (deleteId == "" && messages.isEmpty) {
        documentSender?.set(chatUserRoom?.toFireStore());
      } else {
        documentSender?.update(chatUserRoom?.toFireStore() ?? {});
      }
    }

    if (user != null) {
      var status = (user?.followingStatus ?? 0);
      print(chatUserRoom?.type);
      var myChatRoom = ChatUserRoom(
          isMute: false,
          profileImage: myUser?.profile,
          conversationId: chatUserRoom?.conversationId,
          lastMsg: lastMsg,
          title: myUser?.fullName,
          time: date,
          type: (status == 1) || (status == 3) ? 1 : 0,
          userIdOrRoomId: myUser?.id,
          newMsgCount: 1,
          isDeleted: false);
      if ((deleteId == "" && messages.isEmpty) || this.myChatRoom?.type == null) {
        documentReceiver?.set(myChatRoom.toFireStore());
      } else {
        myChatRoom.type = this.myChatRoom?.type;
        var map = myChatRoom.toFireStore();
        map[FirebaseConst.newMsgCount] = FieldValue.increment(1);
        documentReceiver?.update(map);
      }
      if (user?.isPushNotifications == 1) {
        NotificationService.shared.sendToSingleUser(
            token: user?.deviceToken ?? '',
            deviceType: user?.deviceType,
            title: myUser?.fullName ?? '',
            body: lastMsg,
            conversationId: chatUserRoom?.conversationId ?? '');
      }
    }
    var map = ChatMessage(
            id: date.microsecondsSinceEpoch.toString(),
            msg: messageTextController.text,
            msgType: type.value,
            content: content,
            thumbnail: thumbnail,
            senderId: myUser?.id)
        .toJson();

    drChatMessages?.doc(date.millisecondsSinceEpoch.toString()).set(map);
    messageTextController.text = "";
  }

  void fetchDetailWithAPI() {
    if (chatUserRoom?.type != 2) {
      myUserListener = db
          .collection(FirebaseConst.users)
          .doc("${chatUserRoom?.userIdOrRoomId?.toInt() ?? 0}")
          .collection(FirebaseConst.userList)
          .doc(myUser?.firebaseId())
          .snapshots()
          .listen((event) {
        myChatRoom = ChatUserRoom.fromJson(event.data() ?? {});
        update();
      });
      userListener = db
          .collection(FirebaseConst.users)
          .doc(myUser?.firebaseId())
          .collection(FirebaseConst.userList)
          .doc("${chatUserRoom?.userIdOrRoomId?.toInt() ?? 0}")
          .snapshots()
          .listen((event) {
        if (event.data() != null) {
          chatUserRoom = ChatUserRoom.fromJson(event.data() ?? {});
          stopNotification();
        }
        deleteId = chatUserRoom?.deletedId ?? '';
        if (isFirstTime) {
          fetchMessages();
        }
        update();
      });

      startLoading();
      UserService.shared.fetchProfile(chatUserRoom?.userIdOrRoomId?.toInt() ?? 0, (user) {
        stopLoading();
        this.user = user;
        update();
      });
      UserService.shared.fetchMyProfile(
          userID: myUser?.id ?? 0,
          myUserId: chatUserRoom?.userIdOrRoomId?.toInt(),
          completion: (user) {
            myUser = user;
            update();
          });
    } else if (chatUserRoom?.type == 2) {
      userListener = db.collection(FirebaseConst.chats).doc(chatUserRoom?.conversationId).snapshots().listen((event) {
        if (event.data() != null) {
          chatUserRoom = ChatUserRoom.fromJson(event.data() ?? {});
          stopNotification();
        }

        deleteId = (chatUserRoom?.deleteChatIds?['${myUser?.id}'] ?? '').replaceFirst(RegExp('d'), '');
        if (isFirstTime) {
          fetchMessages();
        }
        update();
      });
      // startLoading();
      RoomService.shared.fetchRoom(chatUserRoom?.userIdOrRoomId?.toInt() ?? 0, shouldShowMembers: true, (room) {
        this.room = room;
        // stopLoading();
        update();
      });
    }
  }

  void markAsRead() {
    if (chatUserRoom?.type == 2) {
      var map = chatUserRoom?.unreadCounts ?? {};
      map['${myUser?.id}'] = 0;
      db.collection(FirebaseConst.chats).doc(chatUserRoom?.conversationId).update({FirebaseConst.unreadCounts: map});
    } else {
      documentSender?.update({FirebaseConst.newMsgCount: 0});
    }
  }

  void fetchMessages() {
    if (messagesListener != null) return;
    messagesListener = drChatMessages
        ?.withConverter(
          fromFirestore: ChatMessage.fromFireStore,
          toFirestore: (value, options) => value.toFireStore(),
        )
        .where(FirebaseConst.id, isGreaterThan: deleteId)
        .orderBy(FirebaseConst.id, descending: true)
        .limit(FirebaseConst.pagination)
        .snapshots()
        .listen((event) {
      isFirstTime = false;
      for (var element in event.docChanges) {
        var data = element.doc.data();
        if (data != null) {
          switch (element.type) {
            case DocumentChangeType.added:
              // print("add");
              messages.add(data);
              messages.sort(
                (a, b) => (b.id ?? '').compareTo((a.id ?? '')),
              );
              update();
              break;
            case DocumentChangeType.modified:
              // print("modify");
              // var index = messages.indexWhere((element) => element.id == data.id);
              break;
            case DocumentChangeType.removed:
              // print("remove");
              messages.remove(data);
              update();
              break;
          }
        }
      }
      if (lastMsgQuery != null) {
        lastMsgQuery = event.docs.last;
      }
    });
  }

  void loadOldData() {
    if (lastMsgQuery == null) {
      return;
    }
    isLoading = true;
    drChatMessages
        ?.withConverter(
          fromFirestore: ChatMessage.fromFireStore,
          toFirestore: (value, options) => value.toFireStore(),
        )
        .where(FirebaseConst.id, isGreaterThan: deleteId)
        .orderBy(FirebaseConst.id, descending: true)
        .startAfterDocument(lastMsgQuery!)
        .limit(FirebaseConst.pagination)
        .get()
        .then((value) {
      isLoading = false;
      for (var element in value.docs) {
        messages.add(element.data());
      }
      if (value.docs.isNotEmpty) {
        lastMsgQuery = value.docs.last;
      }
      update();
    });
  }

  void rejectMessageRequest() {
    Get.bottomSheet(ConfirmationSheet(
      desc: LKeys.rejectChatRequest,
      buttonTitle: LKeys.reject,
      onTap: () {
        var date = DateTime.now().microsecondsSinceEpoch.toString();
        documentSender?.update({FirebaseConst.deletedId: date, FirebaseConst.isDeleted: true});
        Get.back();
      },
    ));
  }

  void acceptMessageRequest() {
    documentSender?.update({FirebaseConst.type: 1});
    chatUserRoom?.type = 1;
    update();
  }

  void leaveRoom() {
    startLoading();
    RoomService.shared.leaveThisRoom(room?.id ?? 0, () {
      stopLoading();
      room?.userRoomStatus = GroupUserAccessType.none.value;
      room?.totalMember = (room?.totalMember ?? 0) - 1;
      chatUserRoom?.usersIds?.removeWhere((element) => element == SessionManager.shared.getUserID());
      db
          .collection(FirebaseConst.chats)
          .doc(chatUserRoom?.conversationId ?? '')
          .update(chatUserRoom?.toFireStore() ?? {});
      Get.back(result: room);

      update();
    });
  }

  List<Invitation> joinRequests = [];

  void fetchRequests() {
    startLoading();
    RoomService.shared.fetchRoomRequestList(room?.id ?? 0, (invitations) {
      stopLoading();
      joinRequests = invitations;
      update();
    });
  }

  void acceptRequest(Invitation invitation) {
    startLoading();
    RoomService.shared.acceptRoomRequest(invitation.userId ?? 0, invitation.roomId ?? 0, () {
      stopLoading();
      room?.totalMember = (room?.totalMember ?? 0) + 1;
      joinRequests.removeWhere((element) => element.id == invitation.id);
      update();
    });
  }

  void muteUnMuteNotification() {
    var type = (room?.isMute ?? 0) == 0 ? 1 : 0;
    RoomService.shared.muteUnmuteNotification(type, room?.id ?? 0, () {
      room?.isMute = type;
      if (type == 0) {
        FirebaseNotificationManager.shared.subscribeToTopic('room_${room?.id ?? 0}');
      } else {
        FirebaseNotificationManager.shared.unsubscribeToTopic('room_${room?.id ?? 0}');
      }
      update();
    });
  }

  void rejectRequest(Invitation invitation) {
    startLoading();
    RoomService.shared.rejectRoomRequest(invitation.userId ?? 0, invitation.roomId ?? 0, () {
      stopLoading();
      joinRequests.removeWhere((element) => element.id == invitation.id);
      update();
    });
  }

  void deleteRoom() {
    startLoading();
    RoomService.shared.deleteRoom(room?.id ?? 0, () {
      stopLoading();
      Get.back();
    });
  }

  void stopNotification() {
    SessionManager.shared.setStoredConversation(chatUserRoom?.conversationId ?? '');
  }

  void startNotification() {
    SessionManager.shared.setStoredConversation('');
  }

  @override
  void onClose() {
    startNotification();
    messagesListener?.cancel();
    userListener?.cancel();
    myUserListener?.cancel();
    markAsRead();
    super.onClose();
    SessionManager.shared.setStoredConversation('');
  }
}
