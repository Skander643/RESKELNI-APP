import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class NotificationModel {
  final String userId;
  final String title;
  final String body;
  final DateTime timestamp;
   RxBool showNotif ; 

  NotificationModel({
    required this.userId,
    required this.title,
    required this.body,
    required this.timestamp,
     required this.showNotif ,
  });

  // Méthode pour convertir le modèle en une Map pour stockage dans Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'body': body,
      'timestamp': Timestamp.fromDate(timestamp),
      'showNotif':showNotif.value,
    };
  }

  // Méthode pour créer un modèle de notification à partir d'un document Firestore
  static NotificationModel fromFirestore(Map<String, dynamic> map) {
    return NotificationModel(
      userId: map['userId'],
      title: map['title'],
      body: map['body'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      showNotif: RxBool(map['showNotif'] ?? false),
    );
  }
}

