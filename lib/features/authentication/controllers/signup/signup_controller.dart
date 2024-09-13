import 'package:e_commerce_app/api/firebase_api.dart';
import 'package:e_commerce_app/common/widgets/loaders/loaders.dart';
import 'package:e_commerce_app/data/repositories/authentication/authentication_repository.dart';
import 'package:e_commerce_app/data/repositories/user/user_repository.dart';
import 'package:e_commerce_app/features/authentication/models/user_model.dart';
import 'package:e_commerce_app/features/authentication/screens/signup/verify_email.dart';
import 'package:e_commerce_app/utils/constants/image_strings.dart';
import 'package:e_commerce_app/utils/helpers/network_manager.dart';
import 'package:e_commerce_app/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  /// Varibales
  String? selectedRole;
  String? selectedAdresse;
  List<String> villes = [
    "Ariana",
    "Béja",
    "Ben Arous",
    "Bizerte",
    "Gabes",
    "Gafsa",
    "Jendouba",
    "Kairouan",
    "Kasserine",
    "Kebili",
    "Manouba",
    "Kef",
    "Mahdia",
    "Médenine",
    "Monastir",
    "Nabeul",
    "Sfax",
    "Sidi Bouzid",
    "Siliana",
    "Sousse",
    "Tataouine",
    "Tozeur",
    "Tunis",
    "Zaghouan"
  ];

  final hidePassword = true.obs; // Observable for hiding/showing password
  final privacyPolice = true.obs; // Observable for privacy policy acceptance
  final email = TextEditingController(); // Controller for email input
  final name = TextEditingController(); // Controller for name input
  final password = TextEditingController(); // Controller for password input

  GlobalKey<FormState> signupFormKey =
      GlobalKey<FormState>(); // Form key for form validation


  /// -- SignUp
  void signup() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          'Nous traitons vos informations...', TImages.docerAnimation);

      // Check Internet Connectivity
      final isConneted = await NetworkManager.instance.isConnected();

      if (!isConneted) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation

      if (!signupFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Privacy Policy check
      if (!privacyPolice.value) {
        TFullScreenLoader.stopLoading();
        TLoaders.warningSnackBar(
            title: 'Accepter la politique de confidentialité',
            message:
                'Pour créer un compte, vous devez accepter la Politique de confidentialité et les Conditions d’utilisation.');
        return;
      }

      
      final token = await FirebaseApi().initNotifications();

      // Register user in the Firebase Authentication & Save user data in the Firebase
      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
              email.text.trim(), password.text.trim());

      // Save authentication user data in the Firebase Firestore
      final newUser = UserModel(
        id: userCredential.user!.uid,
        name: name.text.trim(),
        role: selectedRole!,
        adress: selectedAdresse!,
        email: email.text.trim(),
        profilePicture: '',
        solde: 0.0,
        token : token , 
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      TFullScreenLoader.stopLoading();

      // show Success Message
      TLoaders.succesSnackBar(
          title: 'félicitations',
          message:
              'Votre compte a été créé! Vérifiez l’adresse e-mail pour continuer.');

      // Move to Verify Email Screen
      Get.to(() => VerifyEmailScreen(
            email: email.text.trim(),
          ));
    } catch (e) {
      // Remove Loader
      TFullScreenLoader.stopLoading();
      // Show some Generic Error to the user
      TLoaders.errorSnackBar(title: 'Oh claquement', message: e.toString());
    }
  }
}
