import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:untitled/common/extensions/image_extension.dart';
import 'package:untitled/utilities/const.dart';

class Menu extends StatelessWidget {
  final bool isFromPost;
  final List<PopupMenuItem> items;
  final Color? color;
  final bool isForVideo;
  final Function(String)? onSelect;

  const Menu(
      {super.key,
      this.isForVideo = true,
      required this.items,
      this.color,
      this.onSelect,
      this.isFromPost = false});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) {
        if (onSelect != null) {
          onSelect!(value);
        }
      },
      elevation: 3,
      surfaceTintColor: Colors.white,
      shadowColor: cLightIcon.withOpacity(0.3),
      // padding: const EdgeInsets.all(20),
      shape: const SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.all(
              SmoothRadius(cornerRadius: 8, cornerSmoothing: cornerSmoothing))),
      itemBuilder: (context) => items,
      child: isFromPost
          ? Icon(
              Icons.more_horiz,
              color: color ?? (isForVideo ? cLightIcon : cLightText),
            )
          : Image.asset(
              MyImages.more,
              color: color ?? cWhite,
              height: 30,
              width: 30,
            ),
    );
  }
}
