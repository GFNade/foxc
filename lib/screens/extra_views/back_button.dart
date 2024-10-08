import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/models/registration.dart';
import 'package:untitled/utilities/const.dart';

class BackButton extends StatelessWidget {
  const BackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: const Icon(
        Icons.chevron_left_rounded,
        color: cBlack,
      ),
    );
  }
}

class XMarkButton extends StatelessWidget {
  const XMarkButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: CircleAvatar(
        radius: 15,
        backgroundColor: cWhite.withOpacity(0.1),
        foregroundColor: cWhite.withOpacity(0.5),
        child: const Icon(Icons.close_rounded, size: 18),
      ),
    );
  }
}

class VerifyIcon extends StatelessWidget {
  const VerifyIcon({this.user, Key? key, this.isPlaceholder = false})
      : super(key: key);
  final User? user;
  final bool isPlaceholder;

  @override
  Widget build(BuildContext context) {
    if (isPlaceholder) {
      return icon();
    }
    if (user?.isVerified != 2 && user?.isVerified != 3) {
      return Row();
    } else {
      return Row(
        children: [const SizedBox(width: 5), icon()],
      );
    }
  }

  Widget icon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          color: cBlueTick,
          width: 12,
          height: 12,
        ),
        RotationTransition(
          turns: const AlwaysStoppedAnimation(45 / 360),
          child: Container(
            color: cBlueTick,
            width: 12,
            height: 12,
          ),
        ),
        Text(
          String.fromCharCode(CupertinoIcons.checkmark_alt.codePoint),
          style: TextStyle(
            inherit: false,
            color: cWhite,
            fontSize: 10.0,
            fontWeight: FontWeight.w700,
            fontFamily: CupertinoIcons.exclamationmark_circle.fontFamily,
            package: CupertinoIcons.exclamationmark_circle.fontPackage,
          ),
        )
      ],
    );
  }
}
