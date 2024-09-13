import 'package:e_commerce_app/common/widgets/appbar/appbar.dart';
import 'package:e_commerce_app/features/home/controller/waste_type_controller.dart';
import 'package:e_commerce_app/features/home/models/waste.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WasteTypesScreen extends StatelessWidget {
  const WasteTypesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WasteTypesController());
    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        title: Text('Les types de déchets'),
      ),
      body: ListView.builder(
        itemCount: WasteType.values.length,
        itemBuilder: (context, index) {
          final wasteType = WasteType.values[index];
          // Définissez l'icône correspondant à chaque type de déchet
          IconData iconData =
              Icons.error; // Par défaut, un point d'interrogation
          switch (wasteType) {
            case WasteType.menagers:
              iconData = Icons.home;
              break;
            case WasteType.industriels:
              iconData = Icons.build;
              break;
            case WasteType.dangereux:
              iconData = Icons.warning;
              break;
            case WasteType.organiques:
              iconData = Icons.eco;
              break;
            case WasteType.electroniques:
              iconData = Icons.devices;
              break;
            case WasteType.construction_et_demolition:
              iconData = Icons.construction;
              break;
            case WasteType.radioactifs:
              iconData = Icons.dangerous;
              break;
            case WasteType.verts:
              iconData = Icons.eco_rounded;
              break;
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                leading: Icon(iconData), // Icône à gauche du titre
                title: Text(wasteType.name),
                // Vous pouvez ajouter ici une action à effectuer lorsque l'utilisateur appuie sur la carte
                onTap: () {
                  controller.fetchWastesByType(wasteType);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
