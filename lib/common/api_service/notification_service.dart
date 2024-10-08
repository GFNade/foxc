import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:untitled/common/api_service/api_service.dart';
import 'package:untitled/common/api_service/room_service.dart';
import 'package:untitled/common/managers/firebase_notification_manager.dart';
import 'package:untitled/models/room_member_model.dart';
import 'package:untitled/utilities/params.dart';
import 'package:untitled/utilities/web_service.dart';

class NotificationService {
  static var shared = NotificationService();

  void sendToSingleUser({
    String? token,
    num? deviceType,
    required String title,
    required String body,
    required String conversationId,
  }) {
    bool isIOS = deviceType == 1;

    Map<String, dynamic> messageData = {
      "apns": {
        "payload": {
          "aps": {"sound": "default"}
        }
      },
      "data": {Param.conversationId: conversationId, "body": body, "title": title},
    };

    if (isIOS) {
      messageData["notification"] = {"body": body, "title": title};
    }

    if (token != null) {
      messageData["token"] = token;
    } else {
      return;
    }

    Map<String, dynamic> inputData = {"message": messageData};
    commonSend(inputData);
  }

  void sendToTopic({
    String? topic,
    required String title,
    required String body,
    required String conversationId,
  }) {
    Map<String, dynamic> messageData = {
      "data": {Param.conversationId: conversationId, "body": body, "title": title},
      "apns": {
        "payload": {
          "aps": {"sound": "default"}
        }
      },
    };
    messageData['topic'] = '${topic}_android';
    Map<String, dynamic> inputData = {"message": messageData};
    commonSend(inputData);

    messageData['topic'] = '${topic}_ios';
    messageData["notification"] = {"body": body, "title": title};
    inputData = {"message": messageData};
    commonSend(inputData);
  }

  void commonSend(Map<String, dynamic> inputData) {
    http
        .post(Uri.parse(WebService.pushNotificationToSingleUser),
            headers: ApiService.shared.header, body: json.encode(inputData))
        .then((value) {
      print(value.body);
    });
  }

  void getMyRooms(Function(List<RoomMember> rooms) completion) {
    RoomService.shared.fetchRoomsIAmIn((rooms) {
      completion(rooms);
    });
  }

  void subscribeToAllMyRoom() {
    getMyRooms((rooms) {
      for (var element in rooms) {
        if (element.isMute == 0) {
          FirebaseNotificationManager.shared.subscribeToTopic('room_${element.roomId ?? 0}');
        }
      }
    });
  }

  void unsubscribeToAllMyRoom() {
    getMyRooms((rooms) {
      for (var element in rooms) {
        FirebaseNotificationManager.shared.unsubscribeToTopic('room_${element.roomId ?? 0}');
      }
    });
  }
}
