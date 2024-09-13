import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/common/widgets/loaders/loaders.dart';
import 'package:e_commerce_app/features/home/models/waste.dart';
import 'package:e_commerce_app/utils/constants/image_strings.dart';
import 'package:e_commerce_app/utils/helpers/network_manager.dart';
import 'package:e_commerce_app/utils/popups/full_screen_loader.dart';
import 'package:get/get.dart';

class FavorisScreenController extends GetxController {
  static FavorisScreenController get instance => Get.put(FavorisScreenController());



  // Liste observable pour stocker les déchets favoris
  RxList<Waste> favoriteDechets = <Waste>[].obs;
  RxList<Waste> dechetAccepter = <Waste>[].obs;


  // Booléen pour indiquer si les données sont en cours de chargement
  RxBool isLoading = true.obs;

  Future<void> recuperDechetsFavoris() async {
    try {
      // Réinitialiser la liste des déchets à chaque nouvelle récupération
      favoriteDechets.clear();
      isLoading(true);

      // Récupérer tous les types de déchets
      List<WasteType> allWasteTypes = WasteType.values;

      // Itérer sur tous les types de déchets
      for (var wasteType in allWasteTypes) {
        // Récupérer le nom de la collection correspondant au type de déchet
        String collectionName = getCollectionName(wasteType);

        // Récupérer tous les déchets du type actuel
        final querySnapshot =
            await FirebaseFirestore.instance.collection('dechets').doc(collectionName).collection('items').get();

        // Itérer sur les documents récupérés
        for (var doc in querySnapshot.docs) {
          // Convertir chaque document en un objet de déchet
          Waste waste =
              Waste.fromFirestoreSansUser(doc);

          // Vérifier si le déchet est favori
          if (waste.isFavorite.value) {
            // Ajouter le déchet à la liste des déchets favoris
            favoriteDechets.add(waste);
          }
        }
      }

      isLoading(false);
    } catch (e) {
      // Gérer les erreurs éventuelles
      TLoaders.errorSnackBar(title: 'Erreur', message: e.toString());
    }
  }
  Future<void> recuperDechetsAccepter() async {
    try {

      // Start Loading
      TFullScreenLoader.openLoadingDialog('Nous récupérons vos déchets...', TImages.docerAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();

      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }
      // Réinitialiser la liste des déchets à chaque nouvelle récupération
      dechetAccepter.clear();

      // Récupérer tous les types de déchets
      List<WasteType> allWasteTypes = WasteType.values;

      // Itérer sur tous les types de déchets
      for (var wasteType in allWasteTypes) {
        // Récupérer le nom de la collection correspondant au type de déchet
        String collectionName = getCollectionName(wasteType);

        // Récupérer tous les déchets du type actuel
        final querySnapshot = await FirebaseFirestore.instance
            .collection('dechets')
            .doc(collectionName)
            .collection('items')
            .get();

       for (var doc in querySnapshot.docs) {
          // Convertir chaque document en un objet de déchet
          Waste waste =
              Waste.fromFirestoreSansUser(doc);

          // Vérifier si le déchet est accepté
          if (waste.status.value == 'accepté') {
            // Ajouter le déchet à la liste des déchets acceptés
            dechetAccepter.add(waste);
          }
        }

      }
    } catch (e) {
      // Gérer les erreurs éventuelles
      TLoaders.errorSnackBar(title: 'Erreur', message: e.toString());
    }
  }

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


  // Méthode pour ajouter un déchet favori à la liste
  void addToFavorites(Waste waste) {
    favoriteDechets.add(waste);
  }

  // Méthode pour supprimer un déchet favori de la liste
  void removeFromFavorites(Waste waste) {
    favoriteDechets.remove(waste);
  }

  @override
  void onInit() {
    super.onInit();
    recuperDechetsFavoris();
  }
}
