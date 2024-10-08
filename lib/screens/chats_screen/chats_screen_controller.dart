import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/controller/cupertino_controller.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/chat.dart';
import 'package:untitled/screens/sheets/confirmation_sheet.dart';
import 'package:untitled/utilities/firebase_const.dart';

class ChatsScreensController extends CupertinoController {
  List<ChatUserRoom> chats = [];
  List<ChatUserRoom> roomChats = [];
  StreamSubscription? chatsListener;
  StreamSubscription? roomChatsListener;
  bool isSearching = false;
  List<ChatUserRoom> filterChats = [];
  List<ChatUserRoom> filterRoomChats = [];
  TextEditingController textEditingController = TextEditingController();

  var db = FirebaseFirestore.instance;
  var myUser = SessionManager.shared.getUser();

  void onChange(String keyword) {
    filterChats = chats.where((element) {
      return element.title?.toLowerCase().contains(keyword.toLowerCase()) ??
          false;
    }).toList();

    filterRoomChats = roomChats.where((element) {
      return element.title?.toLowerCase().contains(keyword.toLowerCase()) ??
          false;
    }).toList();

    update();
  }

  @override
  void onReady() {
    fetchChats();
    super.onReady();
  }

  void fetchChats() {
    chatsListener = db
        .collection(FirebaseConst.users)
        .doc(myUser?.firebaseId() ?? '')
        .collection(FirebaseConst.userList)
        .where(FirebaseConst.isDeleted, isEqualTo: false)
        .snapshots()
        .listen((event) {
      chats.clear();
      for (var element in event.docs) {
        chats.add(ChatUserRoom.fromJson(element.data()));
      }
      chats.sort(
        (a, b) =>
            ((b.time ?? DateTime.now()).compareTo(a.time ?? DateTime.now())),
      );
      onChange(textEditingController.text);
      update();
    });

    roomChatsListener = db
        .collection(FirebaseConst.chats)
        .orderBy('time', descending: true)
        .where('usersIds', arrayContains: SessionManager.shared.getUserID())
        .snapshots()
        .listen((event) {
      roomChats.clear();
      for (var element in event.docs) {
        var chat = ChatUserRoom.fromJson(element.data());
        chat.newMsgCount = (chat.unreadCounts?['${myUser?.id}'] ?? 0).toInt();
        if (!(chat.deleteChatIds?['${myUser?.id}'] ?? '').startsWith('d')) {
          roomChats.add(chat);
        }
      }
      onChange(textEditingController.text);
      update();
    });
  }

  void clearChat(ChatUserRoom chatUserRoom) {
    Get.bottomSheet(
      ConfirmationSheet(
        desc: LKeys.chatRoomDesc,
        buttonTitle: LKeys.clearChat,
        onTap: () {
          var date = DateTime.now().microsecondsSinceEpoch.toString();
          if (chatUserRoom.type == 2) {
            var map = chatUserRoom.deleteChatIds ?? {};
            map['${myUser?.id}'] = date;
            db
                .collection(FirebaseConst.chats)
                .doc(chatUserRoom.conversationId)
                .update({FirebaseConst.deleteChatIds: map});
          } else {
            db
                .collection(FirebaseConst.users)
                .doc(myUser?.firebaseId())
                .collection(FirebaseConst.userList)
                .doc('${chatUserRoom.userIdOrRoomId}')
                .update({FirebaseConst.deletedId: date});
          }
        },
      ),
    );
  }

  void markToggle(ChatUserRoom chatUserRoom) {
    if (chatUserRoom.type == 2) {
      var count = (chatUserRoom.unreadCounts?['${myUser?.id}'] ?? 0).toInt();
      var map = chatUserRoom.unreadCounts ?? {};
      map['${myUser?.id}'] = (count == 0) ? -1 : 0;
      db
          .collection(FirebaseConst.chats)
          .doc(chatUserRoom.conversationId)
          .update({FirebaseConst.unreadCounts: map});
    } else {
      db
          .collection(FirebaseConst.users)
          .doc(myUser?.firebaseId())
          .collection(FirebaseConst.userList)
          .doc('${chatUserRoom.userIdOrRoomId}')
          .update({
        FirebaseConst.newMsgCount: (chatUserRoom.newMsgCount == 0) ? -1 : 0
      });
    }
  }

  void deleteChat(ChatUserRoom chatUserRoom) {
    Get.bottomSheet(
      ConfirmationSheet(
        desc: LKeys.deleteChatDesc,
        buttonTitle: LKeys.delete,
        onTap: () {
          var date = DateTime.now().microsecondsSinceEpoch.toString();
          if (chatUserRoom.type == 2) {
            var map = chatUserRoom.deleteChatIds ?? {};
            map['${myUser?.id}'] = 'd$date';
            db
                .collection(FirebaseConst.chats)
                .doc(chatUserRoom.conversationId)
                .update({FirebaseConst.deleteChatIds: map});
          } else {
            db
                .collection(FirebaseConst.users)
                .doc(myUser?.firebaseId())
                .collection(FirebaseConst.userList)
                .doc('${chatUserRoom.userIdOrRoomId}')
                .update({
              FirebaseConst.deletedId: date,
              FirebaseConst.isDeleted: true
            });
          }
        },
      ),
    );
  }

  @override
  void onClose() {
    chatsListener?.cancel();
    roomChatsListener?.cancel();
    super.onClose();
  }
}
