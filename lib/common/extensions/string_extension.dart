import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension S on String {
  Text toTextTR(TextStyle style) {
    return Text(
      tr,
      textAlign: TextAlign.center,
      style: style,
    );
  }
}
