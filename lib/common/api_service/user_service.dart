import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/common/api_service/api_service.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/common_response.dart';
import 'package:untitled/models/registration.dart';
import 'package:untitled/models/setting_model.dart';
import 'package:untitled/models/users_model.dart';
import 'package:untitled/screens/login_screen/login_controller.dart';
import 'package:untitled/utilities/const.dart';
import 'package:untitled/utilities/params.dart';
import 'package:untitled/utilities/web_service.dart';

class UserService {
  static var shared = UserService();

  void fetchFollowingList(num userId, int start, Function(List<User> users) completion) {
    var param = {
      Param.myUserId: userId,
      Param.start: start,
      Param.limit: Limits.pagination,
    };
    ApiService.shared.call(
      url: WebService.fetchFollowingList,
      param: param,
      completion: (response) {
        var users = UsersModel.fromJson(response).data;
        if (users != null) {
          completion(users);
        }
      },
    );
  }

  void fetchFollowerList(num userId, int start, Function(List<User> users) completion) {
    var param = {
      Param.userId: userId,
      Param.start: start,
      Param.limit: Limits.pagination,
    };
    ApiService.shared.call(
      url: WebService.fetchFollowersList,
      param: param,
      completion: (response) {
        var users = UsersModel.fromJson(response).data;
        if (users != null) {
          completion(users);
        }
      },
    );
  }

  void searchProfile(String keyword, int start, Function(List<User> users) completion) {
    var param = {
      Param.myUserId: SessionManager.shared.getUserID(),
      Param.keyword: keyword,
      Param.start: start,
      Param.limit: Limits.pagination,
    };

    ApiService.shared.call(
      url: WebService.searchProfile,
      param: param,
      completion: (response) {
        var users = UsersModel.fromJson(response).data;
        if (users != null) {
          completion(users);
        }
      },
    );
  }

  void fetchBlockedUserList(Function(List<User> users) completion) {
    var param = {
      Param.myUserId: SessionManager.shared.getUserID(),
      Param.limit: Limits.pagination,
    };

    ApiService.shared.call(
      url: WebService.fetchBlockedUserList,
      param: param,
      completion: (response) {
        var users = UsersModel.fromJson(response).data;
        if (users != null) {
          completion(users);
        }
      },
    );
  }

  void profileVerification(String fullName, String documentType, XFile? document, XFile? selfie) {
    var param = {
      Param.userId: SessionManager.shared.getUserID(),
      Param.fullName: fullName,
      Param.documentType: documentType,
    };

    ApiService.shared.multiPartCallApi(
      url: WebService.profileVerification,
      param: param,
      filesMap: {
        Param.document: [document],
        Param.selfie: [selfie]
      },
      completion: (response) {
        var obj = CommonResponse.fromJson(response);
        if (obj.status == true) {
          var user = SessionManager.shared.getUser();
          user?.isVerified = 1;
          SessionManager.shared.setUser(user);
          Get.back();
          Get.back();
          BaseController.share.showSnackBar(LKeys.profileVerificationRequestSent.tr, type: SnackBarType.success);
        }
      },
    );
  }

  void reportUser(num userId, String reason, String desc) {
    var param = {Param.userId: userId, Param.reason: reason, Param.desc: desc};
    ApiService.shared.call(
      url: WebService.reportUser,
      param: param,
      completion: (response) {
        var obj = CommonResponse.fromJson(response);
        if (obj.status == true) {
          Get.back();
          Get.back();
          BaseController.share.showSnackBar(LKeys.reportAddedSuccessfully.tr, type: SnackBarType.success);
        }
      },
    );
  }

  void followUser(int userId, Function() completion) {
    var param = {Param.userId: userId, Param.myUserId: SessionManager.shared.getUserID()};
    ApiService.shared.call(
      url: WebService.followUser,
      param: param,
      completion: (response) {
        var obj = CommonResponse.fromJson(response);
        if (obj.status == true) {
          completion();
        }
      },
    );
  }

  void blockUser(num userId, Function() completion) {
    var param = {Param.userId: userId, Param.myUserId: SessionManager.shared.getUserID()};
    ApiService.shared.call(
      url: WebService.userBlockedByUser,
      param: param,
      completion: (response) {
        var obj = CommonResponse.fromJson(response);
        if (obj.status == true) {
          completion();
        }
      },
    );
  }

  void unblockUser(num userId, Function() completion) {
    var param = {Param.userId: userId, Param.myUserId: SessionManager.shared.getUserID()};
    ApiService.shared.call(
      url: WebService.userUnBlockedByUser,
      param: param,
      completion: (response) {
        var obj = Registration.fromJson(response);
        if (obj.status == true) {
          SessionManager.shared.setUser(obj.data);
          completion();
        }
      },
    );
  }

  void unfollowUser(int userId, Function() completion) {
    var param = {Param.userId: userId, Param.myUserId: SessionManager.shared.getUserID()};
    ApiService.shared.call(
      url: WebService.unfollowUser,
      param: param,
      completion: (response) {
        var obj = CommonResponse.fromJson(response);
        if (obj.status == true) {
          completion();
        }
      },
    );
  }

  void fetchProfile(int userID, Function(User user) completion) {
    var param = {Param.myUserId: SessionManager.shared.getUserID(), Param.userId: userID.toString()};

    ApiService.shared.call(
      param: param,
      url: WebService.fetchProfile,
      completion: (p0) {
        var user = Registration.fromJson(p0).data;
        if (user != null) {
          completion(user);
        }
      },
    );
  }

  void fetchMyProfile({required num userID, int? myUserId, required Function(User user) completion}) {
    var param = {Param.myUserId: myUserId ?? SessionManager.shared.getUserID(), Param.userId: userID.toString()};

    ApiService.shared.call(
      param: param,
      url: WebService.fetchProfile,
      completion: (p0) {
        var user = Registration.fromJson(p0).data;
        if (user != null) {
          completion(user);
        }
      },
    );
  }

  void fetchRandomProfile(Function(User user) completion) {
    var param = {Param.myUserId: SessionManager.shared.getUserID()};
    ApiService.shared.call(
      url: WebService.fetchRandomProfile,
      param: param,
      completion: (response) {
        User? user = Registration.fromJson(response).data;
        if (user != null) {
          completion(user);
        }
      },
    );
  }

  void logOut(Function() completion) {
    var param = {Param.userId: SessionManager.shared.getUserID()};
    ApiService.shared.call(
      url: WebService.logOut,
      param: param,
      completion: (data) {
        var obj = CommonResponse.fromJson(data).status;
        if (obj == true) {
          completion();
        }
      },
    );
  }

  void deleteUser(Function() completion) {
    var param = {Param.userId: SessionManager.shared.getUserID()};
    ApiService.shared.call(
      url: WebService.deleteUser,
      param: param,
      completion: (data) {
        var obj = CommonResponse.fromJson(data).status;
        if (obj == true) {
          completion();
        }
      },
    );
  }

  void checkForUsername(String username, Function(bool) completion) {
    ApiService.shared.client?.close();
    ApiService.shared.call(
        url: WebService.checkUsername,
        param: {Param.username: username},
        completion: (value) {
          var response = CommonResponse.fromJson(value);
          completion(response.status ?? false);
        });
  }

  void editProfile({
    String? username,
    String? fullName,
    String? bio,
    List<Interest>? interests,
    XFile? profileImage,
    XFile? bgImage,
    String? blockUserIds,
    bool? isPushNotifications,
    bool? isInvitedToRoom,
    int? isVerified,
    required Function(User) completion,
  }) {
    Map<String, Object> param = {Param.userId: SessionManager.shared.getUserID()};

    if (username != null) {
      param[Param.username] = username;
    }

    if (fullName != null) {
      param[Param.fullName] = fullName;
    }

    if (bio != null) {
      param[Param.bio] = bio;
    }

    if (isVerified != null) {
      param[Param.isVerified] = isVerified;
    }

    if (fullName != null) {
      param[Param.fullName] = fullName;
    }

    if (blockUserIds != null) {
      param[Param.blockUserIds] = blockUserIds;
    }
    if (isPushNotifications != null) {
      param[Param.isPushNotifications] = isPushNotifications ? 1 : 0;
    }
    if (isInvitedToRoom != null) {
      param[Param.isInvitedToRoom] = isInvitedToRoom ? 1 : 0;
    }

    if (interests?.isNotEmpty == true) {
      var str = (interests ?? []).map((e) => "${e.id ?? 0}").toList().join(",");
      param[Param.interestIds] = str;
    }
    ApiService.shared.multiPartCallApi(
      url: WebService.editProfile,
      param: param,
      filesMap: {
        Param.profile: [profileImage],
        Param.backgroundImage: [bgImage]
      },
      completion: (data) {
        var user = Registration.fromJson(data).data;
        if (user != null) {
          SessionManager.shared.setUser(user);
          completion(user);
        }
      },
    );
  }

  void registration(
      {String? name,
      required String identity,
      required String deviceToken,
      required LoginType loginType,
      required Function(Registration) completion}) async {
    Map<String, String> map = {};
    if (name != null) {
      map[Param.fullName] = name;
    }
    map[Param.identity] = identity;
    map[Param.deviceToken] = deviceToken;
    map[Param.loginType] = loginType.value.toString();
    map[Param.deviceType] = (GetPlatform.isIOS ? 1 : 0).toString();

    ApiService.shared.call(
      url: WebService.addUser,
      param: map,
      completion: (p0) {
        var registration = Registration.fromJson(p0);
        var user = registration.data;
        if (user != null) {
          SessionManager.shared.setUser(user);
          completion(registration);
        }
      },
    );
  }
}
