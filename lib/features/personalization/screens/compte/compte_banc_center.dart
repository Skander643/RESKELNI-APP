import 'package:e_commerce_app/common/widgets/appbar/appbar.dart';
import 'package:e_commerce_app/features/personalization/controllers/compte_banc_center_controlller.dart';
import 'package:e_commerce_app/features/personalization/controllers/user_controller.dart';
import 'package:e_commerce_app/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CompteBancCenter extends StatelessWidget {
 

  const CompteBancCenter({super.key});

  @override
  Widget build(BuildContext context) {
     final controller = Get.put(CompteBancController());
    final userController = Get.put(UserController());

    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        title: Text('Compte Bancaire'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              TImages.compteBanc,
              width: 300,
              height: 400,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                        'Solde du compte : ${userController.user.value.solde.toStringAsFixed(2)} DT',
                        style:
                            const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.showAddMoneyDialog(context);
                      },
                      child: const Text('Ajouter de l\'argent'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}
