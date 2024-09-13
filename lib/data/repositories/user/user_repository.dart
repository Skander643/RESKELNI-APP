import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/data/repositories/authentication/authentication_repository.dart';
import 'package:e_commerce_app/features/authentication/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Function to save user data to Firestore
  Future<void> saveUserRecord(UserModel user) async {
    try {
      if (user.role == "Consommateur") {
        await _db.collection("Consommateurs").doc(user.id).set(user.toJson());
      } else {
        await _db.collection("Centres").doc(user.id).set(user.toJson());
      }
    } catch (e) {
      throw 'Quelque chose s’est mal passé, Veuillez réessayer';
    }
  }

  // Méthode pour mettre à jour le token de l'utilisateur
  Future<void> updateUserToken(String userId, String newToken) async {
   try {
      final documentSnapshotConsom = await _db
          .collection("Consommateurs")
          .doc(userId)
          .get();
      final documentSnapshotCentre = await _db
          .collection("Centres")
          .doc(userId)
          .get();
      if (documentSnapshotConsom.exists) {
        await _db
            .collection("Consommateurs")
            .doc(userId)
            .update({'Token': newToken});
      } else if (documentSnapshotCentre.exists) {
        await _db
            .collection("Centres")
            .doc(userId)
            .update({'Token': newToken});
      }
    } catch (e) {
      throw 'Quelque chose s’est mal passé, Veuillez réessayer';
    }
  }

  // Function to fetch user details based on user ID
  Future<UserModel> fetchUserDetails(String userId) async {
    try {
      final documentSnapshotConsom = await _db
          .collection("Consommateurs")
          .doc(userId)
          .get();
      final documentSnapshotCentre = await _db
          .collection("Centres")
          .doc(userId)
          .get();
      if (documentSnapshotConsom.exists) {
        return UserModel.fromSnapshot(documentSnapshotConsom);
      } else if (documentSnapshotCentre.exists) {
        return UserModel.fromSnapshot(documentSnapshotCentre);
      } else {
        return UserModel.empty();
      }
    } catch (e) {
      throw 'Quelque chose s’est mal passé, Veuillez réessayer';
    }
  }

  // Function to update user data in Firestore
  Future<void> updateUserDetails(UserModel updateUser) async {
    try {
      if (updateUser.role == "Consommateur") {
        await _db
            .collection("Consommateurs")
            .doc(updateUser.id)
            .update(updateUser.toJson());
      } else {
        await _db
            .collection("Centres")
            .doc(updateUser.id)
            .update(updateUser.toJson());
      }
    } catch (e) {
      throw 'Quelque chose s’est mal passé, Veuillez réessayer';
    }
  }

  // Update any field in specific Users Collection
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      final documentSnapshotConsom = await _db
          .collection("Consommateurs")
          .doc(AuthenticationRepository.instance.authUser!.uid)
          .get();
      final documentSnapshotCentre = await _db
          .collection("Centres")
          .doc(AuthenticationRepository.instance.authUser!.uid)
          .get();
      if (documentSnapshotConsom.exists) {
        await _db
            .collection("Consommateurs")
            .doc(AuthenticationRepository.instance.authUser?.uid)
            .update(json);
      } else if (documentSnapshotCentre.exists) {
        await _db
            .collection("Centres")
            .doc(AuthenticationRepository.instance.authUser?.uid)
            .update(json);
      }
    } catch (e) {
      throw 'Quelque chose s’est mal passé, Veuillez réessayer';
    }
  }

  // Function to remove user dat from firestore
  Future<void> removeUserRecord(String userId) async {
    try {
      // Rechercher l'utilisateur dans la collection des consommateurs
      var consumerSnapshot =
          await _db.collection('Consommateurs').doc(userId).get();
      if (consumerSnapshot.exists) {
        await _db.collection('Consommateurs').doc(userId).delete();
        return;
      }

      // Si l'utilisateur n'est pas trouvé dans la collection des consommateurs,
      // rechercher dans la collection des centres de recyclage
      var centerSnapshot = await _db.collection('Centres').doc(userId).get();
      if (centerSnapshot.exists) {
        await _db.collection('Centres').doc(userId).delete();
        return;
      }

      // Si l'utilisateur n'est pas trouvé dans les deux collections, lancer une exception
      throw 'Utilisateur non trouvé';
    } catch (e) {
      throw 'Quelque chose s’est mal passé, Veuillez réessayer';
    }
  }

  // Upload any Image
  Future<String> uploadImage(String path, XFile image) async {
    try {
      final ref = FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      throw 'Quelque chose s’est mal passé, Veuillez réessayer';
    }
  }
}
