import 'package:flutter/material.dart';
import 'package:untitled/screens/extra_views/logo_tag.dart';
import 'package:untitled/utilities/const.dart';

class RoomScreenTopBar extends StatelessWidget {
  const RoomScreenTopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cBG,
      width: double.infinity,
      // padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
      padding: const EdgeInsets.only(top: 13, right: 20, left: 20, bottom: 23),
      child: const SafeArea(
        bottom: false,
        child: LogoTag(),
      ),
    );
  }
}
