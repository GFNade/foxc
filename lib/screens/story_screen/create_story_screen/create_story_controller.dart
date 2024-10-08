import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:untitled/common/api_service/story_service.dart';
import 'package:untitled/common/controller/base_controller.dart';

class CreateStoryController extends BaseController {
  var shouldAddStory = false;

  void createStory(
      {required String fileURL,
      required double duration,
      required bool isVideo}) {
    startLoading();
    StoryService.shared.createStory(
      fileURL,
      UrlTypeHelper.getType(fileURL) == UrlType.VIDEO ? 1 : 0,
      duration,
      () {
        stopLoading();
        Get.back();
        Get.back();
      },
    );
  }

  void createAnotherStory() {
    shouldAddStory = true;
    update();
  }
}

enum UrlType { IMAGE, VIDEO, UNKNOWN }

class UrlTypeHelper {
  static List<String> _image_types = [
    'jpg',
    'jpeg',
    'jfif',
    'pjpeg',
    'pjp',
    'png',
    'svg',
    'gif',
    'apng',
    'webp',
    'avif'
  ];

  static List<String> _video_types = [
    "bin",
    "3g2",
    "3gp",
    "aaf",
    "asf",
    "avchd",
    "avi",
    "drc",
    "flv",
    "m2v",
    "m3u8",
    "m4p",
    "m4v",
    "mkv",
    "mng",
    "mov",
    "mp2",
    "mp4",
    "mpe",
    "mpeg",
    "mpg",
    "mpv",
    "mxf",
    "nsv",
    "ogg",
    "ogv",
    "qt",
    "rm",
    "rmvb",
    "roq",
    "svi",
    "vob",
    "webm",
    "wmv",
    "yuv"
  ];

  static UrlType getType(url) {
    try {
      Uri uri = Uri.parse(url);
      String extension = p.extension(uri.path).toLowerCase();
      if (extension.isEmpty) {
        return UrlType.UNKNOWN;
      }

      extension = extension.split('.').last;
      if (_image_types.contains(extension)) {
        return UrlType.IMAGE;
      } else if (_video_types.contains(extension)) {
        return UrlType.VIDEO;
      }
    } catch (e) {
      return UrlType.UNKNOWN;
    }
    return UrlType.UNKNOWN;
  }
}
