import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/features/home/models/waste.dart';

class Produit {
  final String id;
  final String centerId;
  final String centerName;
  late final String name;
  late final String imageUrl; // Chemin de l'image ou URL
  late final double price;
  late final WasteType wasteType; // Type de déchet associé

  Produit({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.wasteType,
    required this.centerId,
    required this.centerName,
  });
  static Produit empty() => Produit(
        id: '',
        name: '',
        centerId: '',
        price: 0.0,
        imageUrl: "",
        wasteType: WasteType.menagers,
        centerName: '',
      );


  Map<String, dynamic> toMap() {
    return {
      "id":id,
      'centerId': centerId,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'wasteType': wasteType.name,
      'centerName': centerName,
    };
  }

  // Méthode pour créer un modèle de produit à partir d'un document Firestore
  factory Produit.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final map = document.data()!;
      return Produit(
        id: document.id,
        centerId: map['centerId'] ?? '',
        name: map['name'] ?? '',
        imageUrl: map['imageUrl'] ?? '',
        price: map['price'] ?? 0.0,
        wasteType: WasteTypeExtension.fromString(map['wasteType']),
        centerName: map['centerName'] ?? '',
      );
    }else{
      return Produit.empty();
    }
  }
}
