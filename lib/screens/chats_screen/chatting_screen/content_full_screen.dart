import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:untitled/models/chat.dart';
import 'package:untitled/screens/post/video_player_sheet.dart';
import 'package:untitled/utilities/const.dart';
import 'package:untitled/utilities/firebase_const.dart';
import 'package:video_player/video_player.dart';

class ContentFullScreen extends StatefulWidget {
  final ChatMessage message;
  final VideoPlayerController? playerController;

  const ContentFullScreen({super.key, required this.message, this.playerController});

  @override
  State<ContentFullScreen> createState() => _ContentFullScreenState();
}

class _ContentFullScreenState extends State<ContentFullScreen> {
  VideoPlayerController? controller;

  @override
  void initState() {
    var msgType = widget.message.msgType == 'TEXT'
        ? MessageType.text
        : (widget.message.msgType == 'IMAGE' ? MessageType.image : MessageType.video);
    if (msgType == MessageType.video) {
      if (widget.playerController == null) {
        controller = VideoPlayerController.networkUrl(Uri.parse(widget.message.content?.addBaseURL() ?? ''))
          ..initialize().then((value) {
            controller?.play();
            setState(() {});
          });
      } else {
        controller = widget.playerController;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var msgType = widget.message.msgType == 'TEXT'
        ? MessageType.text
        : (widget.message.msgType == 'IMAGE' ? MessageType.image : MessageType.video);
    return Container(
      color: cBlack,
      child: SafeArea(
        top: true,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Center(
              child: msgType == MessageType.video && controller != null
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (controller!.value.isPlaying) {
                              controller?.pause();
                            } else {
                              controller?.play();
                            }
                          },
                          child: controller != null
                              ? AspectRatio(aspectRatio: controller!.value.aspectRatio, child: VideoPlayer(controller!))
                              : null,
                        ),
                        ValueListenableBuilder(
                          valueListenable: controller!,
                          builder: (context, VideoPlayerValue value, child) {
                            return Column(
                              children: [
                                const SizedBox(height: 50),
                                const Spacer(),
                                value.isPlaying == true
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () {
                                          if (value.isPlaying) {
                                            controller?.pause();
                                          } else {
                                            controller?.play();
                                          }
                                        },
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
                                VideoSlider(controller: controller, onChange: onChange),
                              ],
                            );
                          },
                        )
                      ],
                    )
                  : PhotoView(
                      disableGestures: false,
                      minScale: PhotoViewComputedScale.contained * 1,
                      maxScale: PhotoViewComputedScale.covered * 2,
                      backgroundDecoration: const BoxDecoration(color: cBlack),
                      imageProvider: NetworkImage(widget.message.content?.addBaseURL() ?? ''),
                    ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: CircleAvatar(
                      backgroundColor: cLightBg.withOpacity(0.1),
                      child: const Icon(
                        Icons.close_rounded,
                        color: cLightText,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onChange(double value) {
    controller?.seekTo(Duration(milliseconds: value.toInt()));
  }

  @override
  void dispose() {
    if (widget.playerController == null) {
      controller?.dispose();
    }
    super.dispose();
  }
}
