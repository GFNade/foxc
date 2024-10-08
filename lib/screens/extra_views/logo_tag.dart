import 'package:flutter/material.dart';
import 'package:untitled/common/extensions/image_extension.dart';

class LogoTag extends StatelessWidget {
  final bool? isWhite;
  final double? width;

  const LogoTag({Key? key, this.isWhite = false, this.width = 100})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
        MyImages.logoFoxc,
        height: (width ?? 100) * 0.1975683891,
        width: width);
  }
}
