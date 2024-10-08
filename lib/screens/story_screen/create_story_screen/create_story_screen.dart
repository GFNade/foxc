import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/library/camera_filters/camera_filters.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/registration.dart';
import 'package:untitled/screens/story_screen/create_story_screen/create_story_controller.dart';
import 'package:untitled/screens/story_screen/story_screen.dart';
import 'package:untitled/utilities/const.dart';

class CreateStoryScreen extends StatelessWidget {
  final User user;

  const CreateStoryScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    CreateStoryController controller = CreateStoryController();
    return GetBuilder(
        init: controller,
        builder: (controller) {
          return Container(
              color: cBlack,
              child: user.story?.isNotEmpty == true &&
                      controller.shouldAddStory == false
                  ? Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        StoryScreen(users: [user], index: 0),
                        SafeArea(
                          child: GestureDetector(
                            onTap: controller.createAnotherStory,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              padding: const EdgeInsets.only(
                                  right: 20, left: 20, top: 7, bottom: 5),
                              decoration: BoxDecoration(
                                  color: cWhite,
                                  borderRadius: BorderRadius.circular(100)),
                              child: Text(
                                LKeys.create.tr.toUpperCase(),
                                style: MyTextStyle.gilroySemiBold(
                                    color: cBlack, size: 14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : CameraScreenPlugin(
                      onDone: (fileURL, duration) {
                        print("$fileURL - $duration");
                        controller.createStory(
                            fileURL: fileURL,
                            duration: duration,
                            isVideo: false);
                      },
                      onVideoDone: (fileURL, duration) {
                        print("$fileURL - $duration");
                        controller.createStory(
                            fileURL: fileURL,
                            duration: duration,
                            isVideo: true);
                      },
                    ));
        });
  }
}
