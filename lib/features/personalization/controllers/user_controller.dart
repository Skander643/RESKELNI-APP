import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/common/widgets/loaders/loaders.dart';
import 'package:e_commerce_app/data/repositories/authentication/authentication_repository.dart';
import 'package:e_commerce_app/data/repositories/user/user_repository.dart';
import 'package:e_commerce_app/features/authentication/models/user_model.dart';
import 'package:e_commerce_app/features/authentication/screens/login/login.dart';
import 'package:e_commerce_app/features/personalization/screens/profile/widgets/re_autheticate_user_login_form.dart';
import 'package:e_commerce_app/utils/constants/image_strings.dart';
import 'package:e_commerce_app/utils/constants/sizes.dart';
import 'package:e_commerce_app/utils/helpers/network_manager.dart';
import 'package:e_commerce_app/utils/popups/full_screen_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends GetxController {
  static UserController get instance => Get.put(UserController());

  Rx<UserModel> user = UserModel.empty().obs;
  final userRepository = Get.put(UserRepository());

  final Rx<int> selectedIndex = 0.obs;
   Rx<String?> role = Rx<String?>(null);
  final hidePassword = false.obs;
  final imageUploading = false.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  GlobalKey<FormState> reauthFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();

  }

Future<String?> fetchUserRoleFromFirebase(String userId) async {
  try {
    // Référence à la collection Consommateurs dans Firestore
    final consumerDoc = await FirebaseFirestore.instance.collection('Consommateurs').doc(userId).get();
    if (consumerDoc.exists) {
      // Si le document de l'utilisateur existe dans la collection Consommateurs, récupérer son rôle
      final userData = consumerDoc.data() as Map<String, dynamic>;
      final role = userData['Role'] as String?;
      return role;
    }

    // Référence à la collection Centres dans Firestore
    final centerDoc = await FirebaseFirestore.instance.collection('Centres').doc(userId).get();
    if (centerDoc.exists) {
      // Si le document de l'utilisateur existe dans la collection Centres, récupérer son rôle
      final userData = centerDoc.data() as Map<String, dynamic>;
      final role = userData['Role'] as String?;
      return role;
    }

    // Le document de l'utilisateur n'existe pas dans les collections Consommateurs ou Centres
    print('Le document de l\'utilisateur avec l\'ID $userId n\'existe pas dans les collections Consommateurs ou Centres.');
    return null;
  } catch (e) {
    // Une erreur s'est produite lors de la récupération du rôle de Firebase
    print('Erreur lors de la récupération du rôle depuis Firebase: $e');
    return null;
  }
}

Future<String?> fetchUserRole() async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;

      // Référence à la collection Consommateurs dans Firestore
      final consumerDoc = await FirebaseFirestore.instance
          .collection('Consommateurs')
          .doc(userId)
          .get();
      if (consumerDoc.exists) {
        // Si le document de l'utilisateur existe dans la collection Consommateurs, récupérer son rôle
        final userData = consumerDoc.data() as Map<String, dynamic>;
        final role = userData['Role'] as String?;
        return role;
      }

      // Référence à la collection Centres dans Firestore
      final centerDoc = await FirebaseFirestore.instance
          .collection('Centres')
          .doc(userId)
          .get();
      if (centerDoc.exists) {
        // Si le document de l'utilisateur existe dans la collection Centres, récupérer son rôle
        final userData = centerDoc.data() as Map<String, dynamic>;
        final role = userData['Role'] as String?;
        return role;
      }

      // Le document de l'utilisateur n'existe pas dans les collections Consommateurs ou Centres
      print(
          'Le document de l\'utilisateur avec l\'ID $userId n\'existe pas dans les collections Consommateurs ou Centres.');
      return null;
    } catch (e) {
      // Une erreur s'est produite lors de la récupération du rôle de Firebase
      print('Erreur lors de la récupération du rôle depuis Firebase: $e');
      return null;
    }
  }






Future<void> fetchUserRecord() async {
    try {
      final user = await userRepository.fetchUserDetails(AuthenticationRepository.instance.authUser!.uid);
      final role = await fetchUserRoleFromFirebase(
          user.id); // Récupérer le rôle depuis Firebase
      user.role = role!; // Mettre à jour le rôle dans le modèle d'utilisateur
      this.user(user);
    } catch (e) {
      user(UserModel.empty());
    }
  }


  Future<void> saveUserRecord(UserCredential? userCredential) async {
    try {
      if (userCredential != null) {
        final nameParts =
            UserModel.generateUsername(userCredential.user!.displayName ?? '');

        // Map Data
        final user = UserModel(
          id: userCredential.user!.uid,
          name: nameParts,
          role: '',
          adress: '',
          solde: 0.0,
          email: userCredential.user!.email ?? "",
          profilePicture: userCredential.user!.photoURL ?? "",
        );

        // Save user data
        await userRepository.saveUserRecord(user);
      }
    } catch (e) {
      TLoaders.warningSnackBar(
        title: 'Données non sauvegardées',
        message:
            "Une erreur s’est produite lors de l’enregistrement de vos informations. Vous pouvez réenregistrer vos données dans votre profil.",
      );
    }
  }

  /// Delete Accound Warning
  void deleteAccoundWarningPopup() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(TSizes.md),
      title: 'Supprimer le compte',
      middleText:
          'Êtes-vous sûr de vouloir supprimer définitivement votre compte ? Cette action n’est pas réversible et toutes vos données seront définitivement supprimées ',
      confirm: ElevatedButton(
        onPressed: () async => deleteUserAccount(),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            side: const BorderSide(color: Colors.red)),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
          child: Text("Supprimer"),
        ),
      ),
      cancel: OutlinedButton(
          onPressed: () => Navigator.of(Get.overlayContext!).pop(),
          child: const Text("Annuler")),
    );
  }

  // Delete User account
  void deleteUserAccount() async {
    try {
      TFullScreenLoader.openLoadingDialog('Traitement', TImages.docerAnimation);

      // First re_authenticate user
      final auth = Get.put(AuthenticationRepository());
      final provider =
          auth.authUser!.providerData.map((e) => e.providerId).first;
      if (provider.isNotEmpty) {
        TFullScreenLoader.stopLoading();
        Get.to(() => const ReAuthLoginForm());
      }
    } catch (e) {
      TLoaders.warningSnackBar(title: 'Oh claquement', message: e.toString());
    }
  }

  // RE_authenticate before deleting
  Future<void> reAuthenticateEmailAndPasswordUser() async {
    try {
      TFullScreenLoader.openLoadingDialog('Traitement', TImages.docerAnimation);

      // Check Internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (!reauthFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance
          .reAuthenticateWithEmailAndPassword(
              verifyEmail.text.trim(), verifyPassword.text.trim());
      await AuthenticationRepository.instance.deleteAccount();
      TFullScreenLoader.stopLoading();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.warningSnackBar(title: 'Oh claquement', message: e.toString());
    }
  }

  // Upload Profile Image
  uploadUserProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          imageQuality: 70,
          maxHeight: 512,
          maxWidth: 512);
      if (image != null) {
        imageUploading.value = true;
        final imageUrl =
            await userRepository.uploadImage('Users/Images/Profile/', image);

        // Update user image record
        Map<String, dynamic> json = {"ProfilePicture": imageUrl};
        await userRepository.updateSingleField(json);

        user.value.profilePicture = imageUrl;
        user.refresh();

        TLoaders.succesSnackBar(
            title: 'Félicitations',
            message: 'Votre image de profil a été mise à jour !');
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh claquement', message: e.toString());
    } finally {
      imageUploading.value = false;
    }
  }
}
