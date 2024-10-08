import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/widgets/functions.dart';
import 'package:untitled/screens/sheets/web_sheet_view/web_sheet_view.dart';

class Navigate {
  static Future<T?>? to<T>(Widget widget) {
    // return Get.to(widget);
    return Navigator.push(
        Get.context!,
        MaterialPageRoute(
          builder: (context) => widget,
        ));
  }

  static void openURLSheet({required String title, required String url}) {
    Get.bottomSheet(
      WebSheetScreen(title: title, url: url),
      isScrollControlled: true,
      ignoreSafeArea: false,
    ).then((value) {
      Functions.changStatusBar(StatusBarStyle.black);
    });
  }
}