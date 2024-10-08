import 'package:flutter/material.dart';

const String appName = "Foxc";
const String baseURL = "https://chatter.dxdlabs.dev/";
const String itemBaseURL = "${baseURL}storage/";
const String apiURL = "${baseURL}api/";
const String termsURL = "${baseURL}termsOfUse";
const String privacyURL = "${baseURL}privacyPolicy";
const String helpURL = "https://foxcoin.co/";
const String notificationTopic = "chatter";

const String revenuecatAppleApiKey = 'your_ios_revenuecat_api_key';
const String revenuecatAndroidApiKey = '';

const String contactEmail = 'yourContactMail';

class Limits {
  static int username = 20;
  static int roomDescCount = 120;
  static int bioCount = 120;
  static int interestCount = 5;
  static int pagination = 20;
  static int storyDuration = 3;

  static double imageSize = 720;
  static int quality = 100;
}

extension O on String {
  String addBaseURL() {
    return itemBaseURL + this;
  }
}

// Colors
const cPrimary = Color(0xFFFFB03F);
const cPulsing = Color(0xFFA1E5B3);
const cWhite = Colors.white;
const cBlack = Color(0xFF0E0E0E);
const cMainText = Color(0xFF2d2d2d);
const cLightText = Color(0xFF979797);
const cLightIcon = Color(0xFFAEAEAE);
const cDarkText = Color(0xFF585858);
const cLightBg = Color(0xFFF1F1F1);
const cDarkBG = Color(0xFF212121);
const cBG = Color(0xFFF2F2F2);
const cGreen = Color(0xFF2CA757);
const cDarkGreen = Color(0xFF183321);
const cBlueTick = Color(0xFF1D9BF0);
const cRed = Colors.red;

// Corner Radius-Smoothing
const cornerSmoothing = 1.0;
