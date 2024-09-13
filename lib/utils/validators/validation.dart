class TValidator {

  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return "le $fieldName est requis";
    }
    return null; 

  }


  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {

      return "L’adresse e-mail est requise.";

    }


    // Regular expression for email validation


    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');


    if (!emailRegExp.hasMatch(value)) {

      return 'Adresse e-mail non valide.';

    }


    return null;

  }


  static String? validatePassword(String? value) {

    if (value == null || value.isEmpty) {

      return 'Le mot de passe est requis.';

    }


    // Check for minimum password length


    if (value.length < 6) {

      return 'Le mot de passe doit comporter au moins 6 caractères.';

    }


    // Check for uppercase letters


    if (!value.contains(RegExp(r'[A-Z]'))) {

      return 'Le mot de passe doit contenir au moins une lettre majuscule.';

    }


    // Check for numbers


    if (!value.contains(RegExp(r'[0-9]'))) {

      return 'Le mot de passe doit contenir au moins un chiffre.';

    }


    // Check for special characters


    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {

      return 'Le mot de passe doit contenir au moins un caractère spécial.';

    }


    return null;

  }


  static String? validateRole(String? value) {

    if (value == null || value.isEmpty) {

      return 'Le rôle est requis.';

    }


    return null;

  }


  static String? validateAdresse(String? value) {

    if (value == null || value.isEmpty) {

      return "L'adresse est requis.";

    }


    return null;

  }


  static String? validateNom(String? value) {

    if (value == null || value.isEmpty) {

      return 'Le nom est obligatoire.';

    }


    return null;

  }


  static String? validateEmptyDouble(String fieldName ,  String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer le $fieldName';
    }
    // Essayer de convertir la chaîne en double
    try {
      double.parse(value);
      if(double.parse(value) <= 0){
          return 'le $fieldName doit être  positive';
      }
    } catch (e) {
      return 'Veuillez entrer un nombre valide pour le $fieldName';
    }
    return null;
  }

  
  }





