import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/library/camera_filters/src/tapioca/content.dart';
import 'package:untitled/library/camera_filters/src/tapioca/cup.dart';
import 'package:untitled/library/camera_filters/src/tapioca/tapioca_ball.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/screens/post/video_player_sheet.dart';
import 'package:untitled/screens/story_screen/create_story_screen/create_story_controller.dart';
import 'package:untitled/utilities/const.dart';
import 'package:video_player/video_player.dart';

class ResultView extends StatefulWidget {
  final bool isVideo;
  final String fileURL;
  final Color color;
  final Function(String, double)? onDone;
  final CreateStoryController controller = CreateStoryController();

  ResultView({super.key, required this.isVideo, required this.fileURL, this.onDone, required this.color});

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  final GlobalKey _globalKey = GlobalKey();
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    if (widget.isVideo) {
      _videoPlayerController = VideoPlayerController.file(File(widget.fileURL));

      _videoPlayerController?.addListener(() {
        setState(() {});
      });
      _videoPlayerController?.initialize().then((_) {
        setState(() {});
      });
      _videoPlayerController?.play();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: cBlack,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            Center(
              child: widget.isVideo
                  ? ColorFiltered(
                      colorFilter: ColorFilter.mode(widget.color, BlendMode.softLight),
                      child: GestureDetector(onTap: playPause, child: videoPlayer()))
                  : RepaintBoundary(
                      key: _globalKey,
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(widget.color, BlendMode.softLight),
                        child: Image.file(File(widget.fileURL)),
                      ),
                    ),
            ),
            SafeArea(
              child: !widget.isVideo
                  ? Container()
                  : Column(
                      children: [
                        const SizedBox(height: 90),
                        const Spacer(),
                        _videoPlayerController?.value.isPlaying == true
                            ? Container()
                            : GestureDetector(
                                onTap: playPause,
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
                        VideoSlider(controller: _videoPlayerController, onChange: onChange),
                        const SizedBox(height: 40),
                      ],
                    ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    button(
                      LKeys.retake,
                      Get.back,
                    ),
                    const Spacer(),
                    button(
                      LKeys.send,
                      () async {
                        if (widget.color == Colors.transparent) {
                          widget.onDone
                              ?.call(widget.fileURL, _videoPlayerController?.value.duration.inSeconds.toDouble() ?? 0);
                        } else {
                          if (widget.isVideo) {
                            List<TapiocaBall> tapiocaBalls = [
                              TapiocaBall.filterFromColor(Color(widget.color.withOpacity(0.1).value))
                            ];
                            var tempDir = await getTemporaryDirectory();
                            final path = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}result.mp4';
                            makeVideo(widget.controller, tapiocaBalls, path);
                          } else {
                            convertImage(widget.controller);
                          }
                        }
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget button(String title, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.only(right: 20, left: 20, top: 7, bottom: 5),
        decoration: BoxDecoration(
            color: cWhite, borderRadius: BorderRadius.circular(100), boxShadow: [BoxShadow(color: cLightBg)]),
        child: Text(
          title.tr,
          style: MyTextStyle.gilroySemiBold(color: cBlack, size: 14),
        ),
      ),
    );
  }

  Widget videoPlayer() {
    if (_videoPlayerController != null) {
      return AspectRatio(
          aspectRatio: _videoPlayerController?.value.aspectRatio ?? 0, child: VideoPlayer(_videoPlayerController!));
    } else {
      return const Center(
        child: CircularProgressIndicator(
          color: cPrimary,
        ),
      );
    }
  }

  convertImage(CreateStoryController controller) async {
    controller.startLoading();
    RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    //create file
    String dir = (await getApplicationDocumentsDirectory()).path;
    String fullPath = '$dir/${DateTime.now().millisecond}.png';
    var capturedFile = File(fullPath);
    await capturedFile.writeAsBytes(pngBytes);
    controller.stopLoading();
    controller.update();
    widget.onDone?.call(capturedFile.path, 0);
    // print("path is ${capturedFile.path}");
  }

  makeVideo(CreateStoryController controller, tapiocaBalls, path) {
    controller.startLoading();
    final cup = Cup(Content(widget.fileURL), tapiocaBalls);
    cup.suckUp(path).then((_) async {
      print("finished");
      controller.stopLoading();
      widget.onDone?.call(path, _videoPlayerController?.value.duration.inSeconds.toDouble() ?? 0);
      setState(() {});
    });
  }

  void play() {
    _videoPlayerController?.addListener(() {
      setState(() {});
    });
    _videoPlayerController?.play();
  }

  void playPause() {
    if (_videoPlayerController?.value.isPlaying == true) {
      _videoPlayerController?.pause();
    } else {
      _videoPlayerController?.play();
    }
    setState(() {});
  }

  void onChange(double value) {
    _videoPlayerController?.seekTo(Duration(milliseconds: value.toInt()));
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }
}
