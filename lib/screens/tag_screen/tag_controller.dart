import 'package:untitled/common/api_service/post_service.dart';
import 'package:untitled/screens/feed_screen/feed_screen_controller.dart';

class TagController extends FeedScreenController {
  String tag;

  TagController(this.tag);

  @override
  void onReady() {
    fetchPosts();
    super.onReady();
  }

  void fetchPosts() {
    if (posts.isEmpty) {
      startLoading();
    }
    PostService.shared.fetchPostsByHashtag(tag, posts.length, (p0) {
      stopLoading();
      posts = p0;
      update();
    });
  }
}
