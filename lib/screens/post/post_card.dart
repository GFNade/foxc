import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:untitled/common/extensions/date_time_extension.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/extensions/image_extension.dart';
import 'package:untitled/common/extensions/int_extension.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/common/widgets/menu.dart';
import 'package:untitled/common/widgets/my_cached_image.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/feeds_model.dart';
import 'package:untitled/screens/extra_views/back_button.dart';
import 'package:untitled/screens/post/comment/comment_screen.dart';
import 'package:untitled/screens/post/post_controller.dart';
import 'package:untitled/screens/profile_screen/profile_screen.dart';
import 'package:untitled/screens/tag_screen/tag_screen.dart';
import 'package:untitled/utilities/const.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';

import '../tag_screen/tag_controller.dart';
import 'double_click_like.dart';

class PostCard extends StatelessWidget {
  final Feed post;
  final Function(int postID) onDeletePost;

  const PostCard({super.key, required this.post, required this.onDeletePost});

  @override
  Widget build(BuildContext context) {
    final PostController controller = PostController(post, onDeletePost);
    return GetBuilder(
        init: controller,
        tag: "${controller.post.id}",
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: PostTopBar(controller: controller),
              ),
              const SizedBox(
                height: 7,
              ),
              (controller.post.desc != "" && controller.post.desc != null)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: PostDescriptionView(controller: controller),
                    )
                  : const SizedBox(height: 5),
              if (controller.post.content.isNotEmpty == true)
                DoubleClickLikeAnimator(
                  child: (controller.post.content.first.contentType == 0)
                      ? PostImagesPageView(controller: controller)
                      : PostVideoElement(controller: controller),
                  onAnimation: () {
                    if (controller.post.isLike == 0) {
                      controller.likeFromDoubleTap();
                    }
                  },
                  onTap: () {
                    controller.openVideoSheet();
                  },
                )
              else
                const Column(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: PostBottomBar(controller: controller),
              ),
              const Divider(
                thickness: 0.2,
              ),
            ],
          );
        });
  }
}

class PostDescriptionView extends StatelessWidget {
  final PostController controller;
  final bool isForVideo;

  const PostDescriptionView({Key? key, required this.controller, this.isForVideo = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: isForVideo ? 12 : 6),
      child: DetectableText(
        maxLines: null,
        detectionRegExp: detectionRegExp(atSign: false, url: false)!,
        onTap: (p0) {
          Get.delete<TagController>().then((value) {
            Get.to(() => TagScreen(tag: p0), preventDuplicates: false);
          });
        },
        lessStyle: MyTextStyle.gilroyMedium(color: cPrimary),
        moreStyle: MyTextStyle.gilroyMedium(color: cPrimary),
        trimCollapsedText: LKeys.showMore.tr,
        trimExpandedText: '  ${LKeys.showLess.tr}',
        text: controller.post.desc ?? '',
        basicStyle: MyTextStyle.gilroyRegular(size: 16, color: isForVideo ? cLightIcon : cMainText),
        detectedStyle: MyTextStyle.gilroySemiBold(size: 16, color: cPrimary),
      ),
    );
  }
}

class PostBottomBar extends StatelessWidget {
  final PostController controller;
  final bool isForVideo;

  const PostBottomBar({Key? key, required this.controller, this.isForVideo = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 6),
      child: Row(
        children: [
          GetBuilder(
              init: controller,
              tag: "${controller.post.id}",
              id: 'comment',
              builder: (context) {
                return GestureDetector(
                  onTap: () {
                    Get.bottomSheet(CommentScreen(postController: controller),
                            isScrollControlled: true, ignoreSafeArea: false)
                        .then((value) {
                      controller.update(['comment']);
                    });
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        MyImages.comment,
                        width: 20,
                        height: 20,
                        color: isForVideo ? cWhite : cDarkText,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        (controller.post.commentsCount).makeToString(),
                        style: MyTextStyle.gilroyRegular(size: 14, color: isForVideo ? cWhite : cDarkText),
                      ),
                    ],
                  ),
                );
              }),
          const SizedBox(
            width: 15,
          ),
          GetBuilder(
              tag: "${controller.post.id}",
              init: controller,
              builder: (controller) {
                return LikeButton(
                  onTap: (isLiked) async {
                    controller.toggleFav();
                    return true;
                  },
                  countPostion: CountPostion.right,
                  likeCount: controller.post.likesCount,
                  size: 21,
                  isLiked: controller.post.isLike == 1,
                  likeCountPadding: const EdgeInsets.only(left: 4),
                  countBuilder: (likeCount, isLiked, text) {
                    return Text(
                      (likeCount ?? 0).makeToString(),
                      style: MyTextStyle.gilroyRegular(size: 14, color: isForVideo ? cWhite : cDarkText),
                    );
                  },
                  likeBuilder: (isLiked) {
                    return Image.asset(
                      controller.post.isLike == 1 ? MyImages.heartFill : MyImages.heart,
                      width: 21,
                      height: 21,
                      color: controller.post.isLike == 1
                          ? cRed
                          : isForVideo
                              ? cWhite
                              : cDarkText,
                    );
                  },
                );
              })
        ],
      ),
    );
  }
}

class PostTopBar extends StatelessWidget {
  final PostController controller;
  final bool isForVideo;

  const PostTopBar({Key? key, required this.controller, this.isForVideo = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
            () => ProfileScreen(
                  userId: controller.post.userId ?? 0,
                ),
            preventDuplicates: false);
      },
      child: Row(
        children: [
          ClipSmoothRect(
            radius: const SmoothBorderRadius.all(SmoothRadius(cornerRadius: 15, cornerSmoothing: cornerSmoothing)),
            child: MyCachedProfileImage(
              imageUrl: controller.post.user?.profile,
              width: 45,
              height: 45,
              fullName: controller.post.user?.fullName,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              controller.post.user?.fullName ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: MyTextStyle.gilroyBold(color: isForVideo ? cWhite : cBlack, size: 17),
                            ),
                          ),
                          VerifyIcon(user: controller.post.user),
                          const SizedBox(
                            width: 5,
                          )
                        ],
                      ),
                    ),

                    // const Spacer(),
                    Text(
                      controller.post.date.timeAgo(),
                      style: MyTextStyle.gilroyLight(size: 14, color: (isForVideo ? cLightIcon : cLightText)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    PostMenuButton(
                      controller: controller,
                      isForVideo: isForVideo,
                    ),
                    SizedBox(width: isForVideo ? 10 : 0),
                    isForVideo ? const XMarkButton() : Container()
                  ],
                ),
                Text(
                  "@${controller.post.user?.username ?? ""}",
                  style: MyTextStyle.gilroyLight(size: 16, color: isForVideo ? cWhite : cLightText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PostMenuButton extends StatelessWidget {
  final PostController controller;
  final bool isForVideo;

  const PostMenuButton({Key? key, required this.controller, required this.isForVideo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Menu(
      isFromPost: true,
      items: [
        PopupMenuItem(
          textStyle: MyTextStyle.gilroyRegular(),
          onTap: controller.deleteOrReport,
          child: Text(controller.post.userId == SessionManager.shared.getUserID() ? LKeys.delete.tr : LKeys.report.tr),
        ),
        PopupMenuItem(
          textStyle: MyTextStyle.gilroyRegular(),
          onTap: controller.sharePost,
          child: Text(LKeys.share.tr),
        ),
      ],
      isForVideo: isForVideo,
    );
  }
}

class PostImagesPageView extends StatelessWidget {
  final PostController controller;

  const PostImagesPageView({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (controller.post.content.isNotEmpty == true) {
      var height = controller.post.content.length == 1 ? null : Get.width;
      return GetBuilder<PostController>(
          init: controller,
          tag: "${controller.post.id}",
          id: "pageView",
          builder: (control) {
            var contentCount = controller.post.content.length;
            return contentCount == 1
                ? image(imageUrl: controller.post.content.first.content, height: height)
                : SizedBox(
                    height: Get.width,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        PageView.builder(
                          onPageChanged: (value) => control.onPageChange(value),
                          itemCount: controller.post.content.length,
                          itemBuilder: (context, index) {
                            return image(imageUrl: (controller.post.content[index].content ?? ''), height: height);
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(contentCount, (index) {
                              return contentCount > 1
                                  ? Container(
                                      margin: const EdgeInsets.only(right: 3),
                                      height: 2.7,
                                      width: contentCount > 8 ? (Get.width - 120) / contentCount : 30,
                                      decoration: ShapeDecoration(
                                        color: control.selectedImageIndex == index ? cWhite : cWhite.withOpacity(0.30),
                                        shape: const SmoothRectangleBorder(
                                            borderRadius: SmoothBorderRadius.all(
                                                SmoothRadius(cornerRadius: 10, cornerSmoothing: cornerSmoothing))),
                                      ),
                                    )
                                  : Container();
                            }),
                          ),
                        ),
                      ],
                    ),
                  );
          });
    } else {
      return Container();
    }
  }

  Widget image({String? imageUrl, double? height}) {
    return ZoomOverlay(
      modalBarrierColor: Colors.black.withOpacity(0.5),
      minScale: 1,
      maxScale: 3.0,
      animationCurve: Curves.fastOutSlowIn,
      animationDuration: const Duration(milliseconds: 300),
      twoTouchOnly: true,
      child: ClipRRect(
        child: Container(
          constraints: BoxConstraints(maxHeight: Get.height / 1.5),
          child: FadeInImage(
              placeholder: AssetImage(
                MyImages.placeHolderImage,
              ),
              image: NetworkImage(imageUrl?.addBaseURL() ?? ''),
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset(MyImages.placeHolderImage, height: Get.width);
              },
              width: Get.width,
              repeat: ImageRepeat.noRepeat,
              height: height,
              fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class PostVideoElement extends StatelessWidget {
  final PostController controller;

  const PostVideoElement({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (controller.post.content.isEmpty == true) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        controller.openVideoSheet();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: Get.width,
            width: double.infinity,
            child: MyCachedImage(
              imageUrl: (controller.post.content.first.thumbnail ?? ""),
            ),
          ),
          CircleAvatar(
            backgroundColor: cBlack.withOpacity(0.5),
            foregroundColor: cWhite,
            child: const Icon(
              Icons.play_arrow_rounded,
              size: 28,
            ),
          )
        ],
      ),
    );
  }
}
