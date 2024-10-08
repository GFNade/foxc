import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:untitled/common/api_service/post_service.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/common/extensions/image_extension.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/feeds_model.dart';
import 'package:untitled/screens/post/video_player_sheet.dart';
import 'package:untitled/screens/report_screen/report_sheet.dart';
import 'package:untitled/screens/sheets/confirmation_sheet.dart';
import 'package:untitled/utilities/const.dart';
import 'package:untitled/utilities/params.dart';
import 'package:video_player/video_player.dart';

class PostController extends BaseController {
  int selectedImageIndex = 0;
  bool isMyPost = false;
  Feed post;
  Function(int postID) onDeletePost;
  VideoPlayerController? playerController;

  PostController(this.post, this.onDeletePost);

  void initPlayer() {
    playerController = VideoPlayerController.networkUrl(Uri.parse(post.content.first.content?.addBaseURL() ?? ''))
      ..initialize().then((value) {
        play();
        update(['player']);
      });
    update();
  }

  void openVideoSheet() {
    if (post.content.first.contentType == 1) {
      Get.bottomSheet(VideoPlayerSheet(controller: this), isScrollControlled: true).then((value) {
        playerController?.seekTo(Duration(seconds: 0));
        playerController?.pause();
      });
      Future.delayed(
        Duration(milliseconds: 300),
        () {
          if (!(playerController?.value.isInitialized ?? false))
            initPlayer();
          else
            play();
        },
      );
    }
  }

  void play() {
    playerController?.play();
  }

  void playPause() {
    if (playerController?.value.isPlaying == true) {
      playerController?.pause();
    } else {
      playerController?.play();
    }
  }

  void onChange(double value) {
    playerController?.seekTo(Duration(milliseconds: value.toInt()));
  }

  void onPageChange(int value) {
    selectedImageIndex = value;
    update(["pageView"]);
  }

  void toggleFav() {
    print(post.isLike);
    if (post.isLike == 1) {
      post.likesCount = (post.likesCount) - 1;
      post.isLike = 0;
      update();
      dislikePost();
    } else {
      post.likesCount = (post.likesCount) + 1;
      post.isLike = 1;
      update();
      likePost();
    }

    // update(["fav"]);
  }

  void likeFromDoubleTap() {
    print(post.id);
    post.likesCount = (post.likesCount) + 1;
    post.isLike = 1;
    update();
    // PostService.shared.likePost(post.id ?? 0, () {});
    likePost();
  }

  void likePost() {
    PostService.shared.likePost(post.id ?? 0, () {});
  }

  void dislikePost() {
    PostService.shared.dislikePost(post.id ?? 0, () {});
  }

  void deleteOrReport() {
    if (post.userId == SessionManager.shared.getUserID()) {
      deletePost();
    } else {
      reportPost();
    }
  }

  void sharePost() {
    BranchUniversalObject buo = BranchUniversalObject(
        canonicalIdentifier: 'flutter/branch',
        title: post.desc ?? '',
        imageUrl: post.content.isEmpty
            ? ''
            : (post.content.first.thumbnail != null
                ? post.content.first.thumbnail?.addBaseURL() ?? ''
                : post.content.first.content?.addBaseURL() ?? ''),
        // contentDescription: userData?.about ?? '',
        publiclyIndex: true,
        locallyIndex: true);
    BranchLinkProperties lp = BranchLinkProperties();
    lp.addControlParam(Param.postId, '${post.id}');
    if (GetPlatform.isIOS) {
      if (buo.imageUrl != '') {
        FlutterBranchSdk.showShareSheet(buo: buo, linkProperties: lp, messageText: '');
      } else {
        rootBundle.load(MyImages.appIcon).then((data) {
          FlutterBranchSdk.shareWithLPLinkMetadata(
              buo: buo, linkProperties: lp, icon: data.buffer.asUint8List(), title: post.desc ?? '');
        });
      }
    } else {
      FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp).then((value) {
        Share.share(value.result ?? '', subject: post.desc ?? '');
      });
    }
  }

  void reportPost() {
    Future.delayed(const Duration(milliseconds: 1), () {
      Get.bottomSheet(
          ReportSheet(
            post: post,
          ),
          isScrollControlled: true,
          ignoreSafeArea: false);
    });
  }

  void deletePost() {
    Future.delayed(const Duration(milliseconds: 1), () {
      Get.bottomSheet(ConfirmationSheet(
        desc: LKeys.deletePostDesc.tr,
        buttonTitle: LKeys.delete.tr,
        onTap: () {
          startLoading();
          PostService.shared.deletePost(
            post.id ?? 0,
            () {
              stopLoading();
              onDeletePost(post.id ?? 0);
            },
          );
        },
      ));
    });
  }
}
