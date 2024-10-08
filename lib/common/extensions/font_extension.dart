import 'package:flutter/material.dart';
import 'package:untitled/utilities/const.dart';

const TextStyle kGilroyHeavy = TextStyle(
  fontFamily: "gilroy_heavy",
  color: cBlack,
  fontSize: 16,
);

class MyTextStyle {
  static TextStyle gilroyBlack({double? size, Color? color}) {
    return TextStyle(
        fontFamily: "gilroy_black",
        color: color ?? cBlack,
        fontSize: size ?? 16);
  }

  static TextStyle gilroyBold({double? size, Color? color}) {
    return TextStyle(
        fontFamily: "gilroy_bold",
        color: color ?? cBlack,
        fontSize: size ?? 16);
  }

  static TextStyle gilroyExtraBold({double? size, Color? color}) {
    return TextStyle(
        fontFamily: "gilroy_extrabold",
        color: color ?? cBlack,
        fontSize: size ?? 16);
  }

  static TextStyle gilroyHeavy({double? size, Color? color}) {
    return TextStyle(
        fontFamily: "gilroy_heavy",
        color: color ?? cBlack,
        fontSize: size ?? 16);
  }

  static TextStyle gilroyLight({double? size, Color? color}) {
    return TextStyle(
        fontFamily: "gilroy_light",
        color: color ?? cBlack,
        fontSize: size ?? 16);
  }

  static TextStyle gilroyMedium({double? size, Color? color}) {
    return TextStyle(
        fontFamily: "gilroy_medium",
        color: color ?? cBlack,
        fontSize: size ?? 16);
  }

  static TextStyle gilroyRegular({double? size, Color? color}) {
    return TextStyle(
        fontFamily: "gilroy_regular",
        color: color ?? cBlack,
        fontSize: size ?? 16);
  }

  static TextStyle gilroySemiBold({double? size, Color? color}) {
    return TextStyle(
        fontFamily: "gilroy_semibold",
        color: color ?? cBlack,
        fontSize: size ?? 16);
  }

  static TextStyle gilroyThin({double? size, Color? color}) {
    return TextStyle(
        fontFamily: "gilroy_thin",
        color: color ?? cBlack,
        fontSize: size ?? 16);
  }
}
