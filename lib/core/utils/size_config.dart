import 'package:flutter/material.dart';

// Figma design canvas: 390 × 887.59 logical pixels
class SizeConfig {
  static double _screenWidth = 390;
  static double _screenHeight = 887.59;

  static const double _designWidth = 390;
  static const double _designHeight = 887.59;

  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _screenWidth = size.width;
    _screenHeight = size.height;
  }

  static double w(double val) => val * (_screenWidth / _designWidth);
  static double h(double val) => val * (_screenHeight / _designHeight);
  static double sp(double val) => val * (_screenWidth / _designWidth);
  static double r(double val) => val * (_screenWidth / _designWidth);
}

extension SizeExt on num {
  double get w => SizeConfig.w(toDouble());
  double get h => SizeConfig.h(toDouble());
  double get sp => SizeConfig.sp(toDouble());
  double get r => SizeConfig.r(toDouble());
}
