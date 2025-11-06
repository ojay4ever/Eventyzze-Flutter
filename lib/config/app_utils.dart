import 'package:flutter/widgets.dart';

class CustomScreenUtil {
  static late double screenWidth;
  static late double screenHeight;

  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }

  static double width(double value) {
    return (value / 100) * screenWidth;
  }

  static double height(double value) {
    return (value / 100) * screenHeight;
  }
}