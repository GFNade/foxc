import 'dart:io';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:untitled/common/api_service/post_service.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/screens/chats_screen/chatting_screen/chatting_controller.dart';
import 'package:untitled/screens/extra_views/back_button.dart';
import 'package:untitled/screens/extra_views/buttons.dart';
import 'package:untitled/screens/extra_views/top_bar.dart';
import 'package:untitled/utilities/const.dart';
import 'package:untitled/utilities/firebase_const.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ImageVideoChatPicker extends StatelessWidget {
  final ChattingController controller;

  final ImageSource imageSource;

  const ImageVideoChatPicker(
      {super.key, required this.controller, required this.imageSource});

  @override
  Widget build(BuildContext context) {
    final imagePicker = ImagePicker();
    return Wrap(
      children: [
        Container(
          decoration: const ShapeDecoration(
            color: cBlack,
            shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.only(
                    topLeft: SmoothRadius(
                        cornerRadius: 30, cornerSmoothing: cornerSmoothing),
                    topRight: SmoothRadius(
                        cornerRadius: 30, cornerSmoothing: cornerSmoothing))),
          ),
          padding: const EdgeInsets.all(25),
          child: SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Spacer(),
                    XMarkButton(),
                  ],
                ),
                Text(
                  LKeys.howDoYouWant.tr,
                  style: MyTextStyle.gilroyBold(size: 22, color: cWhite),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    btn(
                        title: LKeys.image,
                        onTap: () async {
                          XFile? file =
                              await imagePicker.pickImage(source: imageSource);
                          print(file?.path);
                          if (file != null) {
                            Get.back();
                            Get.bottomSheet(
                                WriteDescriptionSheet(
                                  file: file,
                                  controller: controller,
                                  type: MessageType.image,
                                ),
                                isScrollControlled: true,
                                ignoreSafeArea: false);
                          }
                        }),
                    const SizedBox(
                      width: 10,
                    ),
                    btn(
                      title: LKeys.video,
                      onTap: () async {
                        XFile? file =
                            await imagePicker.pickVideo(source: imageSource);
                        print(file?.path);
                        if (file != null) {
                          Get.back();
                          Get.bottomSheet(
                              WriteDescriptionSheet(
                                file: file,
                                controller: controller,
                                type: MessageType.video,
                              ),
                              isScrollControlled: true,
                              ignoreSafeArea: false);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget btn({required String title, required Function() onTap}) {
    return Expanded(
      child: CommonSheetButton(
        title: title.tr,
        onTap: onTap,
      ),
    );
  }
}

class WriteDescriptionSheet extends StatefulWidget {
  final XFile file;
  final ChattingController controller;
  final MessageType type;

  const WriteDescriptionSheet(
      {super.key,
      required this.file,
      required this.controller,
      required this.type});

  @override
  State<WriteDescriptionSheet> createState() => _WriteDescriptionSheetState();
}

class _WriteDescriptionSheetState extends State<WriteDescriptionSheet> {
  XFile? thumbnail;

  setImage() async {
    if (widget.type == MessageType.video) {
      VideoThumbnail.thumbnailFile(
        video: widget.file.path,
        thumbnailPath: (await getTemporaryDirectory()).path,
        quality: 75,
      ).then((thumb) {
        thumbnail = XFile(thumb ?? '');
        setState(() {});
      });
    } else {
      thumbnail = widget.file;
      setState(() {});
    }
  }

  @override
  void initState() {
    setImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cWhite,
      child: Column(
        children: [
          TopBarForInView(
            title: '',
            backIcon: Icons.close_rounded,
            child: GestureDetector(
              onTap: () {
                if (widget.type == MessageType.image) {
                  widget.controller.startLoading();
                  PostService.shared.uploadFile(widget.file, (url) {
                    widget.controller.stopLoading();
                    Get.back();
                    widget.controller
                        .commonSend(type: MessageType.image, content: url);
                  });
                } else {
                  widget.controller.startLoading();
                  PostService.shared.uploadFile(widget.file, (videoURL) {
                    if (thumbnail != null) {
                      PostService.shared.uploadFile(thumbnail!, (thumbnail) {
                        widget.controller.stopLoading();
                        Get.back();
                        widget.controller.commonSend(
                            type: MessageType.video,
                            content: videoURL,
                            thumbnail: thumbnail);
                      });
                    }
                  });
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.only(
                    right: 20, left: 20, top: 7, bottom: 5),
                decoration: BoxDecoration(
                    color: cPrimary, borderRadius: BorderRadius.circular(100)),
                child: Text(
                  LKeys.send.tr.toUpperCase(),
                  style: MyTextStyle.gilroySemiBold(color: cBlack, size: 14),
                ),
              ),
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
                      decoration: const ShapeDecoration(
                        shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius.all(SmoothRadius(
                                cornerRadius: 8,
                                cornerSmoothing: cornerSmoothing))),
                        color: cLightBg,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 12),
                      child: TextField(
                        controller: widget.controller.messageTextController,
                        textCapitalization: TextCapitalization.sentences,
                        expands: true,
                        minLines: null,
                        maxLines: null,
                        style: MyTextStyle.gilroyRegular(
                            color: cDarkText.withOpacity(0.6)),
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
                        // controller: controller.textEditingController,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    const SizedBox(height: 15),
                    (thumbnail?.path ?? '') == ''
                        ? Container()
                        : ClipSmoothRect(
                            radius: const SmoothBorderRadius.all(SmoothRadius(
                                cornerRadius: 12,
                                cornerSmoothing: cornerSmoothing)),
                            child: Image.file(
                              File(thumbnail?.path ?? ''),
                              fit: BoxFit.cover,
                              height: Get.width - 20,
                              width: Get.width - 20,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
