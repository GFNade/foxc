import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/utilities/const.dart';

class BaseController extends GetxController {
  static var share = BaseController();
  bool isLoading = false;

  void startLoading() {
    loader();
    isLoading = true;
    update();
  }

  void stopLoading([List<Object>? ids, bool condition = true]) {
    if (isLoading) {
      Get.back();
      isLoading = false;
      update();
    }
  }

  loader({double? value}) {
    showDialog(
      context: Get.context!,
      // barrierDismissible: true,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: cPrimary,
          ),
        );
      },
    );
  }

  void showSnackBar(String title,
      {SnackBarType type = SnackBarType.info, String? message}) {
    if (Get.isSnackbarOpen) {
      return;
    }
    var color = type == SnackBarType.success
        ? cGreen
        : (type == SnackBarType.error ? cRed : cBlack);
    IconData icon = type == SnackBarType.success
        ? Icons.check_circle_rounded
        : (type == SnackBarType.error
            ? Icons.cancel_rounded
            : Icons.info_rounded);
    Get.rawSnackbar(
      messageText: Text(
        title,
        style: MyTextStyle.gilroyBold(color: color),
      ),
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 10,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      icon: Icon(
        icon,
        color: color,
        size: 24,
      ),
      backgroundColor: cWhite,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    );
  }
}

enum SnackBarType { info, error, success }
