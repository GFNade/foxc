import 'package:flutter/material.dart';
import 'package:untitled/common/controller/base_controller.dart';

class CupertinoController extends BaseController {
  PageController controller = PageController();
  int selectedPage = 0;

  void onChangeSegment(int value) {
    selectedPage = value;
    controller.animateToPage(value,
        curve: Curves.ease, duration: const Duration(milliseconds: 400));
  }

  void onChangePage(int value) {
    selectedPage = value;
    update();
  }
}
