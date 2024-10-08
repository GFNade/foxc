import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/extensions/image_extension.dart';
import 'package:untitled/utilities/const.dart';

class MyCachedImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;

  const MyCachedImage({super.key, this.imageUrl, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return imageUrl != null && imageUrl?.isNotEmpty == true
        ? CachedNetworkImage(
            cacheKey: imageUrl?.addBaseURL() ?? '',
            imageUrl: imageUrl?.addBaseURL() ?? '',
            width: width,
            height: height,
            fit: BoxFit.cover,
            fadeInDuration: Duration.zero,
            fadeOutDuration: Duration.zero,
            errorWidget: (context, url, error) {
              return placeHolder();
            },
            placeholder: (context, url) {
              return placeHolder();
            },
          )
        : placeHolder();
  }

  Widget placeHolder() {
    return Image.asset(MyImages.placeHolderImage, width: width, height: height, fit: BoxFit.cover);
  }
}

class MyCachedProfileImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final String? fullName;

  const MyCachedProfileImage({super.key, this.imageUrl, this.width, this.height, this.fullName});

  @override
  Widget build(BuildContext context) {
    return imageUrl != null && imageUrl?.isNotEmpty == true
        ? CachedNetworkImage(
            imageUrl: imageUrl?.addBaseURL() ?? '',
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) {
              return placeHolder();
            },
          )
        : placeHolder();
  }

  Widget placeHolder() {
    return Container(
      color: cDarkBG,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 2),
      child: Text(
        (fullName ?? "No")[0].toUpperCase(),
        style: MyTextStyle.gilroyBold(color: cPrimary, size: 30),
      ),
    );
  }
}
