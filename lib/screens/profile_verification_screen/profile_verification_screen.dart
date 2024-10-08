// import 'package:figma_squircle/figma_squircle.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:purchases_flutter/models/package_wrapper.dart';
// import 'package:untitled/common/extensions/font_extension.dart';
// import 'package:untitled/common/managers/session_manager.dart';
// import 'package:untitled/common/managers/subscription_manager.dart';
// import 'package:untitled/localization/languages.dart';
// import 'package:untitled/models/setting_model.dart';
// import 'package:untitled/screens/extra_views/back_button.dart';
// import 'package:untitled/screens/extra_views/buttons.dart';
// import 'package:untitled/screens/extra_views/top_bar.dart';
// import 'package:untitled/screens/profile_picture_screen/profile_picture_screen.dart';
// import 'package:untitled/screens/profile_verification_screen/profile_verification_controller.dart';
// import 'package:untitled/screens/rooms_you_own/create_room_screen/create_room_screen.dart';
// import 'package:untitled/utilities/const.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ProfileVerificationScreen extends StatelessWidget {
//   const ProfileVerificationScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     ProfileVerificationController controller = ProfileVerificationController();
//     return Scaffold(
//       body: Column(
//         children: [
//           const TopBarForInView(title: LKeys.profileVerification),
//           Expanded(
//             child: SingleChildScrollView(
//               child: GetBuilder(
//                   init: controller,
//                   builder: (controller) {
//                     return Column(
//                       children: [
//                         const SizedBox(height: 30),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               SessionManager.shared.getUser()?.username ?? '',
//                               style: MyTextStyle.gilroyBold(),
//                             ),
//                             const SizedBox(width: 5),
//                             const VerifyIcon(isPlaceholder: true)
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         SizedBox(
//                           width: Get.width * 0.75,
//                           child: Text(
//                             LKeys.profileVerificationDesc.tr,
//                             style: MyTextStyle.gilroyLight(color: cLightText, size: 14),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         segmentController(controller),
//                         Divider(),
//                         methodCard(controller, controller.selectedMethod),
//                         controller.selectedMethod.method == VerificationMethod.document
//                             ? documentVerificationView(controller)
//                             : subscriptionView(controller),
//                         const SizedBox(height: 40),
//                         CommonButton(
//                           text: LKeys.submit,
//                           onTap: controller.submitRequest,
//                         )
//                       ],
//                     );
//                   }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget subscriptionView(ProfileVerificationController controller) {
//     if (isPurchaseConfig) {
//       controller.setupSubscriptions();
//       return Container(
//         padding: const EdgeInsets.all(15),
//         child: Column(
//           children: [
//             Text(
//               LKeys.subscriptionDesc.tr,
//               style: MyTextStyle.gilroyLight(color: cLightText, size: 14),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 20),
//             ListView.builder(
//               padding: EdgeInsets.zero,
//               itemCount: controller.packages.length,
//               shrinkWrap: true,
//               primary: false,
//               itemBuilder: (context, index) {
//                 var package = controller.packages[index];
//                 return GestureDetector(
//                   onTap: () {
//                     controller.changeSelectPackage(package);
//                   },
//                   child: Container(
//                     padding: EdgeInsets.all(15),
//                     margin: EdgeInsets.only(bottom: 10),
//                     decoration: BoxDecoration(
//                         border: Border.all(
//                             color: controller.selectedPackage == package ? cPrimary : cLightText.withOpacity(0.3),
//                             width: 2),
//                         borderRadius: SmoothBorderRadius(cornerRadius: 12)),
//                     child: Row(
//                       children: [
//                         Text(
//                           getPackageTitle(package.packageType).tr,
//                           style: MyTextStyle.gilroySemiBold(size: 18, color: cLightText),
//                         ),
//                         Spacer(),
//                         Text(package.storeProduct.priceString,
//                             style: MyTextStyle.gilroyBold(size: 18, color: cDarkText)),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       );
//     } else {
//       return Container(
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
//         child: Column(
//           children: [
//             Text(
//               LKeys.pleaseConfigureSubscription.tr,
//               style: MyTextStyle.gilroyRegular(),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 10),
//             GestureDetector(
//                 onTap: () async {
//                   var url = 'https://errors.rev.cat/configuring-sdk';
//                   if (!await launchUrl(Uri.parse(url))) {
//                     throw Exception('Could not launch ');
//                   }
//                 },
//                 child: Text(
//                   'https://errors.rev.cat/configuring-sdk',
//                   style: MyTextStyle.gilroySemiBold(color: cPrimary),
//                 ))
//           ],
//         ),
//       );
//     }
//   }

//   Widget segmentController(ProfileVerificationController controller) {
//     return CupertinoSlidingSegmentedControl(
//       children: {
//         controller.methods.first: buildSegment(LKeys.method1, 0, controller),
//         controller.methods.last: buildSegment(LKeys.method2, 1, controller)
//       },
//       groupValue: controller.selectedMethod,
//       backgroundColor: cLightBg,
//       thumbColor: cPrimary,
//       padding: const EdgeInsets.all(0),
//       onValueChanged: (value) {
//         if (value is VerificationMethodModel) {
//           controller.onChangeMethod(value);
//         }
//       },
//     );
//   }

//   Widget buildSegment(String text, int index, ProfileVerificationController controller) {
//     return Container(
//       alignment: Alignment.center,
//       width: (Get.width / 2) - 30,
//       child: Text(
//         text.tr.toUpperCase(),
//         style: MyTextStyle.gilroySemiBold(
//                 size: 13, color: controller.selectedMethod == controller.methods[index] ? cBlack : cLightText)
//             .copyWith(letterSpacing: 2),
//       ),
//     );
//   }

//   String getPackageTitle(PackageType type) {
//     switch (type) {
//       case PackageType.annual:
//         return LKeys.annual;
//       case PackageType.monthly:
//         return LKeys.monthly;
//       case PackageType.weekly:
//         return LKeys.weekly;
//       case PackageType.custom:
//         return '';
//       case PackageType.lifetime:
//         return LKeys.lifetime;
//       case PackageType.sixMonth:
//         return LKeys.sixMonth;
//       case PackageType.threeMonth:
//         return LKeys.threeMonth;
//       case PackageType.twoMonth:
//         return LKeys.twoMonth;
//       case PackageType.unknown:
//         return '';
//     }
//   }

//   Widget documentVerificationView(ProfileVerificationController controller) {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       child: Column(
//         children: [
//           const CreateRoomHeading(title: LKeys.fullName),
//           MyTextField(
//               controller: controller.fullNameController, placeHolder: SessionManager.shared.getUser()?.fullName ?? ''),
//           const SizedBox(height: 10),
//           const CreateRoomHeading(title: LKeys.documentType),
//           dropDown(controller),
//           GestureDetector(
//             onTap: () {
//               controller.selectDocument();
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 color: cLightBg,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               width: double.infinity,
//               alignment: Alignment.center,
//               padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
//               child: Text(
//                 (controller.selectedDocument?.name.replaceAll('image_picker_', '') ?? LKeys.selectDocument.tr),
//                 textAlign: TextAlign.center,
//                 style: MyTextStyle.gilroyLight(color: cLightText),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           const CreateRoomHeading(title: LKeys.yourSelfie),
//           ProfileImagePicker(
//             controller: controller,
//             boxSize: Get.width / 2,
//             radius: 100,
//             onTap: () {
//               controller.pickImage(source: ImageSource.gallery);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget dropDown(ProfileVerificationController controller) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       padding: const EdgeInsets.symmetric(horizontal: 15),
//       decoration: BoxDecoration(color: cLightBg, borderRadius: BorderRadius.circular(8)),
//       child: DropdownButton<Interest>(
//         borderRadius: BorderRadius.circular(12),
//         dropdownColor: cLightBg,
//         value: controller.selectedType,
//         elevation: 16,
//         isExpanded: true,
//         underline: const SizedBox(),
//         style: MyTextStyle.gilroyMedium(color: cLightText),
//         onChanged: controller.onChangeType,
//         items: controller.types.map<DropdownMenuItem<Interest>>((Interest value) {
//           return DropdownMenuItem<Interest>(
//             value: value,
//             child: Text(value.title ?? ''),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget methodCard(ProfileVerificationController controller, VerificationMethodModel method) {
//     return Container(
//       padding: EdgeInsets.all(15),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             method.title.tr,
//             style: MyTextStyle.gilroyMedium(size: 18, color: cDarkText),
//           ),
//           SizedBox(height: 3),
//           Text(
//             method.desc.tr,
//             style: MyTextStyle.gilroyLight(size: 14, color: cLightText),
//           )
//         ],
//       ),
//     );
//   }
// }
