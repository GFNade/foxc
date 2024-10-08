import 'package:get/get.dart';
import 'package:untitled/common/api_service/post_service.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/screens/feed_screen/feed_screen_controller.dart';

class SinglePostController extends FeedScreenController {
  int postId;

  SinglePostController(this.postId);

  @override
  void onReady() {
    fetchPost();
    super.onReady();
  }

  void fetchPost() {
    startLoading();
    PostService.shared.fetchPost(postId, (post) {
      stopLoading();
      if (post == null) {
        showSnackBar(LKeys.someThingWentWrong.tr, type: SnackBarType.error);
        return;
      }
      posts.add(post);
      update();
    });
  }
}
