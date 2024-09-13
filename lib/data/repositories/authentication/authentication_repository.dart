import 'package:e_commerce_app/data/repositories/user/user_repository.dart';
import 'package:e_commerce_app/features/authentication/screens/login/login.dart';
import 'package:e_commerce_app/features/authentication/screens/onboarding/onboarding.dart';
import 'package:e_commerce_app/features/authentication/screens/signup/verify_email.dart';
import 'package:e_commerce_app/navigation_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  /// Varibales
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  // Get authenticated user data
  User? get authUser => _auth.currentUser;


  /// Called from main.dart on app launch
  @override
  void onReady() async {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  /// Function to Show Relevant Screen
  screenRedirect() async {
    final user = _auth.currentUser;
    if (user == null) {
      // Local Storage
      deviceStorage.writeIfNull('IsFirstTime', true);
      deviceStorage.read('IsFirstTime') != true
          ? Get.offAll(() => const LoginScreen())
          : Get.offAll(() => const OnBoardingScreen());
    } else {
      if (user.emailVerified) {
        Get.offAll(() => const NavigationMenu( ));
      } else {
        Get.offAll(() => VerifyEmailScreen(
              email: _auth.currentUser?.email,
            ));
      }
    }
  }

  /* ------------------------------ Email & Password sign-in ------------------------ */

  /// [EmailAuthentication] - SignIn
  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      throw 'Quelque chose s’est mal passé, Veuillez réessayer';
    }
  }

  /// [EmailAuthentication] - Register
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      throw 'Quelque chose s’est mal passé, Veuillez réessayer';
    }
  }

  /// [EmailVerification] - Mail Verification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      throw 'Quelque chose s’est mal passé, Veuillez réessayer';
    }
  }

  /// [EmailAuthentication] - Forget Password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw 'Quelque chose s’est mal passé, Veuillez réessayer';
    }
  }

// Fonction pour la déconnexion
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Supprimez le currentUser
      await _auth.currentUser?.delete();
      // Redirigez vers la page de connexion après la déconnexion.
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      throw 'Quelque chose s’est mal passé, Veuillez réessayer';
    }
  }

  /// [ReAuthenticate] - Re Authenticate User
  Future<void> reAuthenticateWithEmailAndPassword(
      String email, String password) async {
    try {
      // Create a credential
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);

      // ReAuthenticate
      await _auth.currentUser!.reauthenticateWithCredential(credential);
    } catch (e) {
      throw 'Quelque chose s’est mal passé, Veuillez réessayer';
    }
  }

  // Delete User - Remove user auth and firestore Account
  Future<void> deleteAccount() async {
    try {
      await UserRepository.instance.removeUserRecord(_auth.currentUser!.uid);
      await _auth.currentUser?.delete();
    } catch (e) {
      throw 'Quelque chose s’est mal passé, Veuillez réessayer';
    }
  }
}
