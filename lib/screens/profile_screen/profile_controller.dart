import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:share_plus/share_plus.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/common/api_service/user_service.dart';
import 'package:untitled/common/extensions/image_extension.dart';
import 'package:untitled/common/widgets/functions.dart';
import 'package:untitled/models/registration.dart';
import 'package:untitled/screens/feed_screen/feed_screen_controller.dart';
import 'package:untitled/utilities/const.dart';
import 'package:untitled/utilities/params.dart';

class ProfileController extends FeedScreenController {
  User? user;
  final int userID;
  String followBtnID = "follow_btn";
  String scrollID = "${DateTime.now().millisecondsSinceEpoch}scrollID";
  double maxExtent = 250.0;
  double currentExtent = 250.0;
  bool isFollowLoading = false;

  ProfileController(this.userID);

  void updateEverything() {
    update([scrollID]);
    update();
  }

  void updateMyProfile() {
    if (user?.id == SessionManager.shared.getUserID()) {
      user = SessionManager.shared.getUser();
      update();
      update([scrollID]);
    }
  }

  void getStories() {
    UserService.shared.fetchProfile(userID, (user) {
      this.user = user;

      if (user.id == SessionManager.shared.getUserID()) {
        SessionManager.shared.setUser(user);
      }
      update();
      update([scrollID]);
    });
  }

  void getProfile() {
    startLoading();
    UserService.shared.fetchProfile(userID, (user) {
      this.user = user;

      if (user.id == SessionManager.shared.getUserID()) {
        SessionManager.shared.setUser(user);
      }
      update();
      update([scrollID]);
      stopLoading();
    });
  }

  @override
  void onReady() {
    super.onReady();
    user = User(id: userID);
    getProfile();
    if (!(user?.isBlockedByMe() ?? false)) {
      fetchUserPosts(userID);
    }

    scrollController.addListener(() {
      currentExtent = maxExtent - scrollController.offset;
      if (currentExtent < 0) currentExtent = 0.0;
      if (currentExtent > maxExtent) currentExtent = maxExtent;
      update([scrollID]);
    });
  }

  @override
  void onClose() {
    Functions.changStatusBar(StatusBarStyle.white);
  }

  void followToggle() {
    if ((user?.followingStatus ?? 0) > 1) {
      unfollow();
    } else {
      follow();
    }
  }

  void follow() {
    isFollowLoading = true;
    update();
    UserService.shared.followUser(userId, () {
      isFollowLoading = false;
      user?.followingStatus = 2;
      user?.followers = (user?.followers ?? 0) + 1;
      update();
    });
  }

  void unfollow() {
    isFollowLoading = true;
    update();
    UserService.shared.unfollowUser(userId, () {
      isFollowLoading = false;
      user?.followingStatus = 0;
      user?.followers = (user?.followers ?? 0) - 1;
      update();
    });
  }

  void shareProfile() {
    BranchUniversalObject buo = BranchUniversalObject(
        canonicalIdentifier: 'flutter/branch',
        title: user?.fullName ?? '',
        imageUrl: user?.profile?.addBaseURL() ?? '',
        contentDescription: user?.username ?? '',
        publiclyIndex: true,
        locallyIndex: true);
    BranchLinkProperties lp = BranchLinkProperties();
    lp.addControlParam(Param.userId, '$userID');
    if (GetPlatform.isIOS) {
      if (buo.imageUrl != '') {
        FlutterBranchSdk.showShareSheet(buo: buo, linkProperties: lp, messageText: '');
      } else {
        rootBundle.load(MyImages.appIcon).then((data) {
          FlutterBranchSdk.shareWithLPLinkMetadata(
              buo: buo, linkProperties: lp, icon: data.buffer.asUint8List(), title: user?.fullName ?? '');
        });
      }
    } else {
      FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp).then((value) {
        Share.share(value.result ?? '', subject: user?.fullName ?? '');
      });
    }
  }
}
