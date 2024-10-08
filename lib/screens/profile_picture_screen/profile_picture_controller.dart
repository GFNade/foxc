import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/common/api_service/user_service.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/screens/tabbar/tabbar_screen.dart';
import 'package:untitled/screens/username_screen/username_controller.dart';
import 'package:untitled/utilities/const.dart';

class ProfilePictureController extends UsernameController {
  final ImagePicker picker = ImagePicker();
  String imagePath = "";
  XFile? file;

  void pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      XFile? image = await picker.pickImage(
          source: source,
          maxHeight: Limits.imageSize,
          maxWidth: Limits.imageSize,
          imageQuality: Limits.quality);
      if (image != null) {
        file = image;
        imagePath = image.path;
        update();
      }
    } catch (e) {
      showSnackBar("Invalid Image");
    }
  }

  void uploadImage() {
    if (file == null) {
      showSnackBar(LKeys.pleaseSelectImage.tr);
      return;
    }
    UserService.shared.editProfile(
      profileImage: file,
      completion: (p0) {
        Get.offAll(() => TabBarScreen());
      },
    );
  }
}
