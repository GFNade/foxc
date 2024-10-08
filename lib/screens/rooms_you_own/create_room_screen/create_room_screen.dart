import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/models/room_model.dart';
import 'package:untitled/screens/extra_views/buttons.dart';
import 'package:untitled/screens/extra_views/top_bar.dart';
import 'package:untitled/screens/interests_screen/interests_controller.dart';
import 'package:untitled/screens/interests_screen/interests_screen.dart';
import 'package:untitled/screens/profile_picture_screen/profile_picture_screen.dart';
import 'package:untitled/screens/rooms_you_own/create_room_screen/create_room_controller.dart';
import 'package:untitled/screens/setting_screen/setting_screen.dart';
import 'package:untitled/utilities/const.dart';

class CreateRoomScreen extends StatelessWidget {
  final Room? room;

  const CreateRoomScreen({Key? key, this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CreateRoomController controller = CreateRoomController(room);
    return Scaffold(
      body: Column(
        children: [
          TopBarForInView(
              title: room != null ? LKeys.roomSettings : LKeys.createNewRoom),
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    const CreateRoomHeading(title: LKeys.selectProfileImage),
                    Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: cLightText.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4), // Shadow position
                        )
                      ], shape: BoxShape.circle),
                      child: ProfileImagePicker(
                        imageURL: room?.photo,
                        controller: controller,
                        boxSize: Get.width / 2,
                        radius: 100,
                      ),
                    ),
                    const CreateRoomHeading(title: LKeys.roomName),
                    MyTextField(
                        controller: controller.titleTextController,
                        placeHolder: "Nature Lover"),
                    GetBuilder<CreateRoomController>(
                        init: controller,
                        id: controller.descriptionID,
                        builder: (controller) {
                          return CreateRoomHeading(
                            title: LKeys.shortDescription,
                            bracketText:
                                "(${controller.textDescriptionController.text.length}/${Limits.roomDescCount})",
                          );
                        }),
                    MyTextField(
                      controller: controller.textDescriptionController,
                      placeHolder: LKeys.whatIsYourRoomAbout,
                      isEditor: true,
                      limit: Limits.roomDescCount,
                    ),
                    GetBuilder<CreateRoomController>(
                        id: controller.interestGetID,
                        init: controller,
                        builder: (controller) {
                          return Column(
                            children: [
                              CreateRoomHeading(
                                title: LKeys.selectTag,
                                bracketText:
                                    "(${controller.selectedInterests.length}/${Limits.interestCount})",
                              ),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                alignment: WrapAlignment.center,
                                children:
                                    InterestsController.interests.map((e) {
                                  return InterestTag(
                                      interest: e.title ?? "",
                                      isContain: controller.selectedInterests
                                          .contains(e),
                                      onTap: () {
                                        controller.toggleInterest(e);
                                      });
                                }).toList(),
                              ),
                            ],
                          );
                        }),
                    const SizedBox(height: 50),
                    GetBuilder<CreateRoomController>(
                      init: controller,
                      id: controller.roomGetID,
                      builder: (controller) {
                        return SettingButtonWithSwitch(
                            title: LKeys.makeRoomPublic,
                            desc: LKeys.makeRoomPublicDesc,
                            isOn: controller.visibleToPublic,
                            onChange: controller.toggleMakeRoomPublic);
                      },
                    ),
                    GetBuilder<CreateRoomController>(
                      init: controller,
                      id: controller.joinGetID,
                      builder: (controller) {
                        return SettingButtonWithSwitch(
                            title: LKeys.joinAfterRequest,
                            desc: LKeys.joinAfterRequestDesc,
                            isOn: controller.joinAfterRequest,
                            onChange: controller.toggleJoinAfterReq);
                      },
                    ),
                    const SizedBox(height: 50),
                    SafeArea(
                      top: false,
                      child: CommonButton(
                          text: room == null ? LKeys.createRoom : LKeys.update,
                          onTap: controller.onSubmit),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CreateRoomHeading extends StatelessWidget {
  final String title;
  final String? bracketText;

  const CreateRoomHeading({Key? key, required this.title, this.bracketText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 15),
      child: Row(
        children: [
          Text(
            "${title.tr} ${bracketText ?? ""}",
            style: MyTextStyle.gilroyRegular(),
          ),
        ],
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeHolder;
  final bool isEditor;
  final bool obscureText;
  final Color? color;
  final int? limit;
  final Function(String text)? onChange;

  const MyTextField(
      {Key? key,
      required this.controller,
      required this.placeHolder,
      this.isEditor = false,
      this.color,
      this.limit,
      this.onChange,
      this.obscureText = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isEditor ? 130 : 45,
      decoration: BoxDecoration(
        color: color ?? cLightBg,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: TextField(
        obscureText: obscureText,
        onChanged: onChange,
        textCapitalization: TextCapitalization.sentences,
        expands: isEditor ? true : false,
        minLines: isEditor ? null : 1,
        maxLines: isEditor ? null : 1,
        decoration: InputDecoration(
            hintText: placeHolder.tr,
            hintStyle:
                MyTextStyle.gilroyRegular(color: cLightText.withOpacity(0.6)),
            border: InputBorder.none,
            counterText: '',
            isDense: true,
            contentPadding: const EdgeInsets.all(0)),
        cursorColor: cPrimary,
        maxLength: isEditor ? limit : null,
        style: MyTextStyle.gilroyRegular(color: cLightText),
        controller: controller,
        textInputAction: TextInputAction.newline,
      ),
    );
  }
}
