import 'package:e_commerce_app/common/widgets/appbar/appbar.dart';
import 'package:e_commerce_app/features/home/controller/waste_type_controller.dart';
import 'package:e_commerce_app/common/widgets/home/dechet_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DechetListType extends StatelessWidget {
  const DechetListType({super.key, this.wasteType});

  final String? wasteType;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WasteTypesController());

    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text("Liste des $wasteType"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: controller.wasteList.isEmpty
            ? Center(
                child: Text("Il n'y a pas de $wasteType enregistrés"),
              )
            : DecheItem(controller: controller),
      ),
    );
  }
}

