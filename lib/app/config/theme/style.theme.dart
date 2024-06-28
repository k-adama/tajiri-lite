import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Style {
  Style._();

  static const Color grey100 = Color(0xFFE4E4E7);

  /// GRADIANT

  static const LinearGradient btnlinearGradiant = LinearGradient(
    colors: [
      Color(0xFFFFA800),
      Color(0xFFFFA800),
      Color(0xFFFFC300),
    ],
  );

  /// NEW COLOR

  static const Color dark = Color(0xFF565E6B);
  static const Color light = Color(0xFFBCC4D1);
  static const Color brandBlue950 = Color(0xFF00001A);
  static const Color brandBlue50 = Color(0xFFE5E5FF);
  static const Color grey700 = Color(0xFF484951);
  static const Color grey200 = Color(0xFFC9CACF);
  static const Color grey500 = Color(0xFF777986);
  static const Color grey50 = Color(0xFFF1F2F3);
  static const Color grey950 = Color(0xFF0C0C0E);
  static const Color brandColor500 = Color(0xFF0000DD);
  static const Color brandBlue100 = Color(0xFFCCCCFF);
  static const Color brandBlue200 = Color(0xFF9999FF);
  static const Color green = Color(0xFF71C761);
  static const Color yellowLigther = Color(0xFFFFE48C);
  static const Color hintColor = Color(0xFFBABABA);
  static const Color dontHaveAccBtnBack = Color(0xFFF8F8F8);
  static const Color brandColorBlue100 = Color(0xFFCCCCFF);
  static const Color titleDark = Color(0xFF0B0B0B);
  static const Color lighter = Color(0xFFF2F7FF);

  /// OLD COLOR
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Color(0x00FFFFFF);
  static const Color black = Color(0xFF232B2F);
  static const Color mainBack = Color(0xFFF4F4F4);
  static const Color borderColor = Color(0xFFE6E6E6);
  static const Color brandGreen = Color(0xFF83EA00);
  static const Color primaryColor = Color(0xFFFFC200);
  static const Color secondaryColor = Color(0xFF0544A8);
  static const Color textGrey = Color(0xFF898989);
  static const Color red = Color(0xFFFF3D00);
  static Color shimmerBase = Colors.grey.shade300;
  static Color shimmerHighlight = Colors.grey.shade100;
  static const Color selectedItemsText = Color(0xFFA0A09C);
  static const Color grey600 = Color(0xFF60626C);
  static const Color grey300 = Color(0xFFAEAFB7);
  static const Color brandColor50 = Color(0xFFE5E5FF);

  /// dark theme based colors
  static const Color shimmerBaseDark = Color.fromRGBO(117, 117, 117, 0.29);
  static const Color bodyNewColor = Color(0xFFEFF0F7);

  /// font style

  static interBold(
          {double size = 15,
          Color color = Style.black,
          bool isUnderLine = false,
          Color underLineColor = Style.secondaryColor,
          double letterSpacing = 0}) =>
      TextStyle(
          fontFamily: 'Cereal',
          fontSize: size.sp,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: letterSpacing.sp,
          decorationColor: isUnderLine ? underLineColor : Style.white,
          decorationThickness: isUnderLine ? 2 : 0,
          decoration:
              isUnderLine ? TextDecoration.underline : TextDecoration.none);

  static interSemi(
          {double size = 18,
          Color color = Style.black,
          TextDecoration decoration = TextDecoration.none,
          double letterSpacing = 0}) =>
      TextStyle(
          fontFamily: 'Cereal',
          fontSize: size.sp,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: letterSpacing.sp,
          decoration: decoration);

  static TextStyle interNoSemi(
          {double size = 18,
          Color color = Style.black,
          TextDecoration decoration = TextDecoration.none,
          double letterSpacing = 0}) =>
      TextStyle(
          fontFamily: 'Cereal',
          fontSize: size.sp,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: letterSpacing.sp,
          decoration: decoration);

  static interNormal(
          {double size = 16,
          Color color = Style.black,
          FontWeight fontWeight = FontWeight.w400,
          TextDecoration textDecoration = TextDecoration.none,
          bool isUnderLine = false,
          Color underLineColor = Style.secondaryColor,
          double letterSpacing = 0}) =>
      TextStyle(
          fontFamily: 'Cereal',
          fontSize: size.sp,
          fontWeight: fontWeight,
          color: color,
          letterSpacing: letterSpacing.sp,
          decorationColor: isUnderLine ? underLineColor : Style.white,
          decoration:
              isUnderLine ? TextDecoration.underline : TextDecoration.none);

  static interRegular(
          {double size = 16,
          Color color = Style.black,
          TextDecoration textDecoration = TextDecoration.none,
          double letterSpacing = 0}) =>
      TextStyle(
          fontFamily: 'Cereal',
          fontSize: size,
          fontWeight: FontWeight.w400,
          color: color,
          letterSpacing: letterSpacing.sp,
          decoration: textDecoration);
}
