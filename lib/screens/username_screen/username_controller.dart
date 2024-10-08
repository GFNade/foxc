import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/api_service/user_service.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/screens/interests_screen/interests_controller.dart';
import 'package:untitled/screens/profile_picture_screen/profile_picture_screen.dart';

class UsernameController extends InterestsController {
  TextEditingController textController = TextEditingController();
  bool isUsernameAvailable = false;

  @override
  void onInit() {
    super.onInit();
    textController.addListener(() {
      checkForUsername();
    });
  }

  void checkForUsername({Function(bool)? completion}) {
    if (textController.text.isNotEmpty && SessionManager.shared.getUser()?.username == textController.text) {
      isUsernameAvailable = true;
      update();
      if (completion != null) {
        completion(false);
      }
      return;
    }
    UserService.shared.checkForUsername(textController.text, (p0) {
      isUsernameAvailable = p0;
      if (completion != null) {
        completion(p0);
      }
      update();
    });
  }

  void updateUsername() {
    if (!isUsernameAvailable) {
      showSnackBar(LKeys.thisUsernameIsNotAvailable.tr, type: SnackBarType.error);
      return;
    }

    startLoading();
    checkForUsername(
      completion: (p0) {
        if (!p0) {
          showSnackBar(LKeys.thisUsernameIsNotAvailable.tr, type: SnackBarType.error);
        } else {
          UserService.shared.editProfile(
              username: textController.text,
              completion: (p0) {
                stopLoading();
                Get.offAll(() => const ProfilePictureScreen());
              });
        }
      },
    );
  }
}
