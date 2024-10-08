import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:untitled/common/api_service/notification_service.dart';
import 'package:untitled/common/api_service/user_service.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/common/managers/firebase_notification_manager.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/screens/block_by_admin_screen/block_by_admin_screen.dart';
import 'package:untitled/screens/interests_screen/interests_screen.dart';
import 'package:untitled/screens/login_screen/sign_in_with_email_screen.dart';
import 'package:untitled/screens/profile_picture_screen/profile_picture_screen.dart';
import 'package:untitled/screens/tabbar/tabbar_screen.dart';
import 'package:untitled/screens/username_screen/username_screen.dart';
import 'package:untitled/utilities/const.dart';

class LoginController extends BaseController {
  void emailLogin() {
    Get.bottomSheet(SignInWithEmailScreen(
      onSubmit: (fullName, identity) {
        registerUser(identity: identity, loginType: LoginType.email, fullName: fullName);
      },
    ), isScrollControlled: true, ignoreSafeArea: false);
  }

  void googleLogin() {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email']
    );
    googleSignIn.signIn().then((googleSignInAccount) {
      print('Email : ${googleSignInAccount?.email}');
      if (googleSignInAccount != null) {
        registerUser(
            fullName: googleSignInAccount.displayName,
            identity: googleSignInAccount.email,
            loginType: LoginType.google);
      } else {
        showSnackBar('Google Sign In Failed');
      }
    }).catchError((error) {
      showSnackBar(error.toString());
    });
  }

  void appleLogin() async {
    try {
      AuthorizationCredentialAppleID value = await SignInWithApple.getAppleIDCredential(
          scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName]);
      registerUser(
          fullName: '${value.givenName} ${value.familyName}',
          identity: value.userIdentifier ?? '',
          loginType: LoginType.apple);
    } on SignInWithAppleException catch (exception) {
      log("Something wrong ${exception.toString()}");
    }
  }

  void registerUser({String? fullName, required String identity, required LoginType loginType}) {
    // startLoading();
    FirebaseNotificationManager.shared.getNotificationToken((token) {
      UserService.shared.registration(
          name: fullName,
          identity: identity,
          deviceToken: token,
          loginType: loginType,
          completion: (p0) {
            SessionManager.shared.setLogin(true);
            print(p0);

            Widget w = InterestScreen();
            var user = p0.data;
            // Purchases.logIn('${user?.id ?? 0}');
            if (user?.isPushNotifications == 1) {
              FirebaseNotificationManager.shared.subscribeToTopic(notificationTopic);
              NotificationService.shared.subscribeToAllMyRoom();
            }
            if (user?.isBlock == 1) {
              w = const BlockedByAdminScreen();
            } else if (user?.interestIds == null) {
              w = InterestScreen();
            } else if (user?.username == null) {
              w = const UserNameScreen();
            } else if (user?.profile == null) {
              w = const ProfilePictureScreen();
            } else {
              w = TabBarScreen();
            }
            Get.offAll(() => w);
            // stopLoading();
          });
    });
  }
}

enum LoginType {
  google(0),
  apple(1),
  email(2);

  const LoginType(this.value);

  final int value;
}
