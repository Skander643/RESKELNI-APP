import 'package:e_commerce_app/common/widgets/appbar/appbar.dart';
import 'package:e_commerce_app/common/widgets/home/option_button.dart';
import 'package:e_commerce_app/features/Favoris/controllers/favoris_screen_controller.dart';
import 'package:e_commerce_app/features/home/controller/waste_type_controller.dart';
import 'package:e_commerce_app/features/home/models/waste.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FavorisScreen extends StatelessWidget {
  const FavorisScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final wasteController = Get.put(WasteTypesController());
    return Scaffold(
      appBar: const TAppBar(
        title: Text('Déchets favoris'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GetBuilder<FavorisScreenController>(
          init:
              FavorisScreenController(), // Créer une nouvelle instance du contrôleur
          builder: (controller) {
            return Obx(
              () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : controller.favoriteDechets.isEmpty
                      ? const Center(child: Text('Aucun déchet favoris'))
                      : ListView.builder(
                          itemCount: controller.favoriteDechets.length,
                          itemBuilder: (context, index) {
                            Waste favorisDechet =
                                controller.favoriteDechets[index];
                            return Card(
                              elevation: 5,
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Stack(
                                children: [
                                  ListTile(
                                    title: Text(
                                      favorisDechet.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        Text(
                                          'Type : ${favorisDechet.type.name}',
                                          style: TextStyle(
                                              color: Colors.grey[700]),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Quantité : ${favorisDechet.quantity}',
                                          style: TextStyle(
                                              color: Colors.grey[700]),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Prix par unité : ${favorisDechet.prix} DT',
                                          style: TextStyle(
                                              color: Colors.grey[700]),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Prix total : ${favorisDechet.prixTotal} DT',
                                          style: TextStyle(
                                              color: Colors.grey[700]),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Enregistré le : ${DateFormat('dd/MMMM/yyyy à HH:mm').format(favorisDechet.registrationDate)}",
                                          style: TextStyle(
                                              color: Colors.grey[700]),
                                        ),
                                        const SizedBox(height: 8),
                                        favorisDechet.status.value ==
                                                'en attente'
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  OptionButton(
                                                    color: Colors.green,
                                                    child: const Text(
                                                      'Accepter',
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                    onPressed: () =>
                                                        wasteController
                                                            .accepteDechet(
                                                                favorisDechet),
                                                  ),
                                                  const SizedBox(
                                                      width:
                                                          15), // Espacement entre les boutons
                                                  OptionButton(
                                                    color: Colors.red,
                                                    child:
                                                        const Text('Refuser'),
                                                    onPressed: () {
                                                      wasteController
                                                          .refuserDechet(
                                                              favorisDechet);
                                                    },
                                                  ),
                                                ],
                                              )
                                            : Text(
                                                favorisDechet.status.value ==
                                                        'accepté'
                                                    ? 'Le déchet est accepté }'
                                                    : 'Le déchet est refusé  }',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: favorisDechet
                                                                .status.value ==
                                                            'accepté'
                                                        ? Colors.green
                                                        : Colors.red),
                                              ),
                                      ],
                                    ),
                                  ),
          
                                ],
                              ),
                            );
                          },
                        ),
            );
          },
        ),
      ),
    );
  }
}
