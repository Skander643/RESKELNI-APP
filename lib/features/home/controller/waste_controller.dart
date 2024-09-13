import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/common/widgets/loaders/loaders.dart';
import 'package:e_commerce_app/features/home/models/waste.dart';
import 'package:e_commerce_app/features/home/screens/widgets/dechet_list.dart';
import 'package:e_commerce_app/features/personalization/screens/profile/widgets/dechet_accepter_ist.dart';
import 'package:e_commerce_app/features/personalization/screens/profile/widgets/dechet_refuser_list.dart';
import 'package:e_commerce_app/navigation_menu.dart';
import 'package:e_commerce_app/utils/constants/image_strings.dart';
import 'package:e_commerce_app/utils/helpers/network_manager.dart';
import 'package:e_commerce_app/utils/popups/full_screen_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WasteController extends GetxController {
  static WasteController get instance => Get.find();

  final nameController = TextEditingController();
  final prixController = TextEditingController();
  WasteType selectedType = WasteType.menagers;
  final TextEditingController quantityController = TextEditingController();
  // Récupérer l'utilisateur actuellement authentifié
  User? user = FirebaseAuth.instance.currentUser;
  Rx<String> selectedUnit = 'Pièce'.obs;

  List<Waste> dechetList = [];
  List<Waste> dechetAccepterList = [];
  List<Waste> dechetRefuserList = [];

  GlobalKey<FormState> registerWasteKeyForm = GlobalKey<FormState>();

  // Date d'enregistrement (non modifiable)
  String get registrationDate =>
      DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

  final RxDouble totalPrice = RxDouble(0.0);

  @override
  void onInit() {
    super.onInit();
    // Observer les changements dans les champs de prix et de quantité
    prixController.addListener(calculateTotalPrice);
    quantityController.addListener(calculateTotalPrice);
  }

  void calculateTotalPrice() {
    double price = double.tryParse(prixController.text) ?? 0.0;
    int quantity = int.tryParse(quantityController.text) ?? 0;
    totalPrice.value = price * quantity;
  }

  void saveWaste() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          'Nous traitons vos informations...', TImages.docerAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();

      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!registerWasteKeyForm.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      Waste waste = Waste(
        id: FirebaseFirestore.instance.collection('dechets').doc().id,
        name: nameController.text,
        type: selectedType,
        prix: double.parse(prixController.text),
        prixTotal: totalPrice.value,
        quantity: int.parse(quantityController.text),
        registrationDate: DateTime.now(),
        dechetUserId: user!.uid,
        isFavorite: false.obs,
        status: 'en attente'.obs,
        unite: selectedUnit.value,
      );

      // Obtenir le nom de la collection en fonction du type de déchet
      String wasteCollectionName = getCollectionName(selectedType);

      // Ajouter le déchet à la collection correspondante dans Firestore
      await FirebaseFirestore.instance
          .collection('dechets')
          .doc(wasteCollectionName)
          .collection('items')
          .doc(waste.id) // Utilisez doc() pour générer un nouvel ID de document
          .set(waste
              .toMap()); // Utilisez set() pour écraser les données existantes

 

      TFullScreenLoader.stopLoading();

      TLoaders.succesSnackBar(
          title: 'Succès', message: 'Déchet enregistré avec succès');

      // Effacement du formulaire après l'enregistrement du déchet
      clearForm();

      // Retourner à l'écran d'accueil
      Get.off(() => const NavigationMenu());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      print("Error: " + e.toString());
      // Afficher une erreur générique à l'utilisateur
      TLoaders.errorSnackBar(title: 'Oh claquement', message: e.toString());
    }
  }

// Méthode pour récupérer les déchets
  Future<void> recupererWaste() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          'Nous récupérons vos déchets...', TImages.docerAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();

      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Liste temporaire pour stocker les déchets récupérés
      List<Waste> tempList = [];

      for (int i = 0; i < WasteType.values.length; i++) {
        // Obtenir le nom de la collection en fonction du type de déchet
        String wasteCollectionName =
            getCollectionName(WasteType.values.elementAt(i));
        final querySnapshot = await FirebaseFirestore.instance
            .collection('dechets')
            .doc(wasteCollectionName)
            .collection('items')
            .where('dechetUserId', isEqualTo: user!.uid)
            .get();

        // Itérer sur tous les documents récupérés
        for (var doc in querySnapshot.docs) {
          // Convertir chaque document en un objet de déchet
          Waste waste = Waste.fromFirestoreUserId(doc, user!.uid);

          // Vérifier si le déchet n'est pas déjà dans la liste temporaire
          if (!tempList.contains(waste)) {
            // Ajouter le déchet à la liste temporaire
            tempList.add(waste);
          }
        }
      }

      // Mettre à jour la liste des déchets avec la liste temporaire
      dechetList.assignAll(tempList);

      if (dechetList.isEmpty) {
        TFullScreenLoader.stopLoading();
        TLoaders.warningSnackBar(
            title: 'Vide', message: 'Aucun déchets enregistrés');
        Get.to(() => const DechetList());
      } else {
        TFullScreenLoader.stopLoading();

        TLoaders.succesSnackBar(
            title: 'Succès', message: 'Déchet récupérés avec succès');

        Get.to(() => const DechetList());
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Erreur', message: e.toString());
    }
  }

  Future<void> recupererWasteAccepter() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          'Nous récupérons vos déchets acceptées...', TImages.docerAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();

      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Liste temporaire pour stocker les déchets récupérés
      List<Waste> tempListAceepter = [];

      for (int i = 0; i < WasteType.values.length; i++) {
        // Obtenir le nom de la collection en fonction du type de déchet
        String wasteCollectionName =
            getCollectionName(WasteType.values.elementAt(i));
        final querySnapshot = await FirebaseFirestore.instance
            .collection('dechets')
            .doc(wasteCollectionName)
            .collection('items')
            .where('status', isEqualTo: 'accepté')
            .get();

        // Itérer sur tous les documents récupérés
        for (var doc in querySnapshot.docs) {
          // Convertir chaque document en un objet de déchet
          Waste waste = Waste.fromFirestoreUserId(doc, user!.uid);

          // Vérifier si le déchet n'est pas déjà dans la liste temporaire
          if (!tempListAceepter.contains(waste)) {
            // Ajouter le déchet à la liste temporaire
            tempListAceepter.add(waste);
          }
        }
      }

      // Mettre à jour la liste des déchets avec la liste temporaire
      dechetAccepterList.assignAll(tempListAceepter);

      if (dechetAccepterList.isEmpty) {
        TFullScreenLoader.stopLoading();
        TLoaders.warningSnackBar(
            title: 'Vide', message: 'Aucun déchets acceptés !');
        Get.to(() => const DechetAccepterList());
      } else {
        TFullScreenLoader.stopLoading();

        TLoaders.succesSnackBar(
            title: 'Succès',
            message: 'Les déchets acceptés récupérés avec succès');

        Get.to(() => const DechetAccepterList());
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Erreur', message: e.toString());
    }
  }

  Future<void> recupererWasteRefuser() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          'Nous récupérons vos déchets refusés...', TImages.docerAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();

      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Liste temporaire pour stocker les déchets récupérés
      List<Waste> tempListRefuser = [];

      for (int i = 0; i < WasteType.values.length; i++) {
        // Obtenir le nom de la collection en fonction du type de déchet
        String wasteCollectionName =
            getCollectionName(WasteType.values.elementAt(i));
        final querySnapshot = await FirebaseFirestore.instance
            .collection('dechets')
            .doc(wasteCollectionName)
            .collection('items')
            .where('status', isEqualTo: 'refusé')
            .get();

        // Itérer sur tous les documents récupérés
        for (var doc in querySnapshot.docs) {
          // Convertir chaque document en un objet de déchet
          Waste waste = Waste.fromFirestoreUserId(doc, user!.uid);

          // Vérifier si le déchet n'est pas déjà dans la liste temporaire
          if (!tempListRefuser.contains(waste)) {
            // Ajouter le déchet à la liste temporaire
            tempListRefuser.add(waste);
          }
        }
      }

      // Mettre à jour la liste des déchets avec la liste temporaire
      dechetRefuserList.assignAll(tempListRefuser);

      if (dechetRefuserList.isEmpty) {
        TFullScreenLoader.stopLoading();
        TLoaders.warningSnackBar(
            title: 'Vide', message: 'Aucun déchets refusés');
        Get.to(() => const DechetRefuserList());
      } else {
        TFullScreenLoader.stopLoading();

        TLoaders.succesSnackBar(
            title: 'Succès',
            message: 'Les déchets refusés récupérés avec succès');

        Get.to(() => const DechetRefuserList());
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Erreur', message: e.toString());
    }
  }

  // Méthode pour obtenir le nom de la collection en fonction du type de déchet
  String getCollectionName(WasteType type) {
    switch (type) {
      case WasteType.menagers:
        return 'Déchets_ménagers';
      case WasteType.industriels:
        return 'Déchets_industriels';
      case WasteType.dangereux:
        return 'Déchets_dangereux';
      case WasteType.organiques:
        return 'Déchets_organiques';
      case WasteType.electroniques:
        return 'Déchets_électroniques';
      case WasteType.construction_et_demolition:
        return 'Déchets_construction_et_demolition';
      case WasteType.radioactifs:
        return 'Déchets_radioactifs';
      case WasteType.verts:
        return 'Déchets_verts';
      default:
        return 'Autres';
    }
  }

  void clearForm() {
    nameController.clear();
    selectedType = WasteType.menagers;
    quantityController.clear();
    prixController.clear();
    quantityController.clear();
  }

  String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer la quantité de déchet';
    } else if (value.contains('.') || value.endsWith('.0')) {
      return 'Veuillez entrer un nombre entier pour la quantité de déchet';
    }
    if (value == '0') {
      return 'La quantité de déchet ne peut pas être zéro';
    }
    return null;
  }
}
