// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

/// This include all text styles according to Deriv theme guideline
class TextStyles {
  static const String appFontFamily = 'IBMPlexSans';

  static TextStyle display1 = TextStyle(
      fontFamily: appFontFamily,
      fontSize: 34,
      height: 1.5,
      fontWeight: FontWeight.normal);

  static TextStyle headline = TextStyle(
      fontFamily: appFontFamily,
      fontSize: 24,
      height: 1.5,
      fontWeight: FontWeight.w700);

  static TextStyle title = TextStyle(
      fontFamily: appFontFamily,
      fontSize: 20,
      height: 1.5,
      fontWeight: FontWeight.w500);

  static TextStyle lightTitle = TextStyle(
      fontFamily: appFontFamily,
      fontSize: 20,
      height: 1.5,
      fontWeight: FontWeight.w300);

  static TextStyle subheading = TextStyle(
      fontFamily: appFontFamily,
      fontSize: 16,
      height: 1.25,
      fontWeight: FontWeight.normal);

  static TextStyle body2 = TextStyle(
      fontFamily: appFontFamily,
      fontSize: 14,
      height: 1.3,
      fontWeight: FontWeight.w500);

  static TextStyle body1Bold = TextStyle(
      fontFamily: appFontFamily,
      fontSize: 14,
      height: 1.3,
      fontWeight: FontWeight.bold);

  static TextStyle body1 = TextStyle(
      fontFamily: appFontFamily,
      fontSize: 14,
      height: 1.3,
      fontWeight: FontWeight.normal);

  static TextStyle caption = TextStyle(
      fontFamily: appFontFamily,
      fontSize: 12,
      height: 1.3,
      fontWeight: FontWeight.normal);

  static TextStyle captionBold = TextStyle(
      fontFamily: appFontFamily,
      fontSize: 12,
      height: 1.3,
      fontWeight: FontWeight.bold);

  static TextStyle button = TextStyle(
      fontFamily: appFontFamily,
      fontSize: 14,
      height: 1,
      fontWeight: FontWeight.w500);
}
