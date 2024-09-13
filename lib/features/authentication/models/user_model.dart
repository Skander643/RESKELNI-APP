import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  String name;
  String role;
  final String adress;
  final String email;
  String profilePicture;
  double solde;
  String? token;

  UserModel({
    required this.id,
    required this.name,
    required this.role,
    required this.adress,
    required this.email,
    required this.profilePicture,
    required this.solde,
     this.token,
  });



  static String generateUsername(String fullName) {
    List<String> nameParts = fullName.split(' ');
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

    String camelCaseUsername = '$firstName$lastName';
    String usernameWithPrefix = "cwt_$camelCaseUsername";
    return usernameWithPrefix;
  }

  static UserModel empty() => UserModel(
        id: '',
        name: '',
        role: '',
        adress: "",
        email: '',
        profilePicture: '',
        solde: 0.0,
      );

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Role': role,
      'Addresse': adress,
      'Email': email,
      'ProfilePicture': profilePicture,
      'Solde': solde,
      'Token' : token,
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
        id: document.id,
        name: data['Name'] ?? '',
        role: data['Role'] ?? '',
        adress: data['Addresse'] ?? '',
        email: data['Email'] ?? '',
        solde: data['Solde'] ?? 0.0,
        profilePicture: data['ProfilePicture'] ?? '',
        token:  data['Token'] ?? '',
      );
    } else {
      return UserModel.empty();
    }
  }
}
