import 'package:e_commerce_app/bindings/general_binding.dart';
import 'package:e_commerce_app/theme_controller.dart';
import 'package:e_commerce_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ThemeController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: controller.themeMode.value,
      theme: controller.lightTheme,
      darkTheme: controller.darkTheme,
      initialBinding: GeneralBindings(),

      /// Show Leader or Circular Progress Indicator meanwhile Authentication Repository is deciding to show relevant screen
      home: const Scaffold(
        backgroundColor: TColors.primary,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
   
}

