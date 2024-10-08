import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/duration_extension.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/extensions/int_extension.dart';
import 'package:untitled/models/chat.dart';
import 'package:untitled/screens/post/post_card.dart';
import 'package:untitled/screens/post/post_controller.dart';
import 'package:untitled/utilities/const.dart';
import 'package:video_player/video_player.dart';

import '../chats_screen/chatting_screen/content_full_screen.dart';

class VideoPlayerSheet extends StatelessWidget {
  final PostController controller;

  const VideoPlayerSheet({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const ShapeDecoration(
          color: cBlack,
          shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.only(
                  topLeft: SmoothRadius(cornerRadius: 20, cornerSmoothing: cornerSmoothing),
                  topRight: SmoothRadius(cornerRadius: 20, cornerSmoothing: cornerSmoothing)))),
      margin: EdgeInsets.only(top: Get.statusBarHeight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 0, right: 20, left: 20),
            child: PostTopBar(
              controller: controller,
              isForVideo: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: PostDescriptionView(controller: controller, isForVideo: true),
          ),
          GetBuilder<PostController>(
              init: controller,
              id: 'player',
              tag: controller.post.likesCount.makeToString(),
              builder: (controller) {
                return controller.playerController != null
                    ? Container(
                        width: Get.width,
                        height: Get.width,
                        color: cWhite.withOpacity(0.1),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            GestureDetector(
                              onTap: controller.playPause,
                              child: controller.playerController != null
                                  ? AspectRatio(
                                      aspectRatio: controller.playerController!.value.aspectRatio,
                                      child: VideoPlayer(controller.playerController!))
                                  : CircularProgressIndicator(),
                            ),
                            controller.playerController != null && controller.playerController!.value.isInitialized
                                ? ValueListenableBuilder(
                                    valueListenable: controller.playerController!,
                                    builder: (context, VideoPlayerValue value, child) => Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Spacer(),
                                            GestureDetector(
                                              onTap: () {
                                                Get.bottomSheet(
                                                    ContentFullScreen(
                                                      message: ChatMessage(
                                                          content: controller.post.content.first.content ?? '',
                                                          msgType: 'VIDEO'),
                                                      playerController: controller.playerController,
                                                    ),
                                                    ignoreSafeArea: false,
                                                    isScrollControlled: true);
                                              },
                                              child: Container(
                                                decoration: ShapeDecoration(
                                                  shape: const SmoothRectangleBorder(
                                                      borderRadius: SmoothBorderRadius.all(SmoothRadius(
                                                          cornerRadius: 5, cornerSmoothing: cornerSmoothing))),
                                                  color: cBlack.withOpacity(0.4),
                                                ),
                                                margin: const EdgeInsets.all(10),
                                                padding: const EdgeInsets.all(4),
                                                child: const Icon(Icons.fullscreen_rounded, color: cWhite),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        value.isPlaying == true
                                            ? Container()
                                            : GestureDetector(
                                                onTap: controller.playPause,
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
                                            controller: controller.playerController, onChange: controller.onChange),
                                      ],
                                    ),
                                  )
                                : SizedBox(height: Get.width)
                          ],
                        ),
                      )
                    : SizedBox();
              }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: PostBottomBar(controller: controller, isForVideo: true),
          )
        ],
      ),
    );
  }
}

class VideoSlider extends StatelessWidget {
  final VideoPlayerController? controller;
  final Function(double) onChange;

  const VideoSlider({Key? key, required this.controller, required this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: const SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius.all(SmoothRadius(cornerRadius: 5, cornerSmoothing: cornerSmoothing))),
        color: cBlack.withOpacity(0.4),
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(7),
      child: Row(
        children: [
          Text(
            controller?.value.position.toStringTime() ?? "",
            style: MyTextStyle.gilroyRegular(color: cWhite, size: 14),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: SliderTheme(
              data: const SliderThemeData().copyWith(trackHeight: 1, overlayShape: SliderComponentShape.noThumb),
              child: Slider(
                label: "",
                thumbColor: cPrimary,
                activeColor: cWhite,
                inactiveColor: cWhite.withOpacity(0.4),
                value: controller?.value.position.inMilliseconds.toDouble() ?? 0,
                max: controller?.value.duration.inMilliseconds.toDouble() ?? 0,
                onChanged: (value) {
                  onChange(value);
                },
              ),
            ),
          ),
          Text(
            controller?.value.duration.toStringTime() ?? "",
            style: MyTextStyle.gilroyRegular(color: cWhite, size: 14),
          ),
        ],
      ),
    );
  }
}
