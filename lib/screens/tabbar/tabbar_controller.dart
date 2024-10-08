import 'package:untitled/common/controller/base_controller.dart';

class TabBarController extends BaseController {
  int selectedTab = 0;

  void selectIndex(int index) {
    selectedTab = index;
    update();
  }
}
