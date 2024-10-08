import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/screens/extra_views/top_bar.dart';
import 'package:untitled/screens/feed_screen/feed_screen.dart';
import 'package:untitled/screens/tag_screen/tag_controller.dart';

class TagScreen extends StatelessWidget {
  final String tag;

  const TagScreen({Key? key, required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = TagController(replaceCharAt(tag, 0, ''));
    return Scaffold(
      body: Column(
        children: [
          TopBarForInView(title: tag),
          Expanded(
            child: GetBuilder(
              init: controller,
              builder: (controller) {
                return FeedsView(
                  controller: controller,
                  id: 'tag_$tag',
                );
              },
            ),
          )
        ],
      ),
    );
  }

  String replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) +
        newChar +
        oldString.substring(index + 1);
  }
}
