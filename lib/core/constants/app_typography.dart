import 'package:flutter/widgets.dart';

class AppTypography {
  static const _baseFontFamily = 'Pretendard';

  // 헤드라인 스타일
  static const headline1 = TextStyle(
    fontFamily: '$_baseFontFamily',
    fontWeight: FontWeight.bold,
    fontSize: 28,
    height: 36 / 28,
    letterSpacing: -2 / 100,
  );

  static const headline2 = TextStyle(
    fontFamily: '$_baseFontFamily',
    fontWeight: FontWeight.bold,
    fontSize: 24,
    height: 32 / 24,
    letterSpacing: -2 / 100,
  );

  static const headline3 = TextStyle(
    fontFamily: '$_baseFontFamily',
    fontWeight: FontWeight.bold,
    fontSize: 20,
    height: 28 / 20,
    letterSpacing: -2 / 100,
  );

  static const headline4 = TextStyle(
    fontFamily: '$_baseFontFamily',
    fontWeight: FontWeight.bold,
    fontSize: 18,
    height: 24 / 18,
    letterSpacing: -2 / 100,
  );

  static const headline5 = TextStyle(
    fontFamily: '$_baseFontFamily',
    fontWeight: FontWeight.bold,
    fontSize: 16,
    height: 24 / 16,
    letterSpacing: -2 / 100,
  );

  static const headline6 = TextStyle(
    fontFamily: '$_baseFontFamily',
    fontWeight: FontWeight.bold,
    fontSize: 14,
    height: 20 / 14,
    letterSpacing: -2 / 100,
  );

  // 바디 텍스트 스타일
  static const body1 = TextStyle(
    fontFamily: '$_baseFontFamily',
    fontWeight: FontWeight.normal,
    fontSize: 16,
    height: 28 / 16,
    letterSpacing: -2 / 100,
  );

  static const body2 = TextStyle(
    fontFamily: '$_baseFontFamily',
    fontWeight: FontWeight.normal,
    fontSize: 14,
    height: 24 / 14,
    letterSpacing: -2 / 100,
  );

  static const body3 = TextStyle(
    fontFamily: '$_baseFontFamily',
    fontWeight: FontWeight.normal,
    fontSize: 12,
    height: 20 / 12,
    letterSpacing: -2 / 100,
  );

  // 버튼 및 라벨 스타일
  static const buttonLabelNormal = TextStyle(
    fontFamily: '$_baseFontFamily',
    fontWeight: FontWeight.w600, // SemiBold
    fontSize: 18,
    height: 24 / 18,
    letterSpacing: -2 / 100,
  );

  static const buttonLabelMedium = TextStyle(
    fontFamily: '$_baseFontFamily',
    fontWeight: FontWeight.w600, // SemiBold
    fontSize: 16,
    height: 20 / 16,
    letterSpacing: -2 / 100,
  );

  static const buttonLabelSmall = TextStyle(
    fontFamily: '$_baseFontFamily',
    fontWeight: FontWeight.w600, // SemiBold
    fontSize: 14,
    height: 16 / 14,
    letterSpacing: -2 / 100,
  );

  static const buttonLabelXSmall = TextStyle(
    fontFamily: '$_baseFontFamily',
    fontWeight: FontWeight.w600, // SemiBold
    fontSize: 12,
    height: 12 / 12,
    letterSpacing: -2 / 100,
  );

  static var caption;
}