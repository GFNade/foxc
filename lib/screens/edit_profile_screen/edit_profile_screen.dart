import 'dart:io';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/common/widgets/my_cached_image.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/screens/edit_profile_screen/edit_profile_controller.dart';
import 'package:untitled/screens/extra_views/buttons.dart';
import 'package:untitled/screens/extra_views/top_bar.dart';
import 'package:untitled/screens/interests_screen/interests_controller.dart';
import 'package:untitled/screens/interests_screen/interests_screen.dart';
import 'package:untitled/screens/profile_picture_screen/profile_picture_screen.dart';
import 'package:untitled/screens/rooms_you_own/create_room_screen/create_room_screen.dart';
import 'package:untitled/screens/username_screen/username_screen.dart';
import 'package:untitled/utilities/const.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EditProfileController controller = EditProfileController();
    return Scaffold(
      body: Column(
        children: [
          const TopBarForInView(title: LKeys.editProfile),
          GetBuilder(
              init: controller,
              builder: (controller) {
                return Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 290,
                            child: Stack(
                              // alignment: Alignment.bottomCenter,
                              children: [
                                backGroundImage(controller: controller, boxSize: Get.width / 1.5, radius: 25),
                                GestureDetector(
                                  onTap: () {
                                    controller.pickBGImage();
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 226,
                                    decoration: ShapeDecoration(
                                      gradient: LinearGradient(colors: [
                                        cBlack.withOpacity(0.5),
                                        Colors.transparent,
                                      ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                                      shape: const SmoothRectangleBorder(
                                          borderRadius: SmoothBorderRadius.all(
                                              SmoothRadius(cornerRadius: 25, cornerSmoothing: cornerSmoothing))),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    decoration: ShapeDecoration(
                                        shape: const SmoothRectangleBorder(
                                            borderRadius: SmoothBorderRadius.all(
                                                SmoothRadius(cornerRadius: 25, cornerSmoothing: cornerSmoothing))),
                                        shadows: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 5,
                                            offset: const Offset(0, 4), // Shadow position
                                          )
                                        ]),
                                    child: ProfileImagePicker(
                                      dotColor: Colors.transparent,
                                      imageURL: SessionManager.shared.getUser()?.profile,
                                      controller: controller,
                                      boxSize: 140,
                                      radius: 25,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const CreateRoomHeading(title: LKeys.fullName),
                          MyTextField(controller: controller.fullNameController, placeHolder: "John Deo"),
                          GetBuilder(
                              init: controller,
                              id: 'bio',
                              builder: (controller) {
                                return Column(
                                  children: [
                                    CreateRoomHeading(
                                      title: LKeys.bio,
                                      bracketText: "(${controller.bioEditController.text.length}/${Limits.bioCount})",
                                    ),
                                    MyTextField(
                                      controller: controller.bioEditController,
                                      placeHolder: LKeys.writeSomethingAboutYourSelf.tr,
                                      isEditor: true,
                                      limit: Limits.bioCount,
                                    ),
                                  ],
                                );
                              }),
                          const SizedBox(height: 5),
                          UserNameTextField(controller: controller),
                          const SizedBox(height: 10),
                          GetBuilder<EditProfileController>(
                              init: controller,
                              builder: (controller) {
                                return Column(
                                  children: [
                                    CreateRoomHeading(
                                      title: LKeys.interests,
                                      bracketText: "(${controller.selectedInterests.length}/${Limits.interestCount})",
                                    ),
                                    Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      alignment: WrapAlignment.center,
                                      children: InterestsController.interests.map((e) {
                                        return InterestTag(
                                            interest: e.title ?? '',
                                            isContain: controller.selectedInterests.contains(e),
                                            onTap: () {
                                              controller.toggleInterest(e);
                                            });
                                      }).toList(),
                                    ),
                                  ],
                                );
                              }),
                          const SizedBox(height: 50),
                          SafeArea(
                            top: false,
                            child: CommonButton(text: LKeys.update, onTap: controller.onSubmit),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }

  Widget backGroundImage({required EditProfileController controller, double? boxSize, required double radius}) {
    var imageURL = SessionManager.shared.getUser()?.backgroundImage;
    return Padding(
        padding: const EdgeInsets.only(top: 6),
        child: GetBuilder(
          init: controller,
          builder: (controller) {
            var isEdit = imageURL != null || controller.backgroundImageFile != null;
            return ClipSmoothRect(
              radius: SmoothBorderRadius.all(SmoothRadius(cornerRadius: radius - 2, cornerSmoothing: cornerSmoothing)),
              child: Container(
                  width: double.infinity,
                  height: 220,
                  decoration: ShapeDecoration(
                    shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius.all(
                            SmoothRadius(cornerRadius: radius, cornerSmoothing: cornerSmoothing))),
                    color: cLightBg,
                  ),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Stack(
                        fit: StackFit.expand,
                        children: [
                          (imageURL != null && controller.backgroundImageFile == null)
                              ? MyCachedImage(imageUrl: imageURL)
                              : Container(),
                          controller.backgroundImageFile == null
                              ? Container()
                              : Image.file(
                                  File(controller.backgroundImageFile?.path ?? ''),
                                  fit: BoxFit.cover,
                                ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: cBlack.withOpacity(0.3),
                          radius: 20,
                          child: Icon(
                            isEdit ? Icons.mode_edit_sharp : Icons.add_circle,
                            color: cWhite,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  )),
            );
          },
        ));
  }
}
