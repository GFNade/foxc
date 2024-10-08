import 'package:flutter/cupertino.dart';
import 'package:untitled/common/api_service/post_service.dart';
import 'package:untitled/models/feeds_model.dart';
import 'package:untitled/models/room_model.dart';
import 'package:untitled/screens/chats_screen/chatting_screen/block_user_controller.dart';

class FeedScreenController extends BlockUserController {
  List<Feed> posts = [];
  List<Room> suggestedRooms = [];
  bool? isFromFeedScreen;
  String profileFeedID = "profileFeedID";
  String feedViewID = "feedViewID";
  ScrollController scrollController = ScrollController();
  int userId = 0;

  FeedScreenController({this.isFromFeedScreen});

  @override
  void onReady() {
    super.onReady();
    update();
    if (isFromFeedScreen == true) {
      fetchFeeds();
    }
    scrollController.addListener(
      () {
        if (scrollController.offset ==
            scrollController.position.maxScrollExtent) {
          if (!isLoading) {
            if ((isFromFeedScreen ?? false) == true) {
              fetchFeeds();
            } else {
              fetchUserPosts(userId);
            }
          }
        }
      },
    );

    // if (isFromFeedScreen == true && posts.isEmpty) {
    //   fetchFeeds();
    // }
  }

  void fetchFeeds() {
    // isLoading = true;
    if (posts.isEmpty) {
      startLoading();
    }
    PostService.shared.fetchPosts(posts.isEmpty, (posts, rooms) {
      this.posts.addAll(posts);
      if (rooms.isNotEmpty) {
        suggestedRooms = rooms;
      }
      stopLoading();
      update();
    });
  }

  void fetchUserPosts(int userID) {
    // isLoading = true;
    userId = userID;
    PostService.shared.fetchUserPosts(userID, posts.length, (posts) {
      // isLoading = false;
      this.posts.addAll(posts);
      update();
    });
  }

  void refreshPosts() {
    if (userId != 0) {
      posts.clear();
      PostService.shared.fetchUserPosts(userId, posts.length, (posts) {
        // isLoading = false;
        this.posts.addAll(posts);
        update();
      });
    }
  }
}
