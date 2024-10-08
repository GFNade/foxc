import 'dart:io';
import 'dart:math';

import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:untitled/common/api_service/post_service.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/utilities/const.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class AddPostController extends BaseController {
  final String postBtnGetID = "postButGetID";
  final String imageGetID = "imageGetID";
  DetectableTextEditingController textEditingController = DetectableTextEditingController(
      detectedStyle: MyTextStyle.gilroySemiBold(size: 18, color: cPrimary).copyWith(height: 1.2),
      regExp: detectionRegExp(atSign: false, url: false)!);
  final ImagePicker _picker = ImagePicker();
  PickerStyle type = PickerStyle.image;
  XFile? videoFile;
  List<XFile> imageFileList = [];
  int selectedImageIndex = 0;
  VideoPlayerController? playerController;

  @override
  void onReady() {
    textEditingController.addListener(() {
      update([postBtnGetID]);
    });
    super.onReady();
  }

  void pick(PickerStyle type) async {
    this.type = type;
    if (type == PickerStyle.image) {
      final List<XFile> selectedImages = await _picker.pickMultiImage(
          maxHeight: Limits.imageSize, maxWidth: Limits.imageSize, imageQuality: Limits.quality);
      var imageCount = min(
          (SessionManager.shared.getSettings()?.maxImagesCanBeUploadedInOnePost ?? 0) - imageFileList.length,
          selectedImages.length);
      for (var i = 0; i < imageCount; i++) {
        imageFileList.add(selectedImages[i]);
      }
    } else {
      XFile? file = await _picker.pickVideo(source: ImageSource.gallery);
      if (file != null) {
        videoFile = file;
        playerController = VideoPlayerController.file(File(videoFile!.path));
        await playerController?.initialize();
        var limit = (SessionManager.shared.getSettings()?.minuteLimitInChoosingVideoForPost ?? 0);
        if ((playerController?.value.duration.inSeconds ?? 0) > limit * 60) {
          playerController?.dispose();
          playerController = null;
          videoFile = null;
          showSnackBar('${LKeys.weAreOnlyAllow.tr} $limit ${LKeys.minute.tr}', type: SnackBarType.error);
        } else {
          playerController?.addListener(() {
            update(['player']);
          });
        }
      }
    }
    update([imageGetID, postBtnGetID]);
  }

  void uploadPost() async {
    startLoading();
    playerController?.pause();
    var thumbnailPath = "";
    if (videoFile != null) {
      thumbnailPath = await VideoThumbnail.thumbnailFile(
            video: videoFile!.path,
            thumbnailPath: (await getTemporaryDirectory()).path,
            imageFormat: ImageFormat.JPEG,
            maxHeight: Limits.imageSize.toInt(),
            maxWidth: Limits.imageSize.toInt(),
            // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
            quality: Limits.quality,
          ) ??
          '';
    }
    List<String> tags = [];
    textEditingController.text.split(' ').forEach((element) {
      if (element.startsWith('#')) {
        tags.add(replaceCharAt(element, 0, '').removeAllWhitespace);
      }
    });
    PostService.shared.uploadPost(
      contentType: imageFileList.isNotEmpty ? 0 : (videoFile != null ? 1 : 2),
      tags: tags.join(','),
      images: imageFileList,
      video: videoFile,
      thumbnailPath: thumbnailPath,
      desc: textEditingController.text,
      onProgress: (bytes, totalBytes) {},
      completion: (post) {
        post.user = SessionManager.shared.getUser();
        stopLoading();
        Get.back(result: post);
        showSnackBar(LKeys.postAddedSuccessfully.tr, type: SnackBarType.success);
      },
    );
  }

  String replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) + newChar + oldString.substring(index + 1);
  }

  void play() {
    playerController?.play();
  }

  void pause() {
    playerController?.pause();
  }

  void playPause() {
    if (playerController?.value.isPlaying ?? false) {
      pause();
    } else {
      play();
    }
  }

  void onPageChange(int value) {
    selectedImageIndex = value;
    update(['pageView']);
  }

  void onChange(double value) {
    playerController?.seekTo(Duration(milliseconds: value.toInt()));
  }

  void removeVideo() {
    playerController?.pause();
    playerController?.dispose();
    videoFile = null;
    update([imageGetID, postBtnGetID]);
  }

  void removeImage() {
    imageFileList.removeAt(selectedImageIndex);
    selectedImageIndex = max(
        imageFileList.length == 1
            ? 0
            : (selectedImageIndex == imageFileList.length ? selectedImageIndex - 1 : selectedImageIndex),
        0);
    update([imageGetID, postBtnGetID, "pageView"]);
  }
}

enum PickerStyle { video, image }
