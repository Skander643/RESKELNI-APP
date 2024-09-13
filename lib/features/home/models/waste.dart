import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class Waste {
  final String id;
  final String name;
  final WasteType type;
  final int quantity;
  final DateTime registrationDate;
  final String dechetUserId;
  final double prix;
  final double prixTotal;
  final String unite;
  RxBool isFavorite;
  RxString status;
  Rx<DateTime>? acceptRefusDate;
  String? acceptRefusCenterId;

  Waste({
    required this.id,
    required this.name,
    required this.prix,
    required this.prixTotal,
    required this.type,
    required this.quantity,
    required this.registrationDate,
    required this.dechetUserId,
    required this.isFavorite,
    required this.status,
    this.acceptRefusDate,
    this.acceptRefusCenterId,
    required this.unite
  });

  static Waste empty() => Waste(
        id: '',
        name: '',
        type: WasteType.menagers,
        prix: 0.0,
        prixTotal: 0.0,
        quantity: 0,
        registrationDate: DateTime.now(),
        dechetUserId: '',
        isFavorite: false.obs,
        status: ''.obs,
        unite: '',
      );

  factory Waste.fromFirestoreUserId(
      DocumentSnapshot<Map<String, dynamic>> document, String userId) {
    if (document.data() != null) {
      final map = document.data()!;
      return Waste(
        id: document.id,
        name: map['name'] ?? '',
        type: WasteTypeExtension.fromString(map['type']),
        quantity: map['quantity'] ?? 0,
        prix: map['prix'] ?? 0.0,
        prixTotal: map['prixTotal'] ?? 0.0,
        registrationDate: (map['registrationDate'] as Timestamp).toDate(),
        dechetUserId: userId,
        isFavorite: RxBool(map['isFavorite'] ??
            false), // Utilisez RxBool pour initialiser isFavorite
        status: RxString(map['status'] ?? 'en attente'),
        acceptRefusDate: map['acceptRefusDate'] != null
            ? Rx<DateTime>((map['acceptRefusDate'] as Timestamp).toDate())
            : null,
        acceptRefusCenterId: map['acceptRefusCenterId'],
        unite: map['unite'] ?? '',
      );
    } else {
      return Waste.empty();
    }
  }
  factory Waste.fromFirestoreSansUser(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final map = document.data()!;
      return Waste(
        id: document.id,
        name: map['name'] ?? '',
        type: WasteTypeExtension.fromString(map['type']),
        quantity: map['quantity'] ?? 0,
        prix: map['prix'] ?? 0.0,
        prixTotal: map['prixTotal'] ?? 0.0,
        registrationDate: (map['registrationDate'] as Timestamp).toDate(),
        dechetUserId: '',
        isFavorite: RxBool(map['isFavorite'] ??
            false), // Utilisez RxBool pour initialiser isFavorite
        status: RxString(map['status'] ?? 'en attente'),
        acceptRefusDate: map['acceptRefusDate'] != null
            ? Rx<DateTime>((map['acceptRefusDate'] as Timestamp).toDate())
            : null,
        acceptRefusCenterId: map['acceptRefusCenterId'],
        unite: map['unite'] ?? '',
      );
    } else {
      return Waste.empty();
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.name, // Convertir le type en son nom
      'quantity': quantity,
      'registrationDate': Timestamp.fromDate(
          registrationDate), // Convertir la date en Timestamp
      'dechetUserId': dechetUserId,
      'prix': prix,
      'prixTotal': prixTotal,
      'isFavorite': isFavorite.value,
      'status': status.value,
      'unite' : unite,
    };
  }
}

enum WasteType {
  menagers,
  industriels,
  dangereux,
  organiques,
  electroniques,
  construction_et_demolition,
  radioactifs,
  verts,
}

extension WasteTypeExtension on WasteType {
  String get name {
    switch (this) {
      case WasteType.menagers:
        return 'Déchets ménagers';
      case WasteType.industriels:
        return 'Déchets industriels';
      case WasteType.dangereux:
        return 'Déchets dangereux';
      case WasteType.organiques:
        return 'Déchets organiques';
      case WasteType.electroniques:
        return 'Déchets électroniques';
      case WasteType.construction_et_demolition:
        return 'Déchets de construction et de démolition';
      case WasteType.radioactifs:
        return 'Déchets radioactifs';
      case WasteType.verts:
        return 'Déchets verts';
    }
  }

  static WasteType fromString(String value) {
    switch (value) {
      case 'Déchets ménagers':
        return WasteType.menagers;
      case 'Déchets industriels':
        return WasteType.industriels;
      case 'Déchets dangereux':
        return WasteType.dangereux;
      case 'Déchets organiques':
        return WasteType.organiques;
      case 'Déchets électroniques':
        return WasteType.electroniques;
      case 'Déchets de construction et de démolition':
        return WasteType.construction_et_demolition;
      case 'Déchets radioactifs':
        return WasteType.radioactifs;
      case 'Déchets verts':
        return WasteType.verts;
      default:
        throw Exception('Type de déchet inconnu: $value');
    }
  }
}
