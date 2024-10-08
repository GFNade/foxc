import 'package:get/get.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/localization/allLanguages.dart';
import 'package:untitled/screens/splash_screen/splash_controller.dart';

class LanguagesController extends BaseController {
  List<Lang> languages = LANGUAGES;
  Lang selectedLan = SessionManager.shared.getLang();

  void setLang(Lang lang) {
    selectedLan = lang;
    // update();

    Future.delayed(
      Duration(milliseconds: 200),
      () {
        SessionManager.shared.setLang(lang);
        Get.updateLocale(lang.language.local);
        Get.offAll(() => Get.find<SplashController>().gotoView());
      },
    );
  }
}
