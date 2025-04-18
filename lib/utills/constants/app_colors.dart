import 'package:flutter/material.dart';

class AppColor {
  static const Color greyColor = Color.fromRGBO(132, 132, 132, 1);
  static const Color greyButtonColor = Color.fromRGBO(217, 217, 217, 1);
  static const Color lightGreyColor = Color(0xffEDF1F3);
  static const Color lightPrimary = Color(0xffFF6C0A);
  static const Color darkPrimary = Color(0xffEB5E00);

  static LinearGradient commonBackgroundGradient = LinearGradient(
    colors: [
      whiteColor,
      Color.fromRGBO(255, 192, 203, 0.3), // Pink with 0.3 opacity
      whiteColor,
    ],
    stops: [0.1, 0.5, 0.8],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  static const Color blackColor = Colors.black;
  static const Color whiteColor = Colors.white;

  static const Color green = Color(0xff24A19C);
  static const Color red = Color(0xffEA4335);
  static const Color yellow = Color(0xffED9611);

  ///Text Colors
  static const Color greyText = Color(0xff6C7278);
  static const Color blueText = Color(0xff2080C6);
}
