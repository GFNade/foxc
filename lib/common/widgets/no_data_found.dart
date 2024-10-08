import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/utilities/const.dart';

class NoDataFound extends StatelessWidget {
  final String title;
  final BaseController controller;

  const NoDataFound({
    super.key,
    this.title = LKeys.noDataFound,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return !controller.isLoading
        ? Center(
            child: Text(
            title.tr,
            style: MyTextStyle.gilroySemiBold(color: cLightText),
          ))
        : Container();
  }
}
