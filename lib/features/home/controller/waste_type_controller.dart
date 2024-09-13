import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/common/widgets/loaders/loaders.dart';
import 'package:e_commerce_app/data/repositories/user/user_repository.dart';
import 'package:e_commerce_app/features/home/models/waste.dart';
import 'package:e_commerce_app/features/home/screens/widgets/dechet_list_type.dart';
import 'package:e_commerce_app/features/notification/models/notification.dart';
import 'package:e_commerce_app/features/personalization/controllers/user_controller.dart';
import 'package:e_commerce_app/utils/constants/image_strings.dart';
import 'package:e_commerce_app/utils/helpers/network_manager.dart';
import 'package:e_commerce_app/utils/popups/full_screen_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WasteTypesController extends GetxController {
  static WasteTypesController get instance => Get.find();

  // Déclaration de la liste observable pour stocker les déchets récupérés
  List<Waste> wasteList = [];

  // Liste pour stocker les déchets favoris
  List<Waste> favoriteDechets = [];

  final userRepository = Get.put(UserRepository());

  final userController = Get.put(UserController());

  RxBool isClikable = false.obs;

  User? user = FirebaseAuth.instance.currentUser;

  // Méthode pour récupérer les déchets correspondant à un type spécifique depuis Firebase
  Future<void> fetchWastesByType(WasteType wasteType) async {
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
      // Réinitialiser la liste des déchets à chaque nouvelle récupération
      wasteList.clear();

      // Récupérer la collection correspondant au type de déchet depuis Firebase
      final querySnapshot = await FirebaseFirestore.instance
          .collection('dechets')
          .doc(getCollectionName(wasteType))
          .collection('items')
          .get();

      // Itérer sur les documents récupérés
      for (var doc in querySnapshot.docs) {
        // Convertir chaque document en un objet de déchet et l'ajouter à la liste des déchets
        wasteList.add(
            Waste.fromFirestoreSansUser(doc));
      }

      if (wasteList.isEmpty) {
        TFullScreenLoader.stopLoading();
        TLoaders.warningSnackBar(
            title: 'Vide', message: 'Aucun ${wasteType.name} enregistrés');
        Get.to(() => DechetListType(
              wasteType: wasteType.name,
            ));
      } else {
        TFullScreenLoader.stopLoading();
        TLoaders.succesSnackBar(
            title: 'Succès',
            message: 'Les ${wasteType.name} récupérés avec succès');
        Get.to(() => DechetListType(
              wasteType: wasteType.name,
            ));
      }
    } catch (e) {
      // Gérer les erreurs éventuelles
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
          .collection('Consommateurs')
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


  Future<void> accepteDechet(Waste waste) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('dechets')
          .doc(getCollectionName(waste.type))
          .collection('items')
          .where('id', isEqualTo: waste.id)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final dechetDocId = querySnapshot.docs.first.id;

        if (userController.user.value.solde >= waste.prixTotal) {
          waste.status.value = 'accepté';
          waste.acceptRefusDate?.value = DateTime.now();

          // Mise à jour des données du déchet dans Firestore
          await FirebaseFirestore.instance
              .collection('dechets')
              .doc(getCollectionName(waste.type))
              .collection('items')
              .doc(dechetDocId)
              .update({
            'status': waste.status.value,
            'acceptRefusDate': Timestamp.now(), // Date d'acceptation
            'acceptRefusCenterId': user!.uid, // ID du centre acceptant
          });

          final soldeApresTrai =
              userController.user.value.solde -= waste.prixTotal;

          // Mettre à jour le solde de l'utilisateur
          Map<String, dynamic> solde = {'Solde': soldeApresTrai};
          await userRepository.updateSingleField(solde);

          // Récupérer la valeur de dechetUserId depuis Firestore
          final dechetDoc = await FirebaseFirestore.instance
              .collection('dechets')
              .doc(getCollectionName(waste.type))
              .collection('items')
              .doc(dechetDocId)
              .get();

          final dechetUserId = dechetDoc.data()?['dechetUserId'];

          if (dechetUserId != null) {
            // Récupérer l'utilisateur correspondant
            final userDoc = await FirebaseFirestore.instance
                .collection('Consommateurs')
                .doc(dechetUserId)
                .get();
            

            if (userDoc.exists) {
              // Mettre à jour le solde de l'utilisateur correspondant
              final double soldeActuelUser = userDoc.data()?['Solde'] ?? 0.0;
              final double nouveauSoldeUser = soldeActuelUser + waste.prixTotal;

              await userDoc.reference.update({'Solde': nouveauSoldeUser});


              final acceptRefusDate =
                  dechetDoc.data()?['acceptRefusDate'] as Timestamp?;
              final formattedDate = acceptRefusDate != null
                  ? DateTime.fromMicrosecondsSinceEpoch(
                      acceptRefusDate.microsecondsSinceEpoch)
                  : null;
              final formattedDateStr = formattedDate != null
                  ? DateFormat('dd/MM/yyyy HH:mm').format(formattedDate)
                  : '';

              // Envoyer la notification à l'utilisateur
              await sendNotificationToUser(
                  dechetUserId,
                  'Le déchet ${waste.name} est accepté',
                  'Votre déchet ${waste.name} a été accepté par le ${userController.user.value.name} le $formattedDateStr.');
            } 
          } else {
            print('La valeur de dechetUserId est nulle');
          }
        } else {
          TLoaders.warningSnackBar(title: "Votre solde est insuffisant");
        }
      }
    } catch (e) {
      print('Erreur lors de la mise à jour du statut du déchet : $e');
    }
  }

  Future<void> refuserDechet(Waste waste) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('dechets')
          .doc(getCollectionName(waste.type))
          .collection('items')
          .where('id', isEqualTo: waste.id)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final dechetDocId = querySnapshot.docs.first.id;

        waste.status.value = 'refusé';
        waste.acceptRefusDate?.value = DateTime.now();

        // Mise à jour des données du déchet dans Firestore
        await FirebaseFirestore.instance
            .collection('dechets')
            .doc(getCollectionName(waste.type))
            .collection('items')
            .doc(dechetDocId)
            .update({
          'status': waste.status.value,
          'acceptRefusDate': Timestamp.now(), // Date de refusage
          'acceptRefusCenterId': user!.uid, // ID du centre refusant
        });

        // Récupérer la valeur de dechetUserId depuis Firestore
        final dechetDoc = await FirebaseFirestore.instance
            .collection('dechets')
            .doc(getCollectionName(waste.type))
            .collection('items')
            .doc(dechetDocId)
            .get();

        final dechetUserId = dechetDoc.data()?['dechetUserId'];

        if (dechetUserId != null) {

          final acceptRefusDate =
              dechetDoc.data()?['acceptRefusDate'] as Timestamp?;
          final formattedDate = acceptRefusDate != null
              ? DateTime.fromMicrosecondsSinceEpoch(
                  acceptRefusDate.microsecondsSinceEpoch)
              : null;
          final formattedDateStr = formattedDate != null
              ? DateFormat('dd/MM/yyyy HH:mm').format(formattedDate)
              : '';
          // Envoyer la notification à l'utilisateur
          await sendNotificationToUser(
              dechetUserId,
              'Le déchet ${waste.name} est refusé',
              'Votre déchet ${waste.name} a été refusé par le ${userController.user.value.name} le $formattedDateStr.');
        }
      }
    } catch (e) {
      print('Erreur lors de la mise à jour du statut du déchet : $e');
    }
  }

  Future<void> addToWishlist(Waste waste) async {
    try {
      // Récupérer l'ID du document correspondant à votre déchet dans la collection "dechets"
      final querySnapshot = await FirebaseFirestore.instance
          .collection('dechets')
          .doc(getCollectionName(waste.type))
          .collection('items')
          .where('id', isEqualTo: waste.id)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final dechetDocId =
            querySnapshot.docs.first.id; // Obtenez l'ID du document de déchet

        // Récupérer le document de déchet correspondant dans la collection "dechets"
        final dechetDocSnapshot = await FirebaseFirestore.instance
            .collection('dechets')
            .doc(getCollectionName(waste.type))
            .collection('items')
            .doc(dechetDocId)
            .get();

        // Vérifier si le déchet est déjà dans la liste de souhaits
        final isFavorite = dechetDocSnapshot.get('isFavorite');
        if (isFavorite != null && isFavorite) {
          // Le déchet est déjà dans la liste de souhaits, le supprimer
          await FirebaseFirestore.instance
              .collection('dechets')
              .doc(getCollectionName(waste.type))
              .collection('items')
              .doc(dechetDocId)
              .update({'isFavorite': false});
          // Mettre à jour localement le statut isFavorite du déchet
          waste.isFavorite.value = false;
          // Afficher un message de succès
          TLoaders.succesSnackBar(
              title: 'Succès',
              message: 'Déchet retiré de la liste de souhaits');
        } else {
          // Le déchet n'est pas dans la liste de souhaits, l'ajouter
          await FirebaseFirestore.instance
              .collection('dechets')
              .doc(getCollectionName(waste.type))
              .collection('items')
              .doc(dechetDocId)
              .update({'isFavorite': true});
          waste.isFavorite.value = true;

          // Afficher un message de succès
          TLoaders.succesSnackBar(
              title: 'Succès', message: 'Déchet ajouté à la liste de souhaits');
        }

        // Appeler update pour forcer la mise à jour du widget
        Get.forceAppUpdate();
      } else {
        // Le déchet n'existe pas dans la collection "dechets"
        TLoaders.errorSnackBar(
            title: 'Erreur',
            message: 'Déchet non trouvé dans la collection de déchets');
      }
    } catch (e) {
      // Gérer les erreurs éventuelles
      TLoaders.errorSnackBar(title: 'Erreur', message: e.toString());
    }
  }
}
