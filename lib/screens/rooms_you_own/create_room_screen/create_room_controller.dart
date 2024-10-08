import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/common/api_service/room_service.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/common/managers/firebase_notification_manager.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/room_model.dart';
import 'package:untitled/models/setting_model.dart';
import 'package:untitled/screens/profile_picture_screen/profile_picture_controller.dart';
import 'package:untitled/utilities/const.dart';

class CreateRoomController extends ProfilePictureController {
  final String descriptionID = "descriptionID";
  final String interestGetID = "interestGetID";
  final roomGetID = "roomGetID";
  final joinGetID = "joinGetID";
  final Room? room;
  bool visibleToPublic = true;
  bool joinAfterRequest = false;
  TextEditingController titleTextController = TextEditingController();
  TextEditingController textDescriptionController = TextEditingController();

  CreateRoomController(this.room) {
    if (room != null) {
      titleTextController.text = room?.title ?? '';
      textDescriptionController.text = room?.desc ?? '';
      selectedInterests = room?.getInterests() ?? [];
      visibleToPublic = room?.isPrivate == 1 ? false : true;
      joinAfterRequest = room?.isJoinRequestEnable == 1 ? true : false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    textDescriptionController.addListener(() {
      update([descriptionID]);
    });
  }

  @override
  void toggleInterest(Interest interest) {
    if (selectedInterests.contains(interest)) {
      selectedInterests.remove(interest);
    } else {
      if (selectedInterests.length < Limits.interestCount) {
        addInterest(interest);
      } else {
        showSnackBar("${LKeys.youCanNotSelectMoreThan.tr} ${Limits.interestCount}", type: SnackBarType.error);
      }
    }
    update([interestGetID]);
  }

  void toggleMakeRoomPublic(bool value) {
    visibleToPublic = value;
    update([roomGetID]);
  }

  void toggleJoinAfterReq(bool value) {
    joinAfterRequest = value;
    update([joinGetID]);
  }

  void onSubmit() {
    if (room == null ? (file == null) : false) {
      showSnackBar(LKeys.pleaseSelectImage.tr, type: SnackBarType.error);
    } else if (titleTextController.text.isEmpty) {
      showSnackBar(LKeys.pleaseEnterRoomName.tr, type: SnackBarType.error);
    } else if (textDescriptionController.text.isEmpty) {
      showSnackBar(LKeys.pleaseEnterDescription.tr, type: SnackBarType.error);
    } else if (selectedInterests.length < 2) {
      showSnackBar(LKeys.pleaseSelectAtLeast2Interests.tr, type: SnackBarType.error);
    } else {
      startLoading();
      var interestIds = selectedInterests.map((e) => e.id ?? 0).toList().join(',');
      RoomService.shared.createOrEditRoom(
        roomId: room?.id,
        title: titleTextController.text,
        description: textDescriptionController.text,
        interestsIds: interestIds,
        image: XFile(imagePath),
        isPrivate: visibleToPublic ? 0 : 1,
        isEnableJoin: joinAfterRequest ? 1 : 0,
        completion: (room) {
          FirebaseNotificationManager.shared.subscribeToTopic('room_${room.id ?? 0}');
          stopLoading();
          Get.back(result: room);
          showSnackBar(this.room != null ? LKeys.roomUpdatedSuccessfully.tr : LKeys.roomCreatedSuccessfully.tr,
              type: SnackBarType.success);
        },
      );
    }
  }
}
