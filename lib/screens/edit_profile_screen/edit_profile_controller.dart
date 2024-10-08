import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/common/api_service/user_service.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/registration.dart';

import '../profile_picture_screen/profile_picture_controller.dart';

class EditProfileController extends ProfilePictureController {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController bioEditController = TextEditingController();
  XFile? backgroundImageFile;

  @override
  void onReady() {
    fetchOldValues();
    bioEditController.addListener(() {
      update(['bio']);
    });
    super.onReady();
  }

  void pickBGImage({ImageSource source = ImageSource.gallery}) async {
    try {
      XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        backgroundImageFile = image;
        update();
      }
    } catch (e) {
      showSnackBar("Invalid Image");
    }
  }

  void fetchOldValues() {
    var user = SessionManager.shared.getUser();
    if (user != null) {
      textController.text = user.username ?? '';
      fullNameController.text = user.fullName ?? '';
      bioEditController.text = user.bio ?? '';
      selectedInterests = user.getInterests();
    }
  }

  void onSubmit() {
    if (!isUsernameAvailable) {
      showSnackBar(LKeys.thisUsernameIsNotAvailable.tr, type: SnackBarType.error);
      return;
    }
    startLoading();
    UserService.shared.editProfile(
      profileImage: file,
      bgImage: backgroundImageFile,
      fullName: fullNameController.text,
      username: textController.text,
      bio: bioEditController.text,
      interests: selectedInterests,
      completion: (p0) {
        stopLoading();
        Get.back();
        showSnackBar(LKeys.profileUpdatedSuccessfully.tr, type: SnackBarType.success);
      },
    );
  }
}
