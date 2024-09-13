// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/common/widgets/loaders/loaders.dart';
import 'package:e_commerce_app/features/home/models/waste.dart';
import 'package:e_commerce_app/features/notification/models/notification.dart';
import 'package:e_commerce_app/features/personalization/controllers/user_controller.dart';
import 'package:e_commerce_app/features/produits_recommender/models/produit.dart';
import 'package:e_commerce_app/features/produits_recommender/screens/product_screen.dart';
import 'package:e_commerce_app/features/produits_recommender/screens/view_product.dart';
import 'package:e_commerce_app/navigation_menu.dart';
import 'package:e_commerce_app/utils/constants/image_strings.dart';
import 'package:e_commerce_app/utils/constants/sizes.dart';
import 'package:e_commerce_app/utils/helpers/network_manager.dart';
import 'package:e_commerce_app/utils/popups/full_screen_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  User? user = FirebaseAuth.instance.currentUser;
  final RxBool isImageSelected = false.obs;
  final Rx<String?> image = Rx<String?>(null);
  GlobalKey<FormState> addProductKeyForm = GlobalKey<FormState>();
  WasteType selectedType = WasteType.menagers;
  RxList<Produit> produits = <Produit>[].obs;
  RxList<Produit> produitsCenter = <Produit>[].obs;
  bool isImagePickerActive = false;
  final userController = Get.put(UserController());

  Future<void> getImage(ImageSource source) async {
    if (!isImagePickerActive) {
      isImagePickerActive = true;
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
          imageQuality: 70,
        );
        if (pickedFile != null) {
          final imageUrl = await uploadImageToFirebase(pickedFile);
          if (imageUrl != null) {
            image.value = imageUrl;
            isImageSelected.value = true;
          } else {
            print("Erreur lors de l'upload de l'image");
          }
        } else {
          print('Aucune image sélectionnée');
        }
      } catch (e) {
        print("Erreur lors de la récupération de l'image: $e");
      } finally {
        isImagePickerActive = false;
      }
    } else {
      print("Le sélecteur d'image est déjà actif");
    }
  }

  Future<String?> uploadImageToFirebase(XFile imageFile) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('Produits')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(File(imageFile.path));
      return await ref.getDownloadURL();
    } catch (e) {
      print("Erreur lors du téléchargement de l'image: $e");
      return null;
    }
  }

  Future<void> addProduct() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Nous traitons vos informations...', TImages.docerAnimation);
           // Effacement du formulaire après l'enregistrement du produit
    
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }
      // Vérification si l'image est sélectionnée
      if (!isImageSelected.value) {
        TFullScreenLoader.stopLoading();
        Get.showSnackbar(const GetSnackBar(
          message: 'Veuillez sélectionner une image.',
          duration: Duration(seconds: 2),
        ));
        return;
      }

      if (!addProductKeyForm.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }
// Créer le produit avec l'ID du document nouvellement ajouté
      Produit produit = Produit(
        // Correction : déclarez la variable produit ici
        id: FirebaseFirestore.instance.collection('Produits').doc().id,
        name: nameController.text,
        wasteType: selectedType,
        price: double.parse(priceController.text),
        centerId: user!.uid,
        imageUrl: image.value ?? '',
        centerName: userController.user.value.name
      );
      // Ajouter le produit à la collection de produits
      final productRef = await FirebaseFirestore.instance
          .collection('Produits')
          .add(produit
              .toMap()); // Correction : utilisez produit à la place de produit

      // Récupérer l'ID du document nouvellement ajouté
      final productId = productRef.id;

      // Mettre à jour le produit avec l'ID
      await productRef.update({'id': productId});

      TFullScreenLoader.stopLoading();
      TLoaders.succesSnackBar(
          title: 'Succès', message: 'Produit ajouté avec succès');

      // Effacement du formulaire après l'enregistrement du produit
      clearForm();
      Get.off(() => const NavigationMenu());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh claquement', message: e.toString());
    }
  }

  Future<void> getProducts() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Chargement des produits en cours...', TImages.docerAnimation);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }
      final querySnapshot =
          await FirebaseFirestore.instance.collection('Produits').get();
      List<Produit> tempList = [];
      for (var doc in querySnapshot.docs) {
        final produit = Produit.fromSnapshot(doc);
      
        if (!tempList.contains(produit)) {
          tempList.add(produit);
        }
      }
      produits.assignAll(tempList);
      if (produits.isEmpty) {
        TFullScreenLoader.stopLoading();
        TLoaders.warningSnackBar(
            title: 'Info', message: 'Aucun produit trouvé.');
        Get.to(() => const ProductScreen());
      } else {
        TFullScreenLoader.stopLoading();
        Get.to(() => const ProductScreen());
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Erreur', message: e.toString());
    }
  }

  Future<void> getProductsCenter(String centerId) async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Recupération de votre produits en cours...', TImages.docerAnimation);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Produits')
          .where('centerId', isEqualTo: centerId)
          .get();
      List<Produit> tempList = [];
      for (var doc in querySnapshot.docs) {
        final produit = Produit.fromSnapshot(doc);

        if (!tempList.contains(produit)) {
          tempList.add(produit);
        }
      }
      produitsCenter.assignAll(tempList);
      if (produitsCenter.isEmpty) {
        TFullScreenLoader.stopLoading();
        TLoaders.warningSnackBar(
            title: 'Vide', message: 'Aucun produit enregistré.');
        Get.to(() => ViewProduct(
              id: centerId,
            ));
      } else {
        TFullScreenLoader.stopLoading();
        Get.to(() => ViewProduct(
              id: centerId,
            ));
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Erreur', message: e.toString());
    }
  }

  Future<void> saveNotificationToFirestore(
      NotificationModel notification) async {
    try {
      // Référence à la collection 'notifications' dans Firestore
      CollectionReference notifications =
          FirebaseFirestore.instance.collection('notifications');

      // Ajouter la notification à la collection
      await notifications.add(notification.toMap());
    } catch (e) {
      // Gérer les erreurs éventuelles
      print('Erreur lors de l\'enregistrement de la notification : $e');
    }
  }

// Méthode pour envoyer une notification à un utilisateur et enregistrer la notification dans Firebase
  Future<void> sendNotificationToUser(
      String userId, String title, String body) async {
    try {
      // Récupérer le jeton (token) de l'utilisateur à partir de la base de données Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('Centres')
          .doc(userId)
          .get();
      final userToken = userDoc.data()?['Token'];

      if (userToken == null) {
        // Gérer le cas où le jeton de l'utilisateur n'est pas trouvé
        print('Le jeton de l\'utilisateur $userId est introuvable');
        return;
      }

      // Construire le message de notification
      final Map<String, dynamic> message = {
        'notification': {
          'title': title,
          'body': body,
        },
        'to': userToken,
      };

      // Envoyer la notification à l'utilisateur en utilisant Firebase Cloud Messaging (FCM)
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAwZRewxI:APA91bFUiLd9ZeNOoSFTwF8xrmSdiJS3HTcodw-wHNPXgqJcUV-nZaLWbN8it2zBk50f-SYivJ150QgE59AvXs7IUWNHjd88X1YJOaY6ZcwcQGFWo5-WiV1Xjj6mvdSNAEWBP7xqGH8M', // Remplacez YOUR_SERVER_KEY par votre clé de serveur FCM
        },
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        // Imprimer un message indiquant que la notification a été envoyée avec succès à l'utilisateur
        print('Notification envoyée avec succès à l\'utilisateur $userId');

        // Enregistrer la notification dans Firebase Firestore
        await saveNotificationToFirestore(
          NotificationModel(
            showNotif: false.obs,
            userId:
                userId, // Utilisez l'ID de l'utilisateur comme identifiant de la notification
            title: title,
            body: body,
            timestamp: DateTime
                .now(), // Utilisez le timestamp actuel comme timestamp de la notification
          ),
        );
      } else {
        // Gérer les erreurs liées à l'envoi de la notification
        print("Erreur lors de l'envoi de la notification : ${response.body}");
      }
    } catch (e) {
      // Gérer les erreurs éventuelles
      print("Erreur lors de l'envoi de la notification : $e");
    }
  }

  Future<void> acheterProduit(Produit produit) async {
    try {
      // Vérifier si le solde de l'utilisateur est suffisant pour acheter le produit
      if (userController.user.value.solde >= produit.price) {
        // Décrémenter le solde de l'utilisateur connecté par le prix du produit acheté
        final nouveauSoldeUtilisateur =
            userController.user.value.solde -= produit.price;

        // Mettre à jour le solde de l'utilisateur
        await FirebaseFirestore.instance
            .collection('Consommateurs')
            .doc(user!.uid)
            .update({'Solde': nouveauSoldeUtilisateur});

        // Incrémenter le solde du centre qui a ajouté ce produit
        final centerId = produit.centerId;
        final centerDoc = await FirebaseFirestore.instance
            .collection('Centres')
            .doc(centerId)
            .get();

        if (centerDoc.exists) {
          final soldeActuelCenter = centerDoc.data()?['Solde'] ?? 0.0;
          final nouveauSoldeCenter = soldeActuelCenter + produit.price;

          // Mettre à jour le solde du centre
          await centerDoc.reference.update({'Solde': nouveauSoldeCenter});

          // Envoyer une notification au token de notification du centre
          await sendNotificationToUser(
            centerId,
            'Produit acheté',
            'Votre produit ${produit.name} a été acheté par le consommateur ${userController.user.value.name}.',
          );
        }

        // Supprimer le produit de la base de données une fois qu'il a été acheté
        await FirebaseFirestore.instance
            .collection('Produits')
            .doc(produit.id)
            .delete();

        TLoaders.succesSnackBar(title: "Produit Acheté");
        Get.off(() => const NavigationMenu());
      } else {
        TLoaders.warningSnackBar(title: "Votre solde est insuffisant");
      }
    } catch (e) {
      print("Erreur lors de l'achat du produit : $e");
      TLoaders.errorSnackBar(title: 'Erreur', message: e.toString());
    }
  }

  void clearForm() {
    nameController.clear();
    selectedType = WasteType.menagers;
    priceController.clear();
    image.value = null;
  }

  /// Delete Accound Warning
  void deleteProductWarningPopup(Produit product) {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(TSizes.md),
      title: 'Supprimer le produit',
      middleText:
          'Êtes-vous sûr de vouloir supprimer définitivement votre produit ?',
      confirm: ElevatedButton(
        onPressed: () async => deleteProduct(product),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            side: const BorderSide(color: Colors.red)),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
          child: Text("Supprimer"),
        ),
      ),
      cancel: OutlinedButton(
          onPressed: () => Get.back(), child: const Text("Annuler")),
    );
  }

  void deleteProduct(Produit product) async {
    try {
      TFullScreenLoader.openLoadingDialog('Traitement', TImages.docerAnimation);
      // Delete the product document from Firestore
      await FirebaseFirestore.instance
          .collection(
              'Produits') // Replace 'products' with your collection name
          .doc(product.id)
          .delete();
      // Remove the product from the local list
      produitsCenter.remove(product);

      TLoaders.succesSnackBar(
          title: 'Succès', message: 'Le produit a été supprimé avec succés');

      TFullScreenLoader.stopLoading();
      getProductsCenter(product.centerId);
    } catch (e) {
      // Show an error message
      Get.snackbar(
          'Erreur', 'Une erreur est survenue lors de la suppression du produit',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

void populateFields(Produit produit) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      nameController.text = produit.name;
      priceController.text = produit.price.toString();
      selectedType = produit.wasteType;
      image.value = produit.imageUrl;
    });
  }


  Future<void> updateProduct(Produit produit) async {
      try {
        TFullScreenLoader.openLoadingDialog(
            'Traitement', TImages.docerAnimation);

        // Log initial des valeurs
        print('Mise à jour du produit avec les valeurs suivantes:');
        print('Nom: ${nameController.text}');
        print('Prix: ${priceController.text}');
        print('Type de déchet: $selectedType');
        print(
            'Image URL: ${isImageSelected.value ? image.value : produit.imageUrl}');
        Produit produitUpdate = Produit(
            name: nameController.text,
            imageUrl: image.value!,
            price: double.parse(priceController.text),
            wasteType: selectedType,
            id: produit.id,
            centerId: produit.centerId,
            centerName: userController.user.value.name
            );

        // Mettre à jour le document du produit dans Firestore
        await FirebaseFirestore.instance
            .collection('Produits')
            .doc(produitUpdate.id)
            .update(produitUpdate.toMap());

        // Mettre à jour la liste locale
        int index = produitsCenter.indexWhere((p) => p.id == produitUpdate.id);
        if (index != -1) {
          produitsCenter[index] = produitUpdate;
          update();
        }

        TFullScreenLoader.stopLoading();
        TLoaders.succesSnackBar(
            title: 'Succès',
            message: 'Le produit a été mis à jour avec succès');
        getProductsCenter(produit.centerId); // Ferme la page de modification
      } catch (e) {
        // Afficher l'erreur dans la console
        print('Erreur lors de la mise à jour du produit: $e');

        TFullScreenLoader.stopLoading();
        Get.snackbar('Erreur',
            'Une erreur est survenue lors de la mise à jour du produit',
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  
}
