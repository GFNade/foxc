import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/common/api_service/post_service.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/models/comments_model.dart';
import 'package:untitled/models/feeds_model.dart';
import 'package:untitled/screens/post/post_controller.dart';

class CommentController extends BaseController {
  final Feed post;
  final PostController postController;
  List<Comment> comments = [];
  TextEditingController textEditingController = TextEditingController();
  RefreshController refreshController = RefreshController();

  CommentController(this.post, this.postController);

  @override
  void onReady() {
    fetchComments();
    super.onReady();
  }

  void fetchComments() {
    if (comments.isEmpty) {
      startLoading();
    }
    PostService.shared.fetchComments(post.id ?? 0, comments.length, (comments) {
      stopLoading();
      if (comments.isEmpty) {
        refreshController.loadNoData();
      }
      this.comments.addAll(comments);
      update();
    });
  }

  void addComment() {
    if (textEditingController.text.isEmpty) {
      return;
    }
    startLoading();
    PostService.shared.addComment(textEditingController.text, post.id ?? 0, (comment) {
      stopLoading();
      comment.user = SessionManager.shared.getUser();
      comments.insert(0, comment);
      textEditingController.clear();
      postController.post.commentsCount += 1;
      print(postController.post.commentsCount);
      postController.update(['comment']);
      update();
    });
  }

  void deleteComment(Comment comment) {
    startLoading();
    PostService.shared.deleteComment(comment.id ?? 0, () {
      stopLoading();
      comments.removeWhere((element) => element.id == comment.id);
      postController.post.commentsCount -= 1;
      postController.update(['comment']);
      update();
    });
  }
}
