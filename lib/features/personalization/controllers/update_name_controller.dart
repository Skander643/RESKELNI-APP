import 'package:e_commerce_app/common/widgets/loaders/loaders.dart';
import 'package:e_commerce_app/data/repositories/user/user_repository.dart';
import 'package:e_commerce_app/features/personalization/controllers/user_controller.dart';
import 'package:e_commerce_app/features/personalization/screens/profile/profile_consumer.dart';
import 'package:e_commerce_app/features/personalization/screens/profile/profile_recycling.dart';
import 'package:e_commerce_app/utils/constants/image_strings.dart';
import 'package:e_commerce_app/utils/helpers/network_manager.dart';
import 'package:e_commerce_app/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateNameController extends GetxController {
  static UpdateNameController get instance => Get.find();

  final name = TextEditingController();
  final userController = Get.put(UserController());

  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateUserNameFormKey = GlobalKey<FormState>();

  /// init user data when home screen appears
  @override
  void onInit() {
    initializeName();
    super.onInit();
  }

  /// Fech user Record
  Future<void> initializeName() async {
    name.text = userController.user.value.name;
  }

  Future<void> updateUserName() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          'Nous mettons à jour vos informations...', TImages.docerAnimation);

      // Check Internet Connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      /// Form Validation
      if (!updateUserNameFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      /// Update user name in the Firebase Firestore
      Map<String, dynamic> fullName = {'Name': name.text.trim()};
      await userRepository.updateSingleField(fullName);

      // Update the Rx user value
      userController.user.value.name = name.text.trim();
      userController.user.refresh();

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Show Success message
      TLoaders.succesSnackBar(
          title: 'Félicitations', message: 'Votre nom a été mis à jour');

          if(userController.user.value.role == "Consommateur") {
            Get.off(() => const ProfileConsumerScreen());
          }else{
             Get.off(() => const ProfileRecyclingScreen());
          }
      
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh claquement', message: e.toString());
    }
  }
}
