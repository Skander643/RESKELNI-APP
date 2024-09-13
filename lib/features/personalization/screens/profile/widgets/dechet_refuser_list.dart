import 'package:e_commerce_app/common/widgets/appbar/appbar.dart';
import 'package:e_commerce_app/features/home/controller/waste_controller.dart';
import 'package:e_commerce_app/features/home/models/waste.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DechetRefuserList extends StatelessWidget {
  const DechetRefuserList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WasteController());

    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        title: Text("Liste des déchets refusés"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: controller.dechetRefuserList.isEmpty
            ? const Center(
                child: Text("Il n'y a pas de déchets refusés"),
              )
            : ListView.builder(
                itemCount: controller.dechetRefuserList.length,
                itemBuilder: (context, index) {
                  Waste waste = controller.dechetRefuserList[index];
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
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
                            'Prix unitaire: ${waste.prix} DT',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Prix total : ${waste.prixTotal} DT',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Enregistré le : ${DateFormat('dd/MM/yyyy à HH:mm').format(waste.registrationDate)}",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "J'ai refusé ce déchet le : ${DateFormat('dd/MM/yyyy à HH:mm').format(waste.acceptRefusDate!.value)}",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
