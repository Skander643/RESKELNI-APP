import 'package:e_commerce_app/features/home/controller/waste_type_controller.dart';
import 'package:e_commerce_app/features/home/models/waste.dart';
import 'package:e_commerce_app/common/widgets/home/favoris_icon.dart';
import 'package:e_commerce_app/common/widgets/home/option_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DecheItem extends StatelessWidget {
  const DecheItem({
    super.key,
    required this.controller,
  });

  final WasteTypesController controller;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: controller.wasteList.length,
      itemBuilder: (context, index) {
        Waste waste = controller.wasteList[index];
        return Card(
          elevation: 5,
          margin: const EdgeInsets.only(bottom: 16),
          child: Stack(
            children: [
              ListTile(
                title: Text(
                  waste.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Type : ${waste.type.name}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Quantité : ${waste.quantity}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Unité : ${waste.unite}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Prix unitaire : ${waste.prix} DT',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Prix total : ${waste.prixTotal} DT',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Enregistré le : ${DateFormat('dd/MMMM/yyyy à HH:mm').format(waste.registrationDate)}",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => waste.status.value == 'en attente'
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OptionButton(
                                  color: Colors.green,
                                  child: const Text(
                                    'Accepter',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  onPressed: () =>
                                      controller.accepteDechet(waste),
                                ),
                                const SizedBox(
                                    width: 15), // Espacement entre les boutons
                                OptionButton(
                                  color: Colors.red,
                                  child: const Text(
                                    'Refuser',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  onPressed: () {
                                    // Ajoutez votre logique pour refuser le déchet ici
                                    controller.refuserDechet(waste);
                                  },
                                ),
                              ],
                            )
                          :  Text(
                                waste.status.value == 'accepté'
                                    ? 'Le déchet est accepté'
                                    : 'Le déchet est refusé',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: waste.status.value == 'accepté'
                                        ? Colors.green
                                        : Colors.red),
                              ),
                          ),
                  
                  ],
                ),
              ),
              Obx(
                () => waste.status.value == 'en attente' 
                ?
                FavorisIcon(controller: controller, waste: waste)
                : const SizedBox(),
              ),
            ],
          ),
        );
      },
    );
  }
}
