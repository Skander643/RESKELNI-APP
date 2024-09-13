import 'package:e_commerce_app/features/home/controller/waste_controller.dart';
import 'package:e_commerce_app/features/home/models/waste.dart';
import 'package:e_commerce_app/utils/constants/colors.dart';
import 'package:e_commerce_app/utils/constants/image_strings.dart';
import 'package:e_commerce_app/utils/constants/sizes.dart';
import 'package:e_commerce_app/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar/appbar.dart';

class WasteRegister extends StatelessWidget {
  const WasteRegister( {super.key, this.wasteType,});

  final String? wasteType; 

  @override
  Widget build(BuildContext context) {
    final wasteController = Get.put(WasteController());
    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        title: Text(
          'Enregistrement des déchets',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              TImages.registerWaste, 
              width: 200, 
              height: 150, 
              fit:
                  BoxFit.cover, 
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: wasteController.registerWasteKeyForm,
                child: Column(
                  children: [
                    const SizedBox(
                      height: TSizes.spaceBtwInputFields,
                    ),
                    TextFormField(
                      validator: (value) =>
                          TValidator.validateEmptyText('nom de déchet', value),
                      controller: wasteController.nameController,
                      decoration: const InputDecoration(
                        prefixIcon : Icon(Icons.delete), 
                        labelText: 'Nom de déchet', border: OutlineInputBorder(borderSide:BorderSide(color: TColors.black) )),
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwInputFields,
                    ),
                    DropdownButtonFormField<WasteType>(
                      value: (wasteType == null ) ? wasteController.selectedType : WasteType.values.firstWhereOrNull((type) => type.name == wasteType),
                     onChanged: wasteType == null
                          ? (value) => wasteController.selectedType = value!
                          : null, // Désactive onChanged si une valeur initiale est passée
                      items: WasteType.values.map((type) {
                        return DropdownMenuItem<WasteType>(
                          value: type,
                          child: Text(type.name,
                          overflow: TextOverflow.ellipsis,),
                        );
                      }).toList(),
                      decoration: const InputDecoration(prefixIcon: Icon(Icons.category),labelText: 'Type de déchet'),
                      isExpanded: true,
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwInputFields,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: false),
                            validator: (value) =>
                                wasteController.validateQuantity(value),
                            controller: wasteController.quantityController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                  Icons.production_quantity_limits_outlined),
                              labelText: 'Quantité',
                            ),
                          ),
                        ),
                        const SizedBox(
                            width:
                                10), // Espace entre le champ de texte et le DropdownButton
                        Obx(
                          () => DropdownButton<String>(
                            value: wasteController.selectedUnit.value,
                            onChanged: (newValue) {
                              wasteController.selectedUnit.value = newValue!;
                              wasteController.update();
                            },
                            items: ['Kg','Pièce'].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            int newValue = int.tryParse(
                                    wasteController.quantityController.text) ??
                                0;
                            newValue = newValue > 0 ? newValue - 1 : 0;
                            wasteController.quantityController.text =
                                newValue.toString();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            int newValue = int.tryParse(
                                    wasteController.quantityController.text) ??
                                0;
                            newValue++;
                            wasteController.quantityController.text =
                                newValue.toString();
                          },
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: TSizes.spaceBtwInputFields,
                    ),
                   TextFormField(
                      validator: (value) =>
                          TValidator.validateEmptyDouble('prix', value),
                      controller: wasteController.prixController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true), // Clavier numérique pour les décimaux
                      decoration: const InputDecoration(
                           prefixIcon: Icon(Iconsax.money),
                          labelText: "Prix unitaire",
                          suffixText: 'DT',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: TColors.black))),
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwInputFields,
                    ),
                    Obx(
                      () => Text(
                        'le prix totale est : ${wasteController.totalPrice.value.toStringAsFixed(3)} DT',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                     const SizedBox(
                      height: TSizes.spaceBtwInputFields,
                    ),
                    Text(
                      'Date d\'enregistrement: ${wasteController.registrationDate}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwSections,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: wasteController.saveWaste,
                        child: const Text('Enregistrer'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
