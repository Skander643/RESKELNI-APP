import 'package:e_commerce_app/common/widgets/home/option_button.dart';
import 'package:e_commerce_app/data/repositories/user/user_repository.dart';
import 'package:e_commerce_app/features/personalization/controllers/user_controller.dart';
import 'package:e_commerce_app/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompteBancController extends GetxController {
  static CompteBancController get instance => Get.find();

  final amountController = TextEditingController();
  GlobalKey<FormState> ajouterMonatntFormKey = GlobalKey<FormState>();
  final controller = Get.put(UserController());
  final userRepository = Get.put(UserRepository());



  void addMoney(double amount)async{
    double currentBalance = controller.user.value.solde;
    double updatedBalance = currentBalance + amount; 

/// Update user name in the Firebase Firestore
      Map<String, dynamic> solde = {'Solde': updatedBalance};
      await userRepository.updateSingleField(solde);

    // Mise à jour du solde dans le contrôleur de l'utilisateur
    controller.user.update((user) {
      user!.solde = updatedBalance;
    });

  }

 showAddMoneyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter de l\'argent'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: ajouterMonatntFormKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: amountController,
                    validator: (value) =>
                        TValidator.validateEmptyDouble('montant', value),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Montant',
                      suffixText: 'DT',
                      prefixIcon: Icon(
                        Icons.monetization_on,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            OptionButton(
              
              onPressed: () => Navigator.of(context).pop(),
              color: Colors.red,
              child: const Text('Annuler'),
            ),
            OptionButton(
              onPressed: () {
                if (!ajouterMonatntFormKey.currentState!.validate()) {
                  return;
                }
                double amount = double.tryParse(amountController.text) ?? 0;
                addMoney(amount);
                Navigator.of(context).pop();
                amountController.text = '';
              },
              color: Colors.green,
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }
}
