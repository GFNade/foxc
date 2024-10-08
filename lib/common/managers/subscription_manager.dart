// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/services.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:untitled/common/api_service/user_service.dart';
// import 'package:untitled/utilities/const.dart';

// bool isSubscribe = false;
// bool isPurchaseConfig = false;

// class SubscriptionManager {
//   static var shared = SubscriptionManager();
//   List<Package> packages = [];

//   Future<void> initPlatformState() async {
//     PurchasesConfiguration configuration;
//     if (Platform.isAndroid) {
//       if (revenuecatAndroidApiKey.isNotEmpty) {
//         configuration = PurchasesConfiguration(revenuecatAndroidApiKey);
//         Purchases.setLogLevel(LogLevel.debug);
//         await Purchases.configure(configuration);
//       }
//     } else if (Platform.isIOS) {
//       if (revenuecatAppleApiKey.isNotEmpty) {
//         configuration = PurchasesConfiguration(revenuecatAppleApiKey);
//         Purchases.setLogLevel(LogLevel.debug);
//         await Purchases.configure(configuration);
//       }
//     }

//     await checkIsConfigured();
//     await fetchOfferings();
//     await subscriptionListener();
//   }

//   bool checkSubscription(CustomerInfo customerInfo) {
//     if (customerInfo.latestExpirationDate == null || customerInfo.latestExpirationDate!.isEmpty) {
//       isSubscribe = false;
//     } else {
//       DateTime dt1 = DateTime.parse(customerInfo.latestExpirationDate ?? '').toLocal();
//       DateTime dt2 = DateTime.now();
//       log('DATE : {$dt1 == $dt2}');
//       if (dt1.compareTo(dt2) < 0) {
//         isSubscribe = false;
//       }
//       if (dt1.compareTo(dt2) > 0) {
//         isSubscribe = true;
//       }
//     }

//     log('✅ Subscription Status : ${isSubscribe ? 'Active' : 'InActive'}');
//     return isSubscribe;
//   }

//   Future<void> subscriptionListener() async {
//     try {
//       Purchases.addCustomerInfoUpdateListener((customerInfo) async {
//         checkSubscription(customerInfo);
//         UserService.shared.editProfile(
//           isVerified: isSubscribe ? 3 : 0,
//           completion: (p0) {},
//         );
//       });
//     } on PlatformException catch (e) {
//       // Error fetching purchaser info
//       log('RevenueCat Error : ${e.message.toString()}');
//     }
//   }

//   Future<void> checkIsConfigured() async {
//     isPurchaseConfig = await Purchases.isConfigured;
//   }

//   Future<LogInResult> login(String appUserID) async {
//     return await Purchases.logIn(appUserID);
//   }

//   Future<(CustomerInfo?, String?)> restorePurchase() async {
//     try {
//       CustomerInfo restoredInfo = await Purchases.restorePurchases();
//       return (restoredInfo, '');
//       // ... check restored customerInfo to see if entitlement is now active
//     } on PlatformException catch (e) {
//       return (null, e.message);
//       // Error restoring purchases
//     }
//   }

//   Future<(Offering?, String?)> fetchOfferings() async {
//     try {
//       Offerings offerings = await Purchases.getOfferings();
//       // Display current offering with offerings.current
//       packages = offerings.current?.availablePackages ?? [];
//       return (offerings.current, null);
//     } on PlatformException catch (e) {
//       // Error restoring purchases
//       print(e.message);
//       return (null, e.message);
//     }
//   }

//   Future<bool?> checkSubscriptionStatus() async {
//     try {
//       CustomerInfo customerInfo = await Purchases.getCustomerInfo();
//       return checkSubscription(customerInfo);
//     } on PlatformException catch (e) {
//       log(e.message.toString());
//       // Error fetching purchaser info
//     }
//     return null;
//   }

//   Future<bool?> makePurchase(Package package) async {
//     try {
//       CustomerInfo customerInfo = await Purchases.purchasePackage(package);
//       return checkSubscription(customerInfo);
//     } on PlatformException catch (e) {
//       print("${e}");
//       return null;
//     }
//   }
// }
