import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/common/widgets/loaders/loaders.dart';
import 'package:e_commerce_app/features/notification/models/notification.dart';
import 'package:e_commerce_app/features/notification/screens/notification_screen.dart';
import 'package:e_commerce_app/utils/constants/image_strings.dart';
import 'package:e_commerce_app/utils/helpers/network_manager.dart';
import 'package:e_commerce_app/utils/popups/full_screen_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  static NotificationController get instance => Get.find();
  RxBool notify = false.obs; // Déclaration en tant que RxBool observable
  List<NotificationModel> notifications = [];
  // Récupérer l'utilisateur actuellement authentifié
  User? user = FirebaseAuth.instance.currentUser;

  // Méthode pour récupérer les déchets
  Future<void> recupererNotification() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          'Nous récupérons vos notifications...', TImages.docerAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();

      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Liste temporaire pour stocker les déchets récupérés
      List<NotificationModel> tempList = [];

// Obtenir le nom de la collection en fonction du type de déchet
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .where('userId', isEqualTo: user!.uid)
          .get();

// Itérer sur tous les documents récupérés
      for (var doc in querySnapshot.docs) {
        // Convertir chaque document en un objet de déchet
        NotificationModel notification =
            NotificationModel.fromFirestore(doc.data() as Map<String, dynamic>);

        // Vérifier si le déchet n'est pas déjà dans la liste temporaire
        if (!tempList.contains(notification)) {
          // Ajouter le déchet à la liste temporaire
          tempList.add(notification);
        }
      }

      // Trier la liste temporaire par date croissante
      tempList.sort((a, b) => a.timestamp.compareTo(b.timestamp));


      // Mettre à jour la liste des déchets avec la liste temporaire
      notifications.assignAll(tempList.reversed.toList()); // Inverser la liste pour avoir la plus récente en haut


      if (notifications.isEmpty) {
        TFullScreenLoader.stopLoading();
        TLoaders.warningSnackBar(title: 'Vide', message: 'Aucun Notification');
        Get.to(() => const NotificationScreen());
      } else {
        TFullScreenLoader.stopLoading();
        markNotificationAsRead();
        Get.to(() => const NotificationScreen());
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Erreur', message: e.toString());
    }
  }

  Future<void> markNotificationAsRead() async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .where('userId', isEqualTo: user!.uid)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.update({'showNotif': true});
        }
      });

      for (var notif in notifications) {
        notif.showNotif.value = true;
      }

      notify.value = false;
    } catch (e) {
      print("Erreur lors de la mise à jour de l'état de la notification : $e");
    }
  }

  Future<void> show() async {
    // Liste temporaire pour stocker les déchets récupérés
    List<NotificationModel> tempList = [];

    // Obtenir le nom de la collection en fonction du type de déchet

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .where('userId', isEqualTo: user!.uid)
        .get();

    // Itérer sur tous les documents récupérés
    for (var doc in querySnapshot.docs) {
      // Convertir chaque document en un objet de déchet
      NotificationModel notification =
          NotificationModel.fromFirestore(doc.data() as Map<String, dynamic>);

      // Vérifier si le déchet n'est pas déjà dans la liste temporaire
      if (!tempList.contains(notification)) {
        // Ajouter le déchet à la liste temporaire
        tempList.add(notification);
      }
    }

    // Mettre à jour la liste des déchets avec la liste temporaire
    notifications.assignAll(tempList);
    for (var notif in notifications) {
      if (!notif.showNotif.value) {
        notify.value = true;
        return; // Sortir de la fonction après avoir mis à jour notify
      }
    }
    notify.value = false;
  }

  @override
  void onInit() async {
    super.onInit();
    await show();
  }
}
