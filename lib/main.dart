import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:untitled/common/managers/firebase_notification_manager.dart';
import 'package:untitled/common/managers/session_manager.dart';
// import 'package:untitled/common/managers/subscription_manager.dart';
import 'package:untitled/common/widgets/functions.dart';
import 'package:untitled/localization/allLanguages.dart';
import 'package:untitled/screens/profile_screen/profile_screen.dart';
import 'package:untitled/screens/rooms_screen/single_room/single_room_screen.dart';
import 'package:untitled/screens/single_post_screen/single_post_screen.dart';
import 'package:untitled/screens/splash_screen/splash_screen_view.dart';
import 'package:untitled/utilities/const.dart';
import 'package:untitled/utilities/params.dart';

import 'common/managers/ads/interstitial_manager.dart';
import 'localization/languages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp();
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await GetStorage.init();
  SessionManager.shared;
  InterstitialManager.shared;
  await AppTrackingTransparency.requestTrackingAuthorization();
  FirebaseNotificationManager.shared;
  PackageInfo.fromPlatform();
  // SubscriptionManager.shared.initPlatformState();
  MobileAds.instance.initialize();

  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.data}");
  await Firebase.initializeApp();
  FirebaseNotificationManager.shared.showNotification(message);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Functions.changStatusBar(StatusBarStyle.black);
    Lang lang = SessionManager.shared.getLang();

    return GetMaterialApp(
      translations: Languages(),
      locale: lang.language.local,
      builder: (context, child) {
        return ScrollConfiguration(behavior: MyScrollBehavior(), child: child!);
      },
      fallbackLocale: LANGUAGES.first.language.local,
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(useMaterial3: false),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    handleBranch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SplashScreenView(),
    );
  }

  Future<String> downloadImage({required String url}) async {
    var response = await get(Uri.parse(url)); // <--2
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = "${documentDirectory.path}/images";
    var filePathAndName = '${documentDirectory.path}/images/pic.jpg';
    await Directory(firstPath).create(recursive: true); // <-- 1
    File file2 = File(filePathAndName); // <-- 2
    file2.writeAsBytesSync(response.bodyBytes);
    return filePathAndName;
  }

  void handleBranch() {
    FlutterBranchSdk.init().then((value) {
      FlutterBranchSdk.listSession().listen(
        (data) {
          if (data.containsKey("+clicked_branch_link") && data["+clicked_branch_link"] == true) {
            if (data.containsKey(Param.postId)) {
              var postId = data[Param.postId];
              if (postId is String) {
                Get.to(() => SinglePostScreen(postId: int.parse(postId)));
              } else if (postId is double) {
                Get.to(() => SinglePostScreen(postId: postId.toInt()));
              }
            } else if (data.containsKey(Param.userId)) {
              var userId = data[Param.userId];
              if (userId is String) {
                Get.to(() => ProfileScreen(userId: int.parse(userId)));
              } else if (userId is double) {
                Get.to(() => ProfileScreen(userId: userId.toInt()));
              }
            } else if (data.containsKey(Param.roomId)) {
              var roomId = data[Param.roomId];
              if (roomId is String) {
                Get.to(() => SingleRoomScreen(roomId: int.parse(roomId)));
              } else if (roomId is double) {
                Get.to(() => SingleRoomScreen(roomId: roomId.toInt()));
              }
            }
          }
          FlutterBranchSdk.clearPartnerParameters();
        },
        onError: (error) {
          PlatformException platformException = error as PlatformException;
          print(platformException.message);
        },
      );
    });
  }
}

class MyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
