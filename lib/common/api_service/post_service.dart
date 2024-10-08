import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/common/api_service/api_service.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/comment_model.dart';
import 'package:untitled/models/comments_model.dart';
import 'package:untitled/models/common_response.dart';
import 'package:untitled/models/feeds_model.dart';
import 'package:untitled/models/room_model.dart';
import 'package:untitled/models/single_feed_model.dart';
import 'package:untitled/models/upload_file.dart';
import 'package:untitled/utilities/const.dart';
import 'package:untitled/utilities/params.dart';
import 'package:untitled/utilities/web_service.dart';

class PostService {
  static var shared = PostService();

  void uploadFile(XFile file, Function(String) completion) {
    ApiService.shared.multiPartCallApi(
      url: WebService.uploadFile,
      filesMap: {
        'uploadFile': [file]
      },
      completion: (response) {
        String? fileURL = UploadFile.fromJson(response).data;
        if (fileURL != null) {
          completion(fileURL);
        }
      },
    );
  }

  void fetchPost(int postId, Function(Feed? post) completion) {
    var param = {
      Param.postId: postId,
      Param.myUserId: SessionManager.shared.getUserID()
    };
    ApiService.shared.call(
      url: WebService.fetchPostByPostId,
      param: param,
      completion: (response) {
        Feed? post = SingleFeedModel.fromJson(response).data;
        completion(post);
      },
    );
  }

  void fetchPostsByHashtag(
      String tag, int start, Function(List<Feed>) completion) {
    var param = {
      Param.userId: SessionManager.shared.getUserID(),
      Param.start: start,
      Param.tag: tag,
      Param.limit: Limits.pagination.toString()
    };
    ApiService.shared.call(
      param: param,
      url: WebService.fetchPostsByHashtag,
      completion: (data) {
        var obj = FeedsModel.fromJson(data).data;
        if (obj != null) {
          completion(obj);
        }
      },
    );
  }

  void deleteComment(num commentId, Function() completion) {
    var params = {
      Param.userId: SessionManager.shared.getUserID(),
      Param.commentId: commentId,
    };
    ApiService.shared.call(
      url: WebService.deleteComment,
      param: params,
      completion: (response) {
        var comment = CommonResponse.fromJson(response);
        if (comment.status == true) {
          completion();
        }
      },
    );
  }

  void addComment(
      String comment, num postId, Function(Comment comment) completion) {
    var params = {
      Param.userId: SessionManager.shared.getUserID(),
      Param.desc: comment,
      Param.postId: postId
    };
    ApiService.shared.call(
      url: WebService.addComment,
      param: params,
      completion: (response) {
        var comment = CommentModel.fromJson(response).data;
        if (comment != null) {
          completion(comment);
        }
      },
    );
  }

  void fetchComments(
      num postId, int start, Function(List<Comment> comments) completion) {
    var params = {
      Param.start: start,
      Param.postId: postId,
      Param.limit: Limits.pagination
    };
    ApiService.shared.call(
      url: WebService.fetchComments,
      param: params,
      completion: (response) {
        var comments = CommentsModel.fromJson(response).data;
        if (comments != null) {
          completion(comments);
        }
      },
    );
  }

  void reportPost(num postId, String reason, String desc) {
    var param = {Param.postId: postId, Param.reason: reason, Param.desc: desc};
    ApiService.shared.call(
      url: WebService.reportPost,
      param: param,
      completion: (response) {
        var obj = CommonResponse.fromJson(response);
        if (obj.status == true) {
          Get.back();
          Get.back();
          BaseController.share.showSnackBar(LKeys.reportAddedSuccessfully.tr,
              type: SnackBarType.success);
        }
      },
    );
  }

  void fetchUserPosts(
      int userID, int start, Function(List<Feed> posts) completion) {
    var param = {
      Param.myUserId: SessionManager.shared.getUserID(),
      Param.userId: userID.toString(),
      Param.start: start.toString(),
      Param.limit: Limits.pagination.toString()
    };
    ApiService.shared.call(
        param: param,
        url: WebService.fetchPostByUser,
        completion: (data) {
          var obj = FeedsModel.fromJson(data).data;
          if (obj != null) {
            completion(obj);
          }
        });
  }

  void uploadPost(
      {required String desc,
      required String tags,
      required int contentType,
      required List<XFile> images,
      XFile? video,
      required Function(int bytes, int totalBytes) onProgress,
      required Function(Feed feed) completion,
      required String thumbnailPath}) {
    var param = {
      Param.desc: desc,
      Param.tags: tags,
      Param.userId: SessionManager.shared.getUserID(),
      Param.contentType: contentType.toString()
    };
    ApiService.shared.multiPartCallApi(
      url: WebService.addPost,
      param: param,
      filesMap: {
        Param.contents: contentType == 0 ? images : [video],
        Param.thumbnail: [XFile(thumbnailPath)]
      },
      completion: (data) {
        var post = SingleFeedModel.fromJson(data).data;
        if (post != null) {
          completion(post);
        }
      },
    );
  }

  void likePost(int postID, Function() completion) {
    var param = {
      Param.userId: SessionManager.shared.getUserID(),
      Param.postId: postID.toString()
    };

    ApiService.shared.call(
      param: param,
      url: WebService.likePost,
      completion: (p0) {
        var response = CommonResponse.fromJson(p0);
        if (response.status == true) {
          completion();
        }
      },
    );
  }

  void deletePost(int postID, Function() completion) {
    var param = {
      Param.userId: SessionManager.shared.getUserID(),
      Param.postId: postID.toString()
    };

    ApiService.shared.call(
      param: param,
      url: WebService.deleteMyPost,
      completion: (p0) {
        var response = CommonResponse.fromJson(p0);
        if (response.status == true) {
          completion();
        }
      },
    );
  }

  void dislikePost(int postID, Function() completion) {
    var param = {
      Param.userId: SessionManager.shared.getUserID(),
      Param.postId: postID.toString()
    };

    ApiService.shared.call(
      param: param,
      url: WebService.dislikePost,
      completion: (p0) {
        var response = CommonResponse.fromJson(p0);
        if (response.status == true) {
          completion();
        }
      },
    );
  }

  void fetchPosts(bool shouldSendSuggestedRoom,
      Function(List<Feed> posts, List<Room> suggestedRooms) completion) {
    var param = {
      Param.myUserId: SessionManager.shared.getUserID(),
      Param.limit: Limits.pagination.toString(),
      Param.shouldSendSuggestedRoom: shouldSendSuggestedRoom ? 1 : 0
    };
    ApiService.shared.call(
        param: param,
        url: WebService.fetchPosts,
        completion: (data) {
          var obj = FeedsModel.fromJson(data).data;
          var rooms = FeedsModel.fromJson(data).suggestedRooms;
          if (obj != null) {
            completion(obj, rooms ?? []);
          }
        });
  }
}
