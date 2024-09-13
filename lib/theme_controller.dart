import 'package:e_commerce_app/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  static ThemeController get instance => Get.find();
  Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  void toggleTheme() {
    themeMode.value =
        themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  ThemeData getTheme() {
    return themeMode.value == ThemeMode.light ? lightTheme : darkTheme;
  }

  ThemeData get lightTheme {
    return TAppTheme.lightTheme;
  }

  ThemeData get darkTheme {
    return TAppTheme.darkTheme;
  }
}
