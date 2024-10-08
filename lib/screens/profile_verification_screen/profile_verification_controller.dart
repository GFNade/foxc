// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// // import 'package:purchases_flutter/object_wrappers.dart';
// import 'package:untitled/common/api_service/user_service.dart';
// import 'package:untitled/common/controller/base_controller.dart';
// import 'package:untitled/common/managers/session_manager.dart';
// // import 'package:untitled/common/managers/subscription_manager.dart';
// import 'package:untitled/localization/languages.dart';
// import 'package:untitled/models/setting_model.dart';
// import 'package:untitled/screens/profile_picture_screen/profile_picture_controller.dart';

// class ProfileVerificationController extends ProfilePictureController {
//   XFile? selectedDocument;
//   TextEditingController fullNameController = TextEditingController();
//   Interest? selectedType;
//   List<Interest> types = SessionManager.shared.getSettings()?.documentType ?? [];
//   List<VerificationMethodModel> methods = [
//     VerificationMethodModel(
//         LKeys.verificationSubscriptionTitle, LKeys.verificationSubscriptionDesc, VerificationMethod.subscription),
//     VerificationMethodModel(
//         LKeys.verificationDocumentTitle, LKeys.verificationDocumentDesc, VerificationMethod.document),
//   ];

//   List<Package> packages = [];
//   Package? selectedPackage;

//   late VerificationMethodModel selectedMethod;

//   ProfileVerificationController() {
//     selectedMethod = methods.first;
//   }

//   @override
//   void onReady() {
//     selectedType = types.first;
//     update();
//     super.onReady();
//   }

//   void setupSubscriptions() {
//     if (selectedPackage == null || packages.isEmpty) {
//       packages = SubscriptionManager.shared.packages;
//       selectedPackage = SubscriptionManager.shared.packages.first;
//       update();
//     }
//   }

//   void selectDocument() async {
//     try {
//       selectedDocument = await picker.pickImage(source: ImageSource.gallery);
//       update();
//     } catch (e) {
//       showSnackBar("Invalid Document");
//     }
//   }

//   void changeSelectPackage(Package package) {
//     selectedPackage = package;
//     update();
//   }

//   void onChangeMethod(VerificationMethodModel method) {
//     selectedMethod = method;
//     update();
//   }

//   void onChangeType(Interest? value) {
//     selectedType = value;
//     update();
//   }

//   void submitRequest() async {
//     if (selectedMethod.method == VerificationMethod.document) {
//       if (fullNameController.text.isEmpty) {
//         showSnackBar(LKeys.pleaseEnterFullName.tr, type: SnackBarType.error);
//       } else if (selectedDocument == null) {
//         showSnackBar(LKeys.pleaseSelectDocument.tr, type: SnackBarType.error);
//       } else if (imagePath.isEmpty) {
//         showSnackBar(LKeys.pleaseEnterYourSelfie.tr, type: SnackBarType.error);
//       } else {
//         startLoading();
//         UserService.shared.profileVerification(
//             fullNameController.text, selectedType?.title ?? '', selectedDocument, XFile(imagePath));
//       }
//     } else {
//       if (selectedPackage != null) {
//         startLoading();
//         var status = await SubscriptionManager.shared.makePurchase(selectedPackage!);
//         if (status == true) {
//           UserService.shared.editProfile(
//             isVerified: 3,
//             completion: (p0) {
//               stopLoading();
//               Get.back();
//             },
//           );
//         } else {
//           stopLoading();
//         }
//       } else {
//         showSnackBar(LKeys.pleaseConfigureSubscription.tr, type: SnackBarType.error);
//       }
//     }
//   }
// }

// class VerificationMethodModel {
//   String title;
//   String desc;
//   VerificationMethod method;

//   VerificationMethodModel(this.title, this.desc, this.method);
// }

// enum VerificationMethod {
//   document,
//   subscription;
// }
