import 'dart:io';

import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/screens/add_post_screen/add_post_controller.dart';
import 'package:untitled/screens/extra_views/top_bar.dart';
import 'package:untitled/screens/post/video_player_sheet.dart';
import 'package:untitled/utilities/const.dart';
import 'package:video_player/video_player.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AddPostController controller = AddPostController();
    return Scaffold(
      body: Column(
        children: [
          TopBarForInView(
            title: LKeys.addPost,
            child: GetBuilder(
              init: controller,
              id: controller.postBtnGetID,
              builder: (controller) {
                var isDisable = controller.textEditingController.text.isEmpty;
                return GestureDetector(
                  onTap: () {
                    if (!isDisable) {
                      controller.uploadPost();
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.only(
                        right: 20, left: 20, top: 7, bottom: 5),
                    decoration: BoxDecoration(
                        color:
                            isDisable ? cLightText.withOpacity(0.5) : cPrimary,
                        borderRadius: BorderRadius.circular(100)),
                    child: Text(
                      LKeys.post.tr.toUpperCase(),
                      style: MyTextStyle.gilroySemiBold(
                          color: isDisable ? cLightText : cBlack, size: 14),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Container(
                      height: 130,
                      decoration: decoration(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 12),
                      child: DetectableTextField(
                        style:
                            MyTextStyle.gilroyRegular(size: 18, color: cBlack)
                                .copyWith(height: 1.2),
                        textCapitalization: TextCapitalization.sentences,
                        expands: true,
                        minLines: null,
                        maxLines: null,
                        decoration: InputDecoration(
                            hintText: LKeys.writeHere.tr,
                            hintStyle: MyTextStyle.gilroyRegular(
                                color: cLightText.withOpacity(0.6)),
                            border: InputBorder.none,
                            counterText: '',
                            isDense: true,
                            contentPadding: const EdgeInsets.all(0)),
                        cursorColor: cPrimary,
                        maxLength: null,
                        controller: controller.textEditingController,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(height: 15),
                    GetBuilder<AddPostController>(
                        init: controller,
                        id: controller.imageGetID,
                        builder: (controller) {
                          if (controller.imageFileList.isEmpty &&
                              controller.videoFile == null) {
                            return Row(
                              children: [
                                postBtn(controller, Icons.image_rounded,
                                    PickerStyle.image),
                                const SizedBox(width: 15),
                                postBtn(controller, Icons.video_library,
                                    PickerStyle.video)
                              ],
                            );
                          } else {
                            return imageOrVideoDataView(controller);
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget postBtn(
      AddPostController controller, IconData iconData, PickerStyle type) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          controller.pick(type);
        },
        child: Container(
          height: 50,
          decoration: decoration(),
          child: Icon(
            iconData,
            color: cLightText,
          ),
        ),
      ),
    );
  }

  Widget imageOrVideoDataView(AddPostController controller) {
    if (controller.imageFileList.isNotEmpty) {
      return PreviewPostImagesPageView(
        controller: controller,
      );
    }
    return PreviewPostVideoView(controller: controller);
  }

  ShapeDecoration decoration() {
    return const ShapeDecoration(
        color: cLightBg,
        shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius.all(SmoothRadius(
                cornerRadius: 10, cornerSmoothing: cornerSmoothing))));
  }
}

class PreviewPostVideoView extends StatelessWidget {
  final AddPostController controller;

  const PreviewPostVideoView({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (controller.playerController != null)
        ? ClipSmoothRect(
            radius: const SmoothBorderRadius.all(SmoothRadius(
                cornerRadius: 8, cornerSmoothing: cornerSmoothing)),
            child: GetBuilder<AddPostController>(
                init: controller,
                id: 'player',
                builder: (controller) {
                  return Container(
                    width: Get.width - 40,
                    height: Get.width - 40,
                    color: cBlack,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onTap: controller.playPause,
                          child: AspectRatio(
                              aspectRatio: controller
                                      .playerController?.value.aspectRatio ??
                                  0,
                              child: VideoPlayer(controller.playerController!)),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                const SizedBox(height: 50),
                                const Spacer(),
                                DeleteIcon(onTap: controller.removeVideo)
                              ],
                            ),
                            const Spacer(),
                            if (controller.playerController?.value.isPlaying ??
                                false)
                              Container()
                            else
                              GestureDetector(
                                onTap: controller.play,
                                child: CircleAvatar(
                                  backgroundColor: cBlack.withOpacity(0.4),
                                  foregroundColor: cWhite,
                                  child: const Icon(
                                    Icons.play_arrow_rounded,
                                    size: 30,
                                  ),
                                ),
                              ),
                            const Spacer(),
                            VideoSlider(
                                controller: controller.playerController!,
                                onChange: controller.onChange),
                          ],
                        )
                      ],
                    ),
                  );
                }),
          )
        : Container();
  }
}

class PreviewPostImagesPageView extends StatelessWidget {
  final AddPostController controller;

  const PreviewPostImagesPageView({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        id: "pageView",
        builder: (controller) {
          var contentCount = controller.imageFileList.length;
          return SizedBox(
            height:
                controller.imageFileList.length == 1 ? null : Get.width - 40,
            width: double.infinity,
            child: ClipSmoothRect(
              radius: const SmoothBorderRadius.all(SmoothRadius(
                  cornerRadius: 12, cornerSmoothing: cornerSmoothing)),
              child: Stack(
                children: [
                  if (controller.imageFileList.length == 1)
                    Image.file(File(controller.imageFileList[0].path),
                        width: double.infinity, fit: BoxFit.fitWidth)
                  else
                    PageView.builder(
                      onPageChanged: (value) => controller.onPageChange(value),
                      itemCount: controller.imageFileList.length,
                      itemBuilder: (context, index) {
                        var image = controller.imageFileList[index];
                        return Image.file(File(image.path), fit: BoxFit.cover);
                      },
                    ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          controller.imageFileList.length <
                                  ((SessionManager.shared
                                          .getSettings()
                                          ?.maxImagesCanBeUploadedInOnePost ??
                                      0))
                              ? DeleteIcon(
                                  onTap: () {
                                    controller.pick(PickerStyle.image);
                                  },
                                  iconData: Icons.add_rounded,
                                )
                              : Container(),
                          DeleteIcon(
                            onTap: () {
                              controller.removeImage();
                            },
                          )
                        ],
                      ),
                      contentCount == 1
                          ? SizedBox()
                          : Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(contentCount, (index) {
                                  return Container(
                                    margin: const EdgeInsets.only(right: 3),
                                    height: 2.7,
                                    width: contentCount > 8
                                        ? (Get.width - 120) / contentCount
                                        : 30,
                                    decoration: ShapeDecoration(
                                      color:
                                          controller.selectedImageIndex == index
                                              ? cWhite
                                              : cWhite.withOpacity(0.30),
                                      shape: const SmoothRectangleBorder(
                                          borderRadius: SmoothBorderRadius.all(
                                              SmoothRadius(
                                                  cornerRadius: 10,
                                                  cornerSmoothing:
                                                      cornerSmoothing))),
                                    ),
                                  );
                                }),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class DeleteIcon extends StatelessWidget {
  final Function() onTap;
  final IconData iconData;

  const DeleteIcon(
      {Key? key, required this.onTap, this.iconData = Icons.delete_rounded})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = cWhite;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8, top: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: color.withOpacity(0.4), shape: BoxShape.circle),
        child: Icon(iconData, color: color, size: 25),
      ),
    );
  }
}
