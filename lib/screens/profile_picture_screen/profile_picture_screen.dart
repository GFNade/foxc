import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/widgets/my_cached_image.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/screens/extra_views/buttons.dart';
import 'package:untitled/screens/extra_views/top_bar.dart';
import 'package:untitled/screens/profile_picture_screen/profile_picture_controller.dart';
import 'package:untitled/utilities/const.dart';

class ProfilePictureScreen extends StatelessWidget {
  const ProfilePictureScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProfilePictureController controller = ProfilePictureController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: pOnBoarding,
          child: Column(
            children: [
              const TopBarForOnBoarding(
                titleStart: LKeys.selectYour,
                titleEnd: LKeys.profilePicture,
                desc: LKeys.setProfileDesc,
              ),
              const Spacer(),
              ProfileImagePicker(controller: controller),
              const Spacer(),
              const Spacer(),
              CommonButton(
                  text: LKeys.continue1,
                  onTap: () {
                    controller.uploadImage();
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileImagePicker extends StatelessWidget {
  final String? imageURL;
  final double? boxSize;
  final ProfilePictureController controller;
  final double radius;
  final Color dotColor;
  final Function()? onTap;

  const ProfileImagePicker(
      {Key? key,
      this.boxSize,
      required this.controller,
      this.radius = 60,
      this.onTap,
      this.imageURL,
      this.dotColor = cLightText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfilePictureController>(
      init: controller,
      builder: (controller) {
        var isEdit = imageURL != null || controller.file != null;
        return GestureDetector(
          onTap: () {
            if (onTap != null) {
              onTap!();
            } else {
              controller.pickImage();
            }
          },
          child: DottedBorder(
              borderType: BorderType.RRect,
              dashPattern: const [3, 2],
              color: dotColor,
              radius: Radius.circular(radius),
              child: ClipSmoothRect(
                radius: SmoothBorderRadius.all(SmoothRadius(
                    cornerRadius: radius, cornerSmoothing: cornerSmoothing)),
                child: Container(
                    width: boxSize ?? (MediaQuery.of(context).size.width / 1.5),
                    height:
                        boxSize ?? (MediaQuery.of(context).size.width / 1.5),
                    decoration: ShapeDecoration(
                      shape: SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius.all(SmoothRadius(
                              cornerRadius: radius,
                              cornerSmoothing: cornerSmoothing))),
                      color: cLightBg,
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: [
                        (imageURL != null && controller.file == null)
                            ? MyCachedImage(
                                imageUrl: imageURL ?? '',
                              )
                            : Container(),
                        controller.imagePath == ""
                            ? Container()
                            : Image.file(
                                File(controller.imagePath),
                                fit: BoxFit.cover,
                              ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: cBlack.withOpacity(0.3),
                              radius: 20,
                              child: Icon(
                                isEdit
                                    ? Icons.mode_edit_sharp
                                    : Icons.add_circle,
                                color: cWhite,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              )),
        );
      },
    );
  }
}
