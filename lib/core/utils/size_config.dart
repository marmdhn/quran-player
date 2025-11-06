import 'package:flutter/widgets.dart';

class SizeConfig {
  static late double screenWidth;
  static late double screenHeight;

  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;
  }

  static double width(double fraction) => screenWidth * fraction;

  static double height(double fraction) => screenHeight * fraction;

  static double text(double fraction) => screenWidth * fraction;
}
